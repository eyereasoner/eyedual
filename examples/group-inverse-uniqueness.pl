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

% leftInverse/2 and rightInverse/2 are proved from group_op/3. sameInverse/3
% then derives uniqueness by combining both inverse directions with sameTerm/2.
group_op(e, X, X) :- element(X).
group_op(X, e, X) :- element(X).
group_op(i, x, e).
group_op(x, j, e).
group_op(j, x, e).
group_op(x, i, e).

sameTerm(X, X) :- element(X).
sameTerm(i, j).
sameTerm(j, i).

leftInverse(A, B) :- group_op(B, A, e).
rightInverse(A, B) :- group_op(A, B, e).

sameInverse(A, B, C) :-
  leftInverse(A, B),
  rightInverse(A, C),
  sameTerm(B, C),
  (B \= C).
