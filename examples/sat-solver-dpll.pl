% DPLL-style SAT solving for a small CNF formula.
%
% The example keeps the solver itself in Eyepl.  It recursively assigns
% variables in a fixed order, prunes a branch as soon as any clause is already
% impossible, and accepts a complete assignment when every clause is satisfied.
% aggregate_min/5 is then used only to choose one canonical satisfying model.

query(satModel(X0)).
query(satValue(X0, X1)).
query(satClauseStatus(X0, X1)).
query(satConclusion(X0, X1)).

% CNF formula:
%   (a or b)
%   (not a or c)
%   (not b or c)
%   (not c or d)
%   (c or not d)
variable_order([a, b, c, d]).
clause(c1, [pos(a), pos(b)]).
clause(c2, [neg(a), pos(c)]).
clause(c3, [neg(b), pos(c)]).
clause(c4, [neg(c), pos(d)]).
clause(c5, [pos(c), neg(d)]).

bool(false).
bool(true).
bit(false, 0).
bit(true, 1).

% Look up a variable inside a partial or complete assignment represented as a
% list of bind(Name, Bool) terms.
lookup_bool(Name, [bind(Name, Value) | _], Value).
lookup_bool(Name, [bind(_, _) | Rest], Value) :- lookup_bool(Name, Rest, Value).

literal_true(pos(Var), Assignment) :- lookup_bool(Var, Assignment, true).
literal_true(neg(Var), Assignment) :- lookup_bool(Var, Assignment, false).
literal_false(pos(Var), Assignment) :- lookup_bool(Var, Assignment, false).
literal_false(neg(Var), Assignment) :- lookup_bool(Var, Assignment, true).

clause_satisfied(Assignment, Clause_name) :-
  clause(Clause_name, Literals),
  member(Literal, Literals),
  literal_true(Literal, Assignment).

% A partial branch is impossible when every literal in a clause is already false.
% Unassigned literals keep the branch alive, just as in DPLL.
clause_impossible(Assignment, Clause_name) :-
  clause(Clause_name, Literals),
  forall(member(Literal, Literals), literal_false(Literal, Assignment)).
partial_consistent(Assignment) :- \+ (clause(Name, _), clause_impossible(Assignment, Name)).
complete_model(Assignment) :- forall(clause(Name, _), clause_satisfied(Assignment, Name)).

% Recursive DPLL search: choose a truth value, prune if inconsistent, then
% continue with the remaining variables.
dpll([], Assignment, Assignment) :- complete_model(Assignment).
dpll([Var | Rest], Partial, Model) :-
  bool(Value),
  partial_consistent([bind(Var, Value) | Partial]),
  dpll(Rest, [bind(Var, Value) | Partial], Model).

satisfying_model(Model) :- variable_order(Vars), dpll(Vars, [], Model).

% Rank models so the query answers shows one deterministic answer.  The
% model list is in reverse decision order because each decision is pushed onto
% the front during recursion.
model_rank(Model, Rank) :-
  lookup_bool(a, Model, A), bit(A, Abit),
  lookup_bool(b, Model, B), bit(B, Bbit),
  lookup_bool(c, Model, C), bit(C, Cbit),
  lookup_bool(d, Model, D), bit(D, Dbit),
  (Arank is Abit * 8),
  (Brank is Bbit * 4),
  (Crank is Cbit * 2),
  (Ab is Arank + Brank),
  (Cd is Crank + Dbit),
  (Rank is Ab + Cd).

best_model(Model, Rank) :-
  aggregate_min(Candidate_rank, Candidate_model,
    (satisfying_model(Candidate_model), model_rank(Candidate_model, Candidate_rank)),
    Rank, Model).

satModel(Model) :- best_model(Model, _).
satValue(Var, Value) :- best_model(Model, _), lookup_bool(Var, Model, Value).
satClauseStatus(Clause, satisfied) :- best_model(Model, _), clause_satisfied(Model, Clause).
satConclusion(case, "DPLL finds a satisfying assignment after pruning clauses that become impossible") :-
  best_model(_, _).
