% Newton-Raphson root finding, adapted from Eyelet input/newton-raphson.pl.
% Each want_root/1 case names a function, starting point, and tolerance.  The
% recursive finder stops when |f(x)| is below tolerance; otherwise it applies
% x := x - f(x)/f'(x) using the corresponding derivative rule.

%% goal: findRoot(X0, X1)


want_root([1, 1.0, 1.0e-15]).
want_root([2, 2.0, 1.0e-15]).
want_root([3, 3.0, 1.0e-15]).

findRoot(Input, Root) :-
  want_root(Input),
  find_root(Input, Root).

% f(1, X) = X^2 - 2
f(1, X, Y) :-
  (Xx is X * X),
  (Y is Xx - 2).

% f(2, X) = log(X) - 1
f(2, X, Y) :-
  (Lx is log(X)),
  (Y is Lx - 1).

% f(3, X) = sin(X)
f(3, X, Y) :-
  (Y is sin(X)).

fd(1, X, Y) :-
  (Y is 2 * X).
fd(2, X, Y) :-
  (Y is 1 / X).
fd(3, X, Y) :-
  (Y is cos(X)).

find_root([N, X, Tolerance], X) :-
  f(N, X, Fx),
  (Afx is abs(Fx)),
  (Afx < Tolerance).
find_root([N, X, Tolerance], Root) :-
  f(N, X, Fx),
  (Afx is abs(Fx)),
  (Afx >= Tolerance),
  fd(N, X, Fdx),
  (Step is Fx / Fdx),
  (Newx is X - Step),
  find_root([N, Newx, Tolerance], Root).
