% Equality unifies, while inequality tests current
% non-unifiability and does not create a constraint or rewrite same_as/2.
query(answer(X0)).

same_as(alice, bob).

answer(reflexive) :- eq(ticket(alice), ticket(alice)).
answer(symmetric_left) :- eq(a, "a").
answer(symmetric_right) :- eq("a", a).
answer(bound_inequality) :- eq(X, bob), neq(X, alice).
answer(domain_equivalence_is_explicit) :-
  same_as(alice, bob),
  neq(alice, bob).

% This must not succeed: X can still unify with alice.
answer(unbound_inequality) :- neq(X, alice).
