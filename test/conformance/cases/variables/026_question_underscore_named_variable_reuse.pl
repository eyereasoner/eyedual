% Reference 3.4, 5.1: `_name` variables are named variables; only exactly `_` is anonymous.
pair(a, a).
pair(a, b).
answer(shared, _value) :- pair(_value, _value).
%% goal: answer(X0, X1)

