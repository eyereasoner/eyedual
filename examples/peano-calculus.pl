% Peano addition, multiplication, and factorial over explicit Herbrand terms.
%
% The original logic-programming example uses `0` and `s(...)`.  Here zero is
% the atom `z`, so every natural number is an ordinary EyeProlog term: z, s(z),
% s(s(z)), and so on.  The rules are relational; the query answers choose
% a few finite calculations as readable examples.

%% goal: peano_answer(X0, X1)


% Addition.
padd(A, z, A).
padd(A, s(B), s(C)) :-
  padd(A, B, C).

% Multiplication by repeated addition.
pmul(_a, z, z).
pmul(A, s(B), C) :-
  pmul(A, B, D),
  padd(A, D, C).

% Factorial with an accumulator.
pfact(N, Value) :-
  pfac(N, s(z), Value).

pfac(z, Acc, Acc).
pfac(s(N), Acc, Value) :-
  pmul(Acc, s(N), Next),
  pfac(N, Next, Value).

peano_answer(two_plus_three, N) :-
  padd(s(s(z)), s(s(s(z))), N).

peano_answer(two_times_three, N) :-
  pmul(s(s(z)), s(s(s(z))), N).

peano_answer(factorial_four, N) :-
  pfact(s(s(s(s(z)))), N).
