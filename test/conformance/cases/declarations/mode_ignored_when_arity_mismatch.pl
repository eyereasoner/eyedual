% Invalid advisory mode length is ignored as metadata but remains a fact.
%% goal: answer(X0)

mode(edge, 2, [in]).
edge(a, b).
answer(ok) :- mode(edge, 2, [in]), edge(a, b).
