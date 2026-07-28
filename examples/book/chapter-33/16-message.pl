% From The Art of Eyepl, Chapter 33 — B.3.5 Context and compound-term helpers.
message(event_17,
        (severity(high), source(sensor_3), reading(temp, 91))).

answer(field(Name, Args)) :-
  message(event_17, Context),
  holds(Context, Name, Args).

query(answer(X)).
