% From The Art of Eyepl, Chapter 34.
travel_status(From, To, Status) :-
  (route(From, To) -> Status = connected ; Status = disconnected).
