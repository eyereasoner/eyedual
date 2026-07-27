% Allen interval calculus adapted from Eyeling allen-interval-calculus.n3.
% Eyeling demonstrates dateTime and duration built-ins; this eyepl version
% uses integer hour offsets so the interval rules remain pure Horn clauses.
% The input interval table is a list of records, showing how tabular data can
% stay scoped as one term instead of many unrelated global start/end facts.

% Output declarations: query/1 selects the relations written to this example's golden output.
query(start(X0, X1)).
query(end(X0, X1)).
query(duration(X0, X1)).
query(statement(X0, X1, X2)).

% Program structure: facts set up the scenario, and rules derive the queried conclusions.
interval_table([
  interval(a, 10, 12),
  interval(b, 13, 15),
  interval(c, 12, 14),
  interval(d, 11, 13),
  interval(e, 10, 12),
  interval(f, 10, 11),
  interval(g, 11, 12),
  interval(h, 9, 16),
  interval(i, 16, 18),
  interval(j, 15, 16),
  interval(k, 13, 14)
]).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
interval(I) :- interval_table(Table), member(interval(I, _start, _end), Table).
start(I, Start) :- interval_table(Table), member(interval(I, Start, _end), Table).
end(I, End) :- interval_table(Table), member(interval(I, _start, End), Table).

relation(I, before, J) :- end(I, Ei), start(J, Sj), (Ei < Sj).
relation(I, meets, J) :- end(I, E), start(J, E).
relation(I, overlaps, J) :-
  start(I, Si), end(I, Ei),
  start(J, Sj), end(J, Ej),
  (Si < Sj), (Sj < Ei), (Ei < Ej).
relation(I, starts, J) :-
  start(I, S), start(J, S),
  end(I, Ei), end(J, Ej),
  (Ei < Ej).
relation(I, during, J) :-
  start(I, Si), end(I, Ei),
  start(J, Sj), end(J, Ej),
  (Sj < Si), (Ei < Ej).
relation(I, finishes, J) :-
  end(I, E), end(J, E),
  start(I, Si), start(J, Sj),
  (Sj < Si).
relation(I, equals, J) :-
  start(I, S), start(J, S),
  end(I, E), end(J, E).

relation(J, after, I) :- relation(I, before, J).
relation(J, metBy, I) :- relation(I, meets, J).
relation(J, overlappedBy, I) :- relation(I, overlaps, J).
relation(J, startedBy, I) :- relation(I, starts, J).
relation(J, contains, I) :- relation(I, during, J).
relation(J, finishedBy, I) :- relation(I, finishes, J).

duration(I, D) :- end(I, E), start(I, S), (D is E - S).

statement(I, Rel, J) :- relation(I, Rel, J).
