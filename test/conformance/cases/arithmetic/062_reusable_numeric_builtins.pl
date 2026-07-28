% Reference 9.1: reusable numeric functions and max/3.
query(answer(X0, X1)).
answer(max, X) :- max(17, 42, X).
answer(sqrt, X) :- (X is sqrt(81)).
answer(floor, X) :- (X is floor(3.9)).
answer(ceiling, X) :- (X is ceiling(3.1)).
answer(trunc, X) :- (X is truncate(-3.9)).
answer(exp, X) :- (X is exp(0)).
answer(tan, X) :- tan(0, X).
answer(atan2, X) :- atan2(0, -1, X).
