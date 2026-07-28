% From The Art of Eyepl, Chapter 33 — B.3.4 Aggregation and bounded control.
cost(a, 8).
cost(b, 3).
cost(c, 3).

answer(count, N) :- countall(cost(_, _), N).
answer(best(Name), Cost) :-
  aggregate_min(CandidateCost, CandidateName,
                cost(CandidateName, CandidateCost),
                Cost, Name).

query(answer(Kind, Value)).
