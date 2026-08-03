% Eyelet-inspired Eulerian path example using findall/3 and sort/2.
%
% The graph is undirected; edges have identifiers so the trail consumes each
% physical edge exactly once even when vertices are revisited.  The remaining
% edge-id list is the explicit search state.
%% goal: oddVertices(X0, X1)

%% goal: path(X0, X1)

%% goal: edgeCount(X0, X1)

%% goal: reason(X0, X1)


% Edge identifiers are part of the search state: the DFS removes ids, not just
% endpoints, so repeated vertex visits do not accidentally reuse an edge.
edge(e12, v1, v2).
edge(e13, v1, v3).
edge(e15, v1, v5).
edge(e16, v1, v6).
edge(e23, v2, v3).
edge(e24, v2, v4).
edge(e26, v2, v6).
edge(e34, v3, v4).
edge(e36, v3, v6).
edge(e45, v4, v5).
edge(e46, v4, v6).

% Degree parity is computed with findall/3.  The Eulerian-start rule then chooses
% an odd-degree vertex when exactly two exist, or any vertex for an Eulerian cycle.
vertex(V) :- edge(_e, V, _u).
vertex(V) :- edge(_e, _u, V).

incident(V, E) :- edge(E, V, _u).
incident(V, E) :- edge(E, _u, V).

adjacent_by_edge(V, U, E) :- edge(E, V, U).
adjacent_by_edge(V, U, E) :- edge(E, U, V).

select(Item, [Item | Rest], Rest).
select(Item, [Head | Tail], [Head | Rest]) :-
  select(Item, Tail, Rest).

% Eulerian paths start at an odd-degree vertex when exactly two exist.
odd_degree(V) :-
  findall(E, incident(V, E), Edges),
  length(Edges, Degree),
  (1 is Degree mod 2).

odd_vertices(Odds) :-
  findall(V, odd_degree(V), Raw),
  sort(Raw, Odds).

all_edges(Edges) :-
  findall(E, edge(E, _a, _b), Raw),
  sort(Raw, Edges).

vertices(Vertices) :-
  findall(V, vertex(V), Raw),
  sort(Raw, Vertices).

eulerian_start(Start) :-
  odd_vertices([Start, _end]).
eulerian_start(Start) :-
  odd_vertices([]),
  vertices([Start | _rest]).

eulerian_path(Path) :-
  eulerian_start(Start),
  all_edges(Edges),
  dfs_euler(Start, [Start], Edges, Reversedpath),
  reverse(Reversedpath, Path).

% Depth-first search consumes the remaining edge-id list one edge at a time.
dfs_euler(_current, Path, [], Path).
dfs_euler(Current, Visited, Remaining, Path) :-
  adjacent_by_edge(Current, Next, Edge),
  select(Edge, Remaining, Newremaining),
  dfs_euler(Next, [Next | Visited], Newremaining, Path).

oddVertices(eulerian_path_case, Odds) :-
  odd_vertices(Odds).

path(eulerian_path_case, Path) :-
  once(eulerian_path(Path)).

edgeCount(eulerian_path_case, Count) :-
  all_edges(Edges),
  length(Edges, Count).

reason(eulerian_path_case, "findall collects graph structure and sort canonicalizes vertices and edges").
