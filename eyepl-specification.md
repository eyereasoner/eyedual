# Eyepl Specification

Status: Draft  
Applies to: Eyepl 0.0.54  
Last updated: 2026-07-26

## 1. Purpose

Eyepl is both:

1. a logic for expressing facts, rules, questions, and derivations; and
2. a programming language for executing those expressions.

This specification keeps those roles separate. It defines:

- the logical meaning of the portable pure core;
- the meaning and limits of negation, built-ins, aggregation, and control;
- the observable behavior of an Eyepl implementation;
- the evidence carried by answers and proofs; and
- the requirements for interoperable implementations.

For policy applications, interoperability means more than accepting the same
source syntax. Conforming implementations must agree on the entailed ground
answers of the portable logical core and on the specified results of portable,
terminating executable programs.

The key words **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY**
are normative.

## 2. Conformance profiles

An implementation may claim either or both of these profiles.

### 2.1 Logical Core

The **Logical Core** consists of:

- finite facts;
- definite Horn rules;
- finite first-order Herbrand terms;
- conjunction;
- finite-tree unification with an occurs check; and
- structural equality through `eq/2`.

Its meaning is the least Herbrand model defined in Section 6. The order of
clauses and body goals does not change that meaning.

### 2.2 Portable Execution

The **Portable Execution** profile adds:

- the standard built-ins in Section 8;
- stratified negation as failure;
- finite aggregation;
- search-control predicates;
- query declarations;
- inference fuses; and
- the answer and proof interfaces.

These features have operational preconditions such as required input modes,
finite nested searches, and ordering. Their result is defined only when those
preconditions are satisfied.

An implementation MUST NOT describe operational negation, aggregation,
floating-point computation, or `once/1` as pure Horn entailment.

## 3. Source language

Eyepl source is UTF-8. `%` begins a comment extending to the end of the line.
Whitespace separates tokens but is otherwise insignificant.

```text
program             ::= { clause }
clause              ::= head "."
                      | head ":-" goal-list "."
head                ::= term
goal-list           ::= term { "," term }
term                ::= variable | atom-constant | string | number
                      | compound | list | parenthesized-term
compound            ::= atom-constant "(" term { "," term } ")"
list                ::= "[" "]"
                      | "[" term { "," term } [ "|" term ] "]"
parenthesized-term  ::= "(" term [ "," term { "," term } ] ")"
variable            ::= "_"
                      | variable-start { name-continue }
atom-constant       ::= plain-atom | quoted-atom | graphic-atom
plain-atom          ::= lowercase-letter { name-continue }
number              ::= [ "-" ] digits [ "." digits ] [ exponent ]
exponent            ::= ( "e" | "E" ) [ "+" | "-" ] digits
variable-start      ::= uppercase-letter | "_"
name-continue       ::= uppercase-letter | lowercase-letter | digit | "_"
```

Plain names use ASCII letters. Unicode is permitted in quoted atoms and
strings. Single quotes delimit atoms; double quotes delimit strings. The bare
variable `_` denotes a fresh variable at every occurrence. Other variables
have clause scope.

Each clause MUST end in `.`. A zero-arity compound such as `ready()` is not
valid; the atom `ready` represents zero-arity data or a zero-arity atomic
formula. Predicate identity is the pair of name and arity.

Lists use `[]` and the conceptual constructor `./2`. `[a, b | T]` is equivalent
to `.(a, .(b, T))`.

Parenthesized comma terms are right-associated `','/2` terms. In goal position
they denote conjunction. In term position they are ordinary inspectable data.

User-defined operators, variables in functor or predicate position, modules,
cut, dynamic database mutation, and implicit existential variables in rule
heads are outside this specification.

## 4. Terms and atomic formulas

The Eyepl term domain contains:

- atom constants;
- strings;
- numbers;
- variables;
- lists; and
- compound terms.

A **ground term** contains no variables. An **atomic formula** is an atom
constant or compound term used as a proposition. The same surface term may be
data when nested inside another term.

Ground terms denote themselves. Distinct lexical values denote distinct scalar
terms. Compound terms are equal exactly when their functor, arity, and
corresponding arguments are equal. Eyepl preserves atom, string, and number
kinds for parsing and read-back, but unification treats scalar terms with the
same lexical value as equal. Thus `eq(a, "a")` and `eq(7, "7")` succeed. This
cross-kind scalar equivalence is part of the current portable contract.

Eyepl therefore makes a unique-name and free-constructor assumption at the
term level. Domain equivalence between different names MUST be expressed by
rules or normalized before reasoning.

## 5. Clauses and quantification

A fact:

```eyepl
parent(alice, bob).
```

asserts its ground atomic formula.

A rule:

```eyepl
ancestor(X, Z) :- parent(X, Y), ancestor(Y, Z).
```

stands for all ground instances in which truth of every body formula implies
truth of the head formula. Variables in a clause are implicitly universally
quantified over Herbrand terms.

Variables in a query are existential: an answer is a substitution under which
the queried goal succeeds. Eyepl has no anonymous existential object creation
in rule heads. A program may instead construct a named witness term:

```eyepl
registration(Student, Course, registration_of(Student, Course)) :-
  takes(Student, Course).
```

## 6. Logical Core semantics

### 6.1 Herbrand universe and base

For a program `P`, the **Herbrand universe** `U(P)` is the set of all ground
terms constructible from the constants and constructors in `P`. The
**Herbrand base** `B(P)` is the set of all ground atomic formulas constructible
from the predicate symbols of `P` and terms in `U(P)`.

A Herbrand interpretation is a subset of `B(P)`.

If a program contains no constant, an implementation MAY use one private
constant to make the universe non-empty. That constant MUST NOT appear in
printed answers.

### 6.2 Immediate consequence

For an interpretation `I`, `T_P(I)` contains:

- every ground fact in `P`; and
- the head of every ground instance of a rule in `P` whose body formulas all
  belong to `I`.

The declarative meaning of a Logical Core program is:

```text
M(P) = least fixed point of T_P
```

Equivalently, begin with the facts and repeatedly add justified rule heads
until no further head can be added.

### 6.3 Entailment

For a ground atomic formula `A`:

```text
P entails A  iff  A is in M(P)
```

This is the normative use of **entails** in Eyepl.

Example:

```eyepl
parent(alice, bob).
parent(bob, clara).

ancestor(X, Y) :- parent(X, Y).
ancestor(X, Z) :- parent(X, Y), ancestor(Y, Z).
```

The program entails:

```eyepl
ancestor(alice, bob).
ancestor(bob, clara).
ancestor(alice, clara).
```

It does not entail `ancestor(clara, alice)`. Non-entailment is absence of a
positive conclusion; it is not classical entailment of its negation.

### 6.4 Logical equality, unification, and inequality

Unification is structural finite-tree unification with an occurs check. A
variable MUST NOT be bound to a term containing that variable.

`eq(A, B)` succeeds exactly when `A` and `B` unify and retains the resulting
substitution. Ground scalar terms unify when their lexical values are equal,
including across the atom, string, and number kinds. Ground compound terms
unify structurally.

For ground terms, `eq/2` is Eyepl's logical equality relation. It is reflexive,
symmetric, transitive, and substitutive through structural unification, modulo
the scalar lexical equivalence above. For non-ground terms, `eq/2` is the
operational realization of equality: it computes the most general unifier
rather than merely returning a Boolean result.

Eyepl does not provide an independent axiomatic equality theory, congruence
closure over user-defined equivalence predicates, or automatic rewriting from
claims such as `same_as(A, B)`. A domain-specific equivalence relation affects
other predicates only through explicit rules.

`neq(A, B)` succeeds exactly when `A` and `B` are not unifiable under the
current substitution. For ground terms, this is logical inequality: exactly
one of `eq(A, B)` and `neq(A, B)` succeeds.

For non-ground terms, `neq/2` is only an immediate test. It is not constructive
negation and does not install a persistent disequality constraint:

```eyepl
% Fails because X can currently unify with alice.
query(neq(X, alice)).

% Succeeds after X is ground.
query(different(ok)).
different(ok) :- eq(X, bob), neq(X, alice).
```

Consequently, portable uses of logical inequality SHOULD call `neq/2` with
ground arguments. A future binding is not remembered by `neq/2`, and success
does not add an explicit negative formula to the model.

### 6.5 Soundness and completeness boundary

Every ground answer produced for a Logical Core query MUST belong to `M(P)`.

For finite Logical Core programs with a finite relevant ground call-and-answer
space, a conforming implementation MUST return every entailed ground answer.
For programs whose search or term space is infinite, this specification does
not require termination or complete enumeration.

Resource limits MAY stop execution, but an implementation MUST distinguish
such an incomplete run from logical failure.

## 7. Negation and closed-world reasoning

Eyepl provides negation as failure:

```eyepl
allowed(User) :-
  user(User),
  not(blocked(User)).
```

`not(G)` succeeds when the nested search for `G`, under the current
substitution, terminates with no solution. It means “`G` cannot be derived
from this program in this call,” not “classical `not G` is entailed.”

A portable negative call MUST be:

- sufficiently instantiated for its intended meaning;
- terminating;
- evaluated over a declared complete knowledge boundary; and
- stratified with respect to user-defined predicates.

A program is stratified when its predicates can be assigned non-negative
strata such that positive dependencies do not point upward and each negative
dependency points strictly downward. A dependency cycle containing a negative
edge is unstratified.

For a stratified program, strata are evaluated from lower to higher. Within a
stratum, positive rules use least-fixed-point meaning; negative goals inspect
the completed lower strata. This is the portable declarative account of
stratified negation.

An implementation MUST be able to report unstratified negation. It MAY execute
such a program, but the resulting negative conclusions are outside the
portable semantic contract and MUST be identified as such.

Eyepl does not define classical negation, explicit negative triples, or
explosion from inconsistency. A policy requiring explicit contrary facts
should model them as positive predicates such as `denied/2` or
`confirmed_absent/1`.

## 8. Standard built-ins

Portable Execution implementations MUST provide these predicate indicators:

| Family | Predicate indicators |
| --- | --- |
| Equality | `eq/2`, `neq/2` |
| Arithmetic | `neg/2`, `abs/2`, `sin/2`, `cos/2`, `tan/2`, `asin/2`, `acos/2`, `sqrt/2`, `floor/2`, `ceiling/2`, `trunc/2`, `rounded/2`, `exp/2`, `log/2`, `add/3`, `sub/3`, `mul/3`, `div/3`, `mod/3`, `min/3`, `max/3`, `pow/3`, `atan2/3` |
| Comparison and generation | `lt/2`, `gt/2`, `le/2`, `ge/2`, `between/3`, `smallest_divisor_from/3` |
| Time | `local_time/1`, `difference/3` |
| Strings | `str_concat/3`, `contains/2`, `matches/2`, `matches/3`, `not_matches/2`, `split/3`, `join/3`, `substring/4`, `replace/4`, `lowercase/2`, `uppercase/2`, `trim/2`, `number_string/2`, `atom_string/2`, `term_string/2` |
| Lists | `append/3`, `nth0/3`, `set_nth0/4`, `head/2`, `rest/2`, `last/2`, `take/3`, `drop/3`, `slice/4`, `member/2`, `select/3`, `not_member/2`, `reverse/2`, `length/2`, `sum_list/2`, `min_list/2`, `max_list/2`, `list_to_set/2`, `sort/2` |
| Aggregation | `findall/3`, `countall/2`, `sumall/3`, `aggregate_min/5`, `aggregate_max/5` |
| Context | `holds/2`, `holds/3` |
| Term inspection | `functor/3`, `arg/3`, `compound_name_arguments/3` |
| Search control | `not/1`, `once/1`, `forall/2` |

The detailed relation, modes, numeric behavior, empty-case behavior, term
ordering, and failure conditions of each built-in are part of the executable
conformance corpus under `test/conformance/`. Appendix B of
`the-art-of-eyepl.md` is the human-readable catalog.

Built-ins are mode-sensitive relations, not necessarily omnidirectional
equations. A portable call MUST satisfy the documented readiness mode.
Failure caused by an unready call MUST NOT be interpreted as logical
non-entailment.

Integer operations preserve arbitrary-precision integers where specified.
Floating-point operations use IEEE-754 double precision. A policy whose
decision depends on floating-point results MUST record that numeric assumption.

`local_time/1`, host regular expressions in `matches/3`, and any external
provider introduce environment-dependent premises. Reproducible policy
evaluation MUST fix or record those inputs.

An implementation MAY add built-ins. Extension predicates MUST be documented
by name, arity, modes, determinism, failure behavior, and proof representation.
A program depending on one is not portable unless the extension is explicitly
included in its declared profile.

## 9. Aggregation and search control

`findall/3`, `countall/2`, and `sumall/3` collect the complete finite solution
sequence of their nested goal. Their empty results are respectively `[]`, `0`,
and `0`.

`aggregate_min/5` and `aggregate_max/5` select one solution by standard term
order and fail when the nested goal has no solution. Structured keys provide
explicit deterministic tie-breaking.

`once(G)` returns at most the first solution of `G`. Clause order, goal order,
and implementation search order are therefore observable.

`forall(Generator, Test)` succeeds when `Test` succeeds for every solution of
`Generator`; it succeeds vacuously when the generator has no solutions.

Every nested search used by negation, aggregation, `once/1`, or `forall/2`
MUST terminate for its result to be portable. Aggregation and `once/1` are
operational result operators; their outputs MUST NOT be described as the
unqualified least-model entailments of the source clauses.

## 10. Queries and answers

`query(G)` is a host declaration. It does not add `G` to the logical theory.

For each query, the host:

1. evaluates all inference fuses;
2. solves `G`;
3. retains ground resolved instances of `G`;
4. suppresses duplicate answers;
5. suppresses answers identical to source facts; and
6. prints each remaining answer as valid Eyepl source.

Answers from one query are not asserted for later queries. A program without
queries produces no normal answer output.

For a portable terminating program, conforming implementations MUST agree on
the set of ground answers. Answer order is not part of the logical contract
unless the program uses an order-sensitive construct such as `once/1` or an
ordered aggregate. Duplicate proof paths do not create duplicate printed
answers.

Implementations MUST distinguish these outcomes:

- **entailed/successful:** at least one answer was derived;
- **not derived:** a complete terminating search found no answer;
- **invalid theory:** an inference fuse matched;
- **non-portable:** a static semantic condition such as stratification failed;
- **incomplete:** execution stopped before the relevant search completed; and
- **error:** the source or a required operation was invalid.

## 11. Inference fuses

A clause headed by `false` is an inference fuse:

```eyepl
false :-
  assigned(Person, Role),
  incompatible_roles(Role, Other),
  assigned(Person, Other).
```

All fuses are checked before any query answer is emitted. If any fuse body
succeeds, the theory is invalid for this run. The implementation MUST abort
query evaluation and MUST report the matched fuse. A bare `false.` always
fires.

A fuse is an integrity condition, not classical falsity and not a resource
limit. Eyepl does not infer arbitrary formulas after a fuse fires.

The reference CLI uses exit status `65` for a matched fuse.

## 12. Proofs

Proof output is requested independently of ordinary answers. Enabling proof,
warning, or statistics output MUST NOT change the ground answer set.

For every explained answer `A`, the reference proof interface emits:

```eyepl
why(A, Proof).
```

The abstract proof form is:

```eyepl
proof(
  goal(G),
  by(Method),
  bindings(Bindings),
  uses(Subproofs)
)
```

Methods identify source facts, source rules, or built-ins:

```eyepl
fact(Filename, clause(Number))
rule(Filename, clause(Number))
builtin(Name, Arity)
```

A proof records one successful derivation, not the complete search tree and
not every possible proof. Proof terms are evidence about a run; they are not
premises used to obtain the answer.

A conforming proof-producing implementation MUST:

- identify the explained ground answer;
- identify every used source clause or built-in step;
- retain the substitutions needed to check rule applications;
- recursively expose the successful premises of user rules; and
- serialize the proof as Eyepl data or provide a lossless mapping to this
  abstract structure.

A proof establishes derivability only relative to:

- the exact input facts and rules;
- the specified built-in semantics;
- any external values or providers used;
- the implementation's correctness; and
- successful completion of all relevant nested searches.

For policy audit, the input version, implementation version, declared profile,
answer, and proof SHOULD be retained together.

## 13. RDF, N3, and external data

RDF and N3 input formats are adapters, not the semantic definition of Eyepl.
Converting an RDF dataset to `rdf/4` facts preserves data for Eyepl rules; it
does not make Eyepl's closed-world operations part of RDF or N3 entailment.

An adapter MUST document:

- the mapping of IRIs, blank nodes, literals, triple terms, and graph names;
- which input statements become Eyepl premises;
- whether the input graph or relation is considered complete;
- whether quoted formulas remain data or become asserted rules; and
- how derived answers are mapped back to the external format.

An implementation MUST NOT label an Eyepl conclusion as an RDF or N3
entailment unless it separately implements and names the applicable RDF or N3
entailment regime.

## 14. Policy interoperability contract

A portable Eyepl policy package SHOULD state:

```text
language: Eyepl
language-version: 0.0.54
profile: Logical-Core | Portable-Execution
entry-queries: predicate indicators
closed-world-relations: predicate indicators
extensions: predicate indicators and versions
external-inputs: named sources and versions
numeric-assumptions: integer and/or IEEE-754
expected-outcome: answer | no-answer | invalid | non-portable | incomplete
proof-required: yes | no
```

For each public policy decision, the package SHOULD define:

- the positive decision predicate;
- whether denial is explicit or derived by closed-world failure;
- the finite domain searched;
- all completeness assumptions;
- every inference fuse;
- all order-sensitive constructs;
- the required built-in modes;
- representative entailed and non-entailed cases; and
- at least one proof fixture when accountability matters.

Example:

```eyepl
% Complete boundary: every employee and every revocation is present here.
employee(alice).
employee(bob).
revoked(bob).

permit(Person) :-
  employee(Person),
  not(revoked(Person)).

false :-
  permit(Person),
  revoked(Person).

query(permit(Person)).
```

Under the stated complete boundary, `permit(alice)` is a portable stratified
conclusion. `permit(bob)` is not derived. This does not classically entail a
negative proposition about Bob; an explicit denial would require a positive
predicate such as:

```eyepl
deny(Person) :- employee(Person), revoked(Person).
```

## 15. Conformance

The executable conformance corpus is located under `test/conformance/` and
contains:

- positive answer cases;
- required parse and execution errors;
- portability warnings; and
- proof-output cases.

A conforming implementation MUST pass every case applicable to its claimed
profile. Conformance is measured against:

- ground answer sets;
- required error classification;
- required portability diagnostics; and
- the abstract proof content, allowing implementation-neutral source names
  where a harness explicitly maps them.

Optimizations MAY change indexing, clause lookup, scheduling, tabling,
memoization, or internal representation. They MUST NOT change:

- the entailed ground answer set of a terminating Logical Core program;
- the specified ground result set of a terminating Portable Execution program;
- whether an inference fuse matches;
- the success or failure specified for a ready standard built-in; or
- the validity of an emitted proof.

Proof choice, answer order, and performance MAY differ unless an
order-sensitive construct makes them observable.

## 16. Semantic boundary summary

| Construct | Contract |
| --- | --- |
| Facts and definite rules | Least-Herbrand-model entailment |
| `eq/2` | Finite-tree unification and Herbrand identity |
| `neq/2` | Operational non-unifiability test |
| Stratified `not/1` | Closed-world test over completed lower strata |
| Unstratified `not/1` | Non-portable |
| Arithmetic and strings | Mode-sensitive built-in semantics |
| Aggregation | Complete finite nested search |
| `once/1` | First operational solution |
| `query/1` | Host request, not a logical premise |
| `false :- ...` | Pre-query integrity rejection |
| `why/2` | Evidence for one derivation, not a premise |
| RDF/N3 adapters | Data mapping, not automatic RDF/N3 entailment |

The shortest accurate statement of Eyepl interoperability is therefore:

> Conforming engines agree on what the portable logical core entails, agree on
> the specified results of terminating portable programs, and explicitly mark
> every closed-world, operational, environmental, or implementation-specific
> assumption.
