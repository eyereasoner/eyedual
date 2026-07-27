% Reference 9.1: aggregation handles empty result sets, structured templates, and ordered best answers.
query(answer(X0, X1)).
score(alice, 2).
score(bob, 1).
score(cara, 3).
answer(findall_empty, X) :- findall(V, missing(V), X).
answer(count_filtered, X) :- countall((score(Name, Score), (Score > 1)), X).
answer(sum_empty, X) :- sumall(V, missing(V), X).
answer(sum_scores, X) :- sumall(Score, score(Name, Score), X).
answer(best_min, pair(Key, Value)) :- aggregate_min(Score, Name, score(Name, Score), Key, Value).
answer(best_max, pair(Key, Value)) :- aggregate_max(Score, Name, score(Name, Score), Key, Value).
answer(best_empty_rejected, ok) :- \+ aggregate_min(Key, Value, missing(Value), Key, Value).
