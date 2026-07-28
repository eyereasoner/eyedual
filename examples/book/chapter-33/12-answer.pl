% From The Art of Eyepl, Chapter 33 — B.3.1 Numeric, comparison, and date predicates.
answer(square, S) :- (S is 12 * 12).
answer(day_count, N) :- between(3, 5, N).
answer(age, D) :- difference("2026-07-28", "2020-05-20", D).
query(answer(Kind, Value)).
