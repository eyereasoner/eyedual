% Proof by contrapositive example adapted from Eyelet input/proof-by-contrapositive.pl.
%
% The implication itself is represented as data with implies/2.  The proof
% rule remains ordinary eyeprolog: if A implies B and B is false, then A is false.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: refutes(X0, X1)

%% goal: method(X0, X1)

%% goal: reason(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
implies(raining, wet_ground).
false(wet_ground).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
false(A) :-
  implies(A, B),
  false(B).

refutes(proof1, raining) :-
  false(raining).

method(proof1, contrapositive) :-
  false(raining).

reason(proof1, "if rain implies wet ground and the ground is not wet, then it is not raining") :-
  false(raining).
