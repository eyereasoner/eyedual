%% goal: answer(X0)

answer(difference_invalid_date_fails) :- difference('2024-02-30', '2024-02-01', _).
