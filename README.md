# EyeDual

<p align="center">
  <img src="eyedual-logo.png" alt="EyeDual logo" width="520">
</p>

[![npm version](https://img.shields.io/npm/v/eyedual.svg)](https://www.npmjs.com/package/eyedual)
[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21446308-blue.svg)](https://doi.org/10.5281/zenodo.21446308)

EyeDual combines ISO Prolog and W3C RDF 1.2 to produce answers with
inspectable proofs.

**[Book — *The Art of EyeDual*](https://eyereasoner.github.io/eyedual/the-art-of-eyedual)** ·
**[Why EyeDual?](https://eyereasoner.github.io/eyedual/why-eyedual)** ·
**[Playground](https://eyereasoner.github.io/eyedual/playground)**

The book is the reference for the language, command line, JavaScript API,
RDF 1.2 support, examples, proofs, conformance, and implementation.

## Quick start

EyeDual requires Node.js 18 or newer.

```sh
npm install --global eyedual
eyedual examples/socrates.pl
eyedual --proof examples/socrates.pl
eyedual --goal 'type(socrates, mortal)' examples/socrates.pl
```

Programs may declare their default queries with `%% goal:` comments.

## RDF 1.2

```sh
node tools/rdf-to-eyedual.mjs --rules rules.pl data.ttl -o program.pl
eyedual program.pl > derived.pl
node tools/eyedual-to-rdf.mjs derived.pl -o derived.nq
```

See the book for RDF mappings, graphs, triple terms, reifiers, annotations,
formats, and policy examples.

## Development

```sh
git clone https://github.com/eyereasoner/eyedual.git
cd eyedual
npm install
npm test
```

EyeDual is released under the [MIT License](LICENSE.md).
