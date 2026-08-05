% From The Art of EyeLang, Chapter 9.
message(event_17, (severity(high), source(sensor_3), reading(temp, 91))).

context_member((Left, _right), Member) :- context_member(Left, Member).
context_member((_left, Right), Member) :- context_member(Right, Member).
context_member(Member, Member) :- Member \= (_left, _right).

hot_event(Id) :-
  message(Id, Context),
  context_member(Context, severity(high)),
  context_member(Context, reading(temp, Value)),
  (Value > 80).
