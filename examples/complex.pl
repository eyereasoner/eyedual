% Complex numbers, adapted from Eyeling complex.n3.
%
% Complex values are represented as two-item lists [Real, Imaginary], matching
% the pair-shaped pair lists used by the Eyeling source.

% Output declarations: query/1 selects the relations written to this example's golden output.
%
% The example derives arithmetic identities, polar conversions, powers, roots,
% exponential/trigonometric functions, and distance/normalization results from
% a small complex-number toolkit.
query(complex_power(X0, X1, X2, X3)).
query(complex_function(X0, X1, X2, X3)).

% Program structure: facts set up the scenario, and rules derive the queried conclusions.
pi(3.141592653589793).
e(2.718281828459045).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
% z^w is evaluated through polar/log form, exposing useful intermediate proof steps.
complex_exponentiation([A, B], [C, D], [E, F]) :-
  complex_polar([A, B], [R, T]),
  (Z1 is R ** C),
  (Z2 is -(D)),
  (Z3 is Z2 * T),
  e(Euler),
  (Z4 is Euler ** Z3),
  (Z5 is log(R)),
  (Z6 is D * Z5),
  (Z7 is C * T),
  (Z8 is Z6 + Z7),
  (Z9 is cos(Z8)),
  (Z1z4 is Z1 * Z4),
  (E is Z1z4 * Z9),
  (Z10 is sin(Z8)),
  (F is Z1z4 * Z10).

complex_asin([A, B], [C, D]) :-
  (Z1 is 1 + A),
  (Z2 is Z1 ** 2),
  (Z3 is B ** 2),
  (Z4 is Z2 + Z3),
  (Z5 is Z4 ** 0.5),
  (Z6 is 1 - A),
  (Z7 is Z6 ** 2),
  (Z8 is Z7 + Z3),
  (Z9 is Z8 ** 0.5),
  (Z10 is Z5 - Z9),
  (E is Z10 / 2),
  (Z11 is Z5 + Z9),
  (F is Z11 / 2),
  asin(E, C),
  (Z12 is F ** 2),
  (Z13 is Z12 - 1),
  (Z14 is Z13 ** 0.5),
  (Z15 is F + Z14),
  (D is log(Z15)).

complex_acos([A, B], [C, D]) :-
  (Z1 is 1 + A),
  (Z2 is Z1 ** 2),
  (Z3 is B ** 2),
  (Z4 is Z2 + Z3),
  (Z5 is Z4 ** 0.5),
  (Z6 is 1 - A),
  (Z7 is Z6 ** 2),
  (Z8 is Z7 + Z3),
  (Z9 is Z8 ** 0.5),
  (Z10 is Z5 - Z9),
  (E is Z10 / 2),
  (Z11 is Z5 + Z9),
  (F is Z11 / 2),
  acos(E, C),
  (Z12 is F ** 2),
  (Z13 is Z12 - 1),
  (Z14 is Z13 ** 0.5),
  (Z15 is F + Z14),
  (U is log(Z15)),
  (D is -(U)).

complex_polar([X, Y], [R, Tp]) :-
  (Z1 is X ** 2),
  (Z2 is Y ** 2),
  (Z3 is Z1 + Z2),
  (R is Z3 ** 0.5),
  (Z4 is abs(X)),
  (Z5 is Z4 / R),
  acos(Z5, T),
  complex_dial(X, Y, T, Tp).

complex_dial(X, Y, T, Tp) :-
  (X >= 0),
  (Y >= 0),
  (Tp is 0 + T).

complex_dial(X, Y, T, Tp) :-
  (X < 0),
  (Y >= 0),
  pi(Pi),
  (Tp is Pi - T).

complex_dial(X, Y, T, Tp) :-
  (X < 0),
  (Y < 0),
  pi(Pi),
  (Tp is Pi + T).

complex_dial(X, Y, T, Tp) :-
  (X >= 0),
  (Y < 0),
  pi(Pi),
  (Z1 is Pi * 2),
  (Tp is Z1 - T).

% Named result rows keep the example output readable.  Each row records the
% operation name, the input value(s), and the computed complex result rather
% than packing all assertions into one large nested term.
complex_power(sqrt_minus_one, [-1, 0], [0.5, 0], Result) :-
  complex_exponentiation([-1, 0], [0.5, 0], Result).

complex_power(e_to_i_pi, [2.718281828459045, 0], [0, 3.141592653589793], Result) :-
  complex_exponentiation([2.718281828459045, 0], [0, 3.141592653589793], Result).

complex_power(i_to_i, [0, 1], [0, 1], Result) :-
  complex_exponentiation([0, 1], [0, 1], Result).

complex_power(e_to_minus_pi_over_two, [2.718281828459045, 0], [-1.57079632679, 0], Result) :-
  complex_exponentiation([2.718281828459045, 0], [-1.57079632679, 0], Result).

complex_function(asin, two, [2, 0], Result) :-
  complex_asin([2, 0], Result).

complex_function(acos, two, [2, 0], Result) :-
  complex_acos([2, 0], Result).
