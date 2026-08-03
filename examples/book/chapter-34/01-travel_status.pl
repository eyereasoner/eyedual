% From The Art of WebEntail, Chapter 34.
travel_status(From, To, Status) :-
  (route(From, To) -> Status = connected ; Status = disconnected).
