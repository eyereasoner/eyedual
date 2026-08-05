% A deterministic 9x9 Sudoku solver.
%
% Zero marks an empty cell. The solver first takes any forced move; otherwise
% it selects the cell with the fewest candidates (minimum remaining values).
%% goal: sudoku_solution(_)

puzzle([
  [0,3,4,6,7,8,9,1,0],
  [6,0,2,1,9,5,3,0,8],
  [1,9,0,3,4,2,0,6,7],
  [8,5,9,0,6,1,4,0,3],
  [4,2,6,8,0,3,7,9,0],
  [0,1,3,9,2,0,8,5,6],
  [9,6,0,5,3,7,0,8,4],
  [2,0,7,4,1,9,6,0,5],
  [0,4,5,2,8,6,1,7,0]
]).

sudoku_solution(Solution) :-
  puzzle(Puzzle),
  solve(Puzzle, Solution),
  !.

solve(Grid, Grid) :-
  \+ empty_cell(Grid, _Row, _Column),
  !.
solve(Grid, Solution) :-
  best_choice(Grid, Row, Column, Candidates),
  member(Digit, Candidates),
  set_cell(Grid, Row, Column, Digit, Next),
  solve(Next, Solution).

% A singleton candidate is already optimal, so take it immediately.
best_choice(Grid, Row, Column, Candidates) :-
  empty_cell(Grid, Row, Column),
  candidates(Grid, Row, Column, Candidates),
  Candidates = [_Only],
  !.
best_choice(Grid, Row, Column, Candidates) :-
  findall(
    choice(Count, R, C, Values),
    (
      empty_cell(Grid, R, C),
      candidates(Grid, R, C, Values),
      length(Values, Count)
    ),
    Choices
  ),
  sort(Choices, [choice(_Count, Row, Column, Candidates)|_]).

empty_cell(Grid, Row, Column) :-
  between(0, 8, Row),
  nth0(Row, Grid, Cells),
  between(0, 8, Column),
  nth0(Column, Cells, 0).

candidates(Grid, Row, Column, Candidates) :-
  findall(
    Digit,
    (
      between(1, 9, Digit),
      allowed(Grid, Row, Column, Digit)
    ),
    Candidates
  ).

allowed(Grid, Row, Column, Digit) :-
  row_unused(Grid, Row, Digit),
  column_unused(Grid, Column, Digit),
  block_unused(Grid, Row, Column, Digit).

row_unused(Grid, Row, Digit) :-
  nth0(Row, Grid, Cells),
  \+ member(Digit, Cells).

column_unused([], _Column, _Digit).
column_unused([Row|Rows], Column, Digit) :-
  nth0(Column, Row, Existing),
  Digit \= Existing,
  column_unused(Rows, Column, Digit).

block_unused(Grid, Row, Column, Digit) :-
  StartRow is (Row // 3) * 3,
  EndRow is StartRow + 2,
  StartColumn is (Column // 3) * 3,
  block_rows_unused(Grid, StartRow, EndRow, StartColumn, Digit).

block_rows_unused(_Grid, Row, EndRow, _StartColumn, _Digit) :-
  Row > EndRow,
  !.
block_rows_unused(Grid, Row, EndRow, StartColumn, Digit) :-
  nth0(Row, Grid, Cells),
  segment_unused(Cells, StartColumn, Digit),
  NextRow is Row + 1,
  block_rows_unused(Grid, NextRow, EndRow, StartColumn, Digit).

segment_unused(Cells, StartColumn, Digit) :-
  nth0(StartColumn, Cells, A),
  Middle is StartColumn + 1,
  nth0(Middle, Cells, B),
  End is StartColumn + 2,
  nth0(End, Cells, C),
  Digit \= A,
  Digit \= B,
  Digit \= C.

set_cell(Grid, Row, Column, Digit, Result) :-
  nth0(Row, Grid, Cells),
  set_nth0(Column, Cells, Digit, UpdatedCells),
  set_nth0(Row, Grid, UpdatedCells, Result).
