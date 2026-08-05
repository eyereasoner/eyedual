# EyeDual

<p align="center">
  <img src="eyedual-logo.png" alt="EyeDual logo" width="520">
</p>

[![npm version](https://img.shields.io/npm/v/eyedual.svg)](https://www.npmjs.com/package/eyedual)
[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21446308-blue.svg)](https://doi.org/10.5281/zenodo.21446308)

EyeDual combines ISO Prolog and W3C RDF 1.2 to turn portable rules and linked
data into answers with inspectable proofs.

**[Book — *The Art of EyeDual*](https://eyereasoner.github.io/eyedual/the-art-of-eyedual)** ·
**[Why EyeDual?](https://eyereasoner.github.io/eyedual/why-eyedual)** ·
**[Playground](https://eyereasoner.github.io/eyedual/playground)**

The book is the reference for the language, built-ins, execution model, RDF
mapping, command line, JavaScript API, examples, proofs, and implementation
boundaries.

## Quick start

Install the command-line tool with Node.js 18 or newer:

```sh
npm install --global eyedual
eyedual examples/socrates.pl
eyedual --proof examples/socrates.pl
```

Most examples declare their queries in source comments:

```prolog
%% goal: holds_result(test, true)
```

EyeDual runs those goals when no explicit goal is supplied. Override them with
`--goal` when needed:

```sh
eyedual --goal 'type(socrates, mortal)' examples/socrates.pl
```

Input can also come from standard input:

```sh
printf 'answer(ok).\n' | eyedual --goal 'answer(X)' -
```

## RDF 1.2

Convert RDF to ordinary `rdf/4` facts, run rules, and serialize derived facts
back to RDF:

```sh
node tools/rdf-to-eyedual.mjs --rules rules.pl data.ttl -o program.pl
eyedual program.pl > derived.pl
node tools/eyedual-to-rdf.mjs derived.pl -o derived.nq
```

The ODRL examples keep policy and risk data in Turtle under
[`examples/input/`](examples/input/) and append small EyeDual rule files to
produce deterministic decisions and rankings. They range from a
[basic permission](examples/odrl-policy-from-turtle.pl) and an
[advanced constrained policy](examples/odrl-policy-advanced-from-turtle.pl) to
[trust-flow decisions](examples/odrl-dpv-fpv-trust-flow.pl),
[healthcare risk ranking](examples/odrl-dpv-healthcare-risk-ranked.pl), and
[consumer risk ranking](examples/odrl-dpv-risk-ranked.pl).

See the book's
[RDF 1.2 chapter](https://eyereasoner.github.io/eyedual/the-art-of-eyedual#15-rdf-12-as-the-interoperable-data-boundary)
for term mappings, named graphs, triple terms, formats, and source inclusion.

## JavaScript

```js
import { run } from 'eyedual';

const result = run(`
answer(ok).
%% goal: answer(X)
`);

console.log(result.stdout);
```

The same parser, solver, EyeDual library, streams, and proof machinery are used
by the CLI, JavaScript API, and browser playground.

## Development

```sh
git clone https://github.com/eyereasoner/eyedual.git
cd eyedual
npm install
npm test
```

The implementation keeps its boundaries visible:

- [`src/iso.js`](src/iso.js) defines the isolated ISO processor registry;
- [`src/library.js`](src/library.js) adds the EyeDual library;
- [`src/playground-worker.js`](src/playground-worker.js) runs browser requests.

Detailed conformance totals, generated artifacts, corpus maintenance, and release
checks are documented in
[Chapter 42 of the book](https://eyereasoner.github.io/eyedual/the-art-of-eyedual#42-standards-limits-and-implementation-boundaries).
