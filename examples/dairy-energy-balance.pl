% EYE-inspired dairy energy balance case study.
%
% cow(Cow, BodyWeightKg, MilkKgPerDay, RationEnergyMcalPerKgDM, IntakeKgDM)
% records a small herd.  Rules estimate maintenance demand, milk-production
% demand, ration supply, and the resulting energy-balance class.
%% goal: energyBalance_Mcal(X0, X1)

%% goal: rationSupportedMilk_kg(X0, X1)

%% goal: status(X0, X1)

%% goal: reason(X0, X1)

%% goal: strongestDeficit(X0, X1)


% Four cows cover negative, near-neutral, and positive balance cases.
cow(early_lactation, 650, 38, 6.4, 22).
cow(mid_lactation, 610, 24, 6.5, 26).
cow(late_lactation, 580, 16, 6.7, 25).
cow(grazing, 540, 18, 5.8, 21).

% Maintenance scales with body weight; milk requirement scales with daily milk.
maintenance(C, M) :-
  cow(C, Weight, _, _, _),
  (M is Weight * 0.08).

milk_requirement(C, R) :-
  cow(C, _, Milk, _, _),
  (R is Milk * 5.0).

ration_supply(C, S) :-
  cow(C, _, _, Density, Intake),
  (S is Density * Intake).

total_requirement(C, R) :-
  maintenance(C, M),
  milk_requirement(C, Milkr),
  (R is M + Milkr).

% energy_balance/2 is intake minus maintenance and milk-production demand.
energy_balance(C, B) :-
  ration_supply(C, S),
  total_requirement(C, R),
  (B is S - R).

ration_supported_milk(C, Milk) :-
  ration_supply(C, S),
  maintenance(C, M),
  (Availableformilk is S - M),
  (Milk is Availableformilk / 5.0).

status(C, negative_energy_balance) :-
  energy_balance(C, B),
  (B < -5.0).

status(C, near_neutral_energy_balance) :-
  energy_balance(C, B),
  (B >= -5.0),
  (B =< 5.0).

status(C, positive_energy_balance) :-
  energy_balance(C, B),
  (B > 5.0).

energyBalance_Mcal(C, B) :- energy_balance(C, B).
rationSupportedMilk_kg(C, M) :- ration_supported_milk(C, M).
reason(dairy_energy_balance, "ration supply minus maintenance and milk energy requirement determines the class").
strongestDeficit(dairy_energy_balance, early_lactation) :-
  status(early_lactation, negative_energy_balance),
  status(late_lactation, positive_energy_balance).
