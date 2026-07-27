# Eyepl Language Reference

Eyepl accepts a partial ISO Prolog syntax and provides a small set of built-in
predicates. This document describes that source language and those built-ins.
It does not specify a reasoning algorithm, a new logic standard, or an
interchange profile.

The implementation's search strategy, tabling, proof output, command-line
interface, RDF adapters, and design rationale are documented in
[*The Art of Eyepl*](the-art-of-eyepl.md) and the [README](README.md).

## Prolog syntax

Eyepl source is UTF-8. It uses the familiar Prolog forms for facts, rules,
compound terms, variables, numbers, quoted atoms, strings, and lists:

```eyepl
parent(alice, bob).
ancestor(X, Z) :- parent(X, Y), ancestor(Y, Z).
names([alice, bob | Tail]).
```

The accepted grammar is:

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

`%` starts a line comment. Plain names use ASCII letters. Unicode is accepted
inside quoted atoms and strings. Single quotes delimit atoms and double quotes
delimit strings. Doubling the active quote includes it literally; common
backslash escapes such as `\n`, `\t`, `\"`, and `\\` are also accepted.

The bare variable `_` is fresh at each occurrence. Other variables have clause
scope. Predicate identity includes name and arity. Lists use the usual `[]`,
`[Head | Tail]`, and `[A, B, C]` notation.

A parenthesized comma sequence is represented as a right-associated `','/2`
term. In a rule body it is a conjunction; as an argument it is ordinary
compound data.

### Differences from ISO Prolog

Eyepl implements only the syntax above. In particular:

- there are no user-defined operators or operator declarations;
- zero-arity compound notation such as `ready()` is not accepted; use `ready`;
- variables cannot occur in functor or predicate position;
- cut, modules, dynamic database updates, DCGs, directives, and the general
  ISO Prolog library are not supported;
- colon names and unquoted angle-bracket IRIs are not accepted; quote such
  names or use a plain name;
- arithmetic operators such as `is`, `+`, and `=:=` are not syntax; use the
  built-in predicates below; and
- every fact and rule must end in a period.

Eyepl terms are finite trees, and unification performs an occurs check.
Atoms, strings, and numbers with the same lexical value compare as equal in
the current implementation; for example, `eq(a, "a")` and `eq(7, "7")`
succeed.

## Recognized declarations

The following terms have a conventional role when they occur as clauses:

| Form | Purpose |
| --- | --- |
| `query(Goal).` | Requests that the host solve `Goal`. |
| `mode(Name, Arity, Modes).` | Documents `in`, `out`, or `any` argument modes. |
| `det(Name, Arity).` | Documents an intended single-answer relation. |
| `semidet(Name, Arity).` | Documents an intended zero-or-one-answer relation. |
| `false :- Goals.` | Defines an inference fuse checked before queries. |

The mode and determinism declarations are advisory and remain ordinary facts.
They do not alter evaluation.

## Supported built-ins

A built-in is called with the same atomic-formula syntax as a user-defined
predicate. Many built-ins are mode-sensitive: required inputs must be bound
before the call can run. The tables below describe the supported calls; the
executable cases under `test/conformance/` provide exact examples and boundary
tests.

### Equality and arithmetic

| Built-in | Description |
| --- | --- |
| `eq(A, B)` | Unifies `A` and `B` and retains the bindings. |
| `neq(A, B)` | Succeeds when `A` and `B` do not currently unify; it does not install a constraint. |
| `neg(A, B)`, `abs(A, B)` | Numeric negation and absolute value. |
| `sin(A, B)`, `cos(A, B)`, `tan(A, B)` | Trigonometric functions. |
| `asin(A, B)`, `acos(A, B)`, `atan2(Y, X, A)` | Inverse trigonometric functions. |
| `sqrt(A, B)`, `exp(A, B)`, `log(A, B)` | Square root, natural exponential, and natural logarithm. |
| `floor(A, B)`, `ceiling(A, B)`, `trunc(A, B)`, `rounded(A, B)` | Numeric rounding. |
| `add(A, B, C)`, `sub(A, B, C)`, `mul(A, B, C)` | Addition, subtraction, and multiplication. |
| `div(A, B, C)`, `mod(A, B, C)`, `pow(A, B, C)` | Division, integer remainder, and exponentiation. |
| `min(A, B, C)`, `max(A, B, C)` | Numeric minimum and maximum. |

Integer arithmetic uses arbitrary-precision decimal representations where
possible. Floating operations use the host's IEEE-754 double-precision
behavior. Invalid numeric domains and division by zero fail.

### Comparison, dates, and generation

| Built-in | Description |
| --- | --- |
| `lt(A, B)`, `gt(A, B)`, `le(A, B)`, `ge(A, B)` | Numeric, duration, or lexical comparison. |
| `between(Low, High, X)` | Enumerates inclusive integers or checks a bound `X`. |
| `smallest_divisor_from(N, Start, D)` | Finds a divisor of `N` beginning at `Start`. |
| `local_time(T)` | Binds `T` to the local ISO date. |
| `difference(End, Start, D)` | Computes an ISO-like calendar duration from `Start` to `End`. |

For repeatable runs, `EYEPL_LOCAL_TIME=YYYY-MM-DD` overrides the value returned
by `local_time/1`.

### Strings and conversion

| Built-in | Description |
| --- | --- |
| `str_concat(A, B, C)` | Concatenates textual values. |
| `contains(Text, Needle)` | Tests literal containment. |
| `matches(Text, Pattern)` | Tests literal alternatives separated by `|`. |
| `matches(Text, Pattern, Context)` | Applies a JavaScript regular expression and returns named captures as a comma context. |
| `not_matches(Text, Pattern)` | Succeeds when `matches/2` does not. |
| `split(Text, Separator, Parts)`, `join(Parts, Separator, Text)` | Splits or joins text. |
| `substring(Text, Start, Length, Out)` | Extracts a zero-based substring. |
| `replace(Text, Search, Replacement, Out)` | Replaces all nonempty literal occurrences. |
| `lowercase(Text, Out)`, `uppercase(Text, Out)`, `trim(Text, Out)` | Text transformations. |
| `number_string(Number, String)` | Converts between a number and textual representation. |
| `atom_string(Atom, String)` | Converts between an atom and textual representation. |
| `term_string(Term, String)` | Renders a non-variable term as Eyepl source text. |

### Lists

| Built-in | Description |
| --- | --- |
| `append(A, B, C)` | Appends lists or enumerates prefix/suffix splits. |
| `nth0(Index, List, Value)` | Zero-based lookup or index enumeration. |
| `set_nth0(Index, List, Value, Out)` | Functionally replaces an item. |
| `head(List, Head)`, `rest(List, Tail)`, `last(List, Last)` | Selects a list part. |
| `take(N, List, Prefix)`, `drop(N, List, Suffix)`, `slice(Start, Length, List, Slice)` | Selects a list range. |
| `member(X, List)`, `select(X, List, Rest)`, `not_member(X, List)` | Membership, selection, and absence. |
| `reverse(A, B)`, `length(List, N)` | Reversal and length. |
| `sum_list(List, Sum)`, `min_list(List, Min)`, `max_list(List, Max)` | List reduction. |
| `list_to_set(List, Set)`, `sort(Input, Output)` | Deduplication and sorting. |

Unless a description says otherwise, list operations require a proper list.

### Aggregation and search control

| Built-in | Description |
| --- | --- |
| `findall(Template, Goal, Bag)` | Collects the resolved template for every solution. |
| `countall(Goal, Count)` | Counts solutions. |
| `sumall(Template, Goal, Sum)` | Sums numeric template values over solutions. |
| `aggregate_min(Key, Template, Goal, BestKey, BestTemplate)` | Selects the solution with the smallest key. |
| `aggregate_max(Key, Template, Goal, BestKey, BestTemplate)` | Selects the solution with the largest key. |
| `not(Goal)` | Negation as failure. |
| `once(Goal)` | Retains at most the first solution. |
| `forall(Generator, Test)` | Tests `Test` for every generated solution. |

Nested searches and generators must be finite for these calls to complete.
`findall/3`, `countall/2`, and `sumall/3` return `[]`, `0`, and `0` when there
are no solutions. The minimum and maximum aggregates fail in that case.

### Context and term inspection

| Built-in | Description |
| --- | --- |
| `holds(Context, Term)` | Enumerates terms in a comma context. |
| `holds(Context, Name, Args)` | Exposes a context member as its name and argument list. |
| `functor(Term, Name, Arity)` | Decomposes a non-variable term. |
| `arg(Index, Term, Arg)` | Selects a compound term's one-based argument. |
| `compound_name_arguments(Term, Name, Args)` | Decomposes or constructs an atom or compound. |

## Implementation behavior

This reference intentionally stops at the accepted source forms and supplied
predicates. Details such as goal order, automatic tabling, negation warnings,
query answer filtering, proof terms, inference-fuse diagnostics, and external
data adapters describe the Eyepl reasoner and host, not the language syntax.
They are covered by [*The Art of Eyepl*](the-art-of-eyepl.md), the
[JavaScript API and CLI overview](README.md), and executable tests.
