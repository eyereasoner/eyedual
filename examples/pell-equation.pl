% Pell equation x^2 - 2y^2 = 1 by automatically tabled recurrence.
%
% The fundamental solution (3,2) induces a linear recurrence for all positive
% solutions of x^2 - 2y^2 = 1.  The example querys later solutions and also
% rechecks the Diophantine identity so the generated sequence is auditable.
%% goal: pell_answer(X0, X1)



% N=0 is the neutral solution; each recursive step multiplies by 3 + 2*sqrt(2).
pell(0, 1, 0).
pell(N, X, Y) :-
  (N > 0),
  (N1 is N - 1),
  pell(N1, X0, Y0),
  (Ax is 3 * X0),
  (By is 4 * Y0),
  (X is Ax + By),
  (Cx is 2 * X0),
  (Dy is 3 * Y0),
  (Y is Cx + Dy).

% Verification is intentionally independent of the recurrence equations above.
pell_holds(N, true) :-
  pell(N, X, Y),
  (X2 is X * X),
  (Y2 is Y * Y),
  (Twicey2 is 2 * Y2),
  (1 is X2 - Twicey2).

pell_answer(solution_5, solution(X, Y)) :- pell(5, X, Y).
pell_answer(solution_8, solution(X, Y)) :- pell(8, X, Y).
pell_answer(check_8, true) :- pell_holds(8, true).
pell_answer(y_sum_1_to_8, Sum) :- sumall(Y, (between(1, 8, N), pell(N, _x, Y)), Sum).
