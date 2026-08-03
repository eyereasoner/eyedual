% EYE-inspired field nitrogen balance case study.
%
% field(Field, SoilN, FertilizerN, LossFraction, CropDemandN) stores a compact
% nutrient budget.  Rules derive retained nitrogen, deficit, surplus, and a
% leaching-risk index before assigning each field a status.
%% goal: availableN_kg_ha(X0, X1)

%% goal: deficitN_kg_ha(X0, X1)

%% goal: surplusN_kg_ha(X0, X1)

%% goal: leachingIndex(X0, X1)

%% goal: status(X0, X1)

%% goal: highestLeachingRisk(X0, X1)

%% goal: reason(X0, X1)


% The four fields cover under-supplied, balanced, and over-supplied scenarios
% with different loss fractions so leaching risk is not just total surplus.
field(low_input, 25, 40, 0.10, 110).
field(balanced_loam, 45, 80, 0.12, 110).
field(sandy_high, 30, 150, 0.35, 105).
field(clay_surplus, 70, 90, 0.08, 120).

% total_n/2 and available_n/2 build the nutrient budget; surplus/deficit and
% leaching rules then explain the resulting field status.
total_n(F, Total) :-
  field(F, Soil, Fert, _, _),
  (Total is Soil + Fert).

available_n(F, Avail) :-
  total_n(F, Total),
  field(F, _, _, Loss, _),
  (Retained is 1.0 - Loss),
  (Avail is Total * Retained).

% surplus_n/2 and deficit_n/2 split the signed balance into reportable quantities.
surplus_n(F, Surplus) :-
  available_n(F, Avail),
  field(F, _, _, _, Demand),
  (Avail > Demand),
  (Surplus is Avail - Demand).

surplus_n(F, 0.0) :-
  available_n(F, Avail),
  field(F, _, _, _, Demand),
  (Avail =< Demand).

deficit_n(F, Deficit) :-
  available_n(F, Avail),
  field(F, _, _, _, Demand),
  (Avail < Demand),
  (Deficit is Demand - Avail).

deficit_n(F, 0.0) :-
  available_n(F, Avail),
  field(F, _, _, _, Demand),
  (Avail >= Demand).

leaching_index(F, Index) :-
  surplus_n(F, Surplus),
  field(F, _, _, Loss, _),
  (Index is Surplus * Loss).

status(F, under_supplied) :- deficit_n(F, D), (D > 10.0).
status(F, balanced) :- deficit_n(F, D), surplus_n(F, S), (D =< 10.0), (S =< 10.0).
status(F, over_supplied) :- surplus_n(F, S), (S > 10.0).

availableN_kg_ha(F, A) :- available_n(F, A).
deficitN_kg_ha(F, D) :- deficit_n(F, D).
surplusN_kg_ha(F, S) :- surplus_n(F, S).
leachingIndex(F, I) :- leaching_index(F, I).
highestLeachingRisk(field_nitrogen_balance, sandy_high) :-
  leaching_index(sandy_high, Sandy),
  leaching_index(clay_surplus, Clay),
  (Sandy > Clay).
reason(field_nitrogen_balance, "available nitrogen is total input retained after losses compared with crop demand").
