% Cat Koko, adapted from Eyeling's examples/cat-koko.n3.
%
% The Eyeling output contains two existential witnesses. eyepl has no blank
% node constructor in the portable core, so this adaptation names those
% witnesses sk_0 and sk_1.

% Output declarations: query/1 selects the relations written to this example's golden output.
query(type(X0, X1)).
query(holds_result(X0, X1)).

% Program structure: facts set up the scenario, and rules derive the queried conclusions.
animal(koko).

witness(cat, sk_0).
witness(british_short_hair, sk_1).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
type(X, cat) :- animal(koko), witness(cat, X).
type(X, british_short_hair) :- animal(koko), witness(british_short_hair, X).

holds_result(test, true) :-
  type(X, cat),
  type(Y, british_short_hair),
  (X \= Y).
