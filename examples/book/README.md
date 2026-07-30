# The Art of Eyepl — inline examples

These files are generated from the complete `eyepl` code blocks in
[The Art of Eyepl](../../the-art-of-eyepl.md). They are grouped by chapter and
retain the source text from the book. Goal fragments and non-Eyepl blocks are
not extracted.

Regenerate them from the repository root with:

```sh
npm run generate
```

## Chapter 1: A program is a little theory

- [01-parent.pl](chapter-01/01-parent.pl)
- [02-child.pl](chapter-01/02-child.pl)
- [03-child-2.pl](chapter-01/03-child-2.pl)

## Chapter 2: Terms, variables, and substitution

- [01-same_shape.pl](chapter-02/01-same_shape.pl) — Unification
- [02-measurement.pl](chapter-02/02-measurement.pl)
- [03-label.pl](chapter-02/03-label.pl)

## Chapter 3: Rules and their two readings

- [01-eligible.pl](chapter-03/01-eligible.pl)
- [02-adult.pl](chapter-03/02-adult.pl)
- [03-can_enter.pl](chapter-03/03-can_enter.pl)
- [04-high_score.pl](chapter-03/04-high_score.pl)
- [05-parent.pl](chapter-03/05-parent.pl) — The Herbrand world
- [06-ancestor.pl](chapter-03/06-ancestor.pl)
- [07-different.pl](chapter-03/07-different.pl) — Why terms denote themselves
- [08-has_parent.pl](chapter-03/08-has_parent.pl) — Quantification and visible witnesses
- [09-program.pl](chapter-03/09-program.pl) — Equality, unification, and the occurs check
- [10-closed.pl](chapter-03/10-closed.pl) — Meaning is not the search strategy
- [11-p.pl](chapter-03/11-p.pl)

## Chapter 4: Recursion: describing reachability

- [01-ancestor.pl](chapter-04/01-ancestor.pl)
- [02-path.pl](chapter-04/02-path.pl)

## Chapter 5: Lists as relations

- [01-first.pl](chapter-05/01-first.pl)
- [02-reverse_acc.pl](chapter-05/02-reverse_acc.pl)

## Chapter 6: Arithmetic and finite generation

- [01-next.pl](chapter-06/01-next.pl)
- [02-safe_reading.pl](chapter-06/02-safe_reading.pl)
- [03-square.pl](chapter-06/03-square.pl)
- [04-factorial.pl](chapter-06/04-factorial.pl)

## Chapter 7: Failure, negation, and quantification

- [01-allowed.pl](chapter-07/01-allowed.pl)
- [02-all_tests_pass.pl](chapter-07/02-all_tests_pass.pl)

## Chapter 8: Collecting and choosing answers

- [01-findall.pl](chapter-08/01-findall.pl)
- [02-outgoing_costs.pl](chapter-08/02-outgoing_costs.pl)
- [03-best_route.pl](chapter-08/03-best_route.pl)

## Chapter 9: Structured data, strings, and contexts

- [01-functor.pl](chapter-09/01-functor.pl)
- [02-normalized.pl](chapter-09/02-normalized.pl)
- [03-message.pl](chapter-09/03-message.pl)

## Chapter 10: From puzzles to models

- [01-color.pl](chapter-10/01-color.pl)
- [02-plan.pl](chapter-10/02-plan.pl)

## Chapter 11: Queries, answers, and proofs

- [01-why.pl](chapter-11/01-why.pl)

## Chapter 12: Integrity constraints and inference fuses

- [01-program.pl](chapter-12/01-program.pl)
- [02-program-2.pl](chapter-12/02-program-2.pl)

## Chapter 14: Knowledge engineering

- [01-heating.pl](chapter-14/01-heating.pl)

## Chapter 15: RDF 1.2 as the interoperable data boundary

- [01-rdf.pl](chapter-15/01-rdf.pl)

## Chapter 16: Embedding Eyepl

- [01-socket.pl](chapter-16/01-socket.pl) — Sockets: naming the knowledge boundary
- [02-socket-2.pl](chapter-16/02-socket-2.pl)

## Chapter 17: Logic and control

- [01-path.pl](chapter-17/01-path.pl)
- [02-adult.pl](chapter-17/02-adult.pl) — The same relation, a different computation
- [03-bad_member.pl](chapter-17/03-bad_member.pl)
- [04-item.pl](chapter-17/04-item.pl)
- [05-mode.pl](chapter-17/05-mode.pl) — Modes are part of the design

## Chapter 18: Constructing a program

- [01-routeable.pl](chapter-18/01-routeable.pl) — Begin with ground sentences
- [02-routeable-2.pl](chapter-18/02-routeable-2.pl)
- [03-prefix.pl](chapter-18/03-prefix.pl) — Invent examples before recursion
- [04-candidate_pair.pl](chapter-18/04-candidate_pair.pl) — Separate generate, test, and describe
- [05-compatible_pair.pl](chapter-18/05-compatible_pair.pl)

## Chapter 19: Correctness and termination

- [01-factorial.pl](chapter-19/01-factorial.pl) — Termination needs its own argument
- [02-program.pl](chapter-19/02-program.pl) — Integrity is not merely failure

## Chapter 20: Improving a program

- [01-connected.pl](chapter-20/01-connected.pl) — Strengthen calls before adding machinery
- [02-within_thermal_limits.pl](chapter-20/02-within_thermal_limits.pl) — Introduce helpers that express invariants
- [03-search.pl](chapter-20/03-search.pl) — Move invariant work outward

## Chapter 21: Reading the computation

- [01-parent.pl](chapter-21/01-parent.pl)
- [02-grandparent.pl](chapter-21/02-grandparent.pl) — Substitutions accumulate
- [03-loop_edge.pl](chapter-21/03-loop_edge.pl)
- [04-eligible.pl](chapter-21/04-eligible.pl) — Failure rewinds choices, not facts
- [05-grows.pl](chapter-21/05-grows.pl) — Variants, cycles, and tables

## Chapter 22: Trees, languages, and symbolic evaluation

- [01-tree.pl](chapter-22/01-tree.pl)
- [02-tree_member.pl](chapter-22/02-tree_member.pl)
- [03-mirror.pl](chapter-22/03-mirror.pl) — Transforming a tree
- [04-sentence.pl](chapter-22/04-sentence.pl) — A grammar without special syntax
- [05-evaluate.pl](chapter-22/05-evaluate.pl) — Interpreting an expression
- [06-query.pl](chapter-22/06-query.pl)
- [07-lookup.pl](chapter-22/07-lookup.pl)
- [08-simplify.pl](chapter-22/08-simplify.pl) — Rewriting symbolic expressions

## Chapter 23: Transforming programs

- [01-adult.pl](chapter-23/01-adult.pl) — Unfolding and folding
- [02-adult-2.pl](chapter-23/02-adult-2.pl)
- [03-can_board.pl](chapter-23/03-can_board.pl)
- [04-traveler_in_good_standing.pl](chapter-23/04-traveler_in_good_standing.pl)
- [05-connection.pl](chapter-23/05-connection.pl) — Specializing a relation
- [06-rail_connection.pl](chapter-23/06-rail_connection.pl)
- [07-sum_numbers.pl](chapter-23/07-sum_numbers.pl) — Accumulators and modes
- [08-sum_numbers_acc.pl](chapter-23/08-sum_numbers_acc.pl)

## Chapter 24: Designing finite search

- [01-worker.pl](chapter-24/01-worker.pl) — Generate, constrain, describe
- [02-simple_path.pl](chapter-24/02-simple_path.pl) — Search over states
- [03-reachable.pl](chapter-24/03-reachable.pl) — Existence, one witness, and all witnesses
- [04-best_plan.pl](chapter-24/04-best_plan.pl) — Optimization is search plus an order

## Chapter 25: Case study: an auditable decision service

- [01-person.pl](chapter-25/01-person.pl) — Source and concept layers
- [02-active_badge.pl](chapter-25/02-active_badge.pl)
- [03-in_good_standing.pl](chapter-25/03-in_good_standing.pl) — Closed-world choice
- [04-permit.pl](chapter-25/04-permit.pl) — Decision, reasons, and proof
- [05-incompatible_status.pl](chapter-25/05-incompatible_status.pl) — Integrity before decisions

## Chapter 26: A proof can be a computation

- [01-mortal.pl](chapter-26/01-mortal.pl)
- [02-triple.pl](chapter-26/02-triple.pl) — Answers are existential witnesses
- [03-triple-2.pl](chapter-26/03-triple-2.pl) — Proof objects and proof checking
- [04-edge.pl](chapter-26/04-edge.pl) — The least model as mathematical closure

## Chapter 27: Recursion is induction in motion

- [01-natural.pl](chapter-27/01-natural.pl)
- [02-list_length.pl](chapter-27/02-list_length.pl) — Structural induction and data design
- [03-reverse_acc.pl](chapter-27/03-reverse_acc.pl) — Accumulators and strengthened invariants

## Chapter 28: Algebra, symmetry, and representation

- [01-program.pl](chapter-28/01-program.pl) — Unification is structural equation solving
- [02-triangle.pl](chapter-28/02-triangle.pl) — Symmetry reduces search
- [03-rectangle.pl](chapter-28/03-rectangle.pl) — Relations reveal inverse problems
- [04-integer_rectangle.pl](chapter-28/04-integer_rectangle.pl)
- [05-preserves_combine.pl](chapter-28/05-preserves_combine.pl) — Composition, homomorphism, and reusable laws

## Chapter 29: Search as experimental mathematics

- [01-counterexample_to_odd_square.pl](chapter-29/01-counterexample_to_odd_square.pl) — Examples suggest; proofs compel
- [02-noncommuting_pair.pl](chapter-29/02-noncommuting_pair.pl) — One counterexample has asymmetric power

## Chapter 31: Testing a theory

- [01-edge.pl](chapter-31/01-edge.pl) — Positive and negative observers
- [02-program.pl](chapter-31/02-program.pl)
- [03-query.pl](chapter-31/03-query.pl) — Test the relation from more than one mode
- [04-double.pl](chapter-31/04-double.pl) — Properties over finite domains

## Chapter 32: Debugging by meaning, search, and proof

- [01-query.pl](chapter-32/01-query.pl) — Reduce to the smallest disputed ground question
- [02-eligible.pl](chapter-32/02-eligible.pl) — Follow bindings from left to right
- [03-eligible-2.pl](chapter-32/03-eligible-2.pl)
- [04-candidate_debug.pl](chapter-32/04-candidate_debug.pl) — Create diagnostic relations
- [05-reference_square.pl](chapter-32/05-reference_square.pl) — Compare specification and implementation

## Chapter 33: A pattern catalog for reasoning

- [01-assigned_badge.pl](chapter-33/01-assigned_badge.pl) — Pattern 1: Ground sentence first
- [02-source_role.pl](chapter-33/02-source_role.pl) — Pattern 2: Normalize at the boundary
- [03-chosen_pair.pl](chapter-33/03-chosen_pair.pl) — Pattern 3: Generate, constrain, describe
- [04-path.pl](chapter-33/04-path.pl) — Pattern 4: Carry the witness
- [05-unregistered.pl](chapter-33/05-unregistered.pl) — Pattern 5: Bound absence
- [06-step.pl](chapter-33/06-step.pl) — Pattern 6: Explicit state transition
- [07-depends.pl](chapter-33/07-depends.pl) — Pattern 7: Fixed-point closure
- [08-within_limit.pl](chapter-33/08-within_limit.pl) — Pattern 8: Proof façade
- [09-program.pl](chapter-33/09-program.pl) — Pattern 9: Integrity before inference
- [10-theory_version.pl](chapter-33/10-theory_version.pl) — Pattern 10: Version the evidence boundary

## Chapter 34: Control, exceptions, and grouped solutions

- [01-travel_status.pl](chapter-34/01-travel_status.pl)
- [02-require_route.pl](chapter-34/02-require_route.pl)
- [03-regional_total.pl](chapter-34/03-regional_total.pl)

## Chapter 35: Reflective terms and atomic conversion

- [01-term_shape.pl](chapter-35/01-term_shape.pl)

## Chapter 36: Dynamic predicates, directives, and operators

- [01-program.pl](chapter-36/01-program.pl)
- [02-program-2.pl](chapter-36/02-program-2.pl)
- [03-program-3.pl](chapter-36/03-program-3.pl)

## Chapter 37: Streams and term I/O

- [01-write_event.pl](chapter-37/01-write_event.pl)
