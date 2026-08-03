%% goal: answer(X0, X1)

answer(select_structured_duplicate, Rest) :- select(box(a), [box(a), box(b), box(a)], Rest).
