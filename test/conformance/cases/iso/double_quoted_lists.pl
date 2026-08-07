% ISO double-quoted list notation follows the active double_quotes flag.
%% goal: default_chars(X0)
%% goal: default_empty(X0)
%% goal: default_shape(X0)
%% goal: atom_mode(X0)
%% goal: atom_functor(X0)
%% goal: atom_shape(X0)
%% goal: codes_mode(X0)
%% goal: codes_shape(X0)

stored_chars("ab").
stored_empty("").
default_chars(Value) :- stored_chars(Value).
default_empty(Value) :- stored_empty(Value).
default_shape(compound) :- compound("a"), \+ atomic("a").

:- set_prolog_flag(double_quotes, atom).
stored_atom("ab").
stored_compound("pair"(a, b)).
atom_mode(Value) :- stored_atom(Value).
atom_functor(Value) :- stored_compound(Value).
atom_shape(atomic) :- atom("a"), atomic("a").

:- set_prolog_flag(double_quotes, codes).
stored_codes("ab").
codes_mode(Value) :- stored_codes(Value).
codes_shape(compound) :- compound("a"), \+ atomic("a").
