% Reference 5.5, 7: parenthesized comma terms with more than two members are conjunctions as goals.
p(a).
q(a).
r(a).
ok(X) :- (p(X), q(X), r(X)).
answer(ok, X) :- ok(X).
%% goal: answer(X0, X1)

