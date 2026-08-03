% Cyclic transitive closure.
%
% The graph deliberately contains the directed cycle a -> b -> c -> d -> a.  The
% recursive path/2 rule therefore has to deal with cycles while still deriving
% the reachable pairs used by the golden output.
%
% This is a compact regression-style example for active-goal handling in recursive
% graph search.

%% goal: path(X0, X1)


arc(a, b).
arc(b, c).
arc(c, d).
arc(d, a).

path(X, Y) :- arc(X, Y).
path(X, Z) :- arc(X, Y), path(Y, Z).
