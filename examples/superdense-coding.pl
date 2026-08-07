% Superdense coding using discrete quantum computing, adapted from
% Eyelet's input/superdense-coding.pl.
%
% The Eyelet program toggles dynamic sdcoding/2 facts so answers appearing an
% even number of times cancel. eyeprolog expresses the same finite example
% declaratively: for this protocol the surviving messages are exactly those
% with a single support path after the interference choices are expanded.

% |R) = |0, 0) + |1, 1)
% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: decodesAs(X0, X1)

%% goal: preservesMessage(X0, X1)

%% goal: cancelsCrossTalk(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
r(false, false).
r(true, true).

% ID |0) = |0), ID |1) = |1)
identity(false, false).
identity(true, true).

% G |0) = |1), G |1) = |0)
g(false, true).
g(true, false).

% K |0) = |0), K |1) = |0) + |1)
k(false, false).
k(true, false).
k(true, true).

% KG and GK compositions.
% Derivation rules: each rule below contributes one logical step toward the displayed results.
kg(X, Y) :-
  g(X, Z),
  k(Z, Y).

gk(X, Y) :-
  k(X, Z),
  g(Z, Y).

% Alice encodes two classical bits as one of four transformations.
alice(0, X, Y) :- identity(X, Y).
alice(1, X, Y) :- g(X, Y).
alice(2, X, Y) :- k(X, Y).
alice(3, X, Y) :- kg(X, Y).

% Bob decodes with the Bell-style measurement basis.
bob(X, Y, 0) :- gk(X, Y).
bob(X, Y, 1) :- k(X, Y).
bob(X, Y, 2) :- g(X, Y).
bob(X, Y, 3) :- identity(X, Y).

% One concrete support path through the entangled pair and the two transforms.
sdc_path(N, M, path(X, Y, B)) :-
  r(X, Y),
  alice(N, X, B),
  bob(B, Y, M).

% If another different support path gives the same answer, this answer cancels
% in pairs in the finite superdense-coding table.
duplicate_sdc_path(N, M, Proof) :-
  sdc_path(N, M, Proof),
  sdc_path(N, M, Other),
  (Proof \= Other).

sdcoding(N, M) :-
  sdc_path(N, M, Proof),
  \+ duplicate_sdc_path(N, M, Proof).

decodesAs(message(N), M) :-
  sdcoding(N, M).

preservesMessage(protocol, true) :-
  sdcoding(0, 0),
  sdcoding(1, 1),
  sdcoding(2, 2),
  sdcoding(3, 3).

cancelsCrossTalk(protocol, true) :-
  \+ sdcoding(0, 1),
  \+ sdcoding(1, 0),
  \+ sdcoding(2, 3),
  \+ sdcoding(3, 2).
