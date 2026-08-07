# EyeProlog

<p align="center">
  <img src="eyeprolog-logo.png" alt="EyeProlog logo" width="520">
</p>

[![npm version](https://img.shields.io/npm/v/eyeprolog.svg)](https://www.npmjs.com/package/eyeprolog)
[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21446308-blue.svg)](https://doi.org/10.5281/zenodo.21446308)

EyeProlog combines ISO Prolog and W3C RDF 1.2 to produce answers with
inspectable proofs.

**[Book — *The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog)** ·
**[Why EyeProlog?](https://eyereasoner.github.io/eyeprolog/why-eyeprolog)** ·
**[Playground](https://eyereasoner.github.io/eyeprolog/playground)**

The book is the reference for the language, command line, JavaScript API,
RDF 1.2 support, examples, proofs, conformance, and implementation.

## Quick start

EyeProlog requires Node.js 18 or newer.

```sh
npm install --global eyeprolog
eyeprolog examples/socrates.pl
eyeprolog --proof examples/socrates.pl
eyeprolog --goal 'type(socrates, mortal)' examples/socrates.pl
```

Programs may declare their default queries with `%% goal:` comments.

## RDF 1.2

```sh
node tools/rdf-to-pl.mjs --rules rules.pl data.ttl -o program.pl
eyeprolog program.pl > derived.pl
node tools/pl-to-rdf.mjs derived.pl -o derived.nq
```

See the book for RDF mappings, graphs, triple terms, reifiers, annotations,
formats, and policy examples.

## Development

```sh
git clone https://github.com/eyereasoner/eyeprolog.git
cd eyeprolog
npm install
npm test
```

EyeProlog is released under the [MIT License](LICENSE.md).
