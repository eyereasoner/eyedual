# Eyepl

<p align="center">
  <img src="eyepl-logo.png" alt="Eyepl logo" width="160">
</p>

[![npm version](https://img.shields.io/npm/v/eyepl.svg)](https://www.npmjs.com/package/eyepl)
[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21446308-blue.svg)](https://doi.org/10.5281/zenodo.21446308)

Eyepl combines ISO Prolog and W3C RDF 1.2 to turn portable rules and linked data into answers and inspectable proofs.

[Playground](https://eyereasoner.github.io/eyepl/playground) ·
[*The Art of Eyepl*](https://eyereasoner.github.io/eyepl/the-art-of-eyepl)

## Quick start

Install the published CLI globally:

```bash
npm install --global eyepl
eyepl --version
printf 'query(works(stdin, true)).\nworks(stdin, true) :- ok = ok.\n' | eyepl -
```

Eyepl has no build step. From a source checkout, install its RDF parser
dependencies and run the CLI directly with Node.js 18 or newer:

```bash
npm install
node bin/eyepl.js --library examples/ancestor.pl
node bin/eyepl.js --library --proof examples/socrates.pl
node bin/eyepl.js --library --warnings test/conformance/warnings/negation/unstratified_mutual.pl
printf 'query(works(stdin, true)).\nworks(stdin, true) :- ok = ok.\n' | node bin/eyepl.js -
```

For one-off local CLI use from the checkout, npm can run the package bin without a manual symlink:

```bash
npm exec --yes --package=. -- eyepl --version
npm exec --yes --package=. -- eyepl --library examples/ancestor.pl
```

To install the checkout's `eyepl` command on your `PATH`, use npm's package link:

```bash
npm link
eyepl --version
```

For local browser use, run `python3 -m http.server` from the checkout and open
`http://localhost:8000/playground.html`.

## Classical search examples

The example corpus includes two classic programs that use the optional portable
list library. Run them with `--library`; their exact checked answers live beside
the other goldens under `examples/output/`:

```bash
node bin/eyepl.js --library examples/lee.pl
node bin/eyepl.js --library examples/n-queens.pl
```

[`lee.pl`](examples/lee.pl) performs Lee wavefront routing around rectangular
obstacles and reconstructs one path ([golden](examples/output/lee.pl)).
[`n-queens.pl`](examples/n-queens.pl) uses selection and diagonal pruning to
enumerate all 92 solutions of the eight-queen puzzle
([golden](examples/output/n-queens.pl)).

## JavaScript API

```js
import { run, Program, Solver } from 'eyepl';

const result = run(`
query(answer(X0)).
answer(ok) :- ok = ok.
`);
console.log(result.stdout);
```

`run` returns captured `stdout`, numeric solver `stats`, and a nullable
`haltCode` when `halt/0` or `halt/1` terminates the processor.

The default registry contains Eyepl's ISO/IEC 13211-1:1995 core profile:
unification and term inspection, control and exceptions, arithmetic, grouped
solutions, the dynamic database, operators and directives, flags, atomic-term
processing, streams, character/byte and term I/O, and processor termination.
The profile has 114 registered predicate indicators across 93 names.

This is broad standards coverage, not a formal certification claim. Eyepl
retains documented host conventions—most visibly `query/1`, automatic tabling,
inference fuses, and a distinct double-quoted string scalar—and exhaustive
standard error/option combinations remain part of the conformance work.
Programs that use Eyepl's non-core string, list, aggregation, context, date,
or convenience predicates must opt in explicitly:

```js
import { getLibraryRegistry, run } from 'eyepl';

run(source, { registry: getLibraryRegistry() });
```

The equivalent CLI switch is `-l` or `--library`.

ISO streams are solver-owned and shared by nested goals. JavaScript callers
can provide standard input and capture standard output:

```js
const result = run(source, {
  ioOptions: {
    input: "term(from_input).\n",
    write: (text) => process.stdout.write(text),
  },
});
```

Rules headed by `false` are inference fuses. A matching fuse aborts before
queries run; the CLI exits with code `65`, while the JavaScript API throws an
`InferenceFuseError` carrying the same code and a matched-rule diagnostic.

## STEM showcase: evidence-backed diagnosis

The spacecraft battery example combines sensor telemetry, the physical relation
`P = I²R`, engineering limits, redundant measurements, and causal rules to
derive a diagnosis and safety action:

```bash
node bin/eyepl.js --library examples/spacecraft-battery-diagnosis.pl
node bin/eyepl.js --library -p examples/spacecraft-battery-diagnosis.pl
```

The normal output reports computed metrics, a thermal-runaway precursor, and an
`isolate_and_cool` action. With `-p`, every conclusion carries machine-readable
evidence back to telemetry facts, arithmetic operations, threshold comparisons,
and the independent temperature channel.

## How it works

The name *Eyepl* combines *EYE* with *pl*: EYE-style reasoning expressed in
the documented and tested ISO Prolog compatibility profile.

Its default execution is automatically hybrid: ordinary goals use indexed
depth-first resolution, while recursive helper predicate groups are detected
and tabled automatically.

Clause selection combines compact type-aware any-argument scalar indexes with
demand-driven multi-argument indexes. SWI-Prolog-inspired quality checks avoid
building indexes for small, weakly selective, or variable-heavy clause groups.

The builtin boundary is intentionally visible in the source tree:
[`src/iso.js`](src/iso.js) contains the ISO processor predicates and default
registry, while [`src/library.js`](src/library.js) contains the explicitly
enabled extension predicates, portable Prolog clauses, and their small
profile-guided accelerator set. Both layers use the same parser, terms, solver,
streams, and proof machinery.

## RDF 1.2 files

The tools convert standard RDF files to ordinary Eyepl `rdf/4` facts, run
Eyepl rules, and serialize query answers as RDF 1.2 N-Quads:

```bash
node tools/rdf-to-eyepl.mjs --rules rules.pl data.ttl -o program.pl
node bin/eyepl.js program.pl > derived.pl
node tools/eyepl-to-rdf.mjs derived.pl -o derived.nq
```

The input format is detected from the filename. Supported inputs include RDF
1.2 Turtle, TriG, N-Triples, N-Quads and RDF/XML, as well as JSON-LD, RDFa,
Microdata, Notation3 and SHACL Compact Syntax. For stdin, provide the format;
use `--base` when relative IRIs need an explicit base:

```bash
node tools/rdf-to-eyepl.mjs --format turtle --base https://example/ -
```

RDF IRIs, scoped blank nodes, literals, directional language strings, nested
triple terms, named graphs and the default graph all have lossless Eyepl term
encodings. The
[RDF 1.2 chapter](https://eyereasoner.github.io/eyepl/the-art-of-eyepl#15-rdf-12-as-relational-data)
in *The Art of Eyepl* covers the mapping and `--include-source` behavior.

## Tests

Every release must pass the complete test suite. The current 695-file
conformance corpus includes 277 focused ISO cases covering the success,
failure, mode, and error behavior derived from ISO/IEC 13211-1 clauses 7 and
8. The generated `conformance-report.md` is the authoritative source for
current category totals.

```bash
npm test
npm run test:conformance
node test/run-conformance-report.mjs
# release preparation writes conformance-report.md via the preversion script
npm run test:examples
npm run test:regression
```
