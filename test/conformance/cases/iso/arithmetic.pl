%% goal: answer(X0, X1, X2)

answer(Integer, Float, Modulo) :-
  Integer is 2 + 3 * 4,
  Float is sqrt(9) / 2,
  Modulo is -7 mod 3,
  Integer =:= 14,
  Float > 1.
