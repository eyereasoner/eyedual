#!/usr/bin/env node
// Supplemental regression runner.
// This file collects focused checks that do not belong to the public
// conformance corpus or the example-output corpus: CLI regressions, public API
// checks, and small white-box tests for maintenance-sensitive internals.
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import * as publicApi from '../src/index.js';
import {
  run as runEyeDual,
  Program,
  makeProgram,
  Solver,
  Env,
  BuiltinRegistry,
  createDefaultRegistry,
  getEyeDualRegistry,
  atom,
  compound,
  listFromItems,
  numberTerm,
  stringTerm,
  variable,
  copyResolved,
  flattenConjunction,
  properListItems,
  termIsGround,
  termToString,
  unify,
  variantTerms,
  parseProgramText,
} from '../src/index.js';
import { parseGoalText } from '../src/parser.js';
import { selectClauseCandidates } from '../src/program.js';
import { TestReporter, isMainModule } from './test-style.mjs';
import { buildConformanceReport, formatConformanceReport } from './run-conformance-report.mjs';
import { proofExamples } from './run-examples.mjs';
import { goalsFromSource } from './goal-metadata.mjs';

const testRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)));
const packageRoot = path.resolve(testRoot, '..');
const bin = path.join(packageRoot, 'bin', 'eyedual.js');
const pkg = JSON.parse(fs.readFileSync(path.join(packageRoot, 'package.json'), 'utf8'));
let tmp = null;
let tmpCounter = 0;

function run(source, options = {}) {
  const programSource = Array.isArray(source) ? source.join('\n') : source;
  const text = programSource instanceof Program ? programSource : String(programSource);
  const goals = options.goals ?? (options.goal == null
    ? (programSource instanceof Program ? [] : goalsFromSource(text))
    : [options.goal]);
  return runEyeDual(programSource, { ...options, goals });
}

export function runRegression(reporter = new TestReporter()) {
  tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'eyedual-regression.'));
  tmpCounter = 0;

  try {
    runSection(reporter, 'Regression', regressionCases());
    runSection(reporter, 'Documentation sync', documentationSyncCases());
    runSection(reporter, 'API', apiCases());
    runSection(reporter, 'White-box', whiteBoxCases());
  } finally {
    fs.rmSync(tmp, { recursive: true, force: true });
    tmp = null;
  }
}

function regressionCases() {
  return [
    {
      name: '--proof rule fact explanation output',
      run: () => runWhy({
        program: 'type(socrates, man).\ntype(X, mortal) :- type(X, man).\n',
        goalText: 'type(socrates, mortal)',
        expected: `type(socrates, mortal).
why(
  type(socrates, mortal),
  proof(
    goal(type(socrates, mortal)),
    by(rule("__FILE__", clause(2))),
    bindings([binding("X", socrates)]),
    uses([
      proof(
        goal(type(socrates, man)),
        by(fact("__FILE__", clause(1)))
      )
    ])
  )
).

`,
      }),
    },
    {
      name: '--proof numeric builtin explanation output',
      run: () => runWhy({
        program: 'p(X) :- between(536, 536, X).\n',
        goalText: 'p(536)',
        expected: `p(536).
why(
  p(536),
  proof(
    goal(p(536)),
    by(rule("__FILE__", clause(1))),
    bindings([binding("X", 536)]),
    uses([
      proof(
        goal(between(536, 536, 536)),
        by(builtin(between, 3))
      )
    ])
  )
).

`,
      }),
    },
    {
      name: '--proof list builtin explanation output',
      run: () => runWhy({
        program: 'p(X) :- member(X, [a]).\n',
        goalText: 'p(a)',
        expected: `p(a).
why(
  p(a),
  proof(
    goal(p(a)),
    by(rule("__FILE__", clause(1))),
    bindings([binding("X", a)]),
    uses([
      proof(
        goal(member(a, [a])),
        by(builtin(member, 2))
      )
    ])
  )
).

`,
      }),
    },
    {
      name: 'explanation backtracks across earlier subgoal alternatives',
      run: () => {
        const result = runWhyLoose({
          program: 'p(ok) :- q(X), r(X).\nq(a).\nq(b).\nr(b).\n',
          goalText: 'p(ok)',
        });
        assertIncludes(result.stdout, 'goal(q(b)),\n        by(fact("', 'stdout');
        assertIncludes(result.stdout, 'goal(r(b)),\n        by(fact("', 'stdout');
        assertNotIncludes(result.stdout, 'no_proof', 'stdout');
      },
    },
    {
      name: 'explanation releases active call before caller rest goals',
      run: () => {
        const result = runWhyLoose({
          program: 'p(ok) :- q(1), q(1).\nq(0).\nq(1) :- q(0).\n',
          goalText: 'p(ok)',
        });
        assertIncludes(result.stdout, 'goal(p(ok)),\n    by(rule("', 'stdout');
        assertIncludes(result.stdout, 'goal(q(1)),\n        by(rule("', 'stdout');
        assertNotIncludes(result.stdout, 'no_proof', 'stdout');
      },
    },
    {
      name: 'EYEDUAL_LOCAL_TIME fixes local_time builtin',
      run: () => {
        const result = runCli(['--goal', 'local_time_answer(D)', '-'], {
          input: 'local_time_answer(D) :- local_time(D).\n',
          env: { EYEDUAL_LOCAL_TIME: '2024-01-02' },
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'local_time_answer("2024-01-02").\n', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'help with no arguments',
      run: () => {
        const result = runCli([]);
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, 'Usage:\n  eyedual [options] [file-or-url.pl|- ...]', 'stdout');
        assertIncludes(result.stdout, '-p, --proof', 'stdout');
        assertIncludes(result.stdout, '-s, --stats', 'stdout');
        assertIncludes(result.stdout, '-v, --version', 'stdout');
        assertIncludes(result.stdout, '-w, --warnings', 'stdout');
        assertIncludes(result.stdout, '-v, --version         Show the package version and exit.\n  -w, --warnings        Print non-fatal portability warnings to stderr.', 'stdout');
        assertIncludes(result.stdout, 'Read an EyeDual program', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'CLI loads EyeDual library predicates by default',
      run: () => {
        const result = runCli(['-'], {
          input: '%% goal: answer(X)\nanswer(X) :- member(X, [library]).\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'answer(library).\n', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'version comes from package.json',
      run: () => {
        const result = runCli(['--version']);
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, `eyedual ${pkg.version}\n`, 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: '-v shows package version',
      run: () => {
        const result = runCli(['-v']);
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, `eyedual ${pkg.version}\n`, 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'npm exec can run package CLI bin from checkout',
      run: () => {
        const result = spawnSync('npm', ['exec', '--loglevel=silent', '--yes', '--package=.', '--', 'eyedual', '--version'], {
          cwd: packageRoot,
          encoding: 'utf8',
          env: { ...process.env, npm_config_update_notifier: 'false' },
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, `eyedual ${pkg.version}\n`, 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'stdin input is accepted',
      run: () => {
        const result = runCli(['-'], { input: '%% goal: q(X, Y)\np(a, b).\nq(X, Y) :- p(X, Y).\n' });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'q(a, b).\n', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },

    {
      name: 'CLI reads repeated goal comments when --goal is omitted',
      run: () => {
        const input = [
          '%% goal: answer(first, X)',
          '%% goal: answer(second, X)',
          'value(first, one).',
          'value(second, two).',
          'answer(Kind, Value) :- value(Kind, Value).',
          '',
        ].join('\n');
        const result = runCli(['-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'answer(first, one).\nanswer(second, two).\n', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'explicit CLI goals override goal comments',
      run: () => {
        const input = [
          '%% goal: answer(metadata, X)',
          'value(metadata, ignored).',
          'value(explicit, selected).',
          'answer(Kind, Value) :- value(Kind, Value).',
          '',
        ].join('\n');
        const result = runCli(['--goal', 'answer(explicit, X)', '-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'answer(explicit, selected).\n', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },

    {
      name: '--proof enables query explanations',
      run: () => {
        const result = runCli(['--proof', '-'], { input: '%% goal: q(X, Y)\np(a, b).\nq(X, Y) :- p(X, Y).\n' });
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, 'q(a, b).\nwhy(', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: '-p enables query explanations',
      run: () => {
        const result = runCli(['-p', '-'], { input: '%% goal: q(X, Y)\np(a, b).\nq(X, Y) :- p(X, Y).\n' });
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, 'q(a, b).\nwhy(', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: '-pw combines proof and warning flags',
      run: () => {
        const input = [
          '%% goal: answer(ok)',
          'p :- \\+ q.',
          'q :- \\+ p.',
          'seed.',
          'answer(ok) :- seed.',
          '',
        ].join('\n');
        const result = runCli(['-pw', '-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, 'answer(ok).\nwhy(', 'stdout');
        assertIncludes(result.stderr, 'eyedual warning: unstratified negation\n', 'stderr');
      },
    },
    {
      name: 'unknown option in a short cluster is rejected',
      run: () => {
        const result = runCli(['-px']);
        assertEqual(result.status, 1, 'exit status');
        assertEqual(result.stdout, '', 'stdout');
        assertIncludes(result.stderr, 'eyedual: unknown option: -px\n', 'stderr');
      },
    },


    {
      name: '--stats prints solver statistics to stderr',
      run: () => {
        const result = runCli(['--stats', '-'], { input: '%% goal: q(X, Y)\np(a, b).\nq(X, Y) :- p(X, Y).\n' });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'q(a, b).\n', 'stdout');
        assertIncludes(result.stderr, 'eyedual stats:\n', 'stderr');
        assertIncludes(result.stderr, '  solve_goals_calls:', 'stderr');
      },
    },
    {
      name: '-s prints solver statistics to stderr',
      run: () => {
        const result = runCli(['-s', '-'], { input: '%% goal: q(X, Y)\np(a, b).\nq(X, Y) :- p(X, Y).\n' });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'q(a, b).\n', 'stdout');
        assertIncludes(result.stderr, 'eyedual stats:\n', 'stderr');
        assertIncludes(result.stderr, '  solve_goals_calls:', 'stderr');
      },
    },
    {
      name: '--warnings prints unstratified negation diagnostics without failing',
      run: () => {
        const input = [
          '%% goal: answer(X)',
          'p(a) :- \\+ q(a).',
          'q(a) :- \\+ p(a).',
          'answer(ok).',
          '',
        ].join('\n');
        const result = runCli(['--warnings', '-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, '', 'stdout');
        assertIncludes(result.stderr, 'eyedual warning: unstratified negation\n', 'stderr');
        assertIncludes(result.stderr, 'p/1 depends negatively on q/1', 'stderr');
        assertIncludes(result.stderr, 'q/1 depends negatively on p/1', 'stderr');
      },
    },
    {
      name: '-w prints unstratified negation diagnostics without failing',
      run: () => {
        const input = [
          '%% goal: answer(X)',
          'p(a) :- \\+ q(a).',
          'q(a) :- \\+ p(a).',
          'answer(ok).',
          '',
        ].join('\n');
        const result = runCli(['-w', '-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, '', 'stdout');
        assertIncludes(result.stderr, 'eyedual warning: unstratified negation\n', 'stderr');
      },
    },
    {
      name: '--warnings stays quiet for stratified negation',
      run: () => {
        const input = '%% goal: answer(X)\np(a).\nq(_) :- fail.\nanswer(ok) :- \\+ q(a).\n';
        const result = runCli(['--warnings', '-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'answer(ok).\n', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'double dash permits option-shaped file names',
      run: () => {
        const file = path.join(tmp, '-h');
        fs.writeFileSync(file, '%% goal: q(X, Y)\np(a, b).\nq(X, Y) :- p(X, Y).\n');
        const result = runCli(['--', file]);
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'q(a, b).\n', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'CLI false/0 fails as an ordinary goal',
      run: () => {
        const input = '%% goal: answer(X)\nanswer(ok) :- false.\n';
        const result = runCli(['-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, '', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'CLI rejects clauses headed by false/0',
      run: () => {
        const input = 'false :- true.\n';
        const result = runCli(['-'], { input });
        assertEqual(result.status, 1, 'exit status');
        assertEqual(result.stdout, '', 'stdout');
        assertIncludes(result.stderr, 'error(permission_error(modify, static_procedure), /(false, 0))', 'stderr');
      },
    },
  ];
}


function documentationSyncCases() {
  return [
    {
      name: 'book builtins match runtime registry',
      run: () => assertArrayEqual(bookBuiltinNames(), registeredBuiltinNames(), 'builtins'),
    },
    {
      name: 'book builtin catalog matches runtime registry',
      run: () => {
        assertArrayEqual(bookBuiltinNames(), registeredBuiltinNames(), 'builtins');
        const summary = bookBuiltinSummary();
        const actual = registeredBuiltinSummary();
        assertEqual(summary.entries, actual.entries, 'builtin entry count');
        assertEqual(summary.names, actual.names, 'builtin predicate name count');
      },
    },
    {
      name: 'book EyeDual library matches runtime registry',
      run: () => assertArrayEqual(bookEyeDualLibraryNames(), registeredEyeDualLibraryNames(), 'EyeDual library predicates'),
    },
    {
      name: 'README links to the book and the book documents runtime boundaries',
      run: () => {
        const readme = fs.readFileSync(path.join(packageRoot, 'README.md'), 'utf8');
        const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyedual.md'), 'utf8');
        assertIncludes(
          readme,
          '[Book — *The Art of EyeDual*](https://eyereasoner.github.io/eyedual/the-art-of-eyedual)',
          'README links to the book',
        );
        for (const filename of ['src/iso.js', 'src/library.js', 'src/playground-worker.js']) {
          assertEqual(fs.existsSync(path.join(packageRoot, filename)), true, `${filename} exists`);
          assertIncludes(book, filename, `book documents ${filename}`);
        }
        assertEqual(fs.existsSync(path.join(packageRoot, 'src', 'portable-library.js')), false, 'obsolete duplicate library module is absent');
        assertEqual('portableLibrarySource' in publicApi, false, 'obsolete portable source API is absent');
        assertEqual(readme.includes('portable-library.js') || readme.includes('portableLibrarySource'), false, 'README has no obsolete portable layer');
        assertEqual(book.includes('portable-library.js') || book.includes('portableLibrarySource'), false, 'book has no obsolete portable layer');
        assertEqual(fs.existsSync(path.join(packageRoot, 'src', 'builtins')), false, 'obsolete builtins directory is absent');
      },
    },
    {
      name: 'book example catalog names resolve in examples directory',
      run: () => assertArrayEqual(bookExampleCatalogIssues(), [], 'guide example catalog'),
    },
    {
      name: 'documented runnable example count and goldens match corpus',
      run: () => assertArrayEqual(exampleCorpusSyncIssues(), [], 'example corpus sync'),
    },
    {
      name: 'documented proof example count and runner match proof goldens',
      run: () => assertArrayEqual(proofCorpusSyncIssues(), [], 'proof corpus sync'),
    },
    {
      name: 'playground example catalog and relative loaders match examples directory',
      run: () => assertArrayEqual(playgroundExampleIssues(), [], 'playground examples'),
    },
    {
      name: 'playground static page is browser-ready and packaged',
      run: () => assertArrayEqual(playgroundStaticIssues(), [], 'playground static page'),
    },
    {
      name: 'documentation local links and anchors resolve',
      run: () => assertArrayEqual(findBrokenDocLinks(), [], 'broken documentation links'),
    },
    {
      name: 'book example extraction matches the Markdown source',
      run: () => {
        const result = spawnSync(process.execPath, ['tools/extract-book-examples.mjs', '--check'], {
          cwd: packageRoot,
          encoding: 'utf8',
        });
        assertEqual(result.status, 0, `exit status${result.stderr ? `\nstderr: ${result.stderr}` : ''}`);
        assertIncludes(result.stdout, 'extracted book examples are up to date.', 'stdout');
      },
    },
    {
      name: 'book introductory output matches the checked Socrates example',
      run: () => assertArrayEqual(bookIntroOutputIssues(), [], 'book introductory output'),
    },
    {
      name: 'documentation imports only public JavaScript API names',
      run: () => assertArrayEqual(documentedPublicApiImportIssues(), [], 'documentation API imports'),
    },
    {
      name: 'documentation uses EyeDual source style',
      run: () => assertArrayEqual(documentationSourceStyleIssues(), [], 'documentation source style'),
    },
    {
      name: 'book is the single implementation reference',
      run: () => assertArrayEqual(bookReferenceDocumentationIssues(), [], 'book reference documentation'),
    },
    {
      name: 'documented npm scripts exist in package.json',
      run: () => assertArrayEqual(missingDocumentedPackageScripts(), [], 'missing documented npm scripts'),
    },
    {
      name: 'documented conformance totals match the generated report',
      run: () => assertArrayEqual(documentedConformanceMetricIssues(), [], 'documented conformance totals'),
    },
    {
      name: 'conformance report summarizes public corpus',
      run: () => {
        const report = buildConformanceReport();
        assertArrayEqual(report.issues, [], 'conformance report issues');
        assertEqual(report.total.total >= 475, true, 'conformance case count');
        assertEqual(report.total.positive + report.total.errors + report.total.warnings + report.total.proofs, report.total.total, 'conformance total');
        assertEqual(report.rows.some((row) => row.category === 'legacy-numbered'), false, 'legacy-numbered category');
        const text = formatConformanceReport(report);
        assertIncludes(text, '| variables |', 'report');
        assertIncludes(text, '| Proofs |', 'report');
        assertIncludes(text, '| **Total** |', 'report');
      },
    },

    {
      name: 'committed conformance report is current',
      run: () => {
        const reportFile = path.join(packageRoot, 'conformance-report.md');
        assertEqual(fs.existsSync(reportFile), true, 'conformance-report.md exists');
        assertEqual(fs.readFileSync(reportFile, 'utf8'), formatConformanceReport(buildConformanceReport()), 'conformance-report.md');
      },
    },
    {
      name: 'source-checkout setup docs match package bin',
      run: () => {
        assertEqual(pkg.bin?.eyedual, './bin/eyedual.js', 'package eyedual bin');
        const binPath = path.join(packageRoot, pkg.bin.eyedual);
        const binText = fs.readFileSync(binPath, 'utf8');
        assertEqual(binText.startsWith('#!/usr/bin/env node\n'), true, 'bin shebang');
        assertArrayEqual(misleadingDependencyInstallDocs(), [], 'misleading dependency install docs');
      },
    },
  ];
}

function apiCases() {
  return [
    {
      name: 'public type declarations match runtime exports',
      run: () => assertArrayEqual(declaredValueExportNames(), runtimeExportNames(), 'public value exports'),
    },
    {
      name: 'run queries through public API without proof by default',
      run: () => {
        const result = run('%% goal: q(X, Y)\np(a, b).\nq(X, Y) :- p(X, Y).\n');
        assertEqual(result.stdout, 'q(a, b).\n', 'stdout');
      },
    },
    {
      name: 'ISO standard streams use API input and ordered output',
      run: () => {
        const writes = [];
        const result = run(
          'answer(T) :- read(T), write(read_back(T)), nl.\n',
          { goal: 'answer(T)', ioOptions: { input: 'sample(42).', write: (text) => writes.push(text) } },
        );
        assertEqual(result.stdout, 'read_back(sample(42))\nanswer(sample(42)).\n', 'stdout');
        assertEqual(writes.join(''), 'read_back(sample(42))\n', 'write callback');
      },
    },
    {
      name: 'ISO directives initialize state before queries',
      run: () => {
        const result = run([
          ':- dynamic(saved/1).',
          ':- initialization(assertz(saved(ready))).',
          ':- op(500, xfy, joins).',
          '%% goal: answer(X)',
          'answer(X) :- saved(ready), X = (a joins b joins c).',
        ].join('\n'));
        assertEqual(result.stdout, 'answer(joins(a, joins(b, c))).\n', 'stdout');
      },
    },
    {
      name: 'empty dynamic predicates fail as defined procedures',
      run: () => {
        const result = run([
          ':- dynamic(cache/1).',
          '%% goal: answer(X)',
          'answer(X) :- cache(X), !.',
          'answer(computed) :- assertz(cache(computed)).',
        ].join('\n'));
        assertEqual(result.stdout, 'answer(computed).\n', 'stdout');
      },
    },
    {
      name: 'scalar fact acceleration preserves Prolog term types',
      run: () => {
        const result = run([
          '%% goal: number_fact(X)',
          '%% goal: atom_fact(X)',
          '%% goal: string_fact(X)',
          '%% goal: repeated(X)',
          'number_fact(X) :- scalar(7, X).',
          "atom_fact(X) :- scalar('7', X).",
          'string_fact(X) :- scalar("7", X).',
          'repeated(X) :- pair(X, X).',
          'scalar(7, number).',
          "scalar('7', atom).",
          'scalar("7", string).',
          "pair(7, '7').",
        ].join('\n'));
        assertEqual(result.stdout, [
          'number_fact(number).',
          'atom_fact(atom).',
          'string_fact(string).',
          '',
        ].join('\n'), 'stdout');
      },
    },
    {
      name: 'dynamic updates invalidate tabled answers',
      run: () => {
        const result = run([
          ':- dynamic(edge/2).',
          'path(X, Y) :- edge(X, Y).',
          'path(X, Y) :- edge(X, Z), path(Z, Y).',
          '%% goal: test(Before, After)',
          'test(Before, After) :-',
          '  assertz(edge(a, b)),',
          '  findall(X, path(a, X), Before),',
          '  assertz(edge(b, c)),',
          '  findall(Y, path(a, Y), After).',
        ].join('\n'));
        assertEqual(result.stdout, 'test([b], [b, c]).\n', 'stdout');
      },
    },
    {
      name: 'default EyeDual registry keeps dynamic program state consistent',
      run: () => {
        const program = Program.parse([
          ':- dynamic(item/1).',
          '%% goal: done',
          'done :- assertz(item(a)), retract(item(a)), assertz(item(b)), abolish(item/1).',
        ].join('\n'));
        const result = run(program, { goal: 'done', registry: getEyeDualRegistry() });
        assertEqual(result.stdout, 'done.\n', 'stdout');
        assertEqual(program.findGroup('item', 1), null, 'abolished group');
        assertEqual(
          program.clauses.some((clause) => clause.head?.name === 'item'),
          false,
          'abolished clauses removed from original program',
        );
      },
    },
    {
      name: 'halt returns processor status through the API',
      run: () => {
        const result = run('stop :- write(stopping), halt(7).\n', { goal: 'stop' });
        assertEqual(result.stdout, 'stopping', 'stdout before halt');
        assertEqual(result.haltCode, 7, 'halt code');
      },
    },
    {
      name: 'query constants restrict answers',
      run: () => {
        const result = run('%% goal: answer(a, X)\nseed(a, one).\nseed(b, two).\nanswer(K, V) :- seed(K, V).\n');
        assertEqual(result.stdout, 'answer(a, one).\n', 'stdout');
      },
    },
    {
      name: 'programs without queries produce no answer output',
      run: () => {
        const result = run('seed(a, one).\nanswer(K, V) :- seed(K, V).\n');
        assertEqual(result.stdout, '', 'stdout');
      },
    },
    {
      name: 'run exposes false/0 as an always-failing built-in',
      run: () => {
        const result = run('answer(ok) :- false.\n', { goal: 'answer(X)' });
        assertEqual(result.stdout, '', 'stdout');
        assertEqual(Boolean(createDefaultRegistry().get('false', 0)), true, 'false/0 is registered');
      },
    },
    {
      name: 'source clauses cannot redefine false/0',
      run: () => {
        for (const source of ['false.\n', 'false :- true.\n', ':- dynamic(false/0).\n']) {
          let error = null;
          try {
            Program.parse(source);
          } catch (caught) {
            error = caught;
          }
          assertEqual(error?.name, 'PrologError', 'error name');
          assertEqual(error?.message, 'error(permission_error(modify, static_procedure), /(false, 0))', 'error');
        }
      },
    },

    {
      name: 'compound factory canonicalizes zero arity to atoms',
      run: () => {
        const nil = compound('nil', []);
        assertEqual(nil.type, 'atom', 'type');
        assertEqual(nil.name, 'nil', 'name');
        assertEqual(nil.arity, 0, 'arity');
        assertEqual(termToString(nil, new Env(), true), 'nil', 'readback');
        assertEqual(unify(nil, atom('nil'), new Env()), true, 'unifies with atom');
      },
    },


    {
      name: 'run query can enable proof explanations',
      run: () => {
        const result = run('%% goal: q(X, Y)\np(a, b).\nq(X, Y) :- p(X, Y).\n', { proof: true });
        assertIncludes(result.stdout, 'q(a, b).\nwhy(', 'stdout');
      },
    },

    {
      name: 'run accepts Program instances',
      run: () => {
        const program = Program.parse('p(a, b).\nq(X, Y) :- p(X, Y).\n');
        const result = run(program, { goal: 'q(X, Y)' });
        assertEqual(result.stdout, 'q(a, b).\n', 'stdout');
      },
    },
    {
      name: 'run keeps recursive queries independent in one solver',
      run: () => {
        const text = fs.readFileSync(path.join(packageRoot, 'examples', 'alignment-demo.pl'), 'utf8');
        const program = Program.parseSources([{ text, filename: 'alignment-demo.pl' }]);
        const result = run(program, { goals: goalsFromSource(text) });
        assertIncludes(result.stdout, 'broaderTransitive(anpr_passenger_car, ref_car).\n', 'stdout');
        assertIncludes(result.stdout, 'narrowerOrEqualOf(anpr_passenger_car, ref_car).\n', 'stdout');
      },
    },
    {
      name: 'makeProgram creates indexed programs',
      run: () => {
        const program = makeProgram('edge(a, b).\npath(X, Y) :- edge(X, Y).\n');
        const group = program.findGroup('path', 2);
        assertEqual(Boolean(group), true, 'path/2 group exists');
        assertEqual(group.groupName ?? group.name, 'path', 'group name');
        assertEqual(group.arity, 2, 'group arity');
      },
    },
    {
      name: 'program keeps negation diagnostics lazy by default',
      run: () => {
        const program = Program.parse('p(a).\nq(X) :- \\+ p(X).\n');
        assertEqual(program._negationAnalysis, null, 'analysis starts lazy');
        assertEqual(program.negationDependencies.length, 1, 'dependency count');
        assertEqual(program._negationAnalysis !== null, true, 'analysis computed on demand');
      },
    },
    {
      name: 'analyzeNegation option computes diagnostics eagerly',
      run: () => {
        const program = Program.parse('p(a).\nq(X) :- \\+ p(X).\n', { analyzeNegation: true });
        assertEqual(program._negationAnalysis !== null, true, 'analysis computed eagerly');
        assertEqual(program.stratifiedNegation, true, 'stratified negation');
      },
    },
    {
      name: 'program reports stratified negation metadata',
      run: () => {
        const program = Program.parse(`
%% goal: open(X0)
candidate(a).
blocked(b).
closed(X) :- blocked(X).
open(X) :- candidate(X), \\+ closed(X).
`);
        assertEqual(program.isStratifiedNegation(), true, 'stratified negation');
        assertEqual(program.negationStratificationErrors.length, 0, 'stratification errors');
        assertEqual(program.findGroup('closed', 1).negationStratum, 0, 'closed stratum');
        assertEqual(program.findGroup('open', 1).negationStratum, 1, 'open stratum');
      },
    },
    {
      name: 'program detects unstratified negation cycles',
      run: () => {
        const program = Program.parse('p(X) :- q(X).\nq(X) :- \\+ p(X).\n');
        assertEqual(program.isStratifiedNegation(), false, 'unstratified negation');
        assertEqual(program.negationStratificationErrors.length, 1, 'stratification error count');
        assertEqual(program.negationStratificationErrors[0].from, 'q/1', 'error source');
        assertEqual(program.negationStratificationErrors[0].to, 'p/1', 'error target');
        let threw = false;
        try { program.assertStratifiedNegation(); } catch (err) {
          threw = true;
          assertIncludes(err.message, 'unstratified negation', 'error message');
        }
        assertEqual(threw, true, 'assertion throws');
      },
    },
    {
      name: 'strictNegation option rejects unstratified programs',
      run: () => {
        let threw = false;
        try { Program.parse('p(X) :- \\+ p(X).\n', { strictNegation: true }); } catch (err) {
          threw = true;
          assertIncludes(err.message, 'p/1 depends negatively on p/1', 'error message');
        }
        assertEqual(threw, true, 'strict negation throws');
      },
    },
    {
      name: 'run loads the EyeDual library by default',
      run: () => {
        const result = run('answer(X) :- append([a], [b], X).', { goal: 'answer(X)' });
        assertEqual(result.stdout, 'answer([a, b]).\n', 'stdout');
      },
    },
    {
      name: 'Solver loads the EyeDual library by default',
      run: () => {
        const program = Program.parse('answer(X) :- append([a], [b], X).');
        const solver = new Solver(program);
        const goal = parseGoalText('answer(X)');
        const answers = [...solver.solve([goal], new Env(), 0)].map((env) => termToString(goal, env, true));
        assertEqual(answers.join('\n'), 'answer([a, b])', 'answers');
      },
    },
    {
      name: 'program and solver public classes',
      run: () => {
        const program = Program.parse('p(a).\np(b).\n');
        const solver = new Solver(program);
        const goal = parseGoalText('p(X)');
        const answers = [...solver.solve([goal], new Env(), 0)].map((env) => termToString(goal, env, true));
        assertEqual(answers.join('\n'), 'p(a)\np(b)', 'answers');
      },
    },
    {
      name: 'solver honors solution limits',
      run: () => {
        const program = Program.parse('p(a).\np(b).\np(c).\n');
        const solver = new Solver(program, { solutionLimit: 2 });
        const goal = parseGoalText('p(X)');
        const answers = [...solver.solve([goal], new Env(), 0)].map((env) => termToString(goal, env, true));
        assertEqual(answers.join('\n'), 'p(a)\np(b)', 'answers');
      },
    },
    {
      name: 'custom builtin registry can be embedded',
      run: () => {
        const registry = new BuiltinRegistry();
        registry.add('hello', 1, function* ({ goal, env }) {
          const next = env.clone();
          if (unify(goal.args[0], atom('world'), next)) yield next;
        });
        const program = Program.parse('answer(X) :- hello(X).\n');
        const solver = new Solver(program, { registry });
        const goal = parseGoalText('answer(X)');
        const answers = [...solver.solve([goal], new Env(), 0)].map((env) => termToString(goal, env, true));
        assertEqual(answers.join('\n'), 'answer(world)', 'answers');
      },
    },
    {
      name: 'ISO-only and EyeDual registries expose separate metadata',
      run: () => {
        const registry = createDefaultRegistry();
        const library = getEyeDualRegistry();
        assertEqual(Boolean(registry.get('is', 2)), true, 'ISO is/2 exists');
        assertEqual(Boolean(registry.get('append', 3)), false, 'append/3 is not ISO core');
        assertEqual(library.eyeDualLibrary, true, 'complete registry marker');
        assertEqual(library.defs.size, 165, 'complete registry size');
        assertEqual(registeredEyeDualLibraryNames().length, 50, 'EyeDual library size');
        assertEqual(library.get('append', 3)?.eyeDualLibrary, true, 'append/3 metadata');
        assertEqual(library.get('maplist', 3)?.eyeDualLibrary, true, 'maplist/3 metadata');
        assertEqual(library.get('matches', 3)?.eyeDualLibrary, true, 'matches/3 metadata');
        assertEqual(library.get('uuid', 1)?.deterministic, true, 'uuid/1 deterministic metadata');
        for (const [name, arity] of [['not_member', 2], ['head', 2], ['rest', 2], ['min', 3], ['max', 3]]) {
          assertEqual(library.get(name, arity), null, `${name}/${arity} removed from library`);
        }
      },
    },
    {
      name: 'EyeDual library does not inject program clauses',
      run: () => {
        const program = Program.parse('answer(X) :- append([a], [b], X).');
        const solver = new Solver(program);
        assertEqual(solver.program, program, 'solver keeps original program object');
        assertEqual(program.findGroup('append', 3), null, 'append/3 is not injected as a clause group');
        assertEqual(fs.existsSync(path.join(packageRoot, 'src', 'portable-library.js')), false, 'portable module removed');
        assertEqual(run(program, { goal: 'answer(X)' }).stdout, 'answer([a, b]).\n', 'native append execution');
      },
    },
    {
      name: 'EyeDual library preserves relational and arithmetic behavior',
      run: () => {
        const result = run([
          '%% goal: answer(A, B, S, M)',
          'answer(A, B, S, M) :-',
          '  append(A, B, [a, b]),',
          '  sumall(X + 1, member(X, [1, 2]), S),',
          '  (9007199254740992 >= 9007199254740993 -> M = 9007199254740992 ; M = 9007199254740993).',
          '',
        ].join('\n'));
        assertEqual(result.stdout, [
          'answer([], [a, b], 5, 9007199254740993).',
          'answer([a], [b], 5, 9007199254740993).',
          'answer([a, b], [], 5, 9007199254740993).',
          '',
        ].join('\n'), 'EyeDual library behavior');
      },
    },
    {
      name: 'EyeDual library preserves strict modes and ISO arithmetic errors',
      run: () => {
        assertEqual(run('answer(X) :- substring("abc", "1", 1, X).', { goal: 'answer(X)' }).stdout, '', 'substring index type');
        let nth1Error = null;
        try { run('answer(N) :- nth1(N, [a, b], _).', { goal: 'answer(N)' }); } catch (error) { nth1Error = error; }
        assertIncludes(nth1Error?.message ?? '', 'instantiation_error', 'nth1 variable index error');
        let sumError = null;
        try { run('answer(S) :- sum_list([1, foo], S).', { goal: 'answer(S)' }); } catch (error) { sumError = error; }
        assertIncludes(sumError?.message ?? '', 'type_error(evaluable)', 'sum_list arithmetic error');
      },
    },
  ];
}

function whiteBoxCases() {
  return [
    {
      name: 'unification binds variables in Env',
      run: () => {
        const env = new Env();
        assertEqual(unify(variable('X'), atom('socrates'), env), true, 'unify result');
        assertEqual(termToString(variable('X'), env, true), 'socrates', 'binding');
      },
    },
    {
      name: 'unification rejects direct and indirect cyclic bindings',
      run: () => {
        const direct = new Env();
        assertEqual(
          unify(variable('X'), compound('wrapper', [variable('X')]), direct),
          false,
          'direct cycle',
        );
        assertEqual(direct.has('X'), false, 'failed direct binding is not installed');

        const indirect = new Env();
        indirect.bind('Y', compound('wrapper', [variable('X')]));
        assertEqual(unify(variable('X'), variable('Y'), indirect), false, 'indirect cycle');
        assertEqual(indirect.has('X'), false, 'failed indirect binding is not installed');
      },
    },
    {
      name: 'cloned environments detach on first write',
      run: () => {
        const parent = new Env();
        parent.bind('Shared', atom('before'));
        const left = parent.clone();
        const right = parent.clone();
        left.bind('Left', atom('only_left'));
        right.bind('Right', atom('only_right'));
        parent.bind('Parent', atom('only_parent'));
        assertEqual(left.get('Shared').name, 'before', 'left keeps shared binding');
        assertEqual(left.has('Right'), false, 'left excludes right write');
        assertEqual(left.has('Parent'), false, 'left excludes parent write');
        assertEqual(right.has('Left'), false, 'right excludes left write');
        assertEqual(parent.has('Left'), false, 'parent excludes child write');
      },
    },
    {
      name: 'deep environment chains flatten without losing bindings',
      run: () => {
        const env = new Env();
        for (let i = 0; i < 40; i++) env.bind(`V${i}`, numberTerm(i));
        assertEqual(env.get('V0').name, '0', 'oldest binding');
        assertEqual(env.get('V31').name, '31', 'binding before flatten');
        assertEqual(env.get('V39').name, '39', 'latest binding');
        assertEqual(env.has('missing'), false, 'missing binding');

        const clone = env.clone();
        clone.bind('OnlyClone', atom('yes'));
        assertEqual(clone.get('OnlyClone').name, 'yes', 'clone write');
        assertEqual(env.has('OnlyClone'), false, 'clone remains isolated');
      },
    },
    {
      name: 'copyResolved and termIsGround follow bindings',
      run: () => {
        const env = new Env();
        const term = compound('p', [variable('X'), atom('b')]);
        assertEqual(termIsGround(term, env), false, 'not ground before binding');
        assertEqual(unify(variable('X'), atom('a'), env), true, 'bind X');
        const resolved = copyResolved(term, env);
        assertEqual(termToString(resolved, new Env(), true), 'p(a, b)', 'resolved term');
        assertEqual(termIsGround(resolved), true, 'ground after copy');
      },
    },

    {
      name: 'parser accepts ISO infix subtraction terms',
      run: () => {
        const [clause] = parseProgramText('value(a-b, ok).\n');
        assertEqual(termToString(clause.head.args[0]), "'-'(a, b)", 'a-b term');
      },
    },
    {
      name: 'parser rejects zero-arity compound syntax',
      run: () => {
        let threw = false;
        try { parseProgramText('value(nil(), ok).\n'); } catch (_) { threw = true; }
        assertEqual(threw, true, 'zero-arity compound rejection');
      },
    },
    {
      name: 'parser preserves list syntax readback',
      run: () => {
        const goal = parseGoalText('member(X, [a, b])');
        assertEqual(termToString(goal, new Env(), true), 'member(X, [a, b])', 'goal');
      },
    },
    {
      name: 'parser accepts ISO-style uppercase variables',
      run: () => {
        const goal = parseGoalText('member(X, [a, b])');
        assertEqual(termToString(goal, new Env(), true), 'member(X, [a, b])', 'goal');
      },
    },
    {
      name: 'parser treats bare underscore as anonymous',
      run: () => {
        const clauses = parseProgramText('p(_, _).\n');
        const left = clauses[0].head.args[0].name;
        const right = clauses[0].head.args[1].name;
        assertEqual(left.startsWith('__anon'), true, 'left anonymous');
        assertEqual(right.startsWith('__anon'), true, 'right anonymous');
        assertEqual(left === right, false, 'fresh anonymous variables');
      },
    },
    {
      name: 'parser rejects old question-mark variable spelling',
      run: () => {
        let threw = false;
        try { parseProgramText('p(?x).\n'); } catch (_) { threw = true; }
        assertEqual(threw, true, 'question-mark variable syntax rejected');
      },
    },
    {
      name: 'parser accepts bare underscore anonymous variable spelling',
      run: () => {
        let threw = false;
        try { parseProgramText('p(_).\n'); } catch (_) { threw = true; }
        assertEqual(threw, false, 'bare underscore syntax accepted');
      },
    },
    {
      name: 'parser rejects unquoted dotted atoms to stay ISO-compatible',
      run: () => {
        let threw = false;
        try { parseProgramText('p(web(be.ugent, josd)).\n'); } catch (_) { threw = true; }
        assertEqual(threw, true, 'unquoted dotted atoms must be quoted');
      },
    },
    {
      name: 'parser preserves quoted dotted atoms for web-style terms',
      run: () => {
        const clauses = parseProgramText("p(web('be.ugent', josd), 'org.schema').\n");
        assertEqual(termToString(clauses[0].head, new Env(), true), "p(web('be.ugent', josd), 'org.schema')", 'head');
      },
    },
    {
      name: 'parser accepts quoted angle-bracket atoms',
      run: () => {
        const clauses = parseProgramText("p('<https://example.org/alice>', '<urn:example:bob>').\n");
        assertEqual(termToString(clauses[0].head, new Env(), true), "p('<https://example.org/alice>', '<urn:example:bob>')", 'head');
      },
    },
    {
      name: 'readback leaves absolute IRI atoms as quoted atoms',
      run: () => {
        const clauses = parseProgramText("p('https://example.org/alice').\n");
        assertEqual(termToString(clauses[0].head, new Env(), true), "p('https://example.org/alice')", 'head');
      },
    },
    {
      name: 'angle IRI syntax does not steal graphic atom syntax',
      run: () => {
        const clauses = parseProgramText('p(<=>).\n');
        assertEqual(termToString(clauses[0].head, new Env(), true), 'p(<=>)', 'head');
      },
    },
    {
      name: 'list construction round-trips through properListItems',
      run: () => {
        const list = listFromItems([atom('a'), numberTerm(2), stringTerm('c')]);
        const items = properListItems(list, new Env());
        assertEqual(items.length, 3, 'length');
        assertEqual(termToString(list, new Env(), true), '[a, 2, "c"]', 'list text');
      },
    },
    {
      name: 'variantTerms recognizes alpha-equivalent goals',
      run: () => {
        const left = parseGoalText('edge(X, Y)');
        const right = parseGoalText('edge(A, B)');
        const nonVariant = parseGoalText('edge(A, A)');
        assertEqual(variantTerms(left, new Env(), right, new Env()), true, 'variant');
        assertEqual(variantTerms(left, new Env(), nonVariant, new Env()), false, 'non-variant');
      },
    },
    {
      name: 'flattenConjunction preserves left-to-right order',
      run: () => {
        const goal = parseGoalText('(a, b, c)');
        const parts = flattenConjunction(goal).map((part) => termToString(part, new Env(), true));
        assertEqual(parts.join(' | '), 'a | b | c', 'order');
      },
    },
    {
      name: 'parseProgramText returns clause objects',
      run: () => {
        const clauses = parseProgramText('p(a).\nq(X) :- p(X).\n');
        assertEqual(clauses.length, 2, 'clause count');
        assertEqual(termToString(clauses[1].head, new Env(), true), 'q(X)', 'rule head');
        assertEqual(clauses[1].body.length, 1, 'body length');
      },
    },
    {
      name: 'fast parser bounds rule-marker scans to the current fact line',
      run: () => {
        const lines = ['q(X, Y) :- p(X, Y).'];
        for (let index = 0; index < 2_000; index++) lines.push(`p(a${index}, b${index}).`);
        const source = lines.join('\n');
        const originalIndexOf = String.prototype.indexOf;
        let wholeSourceRuleScans = 0;
        String.prototype.indexOf = function patchedIndexOf(search, ...args) {
          if (search === ':-' && String(this) === source) wholeSourceRuleScans++;
          return originalIndexOf.call(this, search, ...args);
        };
        try {
          const program = Program.parse(source, { sourceMetadata: false });
          assertEqual(program.clauses.length, 2_001, 'clause count');
          assertEqual(wholeSourceRuleScans, 0, 'whole-source rule scans');
        } finally {
          String.prototype.indexOf = originalIndexOf;
        }
      },
    },
    {
      name: 'clause candidate selection builds arbitrary-width indexes on demand',
      run: () => {
        const facts = ['row(a0, b0, c0, first).', 'row(a0, X, c0, wildcard).'];
        for (let a = 0; a < 6; a++) {
          for (let b = 0; b < 6; b++) {
            for (let c = 0; c < 6; c++) {
              if (a !== 0 || b !== 0 || c !== 0) facts.push(`row(a${a}, b${b}, c${c}, other).`);
            }
          }
        }
        const program = Program.parse(facts.join('\n'));
        const group = program.findGroup('row', 4);
        assertEqual(group.demandIndexes.size, 0, 'indexes start empty');
        const goal = parseGoalText('row(a0, b0, c0, Result)');
        const candidates = selectClauseCandidates(group, goal, new Env());
        assertEqual(group.argIndexes.length, 4, 'any-argument indexes available');
        assertEqual(group.demandIndexes.has('0'), false, 'single indexes are not rebuilt lazily');
        assertEqual(group.demandIndexes.has('0,1,2'), true, 'three-argument index built');
        assertEqual(candidates.primary.length, 2, 'candidate length');
        assertEqual(candidates.fallback.length, 0, 'one ordered candidate stream');
        assertEqual(termToString(candidates.primary[0].head, new Env(), true), 'row(a0, b0, c0, first)', 'first head');
        assertEqual(termToString(candidates.primary[1].head, new Env(), true), 'row(a0, X, c0, wildcard)', 'wildcard head');

        const variableHeavy = Program.parse(Array.from(
          { length: 12 },
          (_, index) => `open(X${index}, Y${index}, value${index}).`,
        ).join('\n'));
        const openGroup = variableHeavy.findGroup('open', 3);
        selectClauseCandidates(openGroup, parseGoalText('open(a, b, Result)'), new Env());
        assertEqual(openGroup.demandIndexes.size, 0, 'poor wide index discarded');
        assertEqual(openGroup.rejectedDemandIndexes.has('0,1'), true, 'poor call mode remembered');
      },
    },
    {
      name: 'dynamic mutations refresh recursive planning',
      run: () => {
        const program = Program.parse(':- dynamic(loop/1).\n');
        const group = program.findGroup('loop', 1);
        assertEqual(group.recursive, false, 'empty dynamic predicate is not recursive');
        assertEqual(program.revision, 0, 'initial revision');
        program.insertDynamicClause({
          head: compound('loop', [variable('X')]),
          body: [compound('loop', [variable('X')])],
        });
        assertEqual(program.revision, 1, 'mutation revision');
        assertEqual(group.recursive, true, 'recursive flag refreshed');
        assertEqual(group.tabled, true, 'tabling decision refreshed');
      },
    },
    {
      name: 'recursive predicate groups are tabled automatically',
      run: () => {
        const program = Program.parse('edge(a, b).\npath(X, Y) :- edge(X, Y).\npath(X, Z) :- path(X, Y), edge(Y, Z).\n');
        const group = program.findGroup('path', 2);
        assertEqual(Boolean(group), true, 'path/2 group exists');
        assertEqual(group.tabled, true, 'path/2 tabled automatically');
      },
    },
    {
      name: 'directly queried recursive groups are tabled automatically',
      run: () => {
        const program = Program.parse('%% goal: path(X, Y)\nedge(a, b).\npath(X, Y) :- edge(X, Y).\npath(X, Z) :- edge(X, Y), path(Y, Z).\n');
        const group = program.findGroup('path', 2);
        assertEqual(group.tabled, true, 'queried path/2 tabled automatically');
      },
    },
    {
      name: 'cycles through negation retain guarded resolution',
      run: () => {
        const program = Program.parse('p(X) :- \\+ q(X).\nq(X) :- p(X).\n');
        assertEqual(program.findGroup('p', 1).recursive, true, 'p/1 recursive');
        assertEqual(program.findGroup('q', 1).recursive, true, 'q/1 recursive');
        assertEqual(program.findGroup('p', 1).tabled, false, 'p/1 not positively tabled');
        assertEqual(program.findGroup('q', 1).tabled, false, 'q/1 not positively tabled');
      },
    },
    {
      name: 'cyclic tabling reaches a complete fixed point',
      run: () => {
        const result = run(Program.parse(`
edge(a, b).
edge(b, c).
edge(c, d).
edge(d, a).
path(X, Y) :- edge(X, Y).
path(X, Z) :- edge(X, Y), path(Y, Z).
`), { goal: 'path(X0, X1)' });
        const answers = result.stdout.trim().split('\n');
        assertEqual(answers.length, 16, 'four-node cycle transitive closure size');
        for (const node of ['a', 'b', 'c', 'd']) {
          assertIncludes(result.stdout, `path(${node}, ${node}).\n`, `${node} reaches itself`);
        }
        assertEqual(result.stats.table_fixpoint_rounds > 1, true, 'cyclic table required multiple rounds');
      },
    },
    {
      name: 'challenging examples infer dynamic-programming predicates automatically',
      run: () => {
        const checks = [
          ['binomial-vandermonde.pl', 'choose_step', 5, true],
          ['catalan-convolution.pl', 'catalan', 2, true],
          ['chart-parser.pl', 'span', 4, true],
          ['continued-fraction-sqrt2.pl', 'conv', 3, true],
          ['critical-path-schedule.pl', 'earliest_start', 2, true],
          ['critical-path-schedule.pl', 'finish_time', 2, true],
          ['integer-partitions.pl', 'partitions', 3, true],
          ['matrix-chain-order.pl', 'cost', 3, true],
          ['modular-exponentiation.pl', 'pow_mod', 4, true],
          ['pell-equation.pl', 'pell', 3, true],
          ['stirling-bell-numbers.pl', 'stirling2', 3, false],
          ['totient-summatory.pl', 'gcd', 3, true],
          ['totient-summatory.pl', 'totient', 2, false],
          ['weighted-interval-scheduling.pl', 'best_from', 2, true],
        ];
        for (const [filename, name, arity, recursive] of checks) {
          const text = fs.readFileSync(path.join(packageRoot, 'examples', filename), 'utf8');
          const program = Program.parseSources([{ text, filename }]);
          const group = program.findGroup(name, arity);
          assertEqual(Boolean(group), true, `${filename} ${name}/${arity} group exists`);
          assertEqual(group.tabled, recursive, `${filename} ${name}/${arity} automatic table decision`);
          assertEqual(group.recursive, recursive, `${filename} ${name}/${arity} recursive`);
        }
      },
    },
    {
      name: 'n-queens example keeps recursive search predicates tabled',
      run: () => {
        const text = fs.readFileSync(path.join(packageRoot, 'examples', 'n-queens.pl'), 'utf8');
        const program = Program.parseSources([{ text, filename: 'n-queens.pl' }]);
        const attack = program.findGroup('attack', 3);
        assertEqual(Boolean(attack), true, 'attack/3 group exists');
        assertEqual(attack.tabled, true, 'attack/3 tabled');
        assertEqual(attack.recursive, true, 'attack/3 recursive');
        assertEqual(attack.tableInputPositions.join(','), '2', 'diagonal scan uses the placed rows as input');
        const queens = program.findGroup('queens', 3);
        assertEqual(Boolean(queens), true, 'queens/3 group exists');
        assertEqual(queens.tabled, true, 'queens/3 tabled');
        assertEqual(queens.recursive, true, 'queens/3 recursive');
      },
    },
    {
      name: 'collatz example keeps recursive trajectory predicate tabled',
      run: () => {
        const text = fs.readFileSync(path.join(packageRoot, 'examples', 'collatz-1000.pl'), 'utf8');
        const program = Program.parseSources([{ text, filename: 'collatz-1000.pl' }]);
        const group = program.findGroup('collatz', 2);
        assertEqual(Boolean(group), true, 'collatz/2 group exists');
        assertEqual(group.tabled, true, 'collatz/2 tabled');
        assertEqual(group.recursive, true, 'collatz/2 recursive');
        assertEqual(group.tableInputPositions.join(','), '0', 'collatz uses its numeric seed as input');
      },
    },
    {
      name: 'collatz example remains stack-safe for browser-sized stacks',
      run: () => {
        // Use a deliberately tiny stack to catch browser-worker recursion regressions.
        const source = fs.readFileSync(path.join(packageRoot, 'examples', 'collatz-1000.pl'), 'utf8');
        const goalArgs = goalsFromSource(source).flatMap((goal) => ['--goal', goal]);
        const result = spawnSync(process.execPath, ['--stack-size=100', bin, ...goalArgs, 'examples/collatz-1000.pl'], {
          cwd: packageRoot,
          encoding: 'utf8',
        });
        assertEqual(result.status, 0, `exit status${result.stderr ? `\nstderr: ${result.stderr}` : ''}`);
        assertEqual(result.stderr, '', 'stderr');
        assertIncludes(result.stdout, 'collatzTrajectory(1000, [1000, 500, 250, 125', 'stdout');
        assertIncludes(result.stdout, 'collatzTrajectory(1, [1]).\n', 'stdout');
      },
    },
  ];
}

function runSection(reporter, name, cases) {
  reporter.section(name);
  for (const testCase of cases) reporter.test(testCase.name, testCase.run);
  reporter.sectionTotal(sectionLabel(name));
}

function sectionLabel(name) {
  if (name === 'Documentation sync') return 'documentation sync';
  if (name === 'API') return 'API';
  if (name === 'White-box') return 'white-box';
  return name.toLowerCase();
}

function bookReferenceDocumentationIssues() {
  const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyedual.md'), 'utf8');
  const guide = fs.readFileSync(path.join(testRoot, 'conformance', 'README.md'), 'utf8');
  const issues = [];

  if (!book.includes('This book is also the reference for the EyeDual implementation.')) {
    issues.push('book introduction does not identify itself as the reference');
  }
  if (!book.includes('This book is the single reference for the EyeDual implementation.')) {
    issues.push('book Chapter 42 does not state the single-reference policy');
  }
  for (const standard of [
    'ISO/IEC 13211-1:1995',
    'Technical Corrigendum 1:2007',
    'Technical Corrigendum 2:2012',
    'Technical Corrigendum 3:2017',
  ]) {
    if (!book.includes(standard)) issues.push(`book does not identify standards baseline: ${standard}`);
  }
  if (!book.includes('EyeDual performs it consistently for ordinary\nunification as well as `unify_with_occurs_check/2`.')) {
    issues.push('book glossary does not match finite-tree unification');
  }
  if (book.includes('EyeDual does not perform it.')) {
    issues.push('book contradicts implementation occurs-check behavior');
  }
  for (const heading of ['## 38. Language and ISO profile', '## 39. Built-in predicates by programming role', '## 40. Running EyeDual: command line and corpus']) {
    if (!book.includes(heading)) issues.push(`book is missing ${heading}`);
  }
  if (!guide.includes('[*The Art of EyeDual*](../../the-art-of-eyedual.md) is the reference')) {
    issues.push('test guide does not identify the book as the reference');
  }
  if (!guide.includes('not a separate\nlanguage specification')) {
    issues.push('test guide presents the suite as a separate specification');
  }

  return issues;
}

function runWhy({ program, goalText, expected }) {
  const programFile = path.join(tmp, `${++tmpCounter}.pl`);
  fs.writeFileSync(programFile, program);
  const goal = parseGoalText(goalText);
  const parsed = Program.parseSources([{ text: program, filename: path.basename(programFile) }], { sourceMetadata: true });
  const result = runEyeDual(parsed, { proof: true, goal });
  const expectedText = expected.replaceAll('__FILE__', path.basename(programFile));
  assertEqual(result.stdout, expectedText, 'stdout');

  Program.parse(result.stdout);
  assertIncludes(result.stdout, '  proof(\n', 'stdout');
  assertIncludes(result.stdout, ' by(rule("', 'stdout');
  assertIncludes(result.stdout, ', clause(', 'stdout');
  assertNotIncludes(result.stdout, 'source(head(', 'stdout');
  assertIncludes(result.stdout, '\n).\n\n', 'stdout');
}

function runWhyLoose({ program, goalText }) {
  const programFile = path.join(tmp, `${++tmpCounter}.pl`);
  fs.writeFileSync(programFile, program);
  const goal = parseGoalText(goalText);
  const parsed = Program.parseSources([{ text: program, filename: path.basename(programFile) }], { sourceMetadata: true });
  const result = runEyeDual(parsed, { proof: true, goal });
  Program.parse(result.stdout);
  assertIncludes(result.stdout, '\n).\n\n', 'stdout');
  return result;
}

function listExampleNames() {
  return fs.readdirSync(path.join(packageRoot, 'examples'))
    .filter((name) => name.endsWith('.pl'))
    .map((name) => name.slice(0, -3))
    .sort();
}

function listGoldenExampleNames() {
  return fs.readdirSync(path.join(packageRoot, 'examples', 'output'))
    .filter((name) => name.endsWith('.pl'))
    .map((name) => name.slice(0, -3))
    .sort();
}

function exampleCorpusSyncIssues() {
  const examples = listExampleNames();
  const issues = arrayDiffMessages(listGoldenExampleNames(), examples, 'examples/output');
  const checks = [
    {
      file: path.join(packageRoot, 'the-art-of-eyedual.md'),
      pattern: /top-level directory contains \*\*(\d+) self-contained runnable programs\*\*/,
    },
  ];
  for (const check of checks) {
    const relative = path.relative(packageRoot, check.file);
    const match = fs.readFileSync(check.file, 'utf8').match(check.pattern);
    if (match == null) {
      issues.push(`${relative}: runnable example count not found`);
    } else if (Number(match[1]) !== examples.length) {
      issues.push(`${relative}: runnable example count ${match[1]} != ${examples.length}`);
    }
  }
  return issues.sort();
}


function proofCorpusSyncIssues() {
  const proofDir = path.join(packageRoot, 'examples', 'proof');
  const goldens = fs.readdirSync(proofDir)
    .filter((name) => name.endsWith('.pl'))
    .sort();
  const configured = [...proofExamples].sort();
  const issues = arrayDiffMessages(configured, goldens, 'proof example runner');
  for (const name of goldens) {
    if (!fs.existsSync(path.join(packageRoot, 'examples', name))) {
      issues.push(`examples/proof/${name}: source example is missing`);
    }
  }
  const checks = [
    {
      file: path.join(packageRoot, 'the-art-of-eyedual.md'),
      pattern: /\*\*(\d+) selected programs\*\* have a checked/,
    },
  ];
  for (const check of checks) {
    const relative = path.relative(packageRoot, check.file);
    const match = fs.readFileSync(check.file, 'utf8').match(check.pattern);
    if (match == null) {
      issues.push(`${relative}: proof example count not found`);
    } else if (Number(match[1]) !== goldens.length) {
      issues.push(`${relative}: proof example count ${match[1]} != ${goldens.length}`);
    }
  }
  return issues.sort();
}

function bookExampleCatalogIssues() {
  const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyedual.md'), 'utf8');
  const section = between(book, '### Further examples', '## 42. Standards, limits, and implementation boundaries');
  const names = [...section.matchAll(/github\.com\/eyereasoner\/eyedual\/blob\/main\/examples\/([A-Za-z0-9_-]+)\.pl/g)]
    .map((match) => match[1]);
  const issues = [];
  if (names.length === 0) issues.push('no source example links found');
  for (const name of names) {
    if (!fs.existsSync(path.join(packageRoot, "examples", name + ".pl"))) issues.push("missing examples/" + name + ".pl");
    if (!fs.existsSync(path.join(packageRoot, "examples", "output", name + ".pl"))) issues.push("missing examples/output/" + name + ".pl");
  }
  return [...new Set(issues)].sort();
}

function playgroundExampleIssues() {
  const issues = [];
  const expected = listExampleNames();
  const html = fs.readFileSync(path.join(packageRoot, 'playground.html'), 'utf8');
  const match = html.match(/const EXAMPLES = (\[[\s\S]*?\]);/);
  if (match == null) return ['playground EXAMPLES array not found'];
  const examples = JSON.parse(match[1]).sort();
  issues.push(...arrayDiffMessages(examples, expected, 'playground EXAMPLES'));
  if (!html.includes('new URL(`./examples/${name}.pl`, location.href)')) {
    issues.push('playground must load selected examples from relative ./examples/*.pl URLs');
  }
  if (!html.includes("fetch(exampleUrl, { cache: 'no-store' })")) {
    issues.push('playground must fetch selected example source from its relative URL');
  }
  return issues.sort();
}

function playgroundStaticIssues() {
  const issues = [];
  const playgroundPath = path.join(packageRoot, 'playground.html');
  const html = fs.readFileSync(playgroundPath, 'utf8');
  const readme = fs.readFileSync(path.join(packageRoot, 'README.md'), 'utf8');
  if (!pkg.files?.includes('playground.html')) issues.push('package files must include playground.html');
  if (!readme.includes('[Playground](https://eyereasoner.github.io/eyedual/playground)')) issues.push('README must link to the GitHub Pages playground URL');
  if (!html.includes('<meta name="viewport" content="width=device-width, initial-scale=1">')) issues.push('missing mobile viewport meta');
  if (!html.includes('main {') || !html.includes('display: block;')) {
    issues.push('playground must use a simple vertical layout');
  }
  if (!html.includes('@media (max-width: 560px)') || !html.includes('button,') || !html.includes('width: 100%')) {
    issues.push('playground must make controls usable at phone widths');
  }
  if (!html.includes('<summary id="advanced-heading">⚙ Advanced configuration</summary>')) {
    issues.push('playground must keep URL/proof controls inside advanced configuration');
  }
  if (!html.includes('id="load-background"') || !html.includes('backgroundSource') || !html.includes('combinedSource()')) {
    issues.push('playground must support loading URL content as background knowledge');
  }
  if (!html.includes('HIGHLIGHT_LIMIT') || !html.includes('text.length > HIGHLIGHT_LIMIT')) {
    issues.push('playground must avoid full syntax coloring for very large examples');
  }
  if (!html.includes('<script type="module">')) issues.push('playground script must be an ES module');
  if (!html.includes("new URL('./src/playground-worker.js?playground=")) issues.push('playground must cache-bust its dedicated module worker');
  if (!html.includes("new Worker(workerUrl, { type: 'module' })")) issues.push('playground must launch the dedicated module worker');
  const workerText = fs.readFileSync(path.join(packageRoot, 'src', 'playground-worker.js'), 'utf8');
  if (!workerText.includes("from './library.js?playground=") ||
      !workerText.includes('createEyeDualRegistry') ||
      !workerText.includes('executePlaygroundRequest')) {
    issues.push('playground worker must install the EyeDual library registry');
  }
  if (fs.existsSync(path.join(packageRoot, 'src', 'portable-library.js'))) {
    issues.push('obsolete portable-library.js must be absent');
  }
  for (const filename of ['src/playground-worker.js', 'src/index.js', 'src/program.js', 'src/io.js']) {
    const sourceText = fs.readFileSync(path.join(packageRoot, filename), 'utf8');
    if (/^\s*import\s+[^('\"]*['\"]node:/m.test(sourceText)) {
      issues.push(`${filename} must not statically import Node built-ins in the browser graph`);
    }
  }
  const platformText = fs.readFileSync(path.join(packageRoot, 'src', 'platform.js'), 'utf8');
  if (!platformText.includes("await import('node:fs')") || !platformText.includes("await import('node:path')")) {
    issues.push('browser platform bridge must guard Node built-ins behind dynamic imports');
  }
  if (!html.includes('activeWorker.onmessageerror') || !html.includes('Serve the checkout over HTTP(S)')) {
    issues.push('playground must report actionable worker startup and message errors');
  }
  if (!html.includes('class="editor"') || !html.includes('id="highlight"') || !html.includes('id="source"')) {
    issues.push('playground must include layered syntax-colored editor');
  }
  if (!html.includes('--editor-bg: #ffffff') || !html.includes('background: var(--editor-bg)')) {
    issues.push('playground editor must use a light editor background');
  }
  if (!html.includes('id="error-line-marker"') || !html.includes('extractParseErrorLine') || !html.includes('markSyntaxErrorLine') || !html.includes('--editor-error-line')) {
    issues.push('playground must highlight syntax-error lines in the editor');
  }
  if (!html.includes('id="line-numbers"') || !html.includes('updateLineNumbers') || !html.includes('lineNumbersInner.style.transform') || !html.includes('--line-number-bg')) {
    issues.push('playground editor must include synced line numbers');
  }
  if (!html.includes('MAX_SHARE_URL_LENGTH') || !html.includes('buildReferenceShareLink') || !html.includes("params.set('example'") || !html.includes("params.set('url'")) {
    issues.push('playground share links must avoid embedding large example or URL-loaded sources');
  }
  if (!html.includes('id="create-gist"') || !html.includes('createGistShare') || !html.includes('GIST_STATE_FILENAME') || !html.includes("fetch('https://api.github.com/gists'")) {
    issues.push('playground must support Gist-backed sharing for large programs');
  }
  if (!html.includes('await createGistShare({') || html.includes('Use “Create Gist share” instead')) {
    issues.push('playground Copy share link must automatically fall back to Gist sharing for large programs');
  }
  if (!html.includes("params.has('state-url')") || !html.includes('#state-url=')) {
    issues.push('playground must restore state from raw Gist state URLs');
  }
  if (!html.includes('id="example-search"') || !html.includes('id="examples"')) issues.push('playground must include searchable examples');
  const scriptMatch = html.match(new RegExp('<script type="module">\\n([\\s\\S]*?)\\n  <\\/script>'));
  if (scriptMatch == null) {
    issues.push('module script not found');
  } else {
    const scriptFile = path.join(tmp, 'playground-script.mjs');
    fs.writeFileSync(scriptFile, scriptMatch[1]);
    const result = spawnSync(process.execPath, ['--check', scriptFile], { encoding: 'utf8' });
    if (result.status !== 0) issues.push(`playground module syntax check failed: ${result.stderr.trim()}`);
  }
  return issues.sort();
}

function registeredBuiltinNames() {
  return [...createDefaultRegistry().defs.keys()].sort();
}

function registeredEyeDualLibraryNames() {
  const defaults = createDefaultRegistry().defs;
  return [...getEyeDualRegistry().defs.entries()]
    .filter(([name]) => !defaults.has(name))
    .map(([name]) => name)
    .sort();
}

function registeredBuiltinSummary() {
  const names = registeredBuiltinNames();
  return {
    entries: names.length,
    names: new Set(names.map((name) => name.split('/')[0])).size,
  };
}

function bookBuiltinNames() {
  const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyedual.md'), 'utf8');
  return documentedBuiltinNames(between(book, '## 39. Built-in predicates by programming role', '### The EyeDual library'), 2);
}

function bookEyeDualLibraryNames() {
  const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyedual.md'), 'utf8');
  return documentedBuiltinNames(between(book, '<!-- eyedual-library-catalog:start -->', '<!-- eyedual-library-catalog:end -->'), 1);
}

function bookBuiltinSummary() {
  const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyedual.md'), 'utf8');
  const match = book.match(/(?:registers|contains) (\d+) name\/arity entries across (\d+) names/);
  if (match == null) throw new Error('book builtin summary not found');
  return { entries: Number(match[1]), names: Number(match[2]) };
}

function documentedBuiltinNames(section, catalogColumn) {
  const names = [];
  for (const line of section.split('\n')) {
    if (!line.trim().startsWith('|') || !line.includes('`')) continue;
    const catalogCell = line.split('|')[catalogColumn] ?? '';
    for (const match of catalogCell.matchAll(/`([A-Za-z_][A-Za-z0-9_]*)\(([^`)]*)\)`/g)) {
      const arity = match[2].trim() === '' ? 0 : match[2].split(',').length;
      names.push(`${match[1]}/${arity}`);
    }
    for (const match of catalogCell.matchAll(/`([^`\s]+)\/(\d+)`/g)) {
      names.push(`${match[1]}/${match[2]}`);
    }
  }
  return [...new Set(names)].sort();
}

function runtimeExportNames() {
  return Object.keys(publicApi).sort();
}

function declaredValueExportNames() {
  const dts = fs.readFileSync(path.join(packageRoot, 'index.d.ts'), 'utf8');
  return [...dts.matchAll(/^export\s+(?:declare\s+)?(?:class|function|const)\s+([A-Za-z_][A-Za-z0-9_]*)/gm)]
    .map((match) => match[1])
    .filter((name, index, names) => names.indexOf(name) === index)
    .sort();
}

function missingDocumentedPackageScripts() {
  const docs = documentationFiles();
  const missing = [];
  const nativeCommands = new Set(['exec', 'install', 'link']);
  for (const file of docs) {
    const text = fs.readFileSync(file, 'utf8');
    for (const line of text.split('\n')) {
      const trimmed = line.trim();
      const commandTexts = [];
      if (trimmed.startsWith('npm ')) commandTexts.push(trimmed);
      for (const match of line.matchAll(/`([^`]*\bnpm\s+[^`]*)`/g)) commandTexts.push(match[1].trim());
      for (const commandText of commandTexts) {
        const match = commandText.match(/^npm\s+(?:run\s+)?([A-Za-z0-9:_-]+)/);
        if (match == null) continue;
        const command = match[1];
        if (nativeCommands.has(command)) continue;
        const script = command === 'test' ? 'test' : command;
        if (!pkg.scripts?.[script]) missing.push(`${path.relative(packageRoot, file)}: npm ${command === 'test' ? 'test' : `run ${script}`}`);
      }
    }
  }
  return [...new Set(missing)].sort();
}

function misleadingDependencyInstallDocs() {
  const misleading = [];
  for (const file of documentationFiles()) {
    const text = fs.readFileSync(file, 'utf8');
    if (text.includes('Install dependencies')) misleading.push(`${path.relative(packageRoot, file)}: Install dependencies`);
    if (text.includes('npm install\n```') || text.includes('npm install\r\n```')) {
      misleading.push(`${path.relative(packageRoot, file)}: bare npm install setup block`);
    }
  }
  return [...new Set(misleading)].sort();
}

function documentationSourceStyleIssues() {
  const issues = [];
  const file = path.join(packageRoot, 'the-art-of-eyedual.md');
  const text = fs.readFileSync(file, 'utf8');
  if (text.includes('```prolog')) {
    issues.push('the-art-of-eyedual.md: use eyedual code fences instead of prolog fences');
  }
  if (/\bv\d+\.\d+(?:\.\d+)?\b/i.test(text)) {
    issues.push('the-art-of-eyedual.md: describe the current system instead of release chronology');
  }
  return issues;
}

function findBrokenDocLinks() {
  const broken = [];
  const anchorsByFile = new Map();
  for (const file of documentationFiles()) {
    const text = fs.readFileSync(file, 'utf8');
    for (const target of markdownLinkTargets(text)) {
      if (/^(?:https?:|mailto:)/i.test(target)) continue;
      const [targetPathRaw, fragmentRaw] = target.split('#');
      const targetPath = targetPathRaw === '' ? file : path.resolve(path.dirname(file), decodeURI(targetPathRaw));
      const display = `${path.relative(packageRoot, file)} -> ${target}`;
      if (!fs.existsSync(targetPath)) {
        broken.push(`${display} (missing target)`);
        continue;
      }
      if (fragmentRaw != null && fragmentRaw !== '') {
        const anchors = anchorsByFile.get(targetPath) ?? markdownAnchors(targetPath);
        anchorsByFile.set(targetPath, anchors);
        if (!anchors.has(fragmentRaw)) broken.push(`${display} (missing heading #${fragmentRaw})`);
      }
    }
  }
  return broken.sort();
}

function documentationFiles() {
  return listMarkdownFiles(packageRoot);
}

function listMarkdownFiles(directory) {
  return fs.readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
    if (entry.name === 'node_modules' || entry.name === '.git') return [];
    const target = path.join(directory, entry.name);
    if (entry.isDirectory()) return listMarkdownFiles(target);
    return entry.name.endsWith('.md') ? [target] : [];
  }).sort();
}

function documentedConformanceMetricIssues() {
  const report = buildConformanceReport();
  const iso = report.rows.find((row) => row.category === 'iso')?.total;
  const total = report.total.total;
  const checks = [
    {
      file: path.join(packageRoot, 'the-art-of-eyedual.md'),
      pattern: /contains (\d+) cases, including (\d+) focused ISO\s+cases/,
      expected: [total, iso],
      labels: ['total', 'ISO'],
    },
    {
      file: path.join(packageRoot, 'test', 'conformance', 'README.md'),
      pattern: /corpus has (\d+) cases in `iso\/` and (\d+) file-based conformance cases/,
      expected: [iso, total],
      labels: ['ISO', 'total'],
    },
  ];
  const issues = [];
  for (const check of checks) {
    const relative = path.relative(packageRoot, check.file);
    const match = fs.readFileSync(check.file, 'utf8').match(check.pattern);
    if (match == null) {
      issues.push(`${relative}: conformance totals not found`);
      continue;
    }
    for (let i = 0; i < check.expected.length; i++) {
      const actual = Number(match[i + 1]);
      if (actual !== check.expected[i]) {
        issues.push(`${relative}: ${check.labels[i]} count ${actual} != ${check.expected[i]}`);
      }
    }
  }
  return issues.sort();
}

function markdownLinkTargets(text) {
  const markdown = [...text.matchAll(/!?\[[^\]\n]*\]\(([^)\s]+)(?:\s+"[^"]*")?\)/g)]
    .map((match) => match[1]);
  const html = [...text.matchAll(/\b(?:src|href)="([^"]+)"/g)]
    .map((match) => match[1]);
  return [...markdown, ...html];
}

function bookIntroOutputIssues() {
  const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyedual.md'), 'utf8');
  const match = book.match(/The (?:first|EyeDual) command should print:\s*```text\n([\s\S]*?)```/);
  if (match == null) return ['the-art-of-eyedual.md: introductory output block not found'];
  const documented = `${match[1].trimEnd()}\n`;
  const expected = fs.readFileSync(path.join(packageRoot, 'examples', 'output', 'socrates.pl'), 'utf8');
  return documented === expected
    ? []
    : ['the-art-of-eyedual.md: introductory Socrates output differs from examples/output/socrates.pl'];
}

function documentedPublicApiImportIssues() {
  const exported = new Set(runtimeExportNames());
  const issues = [];
  for (const file of documentationFiles()) {
    const text = fs.readFileSync(file, 'utf8');
    for (const block of text.matchAll(/^```js\s*\n([\s\S]*?)^```\s*$/gm)) {
      for (const imported of block[1].matchAll(/import\s*\{([\s\S]*?)\}\s*from\s*['"]eyedual['"]/g)) {
        for (const item of imported[1].split(',')) {
          const name = item.trim().split(/\s+as\s+/)[0];
          if (name && !exported.has(name)) {
            issues.push(`${path.relative(packageRoot, file)}: imports undocumented public name ${name}`);
          }
        }
      }
    }
  }
  return issues.sort();
}

function markdownAnchors(file) {
  if (!file.endsWith('.md')) return new Set();
  const text = fs.readFileSync(file, 'utf8');
  const anchors = new Set();
  const counts = new Map();
  for (const match of text.matchAll(/^#{1,6}\s+(.+)$/gm)) {
    const base = githubSlug(match[1]);
    const count = counts.get(base) ?? 0;
    counts.set(base, count + 1);
    anchors.add(count === 0 ? base : `${base}-${count}`);
  }
  return anchors;
}

function githubSlug(heading) {
  return heading
    .replace(/`([^`]*)`/g, '$1')
    .replace(/<[^>]+>/g, '')
    .trim()
    .toLowerCase()
    .replace(/[^\p{Letter}\p{Number}\s-]/gu, '')
    .trim()
    .replace(/\s+/g, '-');
}

function between(text, startMarker, endMarker) {
  const start = text.indexOf(startMarker);
  if (start === -1) throw new Error(`${startMarker} not found`);
  const contentStart = start + startMarker.length;
  const end = text.indexOf(endMarker, contentStart);
  if (end === -1) throw new Error(`${endMarker} not found`);
  return text.slice(contentStart, end);
}

function runCli(args, options = {}) {
  return spawnSync(process.execPath, [bin, ...args], {
    cwd: packageRoot,
    encoding: 'utf8',
    env: options.env ? { ...process.env, ...options.env } : process.env,
    input: options.input ?? undefined,
  });
}

function assertEqual(actual, expected, label) {
  if (actual !== expected) throw new Error(`${label} mismatch\nexpected: ${format(expected)}\nactual:   ${format(actual)}`);
}

function assertIncludes(actual, expected, label) {
  if (!actual.includes(expected)) throw new Error(`${label} did not include ${format(expected)}\nactual: ${format(actual)}`);
}

function assertNotIncludes(actual, expected, label) {
  if (String(actual).includes(expected)) throw new Error(`${label} unexpectedly included ${format(expected)}\nactual: ${format(actual)}`);
}

function arrayDiffMessages(actual, expected, label) {
  const messages = [];
  const actualSet = new Set(actual);
  const expectedSet = new Set(expected);
  for (const item of expected) if (!actualSet.has(item)) messages.push(`${label} missing ${item}`);
  for (const item of actual) if (!expectedSet.has(item)) messages.push(`${label} has unexpected ${item}`);
  if (new Set(actual).size !== actual.length) messages.push(`${label} has duplicate entries`);
  return messages;
}

function assertArrayEqual(actual, expected, label) {
  const actualText = actual.join('\n');
  const expectedText = expected.join('\n');
  if (actualText !== expectedText) {
    const onlyActual = actual.filter((item) => !expected.includes(item));
    const onlyExpected = expected.filter((item) => !actual.includes(item));
    throw new Error(`${label} mismatch\nonly actual: ${format(onlyActual)}\nonly expected: ${format(onlyExpected)}`);
  }
}

function format(value) {
  return typeof value === 'string' ? JSON.stringify(value) : String(value);
}

if (isMainModule(import.meta.url)) {
  const reporter = new TestReporter();
  try {
    runRegression(reporter);
    reporter.totalLine();
  } catch (_) {
    process.exit(1);
  }
}
