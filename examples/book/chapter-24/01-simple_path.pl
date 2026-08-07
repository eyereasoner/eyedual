% From The Art of EyeProlog, Chapter 24 — Search over states.
simple_path(From, To, Path) :-
  walk(From, To, [From], Reversed),
  reverse(Reversed, Path).

walk(To, To, Visited, Visited).
walk(From, To, Visited, Path) :-
  edge(From, Next),
  \+ member(Next, Visited),
  walk(Next, To, [Next | Visited], Path).
