% Compact 4x4 Sudoku search with row permutations and column/box constraints.
%
% The givens are baked into row1/1 ... row4/1, so each candidate row is already
% a permutation of 1..4.  sudoku_solution/1 then checks the remaining columns
% and 2x2 boxes, which keeps the example clear and playground-friendly.
%% goal: sudoku_answer(X0, X1)


perm([], []).
perm(Items, [X|Rest]) :-
  select(X, Items, Remaining),
  perm(Remaining, Rest).

% distinct/1 is the reusable all-different constraint.
distinct([]).
distinct([X|Xs]) :-
  not_member(X, Xs),
  distinct(Xs).

row1([1, B, C, 4]) :- perm([1, 2, 3, 4], [1, B, C, 4]).
row2([A, 4, 1, D]) :- perm([1, 2, 3, 4], [A, 4, 1, D]).
row3([B, 1, 4, C]) :- perm([1, 2, 3, 4], [B, 1, 4, C]).
row4([4, C, B, 1]) :- perm([1, 2, 3, 4], [4, C, B, 1]).

column([R1, R2, R3, R4], Index, [A, B, C, D]) :-
  nth0(Index, R1, A),
  nth0(Index, R2, B),
  nth0(Index, R3, C),
  nth0(Index, R4, D).

% The four boxes are extracted as lists, then passed through distinct/1.
boxes([R1, R2, R3, R4], [Box1, Box2, Box3, Box4]) :-
  nth0(0, R1, A), nth0(1, R1, B), nth0(0, R2, C), nth0(1, R2, D),
  (Box1 = [A, B, C, D]),
  nth0(2, R1, E), nth0(3, R1, F), nth0(2, R2, G), nth0(3, R2, H),
  (Box2 = [E, F, G, H]),
  nth0(0, R3, I), nth0(1, R3, J), nth0(0, R4, K), nth0(1, R4, L),
  (Box3 = [I, J, K, L]),
  nth0(2, R3, M), nth0(3, R3, N), nth0(2, R4, O), nth0(3, R4, P),
  (Box4 = [M, N, O, P]).

sudoku_solution([R1, R2, R3, R4]) :-
  row1(R1),
  row2(R2),
  row3(R3),
  row4(R4),
  column([R1, R2, R3, R4], 0, C0), distinct(C0),
  column([R1, R2, R3, R4], 1, C1), distinct(C1),
  column([R1, R2, R3, R4], 2, C2), distinct(C2),
  column([R1, R2, R3, R4], 3, C3), distinct(C3),
  boxes([R1, R2, R3, R4], [B1, B2, B3, B4]),
  distinct(B1), distinct(B2), distinct(B3), distinct(B4).

sudoku_answer(solution, Grid) :- once(sudoku_solution(Grid)).
sudoku_answer(solution_count, Count) :- countall(sudoku_solution(_grid), Count).
