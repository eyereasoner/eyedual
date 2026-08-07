% From The Art of EyeProlog, Chapter 10.
plan(State, State, _, []).
plan(State, Goal, Seen, [Move | Moves]) :-
  transition(State, Move, Next),
  \+ member(Next, Seen),
  plan(Next, Goal, [Next | Seen], Moves).
