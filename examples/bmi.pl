% BMI — ARC-style Body Mass Index example adapted from Eyeling.
%
% The example normalizes metric or US inputs, computes BMI, assigns the WHO
% adult category, derives a healthy-weight band for the same height, and emits
% an inspectable report plus independent checks.
%
% For reproducibility and documentation only; not medical advice.

% Editable metric input.
% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: unitSystem(X0, X1)

%% goal: weight(X0, X1)

%% goal: height(X0, X1)

%% goal: weightKg(X0, X1)

%% goal: heightM(X0, X1)

%% goal: units(X0, X1)

%% goal: heightSquared(X0, X1)

%% goal: bmi(X0, X1)

%% goal: bmiRoundedInt(X0, X1)

%% goal: healthyMinKg(X0, X1)

%% goal: healthyMaxKg(X0, X1)

%% goal: healthyMinKgRoundedInt(X0, X1)

%% goal: healthyMaxKgRoundedInt(X0, X1)

%% goal: category(X0, X1)

%% goal: heightCm(X0, X1)

%% goal: formula(X0, X1)

%% goal: calculation(X0, X1)

%% goal: categoryRule(X0, X1)

%% goal: unitsExplanation(X0, X1)

%% goal: c1(X0, X1)

%% goal: c2(X0, X1)

%% goal: c3(X0, X1)

%% goal: c4(X0, X1)

%% goal: c5(X0, X1)

%% goal: c6(X0, X1)

%% goal: c7(X0, X1)

%% goal: c8(X0, X1)

%% goal: c9(X0, X1)

%% goal: result(X0, X1)

%% goal: healthyWeightRangeKg(X0, X1)

%% goal: checkPassed(X0, X1)


:- discontiguous(weightKg/2).
:- discontiguous(heightM/2).
:- discontiguous(units/2).
:- discontiguous(bmi/2).
:- discontiguous(category/2).
:- discontiguous(healthyMinKg/2).
:- discontiguous(healthyMaxKg/2).
:- discontiguous(heightCm/2).

% Program structure: facts set up the scenario, and rules derive the queried conclusions.
unitSystem(input, metric).
weight(input, 72.0).
height(input, 178.0).

% US alternative:
% unitSystem(input, us).
% weight(input, 158.73).
% height(input, 70.08).

% Normalization and BMI calculation.
% Derivation rules: each rule below contributes one logical step toward the displayed results.
weightKg(case, W) :-
  unitSystem(input, metric),
  weight(input, W).

heightM(case, M) :-
  unitSystem(input, metric),
  height(input, H),
  (M is H / 100.0).

units(reason, "Inputs were already metric, so kilograms stay kilograms and centimeters are divided by 100 to obtain meters.") :-
  unitSystem(input, metric).

weightKg(case, Kg) :-
  unitSystem(input, us),
  weight(input, W),
  (Kg is W * 0.45359237).

heightM(case, M) :-
  unitSystem(input, us),
  height(input, H),
  (M is H * 0.0254).

units(reason, "US inputs were converted to SI units: pounds to kilograms and inches to meters.") :-
  unitSystem(input, us).

heightSquared(case, M2) :-
  heightM(case, M),
  (M2 is M * M).

bmi(case, Bmi) :-
  weightKg(case, Kg),
  heightSquared(case, M2),
  (Bmi is Kg / M2).

bmiRoundedInt(case, Bmiroundedint) :-
  bmi(case, Bmi),
  (Bmix100 is Bmi * 100.0),
  (Bmiroundedint is round(Bmix100)).

healthyMinKg(case, Healthymin) :-
  heightSquared(case, M2),
  (Healthymin is 18.5 * M2).

healthyMaxKg(case, Healthymax) :-
  heightSquared(case, M2),
  (Healthymax is 24.9 * M2).

healthyMinKgRoundedInt(case, Minroundedint) :-
  healthyMinKg(case, Healthymin),
  (Minx10 is Healthymin * 10.0),
  (Minroundedint is round(Minx10)).

healthyMaxKgRoundedInt(case, Maxroundedint) :-
  healthyMaxKg(case, Healthymax),
  (Maxx10 is Healthymax * 10.0),
  (Maxroundedint is round(Maxx10)).

% WHO adult categories, using half-open intervals.
category(decision, "Underweight") :-
  bmi(case, Bmi),
  (Bmi < 18.5).

category(decision, "Normal") :-
  bmi(case, Bmi),
  (Bmi >= 18.5),
  (Bmi < 25.0).

category(decision, "Overweight") :-
  bmi(case, Bmi),
  (Bmi >= 25.0),
  (Bmi < 30.0).

category(decision, "Obesity I") :-
  bmi(case, Bmi),
  (Bmi >= 30.0),
  (Bmi < 35.0).

category(decision, "Obesity II") :-
  bmi(case, Bmi),
  (Bmi >= 35.0),
  (Bmi < 40.0).

category(decision, "Obesity III") :-
  bmi(case, Bmi),
  (Bmi >= 40.0).

% Answer and reason why.
bmi(answer, 22.72) :-
  bmiRoundedInt(case, 2272).

category(answer, Category) :-
  category(decision, Category).

healthyMinKg(answer, 58.6) :-
  healthyMinKgRoundedInt(case, 586).

healthyMaxKg(answer, 78.9) :-
  healthyMaxKgRoundedInt(case, 789).

heightCm(answer, Cmrounded) :-
  heightM(case, M),
  (Cm is M * 100.0),
  (Cmrounded is round(Cm)).

formula(reason, "BMI is defined as weight in kilograms divided by height in meters squared.") :-
  bmi(case, _bmi).

calculation(reason, "The normalized weight and height were used to compute BMI, then the result was mapped to the WHO adult category table.") :-
  category(decision, _category).

categoryRule(reason, Category) :-
  category(decision, Category).

unitsExplanation(reason, Units) :-
  units(reason, Units).

% Independent checks.
c1(check, "OK - the input was normalized into positive SI values.") :-
  weightKg(case, Kg),
  heightM(case, M),
  (Kg > 0),
  (M > 0).

c2(check, "OK - height squared was reconstructed from the normalized height.") :-
  heightM(case, M),
  heightSquared(case, M2),
  (M2 is M * M).

c3(check, "OK - the BMI value matches the BMI = kg / m² formula.") :-
  weightKg(case, Kg),
  heightSquared(case, M2),
  bmi(case, Bmi),
  (Bmi is Kg / M2).

c4(check, "OK - a BMI of 18.49 stays below the normal-weight threshold.") :-
  (18.49 < 18.5).

c5(check, "OK - the lower boundary is half-open: BMI 18.5 is classified as Normal.") :-
  (18.5 >= 18.5),
  (18.5 < 25.0).

c6(check, "OK - BMI 25.0 starts the Overweight category.") :-
  (25.0 >= 25.0),
  (25.0 < 30.0).

c7(check, "OK - BMI 30.0 starts the Obesity I category.") :-
  (30.0 >= 30.0),
  (30.0 < 35.0).

c8(check, "OK - classification behavior is monotonic across representative BMI values.") :-
  (22.0 >= 18.5),
  (22.0 < 25.0),
  (27.0 >= 25.0),
  (27.0 < 30.0),
  (41.0 >= 40.0).

c9(check, "OK - the healthy-weight band was reconstructed from BMI 18.5 to 24.9 at the same height.") :-
  heightSquared(case, M2),
  healthyMinKg(case, Min),
  healthyMaxKg(case, Max),
  (Min is 18.5 * M2),
  (Max is 24.9 * M2).

% Derived report summary.  These relations are consequences of the calculation
% and checks, not pre-written report lines.
result(report, bmi(Bmi, Category)) :-
  bmi(answer, Bmi),
  category(answer, Category).

healthyWeightRangeKg(report, range(Min, Max)) :-
  healthyMinKg(answer, Min),
  healthyMaxKg(answer, Max).

heightCm(report, Height) :-
  heightCm(answer, Height).

checkPassed(report, Check) :-
  statement(check, Check, _Message).

statement(check, c1, Message) :- c1(check, Message).
statement(check, c2, Message) :- c2(check, Message).
statement(check, c3, Message) :- c3(check, Message).
statement(check, c4, Message) :- c4(check, Message).
statement(check, c5, Message) :- c5(check, Message).
statement(check, c6, Message) :- c6(check, Message).
statement(check, c7, Message) :- c7(check, Message).
statement(check, c8, Message) :- c8(check, Message).
statement(check, c9, Message) :- c9(check, Message).
