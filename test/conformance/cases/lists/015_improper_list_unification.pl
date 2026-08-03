% Reference 5.4: improper list surface syntax unifies with head-tail structure.
cell([head | tail], head, tail).
answer(list, L) :- cell(L, head, tail).
answer(head, H) :- cell([H | tail], H, tail).
answer(tail, T) :- cell([head | T], head, T).
%% goal: answer(X0, X1)

