% Representative example: clinical-trial screening.
%
% The program models a small diabetes trial screening workflow. Helper
% predicates keep the inclusion/exclusion logic separate from the concise
% public relation report.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%
% Inclusion criteria are positive requirements; exclusion criteria veto a
% candidate even when the inclusion checks pass. The emitted reason/2 facts are
% the audit trail a coordinator would need for a screen-failure report.
%% goal: type(X0, X1)

%% goal: status(X0, X1)

%% goal: reason(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
patient(p001).
patient(p002).
patient(p003).
patient(p004).

age(p001, 54).
age(p002, 67).
age(p003, 31).
age(p004, 45).

diagnosis(p001, type2_diabetes).
diagnosis(p002, type2_diabetes).
diagnosis(p003, type2_diabetes).
diagnosis(p004, type2_diabetes).

lab(p001, hba1c_pct, 8.4).
lab(p002, hba1c_pct, 7.9).
lab(p003, hba1c_pct, 9.1).
lab(p004, hba1c_pct, 6.4).

lab(p001, egfr_ml_min, 83.0).
lab(p002, egfr_ml_min, 38.0).
lab(p003, egfr_ml_min, 91.0).
lab(p004, egfr_ml_min, 72.0).

condition(p003, pregnant).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
inclusion_adult(Patient) :-
  patient(Patient),
  age(Patient, Age),
  (Age >= 18).

inclusion_diagnosis(Patient) :-
  diagnosis(Patient, type2_diabetes).

inclusion_hba1c(Patient) :-
  lab(Patient, hba1c_pct, Hba1c),
  (Hba1c >= 7.0),
  (Hba1c =< 10.5).

exclusion_renal(Patient) :-
  lab(Patient, egfr_ml_min, Egfr),
  (Egfr < 45.0).

exclusion_pregnancy(Patient) :-
  condition(Patient, pregnant).

% A patient is eligible only when all inclusion checks pass and no exclusion is proven.
screen_eligible(Patient) :-
  inclusion_adult(Patient),
  inclusion_diagnosis(Patient),
  inclusion_hba1c(Patient),
  \+ exclusion_renal(Patient),
  \+ exclusion_pregnancy(Patient).

screen_fail(Patient) :- exclusion_renal(Patient).
screen_fail(Patient) :- exclusion_pregnancy(Patient).
screen_fail(Patient) :- patient(Patient), \+ inclusion_hba1c(Patient).

type(Patient, trial_candidate) :-
  screen_eligible(Patient).

status(Patient, eligible) :-
  screen_eligible(Patient).

reason(Patient, "meets inclusion criteria and no listed exclusion") :-
  screen_eligible(Patient).

status(Patient, screen_fail) :-
  screen_fail(Patient).

reason(Patient, "eGFR below renal safety threshold") :-
  exclusion_renal(Patient).

reason(Patient, "pregnancy exclusion applies") :-
  exclusion_pregnancy(Patient).

reason(Patient, "HbA1c is outside protocol range") :-
  patient(Patient),
  \+ inclusion_hba1c(Patient).
