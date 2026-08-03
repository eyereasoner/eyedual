% Eyelet-inspired Dijkstra example using findall/3 and sort/2.
% The priority queue is represented as sorted list entries [Cost, Node | Path].
% Each expansion collects unvisited neighbors with findall/3, appends them to
% the frontier, and uses sort/2 so the cheapest frontier entry is processed next.

%% goal: shortestPath(X0, X1)

%% goal: cost(X0, X1)

%% goal: reason(X0, X1)


% Weighted undirected graph; the symmetric edge rule below adds reverse arcs.
edge(a, b, 4).
edge(a, c, 2).
edge(b, c, 1).
edge(b, d, 5).
edge(c, d, 8).
edge(c, e, 10).
edge(d, e, 2).
edge(d, f, 6).
edge(e, f, 3).
edge(A, B, Cost) :- edge(B, A, Cost).

% The frontier is represented as [Cost, Node | ReversePath] entries.
dijkstra(Start, Goal, Path, Cost) :-
  dijkstra_queue([[0, Start]], Goal, [], Revpath, Cost),
  reverse(Revpath, Path).

dijkstra_queue([[Cost, Goal | Path] | _queue], Goal, _visited, [Goal | Path], Cost).
dijkstra_queue([[Cost, Node | Path] | Queue], Goal, Visited, Resultpath, Resultcost) :-
  % Expand all unvisited neighbors, then sort so the cheapest frontier wins.
  findall([Newcost, Neighbor, Node | Path],
    (edge(Node, Neighbor, Weight), \+ member(Neighbor, Visited), (Newcost is Cost + Weight)),
    Neighbors),
  append(Queue, Neighbors, Newqueue),
  sort(Newqueue, Sortedqueue),
  dijkstra_queue(Sortedqueue, Goal, [Node | Visited], Resultpath, Resultcost).

shortestPath(dijkstra_findall_sort, Path) :-
  once(dijkstra(a, f, Path, _cost)).

cost(dijkstra_findall_sort, Cost) :-
  once(dijkstra(a, f, _path, Cost)).

reason(dijkstra_findall_sort, "frontier candidates are collected with findall and ordered with sort").
