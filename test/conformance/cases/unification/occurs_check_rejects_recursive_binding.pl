query(answer(occurs_check)).

answer(occurs_check) :-
  neq(X, wrapper(X)),
  eq(Y, wrapper(X)),
  neq(X, Y).
