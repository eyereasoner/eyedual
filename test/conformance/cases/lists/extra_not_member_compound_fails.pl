%% goal: answer(X0)

answer(not_member_compound_fails) :- not_member(box(a), [box(a), box(b)]).
