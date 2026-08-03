% ISO 8.15.2: false/0 always fails.
%% goal: answer(X)

answer(false_fails) :- \+ false.
answer(fail_fails) :- \+ fail.
