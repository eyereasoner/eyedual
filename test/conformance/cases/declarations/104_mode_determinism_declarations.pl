% Reference 11.3: mode/3 and det/2 or semidet/2 are ordinary facts and advisory declarations.
mode(path, 2, [in, out]).
det(path, 2).
semidet(edge, 2).
%% goal: answer(X0, X1)

edge(a, b).
path(X, Y) :- edge(X, Y).
answer(mode_path, Modes) :- mode(path, 2, Modes).
answer(det_path, ok) :- det(path, 2).
answer(semidet_edge, ok) :- semidet(edge, 2).
answer(path, Y) :- path(a, Y).
