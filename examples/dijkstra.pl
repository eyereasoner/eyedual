% Weighted path enumeration adapted from Eyeling dijkstra.n3.
%
% The Eyeling source uses collect/sort built-ins for Dijkstra's queue.  This
% eyepl variant enumerates simple paths, keeps the bounded frontier shown in
% the Eyeling output for a -> f, and scopes the graph inside a quoted term so the
% route network is not asserted as ambient edge facts.

% Output declarations: query/1 selects the relations written to this example's golden output.
query(edge(X0, X1)).
query(path(X0, X1)).

% The weighted graph stays inside weighted_graph/2; base_link/3 projects only
% the scoped edges needed by this example before the undirected link/3 view is built.
weighted_graph(dijkstraGraph, (
  edge(a, arc(b, 4)),
  edge(a, arc(c, 2)),
  edge(b, arc(c, 1)),
  edge(b, arc(d, 5)),
  edge(c, arc(d, 8)),
  edge(c, arc(e, 10)),
  edge(d, arc(e, 2)),
  edge(d, arc(f, 6)),
  edge(e, arc(f, 3))
)).

% path/5 carries both the visited list and accumulated cost, so the search
% enumerates simple weighted routes without asserting intermediate route facts.
base_link(A, B, Cost) :-
  weighted_graph(dijkstraGraph, Context),
  holds(Context, edge(A, arc(B, Cost))).

% Build an undirected view from directed base edges.
link(A, B, Cost) :- base_link(A, B, Cost).
link(B, A, Cost) :- base_link(A, B, Cost).

path(Goal, Goal, _visited, [Goal], 0).
path(Node, Goal, Visited, [Node|Path], Cost) :-
  link(Node, Next, Stepcost),
  not_member(Next, Visited),
  path(Next, Goal, [Next|Visited], Path, Restcost),
  (Cost is Stepcost + Restcost).

% Derived reverse links, mirroring the rule output in the Eyeling example.
edge([B, A], Cost) :-
  base_link(A, B, Cost).

% Only paths within the displayed cost bound are queried.
path([a, f], [Path, Cost]) :-
  path(a, f, [a], Path, Cost),
  (Cost =< 16).
