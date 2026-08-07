% EYE reasoning-inspired example: exoplanet candidate validation worlds.
%
% Four simplified worlds classify candidate transit signals using either Bayes,
% sensitivity-only reasoning, a heuristic threshold, or a stricter Bayesian rule.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%
% The example is intentionally qualitative: several independent signals must
% align before a candidate is promoted from plausible to confirmed in a world.
%% goal: ppvPlanetGivenDetection(X0, X1)

%% goal: confirmsInWorld(X0, X1)

%% goal: rejectsInWorld(X0, X1)

%% goal: status(X0, X1)

%% goal: reason(X0, X1)


:- discontiguous(confirms_in_world/2).
:- discontiguous(rejects_in_world/2).

% candidate/4 stores occurrence rate, sensitivity, and specificity.  world/2
% names the alternative validation policies applied to the same signals.
candidate(rare_wide_orbit, 0.001, 0.99, 0.99).
candidate(mstar_short_period, 0.20, 0.99, 0.99).
candidate(common_hot_neptune_good, 0.25, 0.95, 0.97).
candidate(common_hot_neptune_low_spec, 0.25, 0.95, 0.90).

world(w0, full_bayes_reference).
world(w1, sensitivity_only_naive).
world(w2, occurrence_sensitivity_specificity_heuristic).
world(w3, cautious_bayes_threshold).

% The Bayes world computes positive predictive value, while the other worlds
% intentionally use simpler or stricter thresholds for contrast.
ppv_planet(Candidate, Ppv) :-
  candidate(Candidate, Occurrence, Sensitivity, Specificity),
  (Numerator is Sensitivity * Occurrence),
  (Noplanetprior is 1.0 - Occurrence),
  (Falsepositiverate is 1.0 - Specificity),
  (Falsepositivemass is Falsepositiverate * Noplanetprior),
  (Denominator is Numerator + Falsepositivemass),
  (Ppv is Numerator / Denominator).

% The world predicates encode different modelling assumptions for the same candidate.
confirms_in_world(Candidate, w0) :-
  ppv_planet(Candidate, Ppv),
  (Ppv >= 0.90).

rejects_in_world(Candidate, w0) :-
  ppv_planet(Candidate, Ppv),
  (Ppv < 0.90).

confirms_in_world(Candidate, w1) :-
  candidate(Candidate, Occurrence, Sensitivity, Specificity),
  (Sensitivity >= 0.95).

rejects_in_world(Candidate, w1) :-
  candidate(Candidate, Occurrence, Sensitivity, Specificity),
  (Sensitivity < 0.95).

confirms_in_world(Candidate, w2) :-
  candidate(Candidate, Occurrence, Sensitivity, Specificity),
  (Occurrence >= 0.05),
  (Sensitivity >= 0.90),
  (Specificity >= 0.97).

rejects_in_world(Candidate, w2) :-
  candidate(Candidate, Occurrence, Sensitivity, Specificity),
  (Occurrence < 0.05).

rejects_in_world(Candidate, w2) :-
  candidate(Candidate, Occurrence, Sensitivity, Specificity),
  (Sensitivity < 0.90).

rejects_in_world(Candidate, w2) :-
  candidate(Candidate, Occurrence, Sensitivity, Specificity),
  (Specificity < 0.97).

confirms_in_world(Candidate, w3) :-
  ppv_planet(Candidate, Ppv),
  (Ppv >= 0.93).

rejects_in_world(Candidate, w3) :-
  ppv_planet(Candidate, Ppv),
  (Ppv < 0.93).

pattern_matches(report) :-
  confirms_in_world(rare_wide_orbit, w1),
  rejects_in_world(rare_wide_orbit, w0), rejects_in_world(rare_wide_orbit, w2), rejects_in_world(rare_wide_orbit, w3),
  confirms_in_world(mstar_short_period, w0), confirms_in_world(mstar_short_period, w1), confirms_in_world(mstar_short_period, w2), confirms_in_world(mstar_short_period, w3),
  confirms_in_world(common_hot_neptune_good, w0), confirms_in_world(common_hot_neptune_good, w1), confirms_in_world(common_hot_neptune_good, w2), rejects_in_world(common_hot_neptune_good, w3),
  confirms_in_world(common_hot_neptune_low_spec, w1),
  rejects_in_world(common_hot_neptune_low_spec, w0), rejects_in_world(common_hot_neptune_low_spec, w2), rejects_in_world(common_hot_neptune_low_spec, w3).

ppvPlanetGivenDetection(Candidate, Ppv) :- ppv_planet(Candidate, Ppv).
confirmsInWorld(Candidate, World) :- confirms_in_world(Candidate, World).
rejectsInWorld(Candidate, World) :- rejects_in_world(Candidate, World).
status(exoplanet_validation_worlds, expected_world_pattern) :- pattern_matches(report).
reason(exoplanet_validation_worlds, "Bayesian worlds account for occurrence and false positives while the naive world trusts sensitivity alone") :- pattern_matches(report).
