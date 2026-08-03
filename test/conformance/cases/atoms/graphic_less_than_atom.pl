% A lone graphic < remains a graphic atom, not an IRI opener.
%% goal: answer(X0)

seed(<).
answer(X) :- seed(X).
