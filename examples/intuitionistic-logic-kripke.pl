% Intuitionistic logic emulation with a finite Kripke model.
%
% The preorder leq/2 represents information growth: later worlds contain at
% least as much information as earlier worlds.  Atomic facts persist upward, and
% implication is checked at every future world.  This lets the example show a
% constructive implication that holds while excluded middle is not forced at the
% root world.
%% goal: intuitionistic_truth(X0, X1, X2)

%% goal: intuitionistic_countermodel(X0, X1, X2)



world(root).
world(left).
world(right).
world(both).

step(root, left).
step(root, right).
step(left, both).
step(right, both).

base(left, p).
base(right, q).

leq(World, World) :- world(World).
leq(From, To) :- step(From, Mid), leq(Mid, To).

% Upward persistence for atoms: if P becomes known at SomeWorld, every later
% world also forces P.
forces(World, atom(Prop)) :-
  leq(Someworld, World),
  base(Someworld, Prop).

forces(World, and(Left, Right)) :-
  forces(World, Left),
  forces(World, Right).

forces(World, or(Left, _right)) :- forces(World, Left).
forces(World, or(_left, Right)) :- forces(World, Right).

% A -> B holds at World when no future world has A without B.
forces(World, implies(Left, Right)) :-
  world(World),
  \+ bad_implication(World, Left, Right).

forces(World, neg(Formula)) :-
  forces(World, implies(Formula, bottom)).

bad_implication(World, Left, Right) :-
  leq(World, Future),
  forces(Future, Left),
  \+ forces(Future, Right).

intuitionistic_truth(monotone_p_reaches_both, both, atom(p)) :-
  forces(both, atom(p)).

intuitionistic_truth(constructive_case_analysis, root, implies(atom(p), or(atom(p), atom(q)))) :-
  forces(root, implies(atom(p), or(atom(p), atom(q)))).

intuitionistic_truth(double_negated_branch_information, root, neg(neg(or(atom(p), atom(q))))) :-
  forces(root, neg(neg(or(atom(p), atom(q))))).

intuitionistic_countermodel(root_does_not_decide_branch, root, or(atom(p), atom(q))) :-
  \+ forces(root, or(atom(p), atom(q))).

intuitionistic_countermodel(excluded_middle_not_forced, root, or(atom(p), neg(atom(p)))) :-
  \+ forces(root, or(atom(p), neg(atom(p)))).
