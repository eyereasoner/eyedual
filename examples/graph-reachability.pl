% Graph reachability example adapted from Eyelet input/graph-reachability.pl.
% The recursive search carries a Visited list and rejects already-seen nodes with
% not(member(...)).  This keeps reachability finite and also lets the example
% derive explicit not_reachable/2 evidence for a negative test case.

%% goal: reachable(X0, X1)

%% goal: not_reachable(X0, X1)


edge(a, b).
edge(a, c).
edge(b, d).
edge(c, e).
edge(d, f).
edge(e, f).
edge(f, g).

reachable(Node, Node, _visited).
reachable(Start, Goal, Visited) :-
  edge(Start, Next),
  \+ member(Next, Visited),
  reachable(Next, Goal, [Next|Visited]).

is_reachable(Start, Goal) :-
  reachable(Start, Goal, [Start]).

reachable(reachability_case, path(a, f)) :-
  is_reachable(a, f).

reachable(reachability_case, path(c, g)) :-
  is_reachable(c, g).

not_reachable(reachability_case, path(b, e)) :-
  \+ is_reachable(b, e).
