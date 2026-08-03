% Science example: competitive enzyme inhibition.
%
% Michaelis-Menten kinetics with a competitive inhibitor:
%   Km_effective = Km * (1 + Inhibitor / Ki)
%   rate = Vmax * Substrate / (Km_effective + Substrate)

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: effectiveKm_uM(X0, X1)

%% goal: uninhibitedRate_uM_s(X0, X1)

%% goal: inhibitedRate_uM_s(X0, X1)

%% goal: inhibitionFraction(X0, X1)

%% goal: status(X0, X1)

%% goal: reason(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
assay(assay1, vmax_uM_s, 120.0).
assay(assay1, substrate_uM, 50.0).
assay(assay1, km_uM, 30.0).
assay(assay1, inhibitor_uM, 10.0).
assay(assay1, ki_uM, 5.0).
threshold(assay1, significant_inhibition_fraction, 0.25).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
competitive_multiplier(Assay, Multiplier) :-
  assay(Assay, inhibitor_uM, Inhibitor),
  assay(Assay, ki_uM, Ki),
  (Ratio is Inhibitor / Ki),
  (Multiplier is 1.0 + Ratio).

effective_km(Assay, Effectivekm) :-
  assay(Assay, km_uM, Km),
  competitive_multiplier(Assay, Multiplier),
  (Effectivekm is Km * Multiplier).

uninhibited_rate(Assay, Rate) :-
  assay(Assay, vmax_uM_s, Vmax),
  assay(Assay, substrate_uM, Substrate),
  assay(Assay, km_uM, Km),
  (Numerator is Vmax * Substrate),
  (Denominator is Km + Substrate),
  (Rate is Numerator / Denominator).

inhibited_rate(Assay, Rate) :-
  assay(Assay, vmax_uM_s, Vmax),
  assay(Assay, substrate_uM, Substrate),
  effective_km(Assay, Effectivekm),
  (Numerator is Vmax * Substrate),
  (Denominator is Effectivekm + Substrate),
  (Rate is Numerator / Denominator).

inhibition_fraction(Assay, Fraction) :-
  uninhibited_rate(Assay, Uninhibited),
  inhibited_rate(Assay, Inhibited),
  (Delta is Uninhibited - Inhibited),
  (Fraction is Delta / Uninhibited).

significant_inhibition(Assay) :-
  inhibition_fraction(Assay, Fraction),
  threshold(Assay, significant_inhibition_fraction, Limit),
  (Fraction > Limit).

effectiveKm_uM(Assay, Effectivekm) :-
  effective_km(Assay, Effectivekm).

uninhibitedRate_uM_s(Assay, Rate) :-
  uninhibited_rate(Assay, Rate).

inhibitedRate_uM_s(Assay, Rate) :-
  inhibited_rate(Assay, Rate).

inhibitionFraction(Assay, Fraction) :-
  inhibition_fraction(Assay, Fraction).

status(Assay, significant_inhibition) :-
  significant_inhibition(Assay).

reason(Assay, "competitive inhibitor raises effective Km and lowers reaction rate") :-
  significant_inhibition(Assay).
