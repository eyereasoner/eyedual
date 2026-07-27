% From The Art of Eyepl, Chapter 31 — Properties over finite domains.
double(N, D) :- (D is N + N).

double_is_even(N) :-
  double(N, D),
  (0 is D mod 2).

bounded_double_law :-
  forall(between(-100, 100, N), double_is_even(N)).

query(bounded_double_law).
