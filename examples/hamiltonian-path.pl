% Hamiltonian path, adapted from Eyelet's input/hamiltonian-path.pl.
%
% The graph is the same six-vertex undirected graph.  eyedual spells the finite
% vertex set directly and derives every path that visits each vertex exactly
% once.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: hasHamiltonianPath(X0, X1)

%% goal: hamiltonianPath(X0, X1)


% The finite six-vertex graph is small enough to search directly.  adjacent/2
% is tabled because every candidate path repeatedly asks the same edge tests.

edge(v1, v2).
edge(v1, v3).
edge(v1, v5).
edge(v1, v6).
edge(v2, v3).
edge(v2, v4).
edge(v2, v6).
edge(v3, v4).
edge(v3, v6).
edge(v4, v5).
edge(v4, v6).

% hamiltonian_path/1 is intentionally unrolled to six positions: each next
% vertex must be adjacent to the previous one and absent from the prefix.
adjacent(V, U) :- edge(V, U).
adjacent(V, U) :- edge(U, V).

vertex(v1).
vertex(v2).
vertex(v3).
vertex(v4).
vertex(v5).
vertex(v6).

hamiltonian_path([A, B, C, D, E, F]) :-
  vertex(A),
  vertex(B), adjacent(A, B), not_member(B, [A]),
  vertex(C), adjacent(B, C), not_member(C, [A, B]),
  vertex(D), adjacent(C, D), not_member(D, [A, B, C]),
  vertex(E), adjacent(D, E), not_member(E, [A, B, C, D]),
  vertex(F), adjacent(E, F), not_member(F, [A, B, C, D, E]).

hasHamiltonianPath(graph, true) :-
  hamiltonian_path(_path).

hamiltonianPath(graph, Path) :-
  hamiltonian_path(Path).
