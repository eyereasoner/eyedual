% Reference 9.8: aggregation copies resolved structured templates from inner goals.
query(answer(X0, X1)).
score(alice, math, 9).
score(alice, logic, 7).
score(bob, math, 5).
score(bob, logic, 8).
answer(all_pairs, X) :- findall(result(Name, Subject, Score), score(Name, Subject, Score), X).
answer(count_high, X) :- countall((score(Name, Subject, Score), (Score >= 8)), X).
answer(sum_alice, X) :- sumall(Score, score(alice, Subject, Score), X).
answer(best_score, pair(Key, Value)) :- aggregate_max(Score, result(Name, Subject), score(Name, Subject, Score), Key, Value).
answer(lowest_pair, pair(Key, Value)) :- aggregate_min([Score, Name], Subject, score(Name, Subject, Score), Key, Value).
