% From The Art of Eyepl, Chapter 36.
:- dynamic(task/2).

prepare_queue :-
  asserta(task(check_power, urgent)),
  assertz(task(check_network, normal)).
