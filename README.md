# WebEntail

<p align="center">
  <img src="webentail-logo.png" alt="WebEntail logo" width="160">
</p>

[![npm version](https://img.shields.io/npm/v/webentail.svg)](https://www.npmjs.com/package/webentail)
[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21446308-blue.svg)](https://doi.org/10.5281/zenodo.21446308)

WebEntail combines ISO Prolog and W3C RDF 1.2 to turn portable rules and linked data into answers and inspectable proofs.

[Playground](https://eyereasoner.github.io/webentail/playground) ·
[*The Art of WebEntail*](https://eyereasoner.github.io/webentail/the-art-of-webentail)

## Quick start

Install the published CLI globally:

```bash
npm install --global webentail
webentail --version
printf 'works(stdin, true) :- ok = ok.\n' | webentail --goal 'works(stdin, true)' -
```

WebEntail has no build step. From a source checkout, install its RDF parser
dependencies and run the CLI directly with Node.js 18 or newer:

```bash
npm install
node bin/webentail.js examples/ancestor.pl
node bin/webentail.js --proof examples/socrates.pl
node bin/webentail.js --warnings test/conformance/warnings/negation/unstratified_mutual.pl
printf 'works(stdin, true) :- ok = ok.\n' | node bin/webentail.js --goal 'works(stdin, true)' -
```

For one-off local CLI use from the checkout, npm can run the package bin without a manual symlink:

```bash
npm exec --yes --package=. -- webentail --version
npm exec --yes --package=. -- webentail examples/ancestor.pl
```

To install the checkout's `webentail` command on your `PATH`, use npm's package link:

```bash
npm link
webentail --version
```

For local browser use, run `python3 -m http.server` from the checkout and open
`http://localhost:8000/playground.html`. Do not open `playground.html` directly as a
`file:` URL: module workers require HTTP(S). Each run uses the dedicated
`src/playground-worker.js` module, which creates the same WebEntail library registry used by the CLI and JavaScript API. Predicates such as `append/3` and
`member/2` therefore work without a browser option. The playground supports the
in-memory reasoner; filesystem predicates and `include/1` remain Node-only.
After replacing playground files in an already-open tab, perform one hard refresh
to terminate the previous worker and discard its cached module graph.

## Classical and challenge search examples

The example corpus now contains **200 runnable examples**. Three useful search
stress cases exercise the WebEntail library, which is loaded by
default in the CLI, JavaScript API, and browser playground. Their exact checked
answers live beside the other goldens under `examples/output/`:

```bash
node bin/webentail.js examples/lee.pl
node bin/webentail.js examples/n-queens.pl
node bin/webentail.js examples/donald-gerald-robert.pl
```

[`lee.pl`](examples/lee.pl) performs Lee wavefront routing around rectangular
obstacles and reconstructs one path ([golden](examples/output/lee.pl)).
[`n-queens.pl`](examples/n-queens.pl) uses selection and diagonal pruning to
enumerate all 92 solutions of the eight-queen puzzle
([golden](examples/output/n-queens.pl)). The milestone 200th example,
[`donald-gerald-robert.pl`](examples/donald-gerald-robert.pl), solves a
pandigital cryptarithm whose naive search space is 10!, or 3,628,800 digit
assignments. Carry propagation and a shrinking digit domain reduce it to one
checked solution ([golden](examples/output/donald-gerald-robert.pl)).

## JavaScript API

```js
import { run, Program, Solver } from 'webentail';

const result = run(`
% Run with: webentail --goal 'answer(X0)' program.pl
answer(ok) :- ok = ok.
`);
console.log(result.stdout);
```

`run` returns captured `stdout`, numeric solver `stats`, and a nullable
`haltCode` when `halt/0` or `halt/1` terminates the processor.

The default runtime includes WebEntail's ISO/IEC 13211-1:1995 core profile plus
54 WebEntail library predicates implemented in `src/library.js`, covering strings,
lists, aggregation, dates, and arithmetic. The ISO profile itself has
115 registered predicate indicators across 94 names.

This is broad standards coverage, not a formal certification claim. WebEntail
retains documented host conventions—most visibly host-supplied goals, automatic tabling,
explicit integrity checks, and a distinct double-quoted string scalar—and exhaustive
standard error/option combinations remain part of the conformance work.
Library predicates such as `append/3`, `member/2`, and `select/3` are available
without a CLI flag or JavaScript registry option.

Advanced embedders and the ISO conformance suite can still select the isolated
core registry explicitly with `createDefaultRegistry()` or
`getDefaultRegistry()`. `createWebEntailRegistry()` creates the complete 169-entry
registry: 115 ISO indicators and 54 WebEntail library indicators. Normal applications can rely on the default and do not need to
install either explicitly.

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

`false/0` is the ISO built-in predicate that always fails. It is a protected
static procedure: source clauses headed by `false` and declarations that make
`false/0` dynamic raise `permission_error(modify, static_procedure)`. Model
domain integrity conditions as ordinary predicates such as `invalid_state/2`,
and have the host query them explicitly before trusting downstream decisions.

## STEM showcase: evidence-backed diagnosis

The spacecraft battery example combines sensor telemetry, the physical relation
`P = I²R`, engineering limits, redundant measurements, and causal rules to
derive a diagnosis and safety action:

```bash
node bin/webentail.js examples/spacecraft-battery-diagnosis.pl
node bin/webentail.js -p examples/spacecraft-battery-diagnosis.pl
```

The normal output reports computed metrics, a thermal-runaway precursor, and an
`isolate_and_cool` action. With `-p`, every conclusion carries machine-readable
evidence back to telemetry facts, arithmetic operations, threshold comparisons,
and the independent temperature channel.

## How it works

The name *WebEntail* describes the system's purpose: deriving and explaining
what follows from rules and linked data on the Web.

Its default execution is automatically hybrid: ordinary goals use indexed
depth-first resolution, while recursive helper predicate groups are detected
and tabled automatically.

Clause selection combines compact type-aware any-argument scalar indexes with
demand-driven multi-argument indexes. SWI-Prolog-inspired quality checks avoid
building indexes for small, weakly selective, or variable-heavy clause groups.

The runtime boundary is intentionally visible in the source tree:
[`src/iso.js`](src/iso.js) contains the isolated ISO processor registry, while
[`src/library.js`](src/library.js) composes that core with host conveniences and
the small profile-guided accelerator set. The complete WebEntail library is implemented directly in the browser-safe
[`src/library.js`](src/library.js), and the
playground executes requests through the dedicated
[`src/playground-worker.js`](src/playground-worker.js). Normal CLI, API, solver,
proof, and playground execution uses the default WebEntail registry; advanced
embedders can still request the ISO-only registry. Every path uses the same
parser, terms, solver, streams, and proof machinery.

## RDF 1.2 files

The tools convert standard RDF files to ordinary WebEntail `rdf/4` facts, run
WebEntail rules, and serialize query answers as RDF 1.2 N-Quads:

```bash
node tools/rdf-to-webentail.mjs --rules rules.pl data.ttl -o program.pl
node bin/webentail.js program.pl > derived.pl
node tools/webentail-to-rdf.mjs derived.pl -o derived.nq
```

The input format is detected from the filename. Supported inputs include RDF
1.2 Turtle, TriG, N-Triples, N-Quads and RDF/XML, as well as JSON-LD, RDFa,
Microdata, Notation3 and SHACL Compact Syntax. For stdin, provide the format;
use `--base` when relative IRIs need an explicit base:

```bash
node tools/rdf-to-webentail.mjs --format turtle --base https://example/ -
```

RDF IRIs, scoped blank nodes, literals, directional language strings, nested
triple terms, named graphs and the default graph all have lossless WebEntail term
encodings. The
[RDF 1.2 chapter](https://eyereasoner.github.io/webentail/the-art-of-webentail#15-rdf-12-as-relational-data)
in *The Art of WebEntail* covers the mapping and `--include-source` behavior.

## Tests

Every release must pass the complete test suite. The current 686-file
conformance corpus includes 279 focused ISO cases covering the success,
failure, mode, and error behavior derived from ISO/IEC 13211-1 clauses 7 and
8. The generated `conformance-report.md` is the authoritative source for
current category totals.
The example runner compares **200 answer goldens** and **55 proof goldens**
byte-for-byte; the extracted-book runner keeps executable displays synchronized with the book. The
dedicated seven-case playground suite executes the exact production module-worker
request path, checks that the WebEntail library is present across repeated browser
runs, verifies serializable success and parse-error messages, and crawls the served
ES-module graph for missing assets, incorrect MIME types, and static Node-only
imports.

```bash
npm test
npm run test:conformance
node test/run-conformance-report.mjs
# release preparation writes conformance-report.md via the preversion script
npm run test:examples
npm run test:regression
npm run test:playground
```
