% ISO relations between atoms, character lists, character codes, and numbers.
%
% Conversion predicates work in both documented directions. sub_atom/5 also
% exposes how a source atom is split around a selected fragment.
%% goal: report(X0, X1)


report(joined, Atom) :-
  atom_concat(eye, prolog, Atom).

report(prefix, Prefix) :-
  atom_concat(Prefix, prolog, eyeprolog).

report(characters, Chars) :-
  atom_chars(eye, Chars).

report(codes, Codes) :-
  atom_codes('AZ', Codes).

report(decoded_character, Char) :-
  char_code(Char, 955).

report(number, Number) :-
  number_chars(Number, ['4', '2']).

report(fragment, fragment(Before, Part, After)) :-
  sub_atom(eyeprolog, Before, 3, After, Part).
