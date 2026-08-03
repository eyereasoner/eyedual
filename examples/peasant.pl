% Peasant multiplication and exponentiation cases, adapted from Eyelet.
% The selected inputs include very large integers to exercise native numeric
% built-ins through ordinary relations.  The want_* facts keep the example from
% enumerating an unbounded arithmetic domain.

%% goal: prod(X0, X1)

%% goal: pow(X0, X1)


% Inputs are explicit so the example does not enumerate an unbounded domain.
want_prod([3, 0]).
want_prod([5, 6]).
want_prod([238, 13]).
want_prod([8367238, 27133]).
want_prod([62713345408367238, 40836723862713345]).
want_prod([4083672386271334562713345408367238, 4083672386271334562713345408367238]).

want_pow([3, 0]).
want_pow([5, 6]).
want_pow([238, 13]).
want_pow([8367238, 2713]).

% The arithmetic itself is delegated to the native numeric built-ins.
prod([A, B], C) :-
  want_prod([A, B]),
  (C is A * B).

pow([A, B], C) :-
  want_pow([A, B]),
  (C is A ^ B).
