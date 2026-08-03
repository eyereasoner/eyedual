% Equality unifies, while inequality tests current
% non-unifiability and does not create a constraint or rewrite same_as/2.
%% goal: answer(X0)


same_as(alice, bob).

answer(reflexive) :- (ticket(alice) = ticket(alice)).
answer(symmetric_left) :- (a = "a").
answer(symmetric_right) :- ("a" = a).
answer(bound_inequality) :- (X = bob), (X \= alice).
answer(domain_equivalence_is_explicit) :-
  same_as(alice, bob),
  (alice \= bob).

% This must not succeed: X can still unify with alice.
answer(unbound_inequality) :- (X \= alice).
