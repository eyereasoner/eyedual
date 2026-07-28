% A tiny CDCL-style SAT trace with one learned clause.
%
% Industrial CDCL solvers use watched literals, mutable trails, non-chronological
% backjumping, clause databases, restarts, and activity heuristics.  Eyepl has
% no mutable state or destructive trail updates, so this example models one small
% conflict-analysis episode as relations over immutable terms.
%
% Formula:
%   c1: not(a) or c
%   c2: not(c)
%   c3: a or b
%
% Decision a=true forces c=true by c1, which conflicts with c2.  Resolving the
% reason c1 with the conflict c2 learns not(a).  After backjumping, learned
% not(a) forces a=false, c2 gives c=false, and c3 forces b=true.

query(cdclAnswer(X0, X1)).

clause(c1, [neg(a), pos(c)]).
clause(c2, [neg(c)]).
clause(c3, [pos(a), pos(b)]).

% Initial trail before conflict analysis.
initial_value(a, true, decision(level1)).
initial_value(c, true, implied_by(c1)).

% The current trail makes a literal true or false.
lit_true(pos(Var), Value_rel) :- call_value(Value_rel, Var, true, _).
lit_true(neg(Var), Value_rel) :- call_value(Value_rel, Var, false, _).
lit_false(pos(Var), Value_rel) :- call_value(Value_rel, Var, false, _).
lit_false(neg(Var), Value_rel) :- call_value(Value_rel, Var, true, _).

% Eyepl cannot pass predicates as first-class values, so this small dispatcher
% lets the same literal helpers inspect either the initial or final trail.
call_value(initial, Var, Value, Reason) :- initial_value(Var, Value, Reason).
call_value(final, Var, Value, Reason) :- final_value(Var, Value, Reason).

% A clause is conflicting when all of its literals are false under a trail.
conflict(Trail, Clause) :-
  clause(Clause, Literals),
  \+ nonfalse_literal(Trail, Literals).
nonfalse_literal(Trail, Literals) :-
  member(Literal, Literals),
  \+ lit_false(Literal, Trail).

% The learned clause for this tiny implication graph is obtained by resolving
% the conflict clause not(c) with c's reason not(a) or c, yielding not(a).
learned_clause(l1, [neg(a)]).
learned_from(l1, resolve(c2, c1, pivot(c))).

% After backjumping, the learned unit clause fixes a=false.  Then the original
% clauses imply c=false and b=true.
final_value(a, false, learned(l1)).
final_value(c, false, unit(c2)).
final_value(b, true, unit(c3)).

model_satisfies_clause(Trail, Clause) :-
  clause(Clause, Literals),
  member(Literal, Literals),
  lit_true(Literal, Trail).

final_model_ok(ok) :- \+ unsatisfied_final_clause.
unsatisfied_final_clause :-
  clause(Name, _),
  \+ model_satisfies_clause(final, Name).

cdclAnswer(conflict_clause, Clause) :- conflict(initial, Clause).
cdclAnswer(learned_clause, Literals) :- learned_clause(l1, Literals).
cdclAnswer(learned_from, Reason) :- learned_from(l1, Reason).
cdclAnswer(final_value(Var), Value) :- final_model_ok(ok), final_value(Var, Value, _).
cdclAnswer(note, "one learned clause makes the final model satisfy all original clauses") :- final_model_ok(ok).
