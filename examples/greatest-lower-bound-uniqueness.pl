% Order-theory proof sketch: greatest lower bounds are unique.
%
% Two candidate GLBs are asserted for the same pair.  The rules derive that
% each must be below the other, then use antisymmetry-style sameTerm/2 reasoning
% to report that the candidates denote the same lower bound.
%% goal: sameGreatestLowerBound(X0, X1, X2, X3)


% Adapted from Eyeling greatest-lower-bound-uniqueness.n3.  The named facts
% intentionally use two different symbols, g1 and g2, so the final output shows
% the equality-style conclusion as an explicit derived relation.

glbOf(g1, a, b).
glbOf(g2, a, b).

% leq/2 captures the defining property of a GLB: every lower bound is below it.
lowerBoundOf(M, A, B) :- glbOf(M, A, B).

leq(L, M) :-
  glbOf(M, A, B),
  lowerBoundOf(L, A, B).

sameTerm(M, N) :-
  leq(M, N),
  leq(N, M).

sameGreatestLowerBound(A, B, M, N) :-
  glbOf(M, A, B),
  glbOf(N, A, B),
  sameTerm(M, N),
  (M \= N).
