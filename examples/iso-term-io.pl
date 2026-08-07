% ISO text streams and term I/O.
%
% The initialization goal writes two Prolog terms to a temporary file. Queries
% reopen it, read terms in order, inspect variable metadata, and close the
% stream explicitly. The path is under /tmp so the source tree is unchanged.
:- initialization(write_fixture).

%% goal: report(X0, X1)


fixture_path('/tmp/eyeprolog-iso-term-io-example.pl').

write_fixture :-
  fixture_path(Path),
  open(Path, write, Stream, [type(text)]),
  write_canonical(Stream, event(sensor_7, online)),
  put_char(Stream, '.'),
  nl(Stream),
  write(Stream, rule(X, X, Y)),
  put_char(Stream, '.'),
  nl(Stream),
  close(Stream).

report(first_term, Term) :-
  fixture_path(Path),
  open(Path, read, Stream, []),
  read(Stream, Term),
  close(Stream).

report(variable_metadata, checked) :-
  fixture_path(Path),
  open(Path, read, Stream, []),
  read(Stream, _),
  read_term(Stream, rule(A, A, B), [
    variables([A, B]),
    variable_names([NameA=A, NameB=B]),
    singletons([NameB=B])
  ]),
  atom(NameA),
  atom(NameB),
  NameA \== NameB,
  close(Stream).

report(reached_end, yes) :-
  fixture_path(Path),
  open(Path, read, Stream, [eof_action(eof_code)]),
  read(Stream, _),
  read(Stream, _),
  read(Stream, end_of_file),
  at_end_of_stream(Stream),
  close(Stream).
