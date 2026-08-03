% EYE-inspired epidemic policy choice.
% Candidate interventions combine vaccination and mask factors against a base
% reproduction-risk estimate.  The recommended policy is the only candidate
% that satisfies the outbreak threshold in this simplified model.

%% goal: riskScore(X0, X1)

%% goal: cost(X0, X1)

%% goal: status(X0, X1)

%% goal: recommendedPolicy(X0, X1)

%% goal: reason(X0, X1)


% Candidate interventions combine vaccination and mask factors.
policy(no_mandate).
policy(vaccination_campaign).
policy(indoor_masks).
policy(vaccination_and_masks).

base_risk(1.40).

vaccination_factor(no_mandate, 1.00).
vaccination_factor(vaccination_campaign, 0.55).
vaccination_factor(indoor_masks, 1.00).
vaccination_factor(vaccination_and_masks, 0.55).

mask_factor(no_mandate, 1.00).
mask_factor(vaccination_campaign, 1.00).
mask_factor(indoor_masks, 0.65).
mask_factor(vaccination_and_masks, 0.65).

policy_cost(no_mandate, 0).
policy_cost(vaccination_campaign, 3).
policy_cost(indoor_masks, 2).
policy_cost(vaccination_and_masks, 5).

% Risk multiplies the base reproduction estimate by policy-specific factors.
risk_score(P, R) :-
  base_risk(Base),
  vaccination_factor(P, Vf),
  mask_factor(P, Mf),
  (A is Base * Vf),
  (R is A * Mf).

acceptable(P) :-
  risk_score(P, R),
  (R =< 0.75).

status(P, insufficient_control) :-
  policy(P),
  risk_score(P, R),
  (R > 0.75).

status(P, acceptable_control) :-
  acceptable(P).

% The recommendation is the only candidate below the outbreak threshold.
recommended(vaccination_and_masks) :-
  acceptable(vaccination_and_masks),
  status(no_mandate, insufficient_control),
  status(vaccination_campaign, insufficient_control),
  status(indoor_masks, insufficient_control).

riskScore(P, R) :- risk_score(P, R).
cost(P, C) :- policy_cost(P, C).
recommendedPolicy(epidemic_policy, P) :- recommended(P).
reason(epidemic_policy, "combined vaccination and indoor masks are the only policy below the outbreak threshold") :-
  recommended(vaccination_and_masks).
