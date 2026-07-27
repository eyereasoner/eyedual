% From The Art of Eyepl, Chapter 2 — Unification.
same_shape(Pair) :- (Pair = pair(X, X)).

query(same_shape(pair(red, red))).
query(same_shape(pair(red, blue))).
