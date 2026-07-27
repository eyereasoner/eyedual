% Herbrand terms denote themselves: distinct names and constructor applications
% remain distinct without extra unique-name or free-constructor axioms.

% Output declaration: query/1 selects the relation written to this
% example's golden output.
query(different(X0, X1)).

% Under unrestricted Tarskian semantics, alice and bob could denote the same
% element. In Eyepl's Herbrand universe, their different syntax is enough.
different(alice, bob) :-
  (alice \= bob).

% A general Tarskian function need not be injective. Herbrand compound terms
% are free constructors, so different arguments produce different terms.
different(ticket(alice), ticket(bob)) :-
  (ticket(alice) \= ticket(bob)).
