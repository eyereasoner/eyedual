% Gray-code counter adapted from Eyeling gray-code-counter.n3.
% Boolean gates are represented as truth-table facts.  The circuit rules compose
% those gates into next-state logic for three flip-flops, and testgcc/3 runs the
% counter over a finite clock sequence.

%% goal: isgcc(X0, X1)


% Boolean gates are truth tables; the circuit rules compose them.
and(0, 0, 0). and(0, 1, 0). and(1, 0, 0). and(1, 1, 1).
or(0, 0, 0).  or(0, 1, 1).  or(1, 0, 1).  or(1, 1, 1).
inv(0, 1). inv(1, 0).

dff(D, 0, Q, Q).
dff(D, 1, _q, D).

neta(A, B, Q) :-
  and(A, B, T1),
  inv(A, Na),
  inv(B, Nb),
  and(Na, Nb, T2),
  or(T1, T2, Q).

netb(A, B, C, Q1, Q2) :-
  and(A, C, T1),
  inv(C, Nc),
  and(B, Nc, T2),
  inv(A, Na),
  and(Na, C, T3),
  or(T1, T2, Q1),
  or(T2, T3, Q2).

% One clock step computes D inputs, then updates the three flip-flops.
gcc(C, [Qa, Qb, Qc], [Za, Zb, Zc]) :-
  netb(Qa, Qb, Qc, D1, D2),
  neta(Qa, Qb, D3),
  dff(D1, C, Qa, Za),
  dff(D2, C, Qb, Zb),
  dff(D3, C, Qc, Zc).

% testgcc/3 runs the circuit over a list of clock inputs.
testgcc([], _state, []).
testgcc([C|Cs], State, [Next|Rest]) :-
  gcc(C, State, Next),
  testgcc(Cs, Next, Rest).

isgcc([[1, 1, 1, 1, 1, 1, 1, 1, 1], [0, 0, 0]], States) :-
  testgcc([1, 1, 1, 1, 1, 1, 1, 1, 1], [0, 0, 0], States).
