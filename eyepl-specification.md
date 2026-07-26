# Eyepl Specification

Status: Draft  
Revision: 0.2
Reference implementation: Eyepl 0.0.57

## 1. Purpose

Eyepl rules have two readings:

1. **logical** — which ground conclusions follow from facts and rules; and
2. **operational** — how an implementation searches, computes, and reports
   those conclusions.

This specification standardizes the small common part needed for exchange. It
does not require every implementation to use the same algorithm, built-ins,
proof format, command line, or host API.

An implementation conforms by implementing the Core and declaring any
additional capabilities it supports. Two implementations are interoperable
for a program when they support the same capabilities used by that program.

The words **MUST**, **MUST NOT**, **SHOULD**, and **MAY** are normative.

## 2. Conformance profiles

### 2.1 Core

The **Core** consists of:

- facts and definite rules;
- first-order terms and conjunction;
- clause-scoped variables;
- finite-tree unification with an occurs check; and
- least-Herbrand-model entailment.

A Core implementation may use bottom-up evaluation, resolution, tabling,
compilation, or another sound method.

### 2.2 Capabilities

Features outside the Core are independent, named capabilities:

| Capability | Adds |
| --- | --- |
| `query` | `query/1` host declarations |
| `eq` | `eq/2` unification |
| `neq` | immediate non-unifiability testing |
| `stratified-negation` | `not/1` over completed lower strata |
| `aggregation` | finite collection and selection |
| `search-control` | `once/1` and `forall/2` |
| `fuses` | rules headed by `false` |
| `proofs` | derivation evidence |
| `rdf-adapter` | mapping RDF datasets to and from Eyepl terms |
| `builtin:Name/Arity` | one named built-in relation |

An implementation MUST publish its supported capabilities. A program that uses
a capability SHOULD name it in accompanying metadata.

Capabilities may define extra operational behavior. Such behavior is not Core
entailment unless this specification explicitly says so.

### 2.3 The Eyepl implementation profile

The JavaScript implementation named **Eyepl** is one conforming implementation.
Its `eyepl-0.0.57` profile consists of:

- the Core;
- all capabilities in Section 2.2;
- the standard built-ins listed in Section 8;
- lexical scalar equivalence as defined in Section 4;
- indexed goal-directed evaluation with automatic tabling;
- Eyepl-readable answer and proof output; and
- the host behavior described in Section 10.

This profile documents Eyepl; it is not the minimum required of another
implementation.

## 3. Source language

Eyepl source is UTF-8. `%` begins a line comment.

```text
program             ::= { clause }
clause              ::= head "."
                      | head ":-" goal-list "."
head                ::= term
goal-list            ::= term { "," term }
term                ::= variable | atom-constant | string | number
                      | compound | list | parenthesized-term
compound            ::= atom-constant "(" term { "," term } ")"
list                ::= "[" "]"
                      | "[" term { "," term } [ "|" term ] "]"
parenthesized-term  ::= "(" term [ "," term { "," term } ] ")"
variable            ::= "_" | variable-start { name-continue }
atom-constant       ::= plain-atom | quoted-atom | graphic-atom
plain-atom          ::= lowercase-letter { name-continue }
number              ::= [ "-" ] digits [ "." digits ] [ exponent ]
exponent            ::= ( "e" | "E" ) [ "+" | "-" ] digits
variable-start      ::= uppercase-letter | "_"
name-continue       ::= uppercase-letter | lowercase-letter | digit | "_"
```

Single quotes delimit quoted atoms; double quotes delimit strings. Plain names
use ASCII letters. Unicode is allowed in quoted atoms and strings. The bare
`_` is fresh at every occurrence; other variables have clause scope.

Every clause ends in `.`. `ready()` is not valid zero-arity syntax; use
`ready`. Predicate identity includes name and arity.

Lists use `[]` and the constructor `./2`. A parenthesized comma sequence is a
right-associated `','/2` term. In goal position it is conjunction; in data
position it remains a term.

User-defined operators, variables in predicate position, cut, modules, dynamic
database mutation, and implicit existential rule-head variables are not Core.

## 4. Terms and atomic formulas

The term domain contains atoms, strings, numbers, variables, lists, and
compounds. A ground term has no variables. An atomic formula is an atom or
compound used as a proposition.

Ground compound terms are identical when their functor, arity, and
corresponding arguments are identical. Lists follow the same structural rule.

Implementations MUST declare one scalar-equivalence mode:

- **typed** — atom `a`, string `"a"`, and number-like scalars are distinct; or
- **lexical** — scalar terms with the same lexical value unify across kinds.

Eyepl uses `lexical`; for example, `eq(a, "a")` and `eq(7, "7")` succeed.
Programs relying on cross-kind equality are interoperable only among
implementations using lexical scalar equivalence.

Different names do not automatically identify the same domain object.
Relations such as `same_as/2` have only the meaning supplied by program rules.

## 5. Clauses and quantification

A fact asserts an atomic formula:

```eyepl
parent(alice, bob).
```

A rule says that every ground instance of its head follows when every body
formula holds:

```eyepl
ancestor(X, Z) :- parent(X, Y), ancestor(Y, Z).
```

Variables in a clause are universally quantified over terms. Variables in a
query request witnesses. The Core does not create unnamed existential objects
in rule heads; a program may construct an explicit witness term instead.

## 6. Logical Core semantics

### 6.1 Herbrand universe and base

For program `P`, `U(P)` is the set of ground terms constructible from its
constants and constructors. `B(P)` is the set of ground atomic formulas
constructible from its predicates and `U(P)`.

A Herbrand interpretation is a subset of `B(P)`.

### 6.2 Immediate consequence

For interpretation `I`, `T_P(I)` contains every ground fact and every ground
rule head whose body formulas all belong to `I`.

The meaning of a Core program is:

```text
M(P) = least fixed point of T_P
```

### 6.3 Entailment

For a ground atomic formula `A`:

```text
P entails A  iff  A is in M(P)
```

Non-entailment of `A` is not entailment of a negative formula.

Clause order, indexing, scheduling, and search strategy do not change Core
entailment.

### 6.4 Logical equality, unification, and inequality

Core unification is finite-tree structural unification with an occurs check.

With the `eq` capability, `eq(A, B)` computes a most general unifier. On ground
terms it tests equality under the declared scalar-equivalence mode.

With the `neq` capability, `neq(A, B)` succeeds when the terms are not
unifiable under the current substitution. On ground terms it is inequality.
On non-ground terms it is only an immediate test: it does not install a
persistent constraint.

Eyepl does not infer substitution from an application relation such as
`same_as/2`; rewriting must be expressed by rules or an additional capability.

### 6.5 Soundness and completeness boundary

Every ground Core answer MUST belong to `M(P)`.

For a finite relevant ground call-and-answer space, a conforming complete
implementation returns every entailed answer. An implementation MAY instead
declare a run incomplete because of an infinite search or resource limit.
Incomplete execution must be distinguishable from a completed search with no
answer.

## 7. Negation and closed-world reasoning

The `stratified-negation` capability provides `not(G)`. It succeeds when a
terminating search for `G` under the current substitution has no solution.
This is negation as failure, not classical negation.

A portable negative call is sufficiently instantiated, terminating, and made
against a declared complete knowledge boundary.

A program is stratified when predicates can be assigned strata such that
positive dependencies do not point upward and negative dependencies point
strictly downward. Lower strata are completed before higher strata inspect
them through `not/1`.

An implementation claiming `stratified-negation` MUST detect or reject a
negative dependency cycle. It MAY support other named negation semantics, but
must not present their conclusions as stratified-negation results.

Explicit denial or absence can be modeled as a positive predicate such as
`denied/2` or `confirmed_absent/1`.

## 8. Standard built-ins

Built-ins are optional capabilities identified as `builtin:Name/Arity`. An
implementation need not provide the complete Eyepl catalog.

The Eyepl profile provides:

| Family | Predicate indicators |
| --- | --- |
| Core helpers | `eq/2`, `neq/2`, `local_time/1`, `difference/3` |
| Arithmetic | `neg/2`, `abs/2`, `sin/2`, `cos/2`, `tan/2`, `asin/2`, `acos/2`, `sqrt/2`, `floor/2`, `ceiling/2`, `trunc/2`, `rounded/2`, `exp/2`, `log/2`, `add/3`, `sub/3`, `mul/3`, `div/3`, `mod/3`, `min/3`, `max/3`, `pow/3`, `atan2/3` |
| Comparison and generation | `lt/2`, `gt/2`, `le/2`, `ge/2`, `between/3`, `smallest_divisor_from/3` |
| Strings | `str_concat/3`, `contains/2`, `matches/2`, `matches/3`, `not_matches/2`, `split/3`, `join/3`, `substring/4`, `replace/4`, `lowercase/2`, `uppercase/2`, `trim/2`, `number_string/2`, `atom_string/2`, `term_string/2` |
| Lists | `append/3`, `nth0/3`, `set_nth0/4`, `head/2`, `rest/2`, `last/2`, `take/3`, `drop/3`, `slice/4`, `member/2`, `select/3`, `not_member/2`, `reverse/2`, `length/2`, `sum_list/2`, `min_list/2`, `max_list/2`, `list_to_set/2`, `sort/2` |
| Aggregation | `findall/3`, `countall/2`, `sumall/3`, `aggregate_min/5`, `aggregate_max/5` |
| Context | `holds/2`, `holds/3` |
| Search control | `not/1`, `once/1`, `forall/2` |
| Term inspection | `functor/3`, `arg/3`, `compound_name_arguments/3` |

Each built-in capability must document its modes, produced bindings, failure
conditions, and relevant numeric or environmental assumptions.

Appendix B of `the-art-of-eyepl.md` and `test/conformance/` define the Eyepl
profile's detailed built-in behavior.

## 9. Aggregation and search control

The `aggregation` capability evaluates a finite nested solution space.
Implementations claiming interoperability for an aggregate must agree on its
empty case, duplicate handling, ordering, and tie-breaking.

In the Eyepl profile:

- `findall/3`, `countall/2`, and `sumall/3` return `[]`, `0`, and `0` for no
  solutions;
- `aggregate_min/5` and `aggregate_max/5` fail for no solutions; and
- structured keys provide term-order tie-breaking.

The `search-control` capability supplies `once/1` and `forall/2`. `once/1`
makes first-solution order observable. `forall/2` succeeds vacuously for an
empty generator. Nested searches must terminate for these results to be
portable.

## 10. Queries and answers

The `query` capability treats `query(G)` as a host request, not a premise.

Implementations may expose answers through a CLI, API, iterator, relation,
file, or protocol. Interoperability concerns the set of ground answers, not
their presentation or discovery order, except when an order-sensitive
capability is used.

The Eyepl host:

1. checks fuses;
2. solves declared queries;
3. retains ground answers;
4. suppresses duplicates and answers identical to source facts; and
5. prints Eyepl-readable terms.

Other hosts need not reproduce those presentation choices. Answers from one
query are not premises for another unless a host explicitly declares such an
extension.

A host SHOULD distinguish success, completed no-answer, invalid theory,
unsupported capability, incomplete execution, and error.

## 11. Inference fuses

The `fuses` capability interprets a clause headed by `false` as an integrity
condition:

```eyepl
false :- permit(Person), revoked(Person).
```

If a fuse body succeeds, the input theory is invalid for that run. The host
must not emit ordinary query answers from it.

This behavior is integrity rejection, not classical explosion. Eyepl checks
fuses before queries, reports the matched fuse, and uses CLI exit status `65`.
Other implementations may report invalidity differently.

## 12. Proofs

The `proofs` capability returns evidence for an answer. A proof format MUST
identify:

- the ground conclusion;
- the source facts or rules used; and
- any capability or built-in steps on which the derivation depends.

Implementations may use trees, DAGs, traces, proof terms, RDF, or another
documented representation. Proof byte-for-byte equality is not required.

Eyepl emits `why(Answer, Proof)` terms containing `goal`, `by`, `bindings`, and
`uses` components. This is one valid proof representation. Enabling Eyepl
proof output does not change its answer set.

A proof establishes derivability relative to its exact inputs, capability
semantics, external values, and implementation.

## 13. RDF and external data

The `rdf-adapter` capability maps RDF data to and from Eyepl terms. RDF is an
input/output boundary, not the semantic definition of the Core.

An adapter must document:

- its representation of IRIs, blank nodes, literals, triple terms, and graphs;
- which RDF statements become premises;
- any completeness assumptions; and
- how answers are mapped back to RDF.

An Eyepl conclusion is not automatically an RDF entailment. An implementation
claiming RDF entailment must name the separately implemented entailment regime.

## 14. Policy interoperability contract

A portable policy package SHOULD state:

```text
language: Eyepl
core: 0.2
scalar-equivalence: typed | lexical
capabilities: [...]
entry-queries: [...]
closed-world-relations: [...]
external-inputs: [...]
```

It should also identify finite search boundaries, completeness assumptions,
fuses, order-sensitive behavior, numeric assumptions, and whether proofs are
required.

Two policy engines can make a meaningful interoperability claim when they use
the same program, inputs, scalar-equivalence mode, and declared capabilities.

## 15. Conformance

Core conformance requires:

1. accepting the shared syntax used by a test;
2. producing only Core-entailable ground answers; and
3. producing all such answers for finite completed test cases.

Capability conformance is claimed separately for each named capability. An
implementation need not pass tests for capabilities it does not claim.

The repository corpus under `test/conformance/` is the executable suite for the
Eyepl profile. Independent implementations may use its Core cases and the
cases for any capabilities they claim. Exact Eyepl CLI messages and proof
serialization are required only for Eyepl-profile compatibility.

Implementations may differ in evaluation strategy, indexes, tabling, storage,
parallelism, answer order, proof shape, and host interface unless a claimed
capability makes one of those differences observable.

## 16. Semantic boundary summary

| Construct | Interoperability contract |
| --- | --- |
| Facts and definite rules | Core least-Herbrand-model entailment |
| Unification | Core finite-tree unification |
| Scalar equality | Declared `typed` or `lexical` mode |
| `eq/2`, `neq/2` | Optional named capabilities |
| `not/1` | Optional stratified closed-world capability |
| Other built-ins | Independently declared `builtin:Name/Arity` capabilities |
| Aggregation and control | Optional operational capabilities |
| Queries | Optional host capability |
| Fuses | Optional integrity capability |
| Proofs | Optional evidence capability with open representation |
| RDF adapters | Optional documented data mapping |

The common promise is deliberately small:

> Implementations agree on Core entailment and on the semantics of every
> additional capability they jointly claim. Eyepl is one such implementation,
> not the definition of all possible implementations.
