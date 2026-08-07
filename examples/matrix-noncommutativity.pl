% Matrix multiplication and non-commutativity.
%
% The original matrix example contains a larger matrix library.  This compact
% EyeProlog case keeps the core operation visible: multiply two 2x2 matrices and
% show that, in general, A*B is not the same matrix as B*A.

%% goal: matrix_result(X0, X1)


matrix_a([[1, 2], [0, 1]]).
matrix_b([[1, 0], [3, 1]]).

dot2([X1, X2], [Y1, Y2], R) :-
  (P1 is X1 * Y1),
  (P2 is X2 * Y2),
  (R is P1 + P2).

transpose2([[A, B], [C, D]], [[A, C], [B, D]]).

row_times_matrix(Row, Matrix, [R1, R2]) :-
  transpose2(Matrix, [Col1, Col2]),
  dot2(Row, Col1, R1),
  dot2(Row, Col2, R2).

matrix_mul([Row1, Row2], Matrix, [Out1, Out2]) :-
  row_times_matrix(Row1, Matrix, Out1),
  row_times_matrix(Row2, Matrix, Out2).

matrix_result(ab, Ab) :-
  matrix_a(A),
  matrix_b(B),
  matrix_mul(A, B, Ab).

matrix_result(ba, Ba) :-
  matrix_a(A),
  matrix_b(B),
  matrix_mul(B, A, Ba).

matrix_result(commutative, false) :-
  matrix_a(A),
  matrix_b(B),
  matrix_mul(A, B, Ab),
  matrix_mul(B, A, Ba),
  (Ab \= Ba).
