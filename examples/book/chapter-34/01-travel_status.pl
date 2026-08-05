% From The Art of EyeLang, Chapter 34.
travel_status(From, To, Status) :-
  (route(From, To) -> Status = connected ; Status = disconnected).
