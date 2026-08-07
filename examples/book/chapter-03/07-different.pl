% From The Art of EyeProlog, Chapter 3 — Why terms denote themselves.
different(alice, bob) :- (alice \= bob).
different(ticket(alice), ticket(bob)) :-
  (ticket(alice) \= ticket(bob)).
