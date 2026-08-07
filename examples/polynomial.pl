% Polynomial roots over complex integer candidates, adapted from Eyelet's
% input/polynomial.pl.
%
% Complex numbers are represented as [Real, Imaginary].  This eyeprolog version
% keeps the example generic by evaluating a polynomial with Horner's rule and
% searching a finite complex-integer candidate grid.  The two cases below are
% the same quartic polynomials used by the Eyelet source.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: polynomial(X0, X1)

%% goal: root(X0, X1)

%% goal: reconstructedPolynomial(X0, X1)

%% goal: reconstructionMatches(X0, X1)

%% goal: allRootsVerified(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
case(real_quartic).
case(complex_quartic).

polynomial(real_quartic, [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]).
polynomial(complex_quartic, [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]).

% Finite search domains for the two sample quartics.
real_domain(real_quartic, 0, 5).
imag_domain(real_quartic, 0, 0).
real_domain(complex_quartic, 0, 5).
imag_domain(complex_quartic, 0, 2).

% The known roots are used only to reconstruct the polynomial and check that
% the coefficient list matches the case polynomial.  Root discovery below is
% driven by polynomial evaluation over the candidate grid.
known_roots(real_quartic, [[1, 0], [2, 0], [3, 0], [4, 0]]).
known_roots(complex_quartic, [[0, 1], [1, 1], [3, 2], [5, 1]]).

c_zero([0, 0]).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
c_add([A, B], [C, D], [E, F]) :-
  (E is A + C),
  (F is B + D).

c_sub([A, B], [C, D], [E, F]) :-
  (E is A - C),
  (F is B - D).

c_neg([A, B], [C, D]) :-
  (C is -(A)),
  (D is -(B)).

c_mul([A, B], [C, D], [E, F]) :-
  (Ac is A * C),
  (Bd is B * D),
  (E is Ac - Bd),
  (Ad is A * D),
  (Bc is B * C),
  (F is Ad + Bc).

poly_eval([Coeff|Rest], X, Value) :-
  poly_eval_acc(Rest, X, Coeff, Value).

poly_eval_acc([], _x, Acc, Acc).
poly_eval_acc([Coeff|Rest], X, Acc, Value) :-
  c_mul(Acc, X, Product),
  c_add(Product, Coeff, Next),
  poly_eval_acc(Rest, X, Next, Value).

candidate(Case, [R, I]) :-
  real_domain(Case, R0, R1),
  imag_domain(Case, I0, I1),
  between(R0, R1, R),
  between(I0, I1, I).

root(Case, Root) :-
  polynomial(Case, Coeffs),
  candidate(Case, Root),
  poly_eval(Coeffs, Root, Value),
  c_zero(Value).

poly_from_roots(Roots, Coeffs) :-
  poly_from_roots_acc(Roots, [[1, 0]], Coeffs).

poly_from_roots_acc([], Coeffs, Coeffs).
poly_from_roots_acc([Root|Rest], Coeffs, Result) :-
  poly_mul_linear(Coeffs, Root, Next),
  poly_from_roots_acc(Rest, Next, Result).

poly_mul_linear(Coeffs, Root, Product) :-
  append(Coeffs, [[0, 0]], Shifted),
  c_neg(Root, Minusroot),
  poly_scale(Minusroot, Coeffs, Scaled),
  append([[0, 0]], Scaled, Lower),
  poly_add(Shifted, Lower, Product).

poly_scale(_factor, [], []).
poly_scale(Factor, [Coeff|Rest], [Product|Scaled]) :-
  c_mul(Factor, Coeff, Product),
  poly_scale(Factor, Rest, Scaled).

poly_add([], [], []).
poly_add([A|As], [B|Bs], [C|Cs]) :-
  c_add(A, B, C),
  poly_add(As, Bs, Cs).

reconstructed(Case, Coeffs) :-
  known_roots(Case, Roots),
  poly_from_roots(Roots, Coeffs).



reconstructedPolynomial(Case, Coeffs) :-
  reconstructed(Case, Coeffs).

reconstructionMatches(Case, true) :-
  polynomial(Case, Coeffs),
  reconstructed(Case, Coeffs).

allRootsVerified(Case, true) :-
  known_roots(Case, Roots),
  all_roots_verify(Case, Roots).

all_roots_verify(_case, []).
all_roots_verify(Case, [Root|Rest]) :-
  root(Case, Root),
  all_roots_verify(Case, Rest).
