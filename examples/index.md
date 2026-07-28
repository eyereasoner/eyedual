---
title: Eyepl examples
permalink: /examples/
---

# Eyepl examples

This directory is the executable companion to
[*The Art of Eyepl*](../the-art-of-eyepl). It contains 183 self-contained
programs spanning first relations, finite search, proofs, planning,
mathematics, program analysis, science, policy, and RDF 1.2.

Each top-level `.pl` source has checked output in [`output/`](output/).
Selected programs also have a checked explanation in [`proof/`](proof/).
The [`book/`](book/) tree contains the smaller displays extracted chapter by
chapter.

## A short path through the collection

| Start here | Main idea | Checked result |
| --- | --- | --- |
| [`socrates.pl`](socrates.pl) | A fact and rule produce a ground conclusion. | [`output/socrates.pl`](output/socrates.pl) |
| [`ancestor.pl`](ancestor.pl) | Base and recursive clauses compute a transitive relation. | [`output/ancestor.pl`](output/ancestor.pl) |
| [`graph-reachability.pl`](graph-reachability.pl) | A visited list bounds cyclic traversal. | [`output/graph-reachability.pl`](output/graph-reachability.pl) |
| [`n-queens-8.pl`](n-queens-8.pl) | Finite generation and constraints retain one witness. | [`output/n-queens-8.pl`](output/n-queens-8.pl) |
| [`route-planning.pl`](route-planning.pl) | Search constructs a route and exposes its cost. | [`output/route-planning.pl`](output/route-planning.pl) |
| [`spacecraft-battery-diagnosis.pl`](spacecraft-battery-diagnosis.pl) | Measurements and policy lead to an evidence-backed action. | [`output/spacecraft-battery-diagnosis.pl`](output/spacecraft-battery-diagnosis.pl) |
| [`expression-eval.pl`](expression-eval.pl) | A relation interprets a syntax tree under an environment. | [`output/expression-eval.pl`](output/expression-eval.pl) |
| [`rdf12-triple-term.pl`](rdf12-triple-term.pl) | RDF 1.2 triple terms cross the adapter boundary losslessly. | [`output/rdf12-triple-term.pl`](output/rdf12-triple-term.pl) |
| [`inference-fuse.pl`](inference-fuse.pl) | An invalid theory stops downstream decisions. | [`output/inference-fuse.pl`](output/inference-fuse.pl) |

The book’s [complete categorized catalog](../the-art-of-eyepl#appendix-e-further-examples)
describes every program and links its answer and proof companions.

## Run an example

From a source checkout:

```sh
node bin/eyepl.js examples/ancestor.pl
node bin/eyepl.js --proof examples/ancestor.pl
```

With the installed package:

```sh
eyepl ancestor.pl
eyepl --proof socrates.pl
```

Read the query first, predict the answers, run the source, and compare the
result with its checked output. Where a proof file exists, inspect which facts
and rules support the conclusion.

[Project home](../) · [Book](../the-art-of-eyepl) ·
[Browser playground](../playground.html) · [Source repository](https://github.com/eyereasoner/eyepl)
