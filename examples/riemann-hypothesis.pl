% Riemann hypothesis, as a finite eyeprolog check.
%
% This example does not prove the Riemann hypothesis.  It models the
% finite statement: every non-trivial zero in the local catalogue has
% real part 0.5.  A real proof would have to cover all non-trivial zeros,
% not only the facts listed here.

% Print the finite check summary and the per-zero audit rows.
%% goal: rh(X0, X1)

%% goal: zero_check(X0, X1, X2)


:- discontiguous(zeta_zero/1).
:- discontiguous(real_part/2).
:- discontiguous(imaginary_part/2).
:- discontiguous(source/2).

% --- Sample zero catalogue -------------------------------------------------
%
% The three z* entries stand for catalogued non-trivial zeros of the
% Riemann zeta function.  The t* entry is a trivial zero, included to show
% that the rules below deliberately exclude it from the RH check.

zeta_zero(z1).
real_part(z1, 0.5).
imaginary_part(z1, 14.134725).
source(z1, "first catalogued non-trivial zero in this example").

zeta_zero(z2).
real_part(z2, 0.5).
imaginary_part(z2, 21.02204).
source(z2, "second catalogued non-trivial zero in this example").

zeta_zero(z3).
real_part(z3, 0.5).
imaginary_part(z3, 25.010858).
source(z3, "third catalogued non-trivial zero in this example").

zeta_zero(t1).
trivial_zero(t1).
real_part(t1, -2).
imaginary_part(t1, 0).
source(t1, "trivial zero, outside the non-trivial RH check").

% --- Classification rules --------------------------------------------------
%
% A non-trivial zero is one of the catalogued zeta zeros that lies in the
% critical strip 0 < real part < 1 and is not explicitly marked as trivial.

in_critical_strip(Zero) :-
  real_part(Zero, Real),
  (Real > 0),
  (Real < 1).

non_trivial_zero(Zero) :-
  zeta_zero(Zero),
  in_critical_strip(Zero),
  \+ trivial_zero(Zero).

% The RH condition for one zero: its real part is exactly one half.

on_critical_line(Zero) :-
  non_trivial_zero(Zero),
  real_part(Zero, 0.5).

% A finite counterexample would be a catalogued non-trivial zero whose real
% part is not one half.

off_critical_line(Zero) :-
  non_trivial_zero(Zero),
  real_part(Zero, Real),
  (Real \= 0.5).

catalog_has(non_trivial_zero) :-
  non_trivial_zero(_somezero).

counterexample_found(yes) :-
  off_critical_line(_zero).

% The finite catalogue supports RH exactly when it contains at least one
% non-trivial zero and no catalogued counterexample.

finite_catalog_supports_rh(yes) :-
  catalog_has(non_trivial_zero),
  \+ counterexample_found(yes).

% --- Queried audit output --------------------------------------------

% These tiny support facts make the summary rows derived output rather than
% source facts; eyeprolog intentionally does not reprint source facts.

summary_row(scope, finite_catalog_only).
summary_row(caveat, "finite catalogue evidence only; this is not a proof of RH").

rh(Key, Value) :-
  summary_row(Key, Value).

rh(status, no_counterexample_in_catalog) :-
  finite_catalog_supports_rh(yes).

rh(status, counterexample_in_catalog) :-
  counterexample_found(yes).

zero_check(Zero, real_part, Real) :-
  non_trivial_zero(Zero),
  real_part(Zero, Real).

zero_check(Zero, imaginary_part, Imaginary) :-
  non_trivial_zero(Zero),
  imaginary_part(Zero, Imaginary).

zero_check(Zero, classification, on_critical_line) :-
  on_critical_line(Zero).

zero_check(Zero, classification, off_critical_line) :-
  off_critical_line(Zero).
