%% goal: answer(occurs_check)


answer(occurs_check) :-
  (X \= wrapper(X)),
  (Y = wrapper(X)),
  (X \= Y).
