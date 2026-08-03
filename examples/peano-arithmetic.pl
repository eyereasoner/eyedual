% Peano arithmetic port from EYE reasoning/peano.
%
% The EYE example defines add, multiply and factorial over Peano numerals.
% Its selected output computes (1 * 2 + 3)! and emits the factorial of 5.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: factorial(X0, X1)


% Numbers are represented only with 0 and successor terms s(...).  The final
% query constructs the Peano value for five through add and multiply.
peano_add(A, 0, A).
% peano_add/3, peano_multiply/3, and fac/3 are structurally recursive, so
% the proof mirrors the Peano definitions of arithmetic.
peano_add(A, s(B), s(C)) :-
  peano_add(A, B, C).

peano_multiply(_a, 0, 0).
peano_multiply(A, s(B), C) :-
  peano_multiply(A, B, D),
  peano_add(A, D, C).

factorial(A, B) :-
  fac(A, s(0), B).

fac(0, A, A).
fac(s(A), B, C) :-
  peano_multiply(B, s(A), D),
  fac(A, D, C).

factorial(B, C) :-
  peano_multiply(s(0), s(s(0)), A),
  peano_add(A, s(s(s(0))), B),
  factorial(B, C).
