% Ackermann-style hyperoperation benchmark adapted from Eyeling ackermann.n3.
% The public ackermann/2 answers are small, but the helper relation exercises
% deeply nested arithmetic recursion: hyper/4 encodes successor, addition,
% multiplication, exponentiation, and then the Ackermann-style offset
% ackermann(X, Y) = hyper(X, Y + 3, 2) - 3.
% Keeping the selected inputs explicit avoids unbounded generation while still
% testing the solver's recursive numeric workload.

%% goal: ackermann(X0, X1)


ackermann(X, Y, A) :-
  (B is Y + 3),
  hyper(X, B, 2, C),
  (A is C - 3).

% Successor, addition, multiplication, and exponentiation levels.
hyper(0, Y, _z, A) :- (A is Y + 1).
hyper(1, Y, Z, A) :- (A is Y + Z).
hyper(2, Y, Z, A) :- (A is Y * Z).
hyper(3, Y, Z, A) :- (A is Z ^ Y).

% Higher levels recurse over the previous hyperoperation.
hyper(X, 0, _z, 1) :- (X > 3).
hyper(X, Y, Z, A) :-
  (X > 3),
  (Y \= 0),
  (B is Y - 1),
  hyper(X, B, Z, C),
  (D is X - 1),
  hyper(D, C, Z, A).

ack_case(0, 0).
ack_case(0, 6).
ack_case(1, 2).
ack_case(1, 7).
ack_case(2, 2).
ack_case(2, 9).
ack_case(3, 4).
ack_case(3, 1000).
ack_case(4, 0).
ack_case(4, 1).
ack_case(4, 2).
ack_case(5, 0).

ackermann([X, Y], A) :-
  ack_case(X, Y),
  ackermann(X, Y, A).
