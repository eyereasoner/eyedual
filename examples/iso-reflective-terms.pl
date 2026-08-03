% ISO term inspection, construction, copying, and standard ordering.
%
% These operations are useful when a program manipulates syntax trees,
% schemas, or other terms whose shape is not fixed in the calling clause.
%% goal: report(X0, X1)


sample(event(sensor_7, reading(temperature, 21))).

report(shape, shape(Name, Arity)) :-
  sample(Term),
  functor(Term, Name, Arity).

report(payload, Payload) :-
  sample(Term),
  arg(2, Term, Payload).

report(parts, Parts) :-
  sample(Term),
  (Term =.. Parts).

report(rebuilt, Term) :-
  (Term =.. [alert, sensor_7, high]).

report(variable_count, Count) :-
  term_variables(rule(X, pair(X, Y), Z), Variables),
  Variables = [_, _, _],
  Count = 3.

report(copied_shape, same_but_fresh) :-
  copy_term(pair(X, X), pair(A, B)),
  A == B,
  X \== A.

report(order, Order) :-
  compare(Order, alpha, beta).
