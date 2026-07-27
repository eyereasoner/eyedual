// Command-line interface for Eyepl.
// It loads programs from files, URLs, or stdin, then runs their declared queries.
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
    library: false,
    proof: false,
    stats: false,
    version: false,
    warnings: false,
  };

  let endOptions = false;

  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];

    if (!endOptions && arg === '--') {
      endOptions = true;
    } else if (!endOptions && (arg === '--help' || arg === '-h')) {
      await usage(process.stdout);
      return;
    } else if (!endOptions && (arg === '--library' || arg === '-l')) {
      options.library = true;
    } else if (!endOptions && (arg === '--proof' || arg === '-p')) {
      options.proof = true;
    } else if (!endOptions && (arg === '--stats' || arg === '-s')) {
      options.stats = true;
    } else if (!endOptions && (arg === '--version' || arg === '-v')) {
      options.version = true;
    } else if (!endOptions && (arg === '--warnings' || arg === '-w')) {
      options.warnings = true;
    } else if (!endOptions && arg.startsWith('-') && arg !== '-') {
      throw new Error(`unknown option: ${arg}`);
    } else {
      options.files.push(arg);
    }
  }

  if (options.version) {
    process.stdout.write(`eyepl ${await packageVersion()}\n`);
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
      sourceParts.push({ text: await fs.readFile(file, 'utf8'), filename: path.basename(file) || file });
    }
  }

  const engine = await loadEngine();
  const program = engine.Program.parseSources(sourceParts, { sourceMetadata: options.proof, markRecursive: options.proof });

  if (options.warnings) printWarnings(program);

  await runDefault(engine, program, options);
}

async function loadEngine() {
  if (engineModule == null) {
    const [term, program, solver, registry, fuse] = await Promise.all([
      import('./term.js'),
      import('./program.js'),
      import('./solver.js'),
      import('./builtins/registry.js'),
      import('./fuse.js'),
    ]);
    engineModule = { ...term, ...program, ...solver, ...registry, ...fuse };
  }
  return engineModule;
}

async function loadExplanation() {
  if (explanationModule == null) explanationModule = await import('./explain.js');
  return explanationModule;
}

async function runDefault(engine, program, options) {
  const goals = program.queryGoals();
  const queriedKeys = new Set(goals.map((goal) => `${goal.name}/${goal.arity}`));
  const facts = program.sourceFactLines(queriedKeys);
  const lines = new Set();
  const registry = options.library ? engine.getLibraryRegistry() : engine.getDefaultRegistry();
  const explanation = options.proof ? await loadExplanation() : null;
  const solver = new engine.Solver(program, { registry });
  engine.checkInferenceFuses(program, solver);

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

  if (options.stats) printStats(solver.stats);
}

function writeExplanation(explanation, program, resolved, registry) {
  const proof = explanation.whyProof(program, resolved, { registry });
  process.stdout.write(proof.text);
  if (!proof.ok) process.stdout.write(explanation.whyNoProof(resolved));
}

async function usage(stream) {
  stream.write(`eyepl ${await packageVersion()}

Usage:
  eyepl [options] [file-or-url.pl|- ...]

Input:
  file-or-url.pl        Read a Eyepl program from a local file or http(s) URL.
  -                     Read a Eyepl program from standard input.

Options:
  -h, --help            Show this help text and exit.
  -l, --library         Enable the non-core Eyepl library predicates.
  -p, --proof           Enable proof explanations.
  -s, --stats           Print solver statistics to stderr after execution.
  -v, --version         Show the package version and exit.
  -w, --warnings        Print non-fatal portability warnings to stderr.
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

  process.stderr.write('eyepl warning: unstratified negation\n');
  for (const edge of errors) {
    process.stderr.write(`  ${edge.from} depends negatively on ${edge.to}\n`);
  }
}

function printStats(stats) {
  process.stderr.write('eyepl stats:\n');
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
