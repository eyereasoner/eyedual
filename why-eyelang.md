# Why Eyelang?

Eyelang combines ISO Prolog and W3C RDF 1.2 to turn portable rules and linked data into answers with inspectable proofs.

The name reflects this dual standards foundation: ISO Prolog provides the executable rule language, while RDF provides the interoperable linked-data model.

Its central design choice is **composition rather than invention**: use an established international standard for the rule language, use the Web's standard graph data model, and define the smallest practical bridge between them.

> **Eyelang arguably provides one of the strongest standards-based foundations for Web rules because it combines ISO Prolog as the rule language with the W3C RDF 1.2 data model and defines the missing operational bridge between them—including RDF term mappings, named graphs, triple terms, serialization, querying, and proofs.**

This is a strong architectural claim, not a claim that the complete Eyelang system is itself an ISO or W3C standard.

## A standards-based foundation for Web rules

A Web rule system needs both a rule language and a data model.

[ISO/IEC 13211-1](https://www.iso.org/standard/21413.html) standardizes the Prolog general core, including its syntax, semantic rules, data representation, input and output, and processor behavior. The standard is intended to promote the portability of Prolog programs and data across processors.

[RDF 1.2](https://www.w3.org/TR/rdf12-concepts/) defines the graph data model used by Eyelang for linked data. It includes IRIs, blank nodes, literals, datasets, named graphs, and triple terms. RDF 1.2 is currently a W3C Candidate Recommendation, while RDF 1.1 remains the latest completed Recommendation.

Eyelang brings these foundations together:

- ISO Prolog supplies predicates, clauses, variables, unification, recursion, arithmetic, control, and standard errors.
- RDF 1.2 supplies globally identified resources and an interoperable graph data model.
- Eyelang defines lossless mappings between RDF values and Prolog terms.
- RDF files can be converted to ordinary `rdf/4` facts, queried with rules, and serialized back to RDF datasets.
- Named graphs, the default graph, scoped blank nodes, literals, directional language strings, and nested triple terms remain distinguishable.
- Derived answers can carry inspectable proofs.
- The same parser, solver, term model, and proof machinery run from the command line, JavaScript, and the browser.

The exact status wording matters. Eyelang is grounded in a current ISO International Standard and the W3C RDF 1.2 standards track. It should not imply that RDF 1.2 has already completed the W3C Recommendation process.

## The missing bridge

Prolog and RDF solve complementary problems, but neither standard defines their integration.

ISO Prolog does not specify:

- how an RDF IRI maps to a Prolog term;
- how blank-node scope is preserved;
- how language-tagged, directional, and datatype literals are represented;
- how named and default graphs are distinguished;
- how RDF 1.2 triple terms are nested;
- how Prolog answers become RDF datasets; or
- how derivations are exposed as proofs.

RDF does not specify:

- a general recursive rule-programming language;
- Prolog-style unification;
- reusable predicates;
- operational query execution; or
- proof construction for arbitrary rule derivations.

Eyelang fills that gap with an explicit Prolog–RDF integration profile. The profile belongs to Eyelang's documented and tested behavior; it is not itself an ISO or W3C standard.

That limitation should be stated plainly:

> **Eyelang is standards-based, but its Prolog–RDF integration profile has not itself been standardized by ISO or W3C.**

## Why composition matters

A new rule language must establish its own syntax, semantics, implementation model, tooling, teaching material, and interoperability story. It can also become isolated if its original implementation or community disappears.

Eyelang instead composes standards that remain useful independently:

- Prolog programs retain a recognizable logic-programming model.
- RDF data remains usable by existing RDF processors and Web tooling.
- Standard constructs keep their standard meanings.
- Eyelang-specific behavior can be identified, documented, tested, and changed without redefining the language core.
- The integration boundary is small enough to audit.

This is why removing hidden extensions strengthens Eyelang.

For example, `false/0` is the ISO built-in predicate that always fails. Eyelang does not overload clauses headed by `false` as automatically executed inference fuses. Integrity checks are ordinary predicates that the host invokes explicitly. The standardized construct keeps its standardized meaning, and application policy remains visible.

The governing design rule is:

> **Standards define the core. Eyelang extensions must be explicit, minimal, documented, and testable.**

## Compared with alternatives

### Notation3

[Notation3](https://w3c.github.io/N3/spec/) is a Web-native logic language that extends the RDF family with quoted formulae, implication, variables, built-in relations, and rules. Facts, rules, queries, and conclusions can all be expressed in one compact notation.

That design gives N3 distinctive strengths:

- rules and RDF data share one Web-native syntax;
- rules can themselves be published, linked, quoted, and exchanged as data;
- formulae can be nested, passed as terms, and reasoned about;
- IRIs identify vocabulary and built-in relations;
- graph-level metareasoning is part of the language model; and
- the notation remains closely connected to Semantic Web architecture.

N3 is therefore not merely an RDF serialization with rule syntax added. It offers an integrated model in which data, rules, and quoted graphs belong to the same language.

Its standards position differs from Eyelang's. The W3C N3 Community Group develops language, built-in, and semantics specifications, but Community Group reports are not W3C Standards and are not currently on the W3C Standards Track. N3 also defines a complete logic notation beyond RDF, so interoperability depends on processors agreeing on that additional syntax, semantics, and built-in vocabulary.

Eyelang explores a complementary standards architecture:

- ISO Prolog is the rule language;
- RDF 1.2 is the external graph data model;
- the mapping between Prolog terms and RDF terms is explicit;
- standardized Prolog constructs retain their standardized meanings; and
- proofs are produced without requiring rules themselves to use RDF syntax.

The trade-off is clear.

N3 is stronger when rules should themselves be Web data, or when quoted formulae and graph-level metareasoning are central. Eyelang is stronger when users want conventional Prolog syntax and semantics, an ISO-defined language core, direct term-level programming, or a sharply separated interface between executable logic and RDF data.

The two approaches can interoperate at the language and data-model level. N3 can serve as a Web-native exchange and publication form, while compatible rules or data are translated into Eyelang for ISO-Prolog execution. Eyelang conclusions and proofs can in turn be serialized as RDF or N3.

In brief:

> **Notation3 provides an integrated, Web-native language for data and rules; Eyelang separates an ISO-standard rule language from the RDF data model and makes the bridge explicit.**

### RIF

The [W3C Rule Interchange Format](https://www.w3.org/TR/rif-overview/) remains stronger in the narrow formal sense. Its principal dialects, datatype framework, and RDF and OWL compatibility specifications are W3C Recommendations. RIF was explicitly designed for exchanging rules among heterogeneous rule systems.

RIF therefore has the stronger claim when the requirement is:

- a formally standardized rule-interchange family;
- translation between different rule paradigms;
- a normative interchange syntax and semantics; or
- compatibility defined within one integrated W3C specification family.

Eyelang takes a different architectural approach. It reuses ISO Prolog as the executable rule language and RDF as the data model instead of defining another complete family of rule dialects.

That may be more durable for executable Web rules because both foundations are mature and independently useful. The trade-off is that Eyelang's bridge between them is an implementation profile rather than a formally standardized interchange specification.

In brief:

> **RIF is stronger as a standardized interchange framework; Eyelang may be stronger as a small executable architecture built by composing existing standards.**

### SHACL 1.2 Rules

[SHACL 1.2 Rules](https://www.w3.org/TR/shacl12-rules/) is the closest emerging RDF-native comparison.

The current draft defines declarative rules that derive new RDF triples from a base graph. It provides:

- an `infer` operation that produces an inference graph;
- a `query` operation that determines whether a goal pattern is derivable;
- rules represented in RDF or in the Shape Rules Language;
- creation of RDF terms, including blank nodes;
- negation as failure; and
- dependency analysis and stratification to make rule evaluation deterministic and finite.

SHACL 1.2 Rules has important advantages:

- Rules are native to the SHACL and RDF ecosystem.
- The rule set itself can be represented as RDF.
- Its graph-production semantics are directly aligned with RDF processing.
- Stratification gives a well-defined outcome for supported rule sets.
- It is being developed on the W3C Recommendation track.

Its present limitations relative to Eyelang are different rather than absolute:

- As of August 2026, SHACL 1.2 Rules is a W3C Working Draft, not yet a Recommendation.
- Its primary abstraction is RDF graph inference, not a general ISO Prolog programming environment.
- Its rule language and evaluation model are deliberately constrained around RDF triple production.
- The current specification standardizes inference and query results, but not an Eyelang-style derivation-proof artifact.
- Applications needing arbitrary Prolog terms, reusable procedural abstractions, standard Prolog control, or direct JavaScript predicate integration may find Eyelang more natural.

SHACL 1.2 Rules is therefore not merely a competitor. It is also a potential interoperability target.

Eyelang could eventually:

- import a useful SHACL 1.2 Rules profile;
- export compatible RDF-producing rules where semantics align;
- execute SHACL-derived rule sets through its RDF mapping; or
- attach Eyelang proofs to triples inferred from compatible SHACL rules.

The positioning should remain balanced:

> **SHACL 1.2 Rules is stronger as an RDF-native rules specification on the W3C Recommendation track. Eyelang is stronger where applications need an established general-purpose logic language, direct Prolog execution, richer term-level computation, and inspectable derivations.**

### SPARQL

[SPARQL](https://www.w3.org/TR/sparql11-query/) is the standard choice for querying RDF graphs. It provides graph-pattern matching, filters, aggregation, property paths, federation, and standardized result formats. SPARQL Update provides standardized graph modification.

SPARQL should be preferred when the task is fundamentally an interoperable RDF query or update.

Eyelang is preferable when the task depends on:

- recursive rules beyond property-path navigation;
- reusable predicates;
- unification over structured terms;
- a conventional logic-programming model;
- rule-level composition; or
- proof-producing derivations.

The two approaches are complementary. RDF data queried by SPARQL can also be reasoned over by Eyelang, and Eyelang results can be serialized back into RDF.

### Full Prolog systems

Systems such as SWI-Prolog, SICStus Prolog, Scryer Prolog, and Trealla Prolog provide broader Prolog environments, richer libraries, or stronger implementation maturity in particular deployment settings.

They are preferable when an application needs:

- a large Prolog ecosystem;
- native-code performance;
- extensive operating-system integration;
- mature debugging and development tools; or
- a complete general-purpose Prolog platform.

Eyelang does not need to compete on feature count. Its distinction is the deliberately small and visible combination of:

- a tested ISO Prolog core profile;
- lossless RDF 1.2 term and dataset handling;
- proof-producing execution;
- JavaScript and browser embedding; and
- one implementation path across command-line, server, and browser use.

A general Prolog system can provide RDF through libraries. Eyelang makes the Prolog–RDF boundary part of its central language and interoperability story.

### Custom RDF rule engines

Custom engines can optimize aggressively for one domain, data model, or deployment environment. They may offer specialized forward chaining, incremental materialization, distributed execution, or domain-specific syntax.

Their cost is often a proprietary semantic model.

Eyelang avoids requiring users to adopt an isolated rule language. Its programs begin with recognizable Prolog, and its data begins with recognizable RDF. Eyelang-specific behavior remains concentrated in the bridge between them.

## What Eyelang should claim

A concise positioning statement is:

> **Eyelang combines a conformance-tested ISO Prolog profile with W3C RDF 1.2 linked data, explicit extensions, and inspectable proofs in a lightweight JavaScript implementation.**

A stronger comparative statement is:

> **Eyelang arguably provides one of the strongest standards-based foundations for executable Web rules because it composes ISO Prolog and RDF 1.2 instead of introducing another complete rule language.**

Both claims require qualifications:

- Eyelang implements a tested ISO compatibility profile; it is not formally certified by ISO.
- RDF 1.2 is currently a W3C Candidate Recommendation.
- SHACL 1.2 Rules is currently a W3C Working Draft.
- Eyelang's Prolog–RDF integration profile is not itself an ISO or W3C standard.
- Proof production is an Eyelang capability, not a feature inherited from ISO Prolog or RDF.

These qualifications make the standards argument more credible, not less.

## What Eyelang should not become

The standards-based position creates a useful filter for future features.

Eyelang should resist:

- silently changing the meaning of ISO predicates;
- adding advisory syntax that the runtime does not use;
- introducing hidden execution phases;
- duplicating features already expressible as ordinary predicates;
- growing an undocumented compatibility layer; or
- claiming standards conformance beyond what its tests and documentation establish.

New capabilities should normally take one of three forms:

1. an implementation of standardized Prolog behavior;
2. an explicit library predicate; or
3. a documented bridge between Prolog and RDF.

Syntax or semantics outside those categories should need a strong justification.

## The durable idea

Eyelang's most important contribution is not a novel rule syntax.

It is the proposition that Web rules can be built by joining two established foundations:

- **ISO Prolog for executable logic**, and
- **RDF for interoperable linked data**.

RIF demonstrates the value of formal rule interchange. SHACL 1.2 Rules demonstrates renewed demand for standardized RDF-native inference. SPARQL demonstrates the value of a shared graph-query language.

Eyelang occupies a complementary position: a small executable system in which standard Prolog rules operate directly over faithfully represented RDF data and produce answers that can be explained.

That is a focused and defensible reason for Eyelang to exist.

## References

- [Notation3 Language](https://w3c.github.io/N3/spec/)
- [Notation3 Community Group](https://www.w3.org/groups/cg/n3-dev)
- [ISO/IEC 13211-1:1995 — Prolog, Part 1: General core](https://www.iso.org/standard/21413.html)
- [RDF 1.2 Concepts and Abstract Data Model](https://www.w3.org/TR/rdf12-concepts/)
- [SHACL 1.2 Rules](https://www.w3.org/TR/shacl12-rules/)
- [SHACL 1.2 Core](https://www.w3.org/TR/shacl12-core/)
- [Rule Interchange Format overview](https://www.w3.org/TR/rif-overview/)
- [SPARQL 1.1 Query Language](https://www.w3.org/TR/sparql11-query/)
- [The Art of Eyelang](the-art-of-eyelang.md)
- [Eyelang README](README.md)
