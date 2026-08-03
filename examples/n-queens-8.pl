% N-queens search for the 8x8 board.
%
% A solution is represented as a list of row numbers, one per column.  Using a
% permutation enforces one queen per row automatically; safe_rows/1 only has to
% reject diagonal attacks.
%% goal: n_queens_answer(X0, X1)


% Cache diagonal checks; the same row/distance/suffix states recur across many
% candidate permutations during the 8-queens search.  The example asks only for
% the first solution with once/1, keeping it playground-friendly.

perm([], []).
perm(Items, [X|Rest]) :-
  select(X, Items, Remaining),
  perm(Remaining, Rest).

safe_rows([]).
safe_rows([Row|Rest]) :-
  no_diagonal_attack(Row, 1, Rest),
  safe_rows(Rest).

no_diagonal_attack(_row, _distance, []).
no_diagonal_attack(Row, Distance, [Other|Rest]) :-
  (Delta is Row - Other),
  (Absdelta is abs(Delta)),
  (Absdelta \= Distance),
  (Nextdistance is Distance + 1),
  no_diagonal_attack(Row, Nextdistance, Rest).

queen_solution(Rows) :-
  perm([1, 2, 3, 4, 5, 6, 7, 8], Rows),
  safe_rows(Rows).

n_queens_answer(first_solution, Rows) :- once(queen_solution(Rows)).
