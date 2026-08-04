// Command-line interface for EyeDual.
// It loads programs from files, URLs, or stdin, then runs requested goals.
import fs from 'node:fs/promises';
import path from 'node:path';
import process from 'node:process';

let engineModule = null;
let explanationModule = null;

export async function main(argv) {
  if (argv.length === 0) {
    await usage(process.stdout);
    return;
  }

  const options = {
    files: [],
    proof: false,
    stats: false,
    version: false,
    warnings: false,
    goals: [],
  };

  let endOptions = false;

  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];

    if (!endOptions && arg === '--') {
      endOptions = true;
    } else if (!endOptions && (arg === '--help' || arg === '-h')) {
      await usage(process.stdout);
      return;
    } else if (!endOptions && (arg === '--proof' || arg === '-p')) {
      options.proof = true;
    } else if (!endOptions && (arg === '--stats' || arg === '-s')) {
      options.stats = true;
    } else if (!endOptions && (arg === '--version' || arg === '-v')) {
      options.version = true;
    } else if (!endOptions && (arg === '--warnings' || arg === '-w')) {
      options.warnings = true;
    } else if (!endOptions && arg === '--goal') {
      const goal = argv[++i];
      if (goal == null) throw new Error('option --goal requires a goal');
      options.goals.push(goal);
    } else if (!endOptions && arg.startsWith('-') && !arg.startsWith('--') && arg.length > 2) {
      const flags = arg.slice(1);
      for (const flag of flags) {
        if (!'hpsvw'.includes(flag)) throw new Error(`unknown option: ${arg}`);
      }
      if (flags.includes('h')) {
        await usage(process.stdout);
        return;
      }
      if (flags.includes('p')) options.proof = true;
      if (flags.includes('s')) options.stats = true;
      if (flags.includes('v')) options.version = true;
      if (flags.includes('w')) options.warnings = true;
    } else if (!endOptions && arg.startsWith('-') && arg !== '-') {
      throw new Error(`unknown option: ${arg}`);
    } else {
      options.files.push(arg);
    }
  }

  if (options.version) {
    process.stdout.write(`eyedual ${await packageVersion()}\n`);
    return;
  }

  if (options.files.length === 0) {
    options.files.push('-');
  }

  const sourceParts = [];
  let usedStdin = false;

  for (const file of options.files) {
    if (file === '-') {
      if (usedStdin) throw new Error("stdin input '-' can only be used once");
      usedStdin = true;
      sourceParts.push({ text: await readStdin(), filename: '<stdin>' });
    } else if (/^https?:\/\//.test(file)) {
      const response = await fetch(file);
      if (!response.ok) throw new Error(`could not fetch URL: ${file}`);
      sourceParts.push({ text: await response.text(), filename: file });
    } else {
      sourceParts.push({
        text: await fs.readFile(file, 'utf8'),
        filename: path.basename(file) || file,
        baseDir: path.dirname(path.resolve(file)),
      });
    }
  }

  const engine = await loadEngine();
  let program = engine.Program.parseSources(sourceParts, { sourceMetadata: options.proof });

  if (options.warnings) printWarnings(program);

  await runDefault(engine, program, options);
}

async function loadEngine() {
  if (engineModule == null) {
    const [term, parser, program, solver, iso, library] = await Promise.all([
      import('./term.js'),
      import('./parser.js'),
      import('./program.js'),
      import('./solver.js'),
      import('./iso.js'),
      import('./library.js'),
    ]);
    engineModule = { ...term, ...parser, ...program, ...solver, ...iso, ...library };
  }
  return engineModule;
}

async function loadExplanation() {
  if (explanationModule == null) explanationModule = await import('./explain.js');
  return explanationModule;
}

async function runDefault(engine, program, options) {
  const goals = options.goals.map((text) => {
    const goal = engine.parseGoalText(text);
    if (goal.type === 'var') throw new engine.PrologError('instantiation_error');
    if (goal.type !== 'atom' && goal.type !== 'compound') throw new engine.PrologError('type_error(callable)', goal);
    return goal;
  });
  const queriedKeys = new Set(goals.map((goal) => `${goal.name}/${goal.arity}`));
  const facts = program.sourceFactLines(queriedKeys);
  const lines = new Set();
  const registry = engine.getEyeDualRegistry();
  const explanation = options.proof ? await loadExplanation() : null;
  const solver = new engine.Solver(program, {
    registry,
    ioOptions: { write: (text) => process.stdout.write(String(text)) },
  });
  program = solver.program;
  try {
    solver.runInitializations();
    for (const goal of goals) {
      solver.solutionsSeen = 0;
      for (const env of solver.solve([goal], new engine.Env(), 0)) {
        if (!engine.termIsGround(goal, env)) continue;

        const line = `${engine.termToString(goal, env, true)}.\n`;
        if (facts.has(line) || lines.has(line)) continue;

        lines.add(line);

        process.stdout.write(line);
        if (options.proof) writeExplanation(explanation, program, engine.copyResolved(goal, env), registry);
      }
    }
  } catch (error) {
    if (error?.name !== 'HaltSignal') throw error;
    process.exitCode = error.code;
  }

  if (options.stats) printStats(solver.stats);
}

function writeExplanation(explanation, program, resolved, registry) {
  const proof = explanation.whyProof(program, resolved, { registry });
  process.stdout.write(proof.text);
  if (!proof.ok) process.stdout.write(explanation.whyNoProof(resolved));
}

async function usage(stream) {
  stream.write(`eyedual ${await packageVersion()}

Usage:
  eyedual [options] [file-or-url.pl|- ...]

Input:
  file-or-url.pl        Read an EyeDual program from a local file or http(s) URL.
  -                     Read an EyeDual program from standard input.

Options:
  -h, --help            Show this help text and exit.
  -p, --proof           Enable proof explanations.
  -s, --stats           Print solver statistics to stderr after execution.
  -v, --version         Show the package version and exit.
  -w, --warnings        Print non-fatal portability warnings to stderr.
  --goal goal           Solve goal and print its ground answers; may be repeated.
  --                    Stop option parsing; following arguments are treated as files.
`);
}

function readStdin() {
  return new Promise((resolve, reject) => {
    let data = '';
    process.stdin.setEncoding('utf8');
    process.stdin.on('data', (chunk) => {
      data += chunk;
    });
    process.stdin.on('end', () => resolve(data));
    process.stdin.on('error', reject);
  });
}

function printWarnings(program) {
  const errors = program.negationStratificationErrors;
  if (errors.length === 0) return;

  process.stderr.write('eyedual warning: unstratified negation\n');
  for (const edge of errors) {
    process.stderr.write(`  ${edge.from} depends negatively on ${edge.to}\n`);
  }
}

function printStats(stats) {
  process.stderr.write('eyedual stats:\n');
  for (const [key, value] of Object.entries(stats)) {
    process.stderr.write(`  ${key}: ${value}\n`);
  }
}

async function packageVersion() {
  try {
    const text = await fs.readFile(new URL('../package.json', import.meta.url), 'utf8');
    const pkg = JSON.parse(text);
    if (pkg && typeof pkg.version === 'string' && pkg.version) return pkg.version;
  } catch (_) {
    // Fall through to a stable marker if package metadata is unavailable.
  }

  return 'unknown';
}
