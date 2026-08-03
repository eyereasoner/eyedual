% Group inverse uniqueness, adapted from Eyeling's examples/group-inverse-uniqueness.n3.
%
% The output mirrors the Eyeling golden result shape:
% sameInverse(x, i, j) and sameInverse(x, j, i).

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: sameInverse(X0, X1, X2)


% The group table is deliberately tiny: e is the identity, and i and j are
% two names that both behave as the inverse of x.
element(e).
element(x).
element(i).
element(j).

% leftInverse/2 and rightInverse/2 are proved from op/3.  sameInverse/3
% then derives uniqueness by combining both inverse directions with sameTerm/2.
op(e, X, X) :- element(X).
op(X, e, X) :- element(X).
op(i, x, e).
op(x, j, e).
op(j, x, e).
op(x, i, e).

sameTerm(X, X) :- element(X).
sameTerm(i, j).
sameTerm(j, i).

leftInverse(A, B) :- op(B, A, e).
rightInverse(A, B) :- op(A, B, e).

sameInverse(A, B, C) :-
  leftInverse(A, B),
  rightInverse(A, C),
  sameTerm(B, C),
  (B \= C).
