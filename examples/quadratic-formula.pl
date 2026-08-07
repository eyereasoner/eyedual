% Quadratic formula over sample equations.
%
% Each equation is represented as a*x^2 + b*x + c = 0.  The example uses
% eyeprolog arithmetic predicates to derive the discriminant and the two roots.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: discriminant(X0, X1)

%% goal: root(X0, X1)


% equation/4 stores coefficients A, B, and C for each quadratic.  The examples
% use decimal constants so roots and discriminants flow through floating arithmetic.
equation(eq1, 1.0, -5.0, 6.0).
equation(eq2, 2.0, -4.0, -6.0).

% The formula is decomposed into discriminant, square root, -B, denominator,
% and the plus/minus branches so each algebraic step can be inspected.
discriminant(Case, D) :-
  equation(Case, A, B, C),
  (B2 is B ** 2.0),
  (Foura is 4.0 * A),
  (Fourac is Foura * C),
  (D is B2 - Fourac).

sqrt_discriminant(Case, S) :-
  discriminant(Case, D),
  (D >= 0.0),
  (S is D ** 0.5).

negative_b(Case, Nb) :-
  equation(Case, _a, B, _c),
  (Nb is -(B)).

denominator(Case, Den) :-
  equation(Case, A, _b, _c),
  (Den is 2.0 * A).

root_plus(Case, Root) :-
  negative_b(Case, Nb),
  sqrt_discriminant(Case, S),
  denominator(Case, Den),
  (Numerator is Nb + S),
  (Root is Numerator / Den).

root_minus(Case, Root) :-
  negative_b(Case, Nb),
  sqrt_discriminant(Case, S),
  denominator(Case, Den),
  (Numerator is Nb - S),
  (Root is Numerator / Den).


root(Case, Root) :-
  root_plus(Case, Root).

root(Case, Root) :-
  root_minus(Case, Root).
