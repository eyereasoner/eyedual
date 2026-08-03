% GDPR-style compliance check.
% Each processing case is tested for purpose compatibility, legal basis,
% minimisation, special-category safeguards, and international-transfer safety.
% Separate failure rules produce concise reasons for noncompliant cases.

%% goal: status(X0, X1)

%% goal: reason(X0, X1)


% case_alpha is intended to pass; case_beta is intentionally incomplete.
processing(case_alpha).
processing(case_beta).

purpose(case_alpha, care_coordination).
purpose(case_beta, marketing).

legal_basis(case_alpha, explicit_consent).
% case_beta intentionally has no legal basis.

minimized(case_alpha).
not_minimized(case_beta).

special_category(case_alpha, health_data).
special_category(case_beta, health_data).

safeguard(case_alpha, encryption).
safeguard(case_alpha, access_logging).
safeguard(case_beta, encryption).

third_country_transfer(case_beta).
adequacy_decision(case_alpha).

% Compliance is decomposed into reusable checks so reasons can be reported.
has_required_basis(Case) :- legal_basis(Case, explicit_consent).
has_required_basis(Case) :- legal_basis(Case, medical_care).

has_health_safeguards(Case) :-
  special_category(Case, health_data),
  safeguard(Case, encryption),
  safeguard(Case, access_logging).

transfer_ok(Case) :- \+ third_country_transfer(Case).
transfer_ok(Case) :- adequacy_decision(Case).

compliant(Case) :-
  processing(Case),
  has_required_basis(Case),
  minimized(Case),
  has_health_safeguards(Case),
  transfer_ok(Case).

% Individual failure rules explain why a case is noncompliant.
noncompliance_reason(Case, missing_legal_basis) :-
  processing(Case),
  \+ has_required_basis(Case).

noncompliance_reason(Case, not_minimized) :-
  not_minimized(Case).

noncompliance_reason(Case, missing_access_logging) :-
  special_category(Case, health_data),
  \+ safeguard(Case, access_logging).

noncompliance_reason(Case, transfer_without_adequacy) :-
  third_country_transfer(Case),
  \+ adequacy_decision(Case).

status(Case, gdpr_compliant) :- compliant(Case).
status(Case, gdpr_noncompliant) :- noncompliance_reason(Case, _reason).
reason(Case, Reason) :- noncompliance_reason(Case, Reason).
