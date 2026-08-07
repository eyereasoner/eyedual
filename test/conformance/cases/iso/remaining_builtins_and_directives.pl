% ISO 7.4 and 8.14/8.17: remaining directives and mandatory built-ins.
:- dynamic([stored/1, spare/0]).
:- multifile(distributed/1).
:- discontiguous(distributed/1).
:- initialization(assertz(stored(initialized))).
:- set_prolog_flag(debug, on).
:- char_conversion('&', a).

distributed(first).
between_clause(ok).
distributed(second).

%% goal: directive_state(Value, Debug)

directive_state(Value, Debug) :-
    stored(Value),
    current_prolog_flag(debug, Debug).

%% goal: character_conversion(Term, From, To)

character_conversion(Term, From, To) :-
    open('/tmp/eyeprolog-iso-conversion.txt', write, Output),
    put_char(Output, '&'),
    put_char(Output, '.'),
    close(Output),
    open('/tmp/eyeprolog-iso-conversion.txt', read, Input),
    read(Input, Term),
    close(Input),
    current_char_conversion(From, To).

%% goal: remove_conversion(ok)

remove_conversion(ok) :-
    char_conversion('&', '&'),
    \+ current_char_conversion('&', _).
