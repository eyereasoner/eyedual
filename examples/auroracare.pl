% AuroraCare purpose-based medical-data exchange case adapted from Eyeling auroracare.n3.
% The original N3 emits one Markdown block per scenario.  This eyeprolog
% translation querys the policy decisions, reasons, traces, and ARC-style
% check values as ordinary relation output.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: label(X0, X1)

%% goal: description(X0, X1)

%% goal: careTeamLinked(X0, X1)

%% goal: subjectOptIn(X0, X1)

%% goal: subjectOptOut(X0, X1)

%% goal: decision(X0, X1)

%% goal: reason(X0, X1)

%% goal: matchedPolicyUid(X0, X1)

%% goal: matchedProhibition(X0, X1)

%% goal: trace(X0, X1)

%% goal: checkC1(X0, X1)

%% goal: checkC2(X0, X1)

%% goal: checkC3(X0, X1)

%% goal: checkC4(X0, X1)

%% goal: checkC5(X0, X1)

%% goal: checkC6(X0, X1)

%% goal: checkC7(X0, X1)

%% goal: checkC8(X0, X1)

%% goal: checkC9(X0, X1)

%% goal: checkC10Text(X0, X1)


:- discontiguous(policyUid/2).
:- discontiguous(purposeAllowed/2).
:- discontiguous(requireEnvironment/2).
:- discontiguous(allowAnyCategory/2).
:- discontiguous(duty/2).
:- discontiguous(scenario/1).
:- discontiguous(outputKey/2).
:- discontiguous(scenario_label/2).
:- discontiguous(scenario_description/2).
:- discontiguous(requester/2).
:- discontiguous(requesterRole/2).
:- discontiguous(subject/2).
:- discontiguous(purpose/2).
:- discontiguous(environment/2).
:- discontiguous(category/2).
:- discontiguous(checkC1/2).
:- discontiguous(checkC2/2).
:- discontiguous(checkC3/2).
:- discontiguous(checkC4/2).
:- discontiguous(checkC5/2).
:- discontiguous(checkC6/2).
:- discontiguous(checkC7/2).
:- discontiguous(checkC8/2).
:- discontiguous(checkC9/2).
:- discontiguous(checkC10Text/2).

% Program structure: facts set up the scenario, and rules derive the queried conclusions.
caseName(case, "auroracare").
question(case, "For each AuroraCare scenario, should the PDP permit or deny the requested use of health data, and why?").

% Policies: primary care, quality improvement, research, and an explicit denial.
policyUid(policyPrimary, "urn:policy:primary-care-001").
purposeAllowed(policyPrimary, primaryCareManagement).
purposeAllowed(policyPrimary, patientRemoteMonitoring).
roleAllowed(policyPrimary, "clinician").
allowAnyCategory(policyPrimary, patientSummary).
allowAnyCategory(policyPrimary, labResults).

policyUid(policyQi, "urn:policy:qi-2025-aurora").
purposeAllowed(policyQi, ensureQualitySafetyHealthcare).
requireEnvironment(policyQi, "secure_env").
requireAllCategory(policyQi, labResults).
requireAllCategory(policyQi, patientSummary).
duty(policyQi, requireConsent).
duty(policyQi, noExfiltration).

policyUid(policyResearch, "urn:policy:research-aurora-diabetes").
purposeAllowed(policyResearch, healthcareScientificResearch).
requireEnvironment(policyResearch, "secure_env").
requireTom(policyResearch, anonymisation).
allowAnyCategory(policyResearch, labResults).
allowAnyCategory(policyResearch, patientSummary).
allowAnyCategory(policyResearch, imagingReport).
duty(policyResearch, annualOutcomeReport).
duty(policyResearch, noReidentification).
duty(policyResearch, noExfiltration).

policyUid(policyDenyInsurance, "urn:policy:deny-insurance").
prohibitPurpose(policyDenyInsurance, insuranceManagement).

linkedTo(clinicianAlba, ruben).
linkedTo(gpRuben, ruben).
consentAllow(ruben, healthcareScientificResearch).
consentDeny(ruben, trainTestAndEvaluateAiSystemsAlgorithms).
primaryPurpose(auroracare, primaryCareManagement).
primaryPurpose(auroracare, patientRemoteMonitoring).
prohibitedPurpose(auroracare, insuranceManagement).

% Scenarios A-G mirror the upstream Markdown report cases.
scenario(scenarioA).
outputKey(scenarioA, out010A).
scenario_label(scenarioA, "A – Primary care visit").
scenario_description(scenarioA, "Clinician in the patient's care team accessing the patient summary for primary care management.").
requester(scenarioA, clinicianAlba).
requesterRole(scenarioA, "clinician").
subject(scenarioA, ruben).
purpose(scenarioA, primaryCareManagement).
environment(scenarioA, "api_gateway").
category(scenarioA, patientSummary).

scenario(scenarioB).
outputKey(scenarioB, out020B).
scenario_label(scenarioB, "B – Quality improvement (in scope)").
scenario_description(scenarioB, "QI analyst using lab results + summary in a secure environment.").
requester(scenarioB, qiAnalyst).
requesterRole(scenarioB, "data_user").
subject(scenarioB, ruben).
purpose(scenarioB, ensureQualitySafetyHealthcare).
environment(scenarioB, "secure_env").
category(scenarioB, labResults).
category(scenarioB, patientSummary).

scenario(scenarioC).
outputKey(scenarioC, out030C).
scenario_label(scenarioC, "C – Quality improvement (out of scope)").
scenario_description(scenarioC, "QI analyst with only lab results; policy expects labs + summary.").
requester(scenarioC, qiAnalyst).
requesterRole(scenarioC, "data_user").
subject(scenarioC, ruben).
purpose(scenarioC, ensureQualitySafetyHealthcare).
environment(scenarioC, "secure_env").
category(scenarioC, labResults).

scenario(scenarioD).
outputKey(scenarioD, out040D).
scenario_label(scenarioD, "D – Insurance management").
scenario_description(scenarioD, "Insurance bot attempting to use health data for insurance management (prohibited purpose).").
requester(scenarioD, insurerBot).
requesterRole(scenarioD, "data_user").
subject(scenarioD, ruben).
purpose(scenarioD, insuranceManagement).
environment(scenarioD, "secure_env").
category(scenarioD, patientSummary).

scenario(scenarioE).
outputKey(scenarioE, out050E).
scenario_label(scenarioE, "E – GP checks labs").
scenario_description(scenarioE, "GP for the same patient checking lab results via the API gateway.").
requester(scenarioE, gpRuben).
requesterRole(scenarioE, "clinician").
subject(scenarioE, ruben).
purpose(scenarioE, primaryCareManagement).
environment(scenarioE, "api_gateway").
category(scenarioE, labResults).

scenario(scenarioF).
outputKey(scenarioF, out060F).
scenario_label(scenarioF, "F – Research on anonymised dataset").
scenario_description(scenarioF, "Researcher using anonymised labs + summary in a secure environment, with opt-in.").
requester(scenarioF, researcherAurora).
requesterRole(scenarioF, "data_user").
subject(scenarioF, ruben).
purpose(scenarioF, healthcareScientificResearch).
environment(scenarioF, "secure_env").
tom(scenarioF, anonymisation).
category(scenarioF, patientSummary).
category(scenarioF, labResults).

scenario(scenarioG).
outputKey(scenarioG, out070G).
scenario_label(scenarioG, "G – AI training (opt-out)").
scenario_description(scenarioG, "Data user wants to train AI, but the subject opted out of AI training.").
requester(scenarioG, mlOps).
requesterRole(scenarioG, "data_user").
subject(scenarioG, ruben).
purpose(scenarioG, trainTestAndEvaluateAiSystemsAlgorithms).
environment(scenarioG, "secure_env").
category(scenarioG, patientSummary).
category(scenarioG, labResults).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
label(S, Label) :- scenario_label(S, Label).
description(S, Description) :- scenario_description(S, Description).

care_team_linked(S) :-
  requester(S, Requester),
  subject(S, Subject),
  linkedTo(Requester, Subject).

subject_opt_in(S) :-
  subject(S, Subject),
  purpose(S, Purpose),
  consentAllow(Subject, Purpose).

subject_opt_out(S) :-
  subject(S, Subject),
  purpose(S, Purpose),
  consentDeny(Subject, Purpose).

primary_policy_match(S) :-
  purpose(S, primaryCareManagement),
  requesterRole(S, "clinician"),
  care_team_linked(S),
  category(S, Category),
  allowAnyCategory(policyPrimary, Category).

qi_policy_match(S) :-
  purpose(S, ensureQualitySafetyHealthcare),
  environment(S, "secure_env"),
  category(S, labResults),
  category(S, patientSummary).

research_policy_match(S) :-
  purpose(S, healthcareScientificResearch),
  environment(S, "secure_env"),
  tom(S, anonymisation),
  subject_opt_in(S),
  category(S, labResults).

insurance_prohibition_match(S) :-
  purpose(S, insuranceManagement),
  prohibitPurpose(policyDenyInsurance, insuranceManagement).

ai_training_opt_out_match(S) :-
  purpose(S, trainTestAndEvaluateAiSystemsAlgorithms),
  subject_opt_out(S).

careTeamLinked(S, true) :- care_team_linked(S).
subjectOptIn(S, true) :- subject_opt_in(S).
subjectOptOut(S, true) :- subject_opt_out(S).

% Permit when a scenario satisfies one of the allowed policy branches.
decision(S, "PERMIT") :- primary_policy_match(S).
decision(S, "PERMIT") :- qi_policy_match(S).
decision(S, "PERMIT") :- research_policy_match(S).
% Deny branches preserve the reason that will be queried for the report.
decision(S, "DENY") :- insurance_prohibition_match(S).
decision(S, "DENY") :- ai_training_opt_out_match(S).
decision(scenarioC, "DENY") :- purpose(scenarioC, ensureQualitySafetyHealthcare).

matchedPolicyUid(S, Uid) :- primary_policy_match(S), policyUid(policyPrimary, Uid).
matchedPolicyUid(S, Uid) :- qi_policy_match(S), policyUid(policyQi, Uid).
matchedPolicyUid(S, Uid) :- research_policy_match(S), policyUid(policyResearch, Uid).
matchedProhibition(S, policyDenyInsurance) :- insurance_prohibition_match(S).

reason(S, "Permitted: clinician in the patient's care team, and the primary-care policy matched.") :- primary_policy_match(S).
reason(S, "Permitted: ODRL/DPV policy matched for secondary use.") :- qi_policy_match(S).
reason(S, "Permitted: subject opted in and an ODRL/DPV policy matched (anonymised dataset in secure environment).") :- research_policy_match(S).
reason(S, "Denied: the requested purpose (insurance management) is prohibited by policy.") :- insurance_prohibition_match(S).
reason(S, "Denied: you opted out of your data being used to train AI systems.") :- ai_training_opt_out_match(S).
reason(scenarioC, "Denied: no policy matched (purpose, environment, TOMs, or categories out of scope).") :- purpose(scenarioC, ensureQualitySafetyHealthcare).

trace(S, "permit:primary_care_allowed") :- primary_policy_match(S).
trace(S, "urn:policy:primary-care-001:permit:odrl:permission_matched") :- primary_policy_match(S).
trace(S, "urn:policy:qi-2025-aurora:permit:odrl:permission_matched") :- qi_policy_match(S).
trace(S, "urn:policy:research-aurora-diabetes:permit:odrl:permission_matched") :- research_policy_match(S).
trace(S, "deny:prohibited_purpose") :- insurance_prohibition_match(S).
trace(S, "urn:policy:deny-insurance:deny:odrl:prohibition_matched") :- insurance_prohibition_match(S).
trace(S, "deny:subject_opted_out_ai_training") :- ai_training_opt_out_match(S).
trace(scenarioC, "urn:policy:qi-2025-aurora:deny:odrl:no_permission_matched") :- purpose(scenarioC, ensureQualitySafetyHealthcare).

% C1-C10 below are the ARC-style checklist lines from the upstream output.
checkC1(scenarioA, "SKIPPED - not a prohibited purpose") :- decision(scenarioA, "PERMIT").
checkC2(scenarioA, "OK - clinician") :- decision(scenarioA, "PERMIT").
checkC3(scenarioA, "OK - care-team linked") :- decision(scenarioA, "PERMIT").
checkC4(scenarioA, "SKIPPED") :- decision(scenarioA, "PERMIT").
checkC5(scenarioA, "OK - operator=isAnyOf, allowed=[\"https://example.org/health#PATIENT_SUMMARY\", \"https://example.org/health#LAB_RESULTS\"], requested=[\"https://example.org/health#PATIENT_SUMMARY\"]") :- decision(scenarioA, "PERMIT").
checkC6(scenarioA, "SKIPPED - no prohibition matched") :- decision(scenarioA, "PERMIT").
checkC7(scenarioA, "OK - trace shows matching permission") :- decision(scenarioA, "PERMIT").
checkC8(scenarioA, "SKIPPED - no matched policy or no duties") :- decision(scenarioA, "PERMIT").
checkC9(scenarioA, "SKIPPED - policy has no environment constraint") :- decision(scenarioA, "PERMIT").
checkC10Text(scenarioA, "INFO - matched policy: urn:policy:primary-care-001") :- decision(scenarioA, "PERMIT").

checkC1(scenarioB, "SKIPPED - not a prohibited purpose") :- decision(scenarioB, "PERMIT").
checkC2(scenarioB, "SKIPPED") :- decision(scenarioB, "PERMIT").
checkC3(scenarioB, "SKIPPED") :- decision(scenarioB, "PERMIT").
checkC4(scenarioB, "OK - opt-in present and policy matched") :- decision(scenarioB, "PERMIT").
checkC5(scenarioB, "OK - operator=isAllOf, allowed=[\"https://example.org/health#LAB_RESULTS\", \"https://example.org/health#PATIENT_SUMMARY\"], requested=[\"https://example.org/health#LAB_RESULTS\", \"https://example.org/health#PATIENT_SUMMARY\"]") :- decision(scenarioB, "PERMIT").
checkC6(scenarioB, "SKIPPED - no prohibition matched") :- decision(scenarioB, "PERMIT").
checkC7(scenarioB, "OK - trace shows matching permission") :- decision(scenarioB, "PERMIT").
checkC8(scenarioB, "INFO - duties attached: duty:https://w3id.org/dpv/legal/eu/ehds#requireConsent, duty:https://w3id.org/dpv/legal/eu/ehds#noExfiltration") :- decision(scenarioB, "PERMIT").
checkC9(scenarioB, "OK - operator=eq, allowed=\"secure_env\", requested=\"secure_env\"") :- decision(scenarioB, "PERMIT").
checkC10Text(scenarioB, "INFO - matched policy: urn:policy:qi-2025-aurora") :- decision(scenarioB, "PERMIT").

checkC1(scenarioC, "SKIPPED - not a prohibited purpose") :- decision(scenarioC, "DENY").
checkC2(scenarioC, "SKIPPED") :- decision(scenarioC, "DENY").
checkC3(scenarioC, "SKIPPED") :- decision(scenarioC, "DENY").
checkC4(scenarioC, "OK - denied because opt-in missing or no policy match") :- decision(scenarioC, "DENY").
checkC5(scenarioC, "SKIPPED") :- decision(scenarioC, "DENY").
checkC6(scenarioC, "SKIPPED - no prohibition matched") :- decision(scenarioC, "DENY").
checkC7(scenarioC, "SKIPPED") :- decision(scenarioC, "DENY").
checkC8(scenarioC, "SKIPPED - no matched policy or no duties") :- decision(scenarioC, "DENY").
checkC9(scenarioC, "SKIPPED") :- decision(scenarioC, "DENY").
checkC10Text(scenarioC, "SKIPPED - no matched policy") :- decision(scenarioC, "DENY").

checkC1(scenarioD, "OK - denied prohibited purpose") :- decision(scenarioD, "DENY").
checkC2(scenarioD, "SKIPPED") :- decision(scenarioD, "DENY").
checkC3(scenarioD, "SKIPPED") :- decision(scenarioD, "DENY").
checkC4(scenarioD, "SKIPPED") :- decision(scenarioD, "DENY").
checkC5(scenarioD, "SKIPPED") :- decision(scenarioD, "DENY").
checkC6(scenarioD, "OK - denied due to prohibition") :- decision(scenarioD, "DENY").
checkC7(scenarioD, "SKIPPED") :- decision(scenarioD, "DENY").
checkC8(scenarioD, "SKIPPED - no matched policy or no duties") :- decision(scenarioD, "DENY").
checkC9(scenarioD, "SKIPPED") :- decision(scenarioD, "DENY").
checkC10Text(scenarioD, "SKIPPED - no matched policy") :- decision(scenarioD, "DENY").

checkC1(scenarioE, "SKIPPED - not a prohibited purpose") :- decision(scenarioE, "PERMIT").
checkC2(scenarioE, "OK - clinician") :- decision(scenarioE, "PERMIT").
checkC3(scenarioE, "OK - care-team linked") :- decision(scenarioE, "PERMIT").
checkC4(scenarioE, "SKIPPED") :- decision(scenarioE, "PERMIT").
checkC5(scenarioE, "OK - operator=isAnyOf, allowed=[\"https://example.org/health#PATIENT_SUMMARY\", \"https://example.org/health#LAB_RESULTS\"], requested=[\"https://example.org/health#LAB_RESULTS\"]") :- decision(scenarioE, "PERMIT").
checkC6(scenarioE, "SKIPPED - no prohibition matched") :- decision(scenarioE, "PERMIT").
checkC7(scenarioE, "OK - trace shows matching permission") :- decision(scenarioE, "PERMIT").
checkC8(scenarioE, "SKIPPED - no matched policy or no duties") :- decision(scenarioE, "PERMIT").
checkC9(scenarioE, "SKIPPED - policy has no environment constraint") :- decision(scenarioE, "PERMIT").
checkC10Text(scenarioE, "INFO - matched policy: urn:policy:primary-care-001") :- decision(scenarioE, "PERMIT").

checkC1(scenarioF, "SKIPPED - not a prohibited purpose") :- decision(scenarioF, "PERMIT").
checkC2(scenarioF, "SKIPPED") :- decision(scenarioF, "PERMIT").
checkC3(scenarioF, "SKIPPED") :- decision(scenarioF, "PERMIT").
checkC4(scenarioF, "OK - opt-in present and policy matched") :- decision(scenarioF, "PERMIT").
checkC5(scenarioF, "OK - operator=isAnyOf, allowed=[\"https://example.org/health#LAB_RESULTS\", \"https://example.org/health#PATIENT_SUMMARY\", \"https://example.org/health#IMAGING_REPORT\"], requested=[\"https://example.org/health#PATIENT_SUMMARY\", \"https://example.org/health#LAB_RESULTS\"]") :- decision(scenarioF, "PERMIT").
checkC6(scenarioF, "SKIPPED - no prohibition matched") :- decision(scenarioF, "PERMIT").
checkC7(scenarioF, "OK - trace shows matching permission") :- decision(scenarioF, "PERMIT").
checkC8(scenarioF, "INFO - duties attached: duty:https://w3id.org/dpv/legal/eu/ehds#annualOutcomeReport, duty:https://w3id.org/dpv/legal/eu/ehds#noReidentification, duty:https://w3id.org/dpv/legal/eu/ehds#noExfiltration") :- decision(scenarioF, "PERMIT").
checkC9(scenarioF, "OK - operator=eq, allowed=\"secure_env\", requested=\"secure_env\"") :- decision(scenarioF, "PERMIT").
checkC10Text(scenarioF, "INFO - matched policy: urn:policy:research-aurora-diabetes") :- decision(scenarioF, "PERMIT").

checkC1(scenarioG, "SKIPPED - not a prohibited purpose") :- decision(scenarioG, "DENY").
checkC2(scenarioG, "SKIPPED") :- decision(scenarioG, "DENY").
checkC3(scenarioG, "SKIPPED") :- decision(scenarioG, "DENY").
checkC4(scenarioG, "OK - denied because opt-in missing or no policy match") :- decision(scenarioG, "DENY").
checkC5(scenarioG, "SKIPPED") :- decision(scenarioG, "DENY").
checkC6(scenarioG, "SKIPPED - no prohibition matched") :- decision(scenarioG, "DENY").
checkC7(scenarioG, "SKIPPED") :- decision(scenarioG, "DENY").
checkC8(scenarioG, "SKIPPED - no matched policy or no duties") :- decision(scenarioG, "DENY").
checkC9(scenarioG, "SKIPPED") :- decision(scenarioG, "DENY").
checkC10Text(scenarioG, "SKIPPED - no matched policy") :- decision(scenarioG, "DENY").
