% Bounded equality saturation over tiny arithmetic expression terms.
%
% Real equality-saturation engines use mutable e-graphs, union-find classes,
% congruence closure, rewrite scheduling, and cost-based extraction.  EyeProlog has
% none of those primitives, so this example simulates the idea relationally: it
% enumerates expressions reachable within a small rewrite-fuel bound, scores the
% generated terms, and extracts the cheapest equivalent expression.
%
% The point is not to be fast.  The point is to show the declarative shape of an
% e-graph optimizer in a language that was not designed for it.

%% goal: egraphAnswer(X0, X1)



% Start expression:
%   ((x + 0) * 1) + 2 * (1 + 2)
% The best bounded rewrite result should be x + 6.
expr(start, add(mul(add(x, 0), 1), mul(2, add(1, 2)))).
fuel(6).

% Directed rewrite rules.  A true e-graph would keep equalities in equivalence
% classes.  This bounded version uses oriented rewrites so search terminates.
rewrite(add(X, 0), X).
rewrite(add(0, X), X).
rewrite(mul(X, 1), X).
rewrite(mul(1, X), X).
rewrite(mul(X, 0), 0).
rewrite(mul(0, X), 0).

% Constant folding and one distributivity rule make the search space less toyish.
rewrite(add(A, B), C) :- number(A), number(B), (C is A + B).
rewrite(mul(A, B), C) :- number(A), number(B), (C is A * B).
rewrite(mul(X, add(Y, Z)), add(mul(X, Y), mul(X, Z))).

% Apply a rewrite at the root or inside one subterm.
rewrite_anywhere(In, Out) :- rewrite(In, Out).
rewrite_anywhere(add(A, B), add(New_a, B)) :- rewrite_anywhere(A, New_a).
rewrite_anywhere(add(A, B), add(A, New_b)) :- rewrite_anywhere(B, New_b).
rewrite_anywhere(mul(A, B), mul(New_a, B)) :- rewrite_anywhere(A, New_a).
rewrite_anywhere(mul(A, B), mul(A, New_b)) :- rewrite_anywhere(B, New_b).

% Fuel-bounded closure.  Every depth represents exactly that many rewrite steps;
% candidate_expression/1 looks across all depths from zero to the fuel limit.
equivalent_at_depth(0, Expr, Expr).
equivalent_at_depth(Depth, Expr, Out) :-
  (Depth > 0),
  (Previous_depth is Depth - 1),
  equivalent_at_depth(Previous_depth, Expr, Mid),
  rewrite_anywhere(Mid, Out).

candidate_expression(Candidate) :-
  expr(start, Expr),
  fuel(Fuel),
  between(0, Fuel, Depth),
  equivalent_at_depth(Depth, Expr, Candidate).

% A tiny cost model for extraction.  Leaves cost 1; compound nodes cost 1 plus
% their children.  The numeric range is deliberately bounded for the generated
% constants in this example.
expr_cost(x, 1).
expr_cost(N, 1) :- between(0, 20, N).
expr_cost(add(A, B), Cost) :-
  expr_cost(A, A_cost),
  expr_cost(B, B_cost),
  (Children is A_cost + B_cost),
  (Cost is Children + 1).
expr_cost(mul(A, B), Cost) :-
  expr_cost(A, A_cost),
  expr_cost(B, B_cost),
  (Children is A_cost + B_cost),
  (Cost is Children + 1).

best_expression(Expr, Cost) :-
  aggregate_min([Candidate_cost, Candidate], Candidate,
    (candidate_expression(Candidate), expr_cost(Candidate, Candidate_cost)),
    [Cost, Expr], Expr).

egraphAnswer(start, Expr) :- expr(start, Expr).
egraphAnswer(best, Expr) :- best_expression(Expr, _).
egraphAnswer(cost, Cost) :- best_expression(_, Cost).
egraphAnswer(candidate_count, Count) :- countall(candidate_expression(_), Count).
egraphAnswer(note, "bounded equality saturation extracts the cheapest term without a real e-graph") :- best_expression(_, _).
