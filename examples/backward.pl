% Backward-rule example adapted from Eyeling backward.n3.
% Eyeling writes the interestingness rule in a backward style; eyeprolog records
% the same dependency as an ordinary Horn rule.  The example is intentionally
% tiny: it demonstrates that a derived fact can be justified by a numeric
% comparison in the rule body.

%% goal: isIndeedMoreInterestingThan(X0, X1)


moreInterestingThan(X, Y) :- (X > Y).

isIndeedMoreInterestingThan(5, 3) :- moreInterestingThan(5, 3).
