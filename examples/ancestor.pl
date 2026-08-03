% Basic recursive relation example.
% parent/2 facts form a small family chain.  ancestor/2 has the classic two-rule
% shape: one base rule copies direct parents, and one recursive rule walks one
% parent edge before continuing through the chain.  Both source and derived
% relations are queried so the output shows the closure explicitly.

%% goal: parent(X0, X1)

%% goal: ancestor(X0, X1)


% Direct parent facts form a simple chain.
parent(pat, jan).
parent(jan, lies).
parent(lies, emma).

% Base case: every parent is also an ancestor.
ancestor(X, Y) :-
  parent(X, Y).

% Recursive case: walk one parent edge and continue through the chain.
ancestor(X, Z) :-
  parent(X, Y),
  ancestor(Y, Z).
