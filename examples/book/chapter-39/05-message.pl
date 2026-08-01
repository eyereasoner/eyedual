% From The Art of Eyepl, Chapter 39.
message(event_17,
        (severity(high), source(sensor_3), reading(temp, 91))).

context_member((Left, _right), Member) :- context_member(Left, Member).
context_member((_left, Right), Member) :- context_member(Right, Member).
context_member(Member, Member) :- Member \= (_left, _right).

context_parts(Context, Name, Args) :-
  context_member(Context, Member),
  (Member =.. [Name | Args]),
  atom(Name).

answer(field(Name, Args)) :-
  message(event_17, Context),
  context_parts(Context, Name, Args).

query(answer(X)).
