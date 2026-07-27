% ODRL + DPV healthcare risk ranking adapted from Eyeling.
%
% The scenario models a healthcare data-use agreement, patient needs, processing
% clauses, risk scores, and mitigation suggestions.  Rules derive violations, raw
% and normalized scores, risk levels, and small formula-valued suggestion graphs.
%
% This is one of the richer policy examples: it combines structured policy data,
% ranked risk computation, and report-oriented query execution.
% Output declarations: query/1 selects the relations written to this example's golden output.
query(policyGraph(X0, X1)).
query(contains(X0, X1)).
query(dpv_hasRisk(X0, X1)).
query(type(X0, X1)).
query(scoreRaw(X0, X1)).
query(score(X0, X1)).
query(dpv_hasRiskLevel(X0, X1)).
query(dpv_hasSeverity(X0, X1)).
query(aboutClause(X0, X1)).
query(violatesNeed(X0, X1)).
query(dct_source(X0, X1)).
query(dct_description(X0, X1)).
query(reportKey(X0, X1)).
query(dpv_isMitigatedByMeasure(X0, X1)).
query(suggestAddGraph(X0, X1)).
query(firstRisk(X0, X1)).
query(retentionRiskScore(X0, X1)).

% Program structure: facts set up the scenario, and rules derive the queried conclusions.
party(hospital).
party(researchUnit).
party(pharmaPartner).
party(clinicalAIService).
data_asset(healthRecordData).
data_asset(genomicData).
process(processContextHC1).

title(agreementHC1, "Example Healthcare & Life-Sciences Data Use Agreement").
title(patientExample, "Example patient profile").

has_need(patientExample, need_ConsentForResearch).
has_need(patientExample, need_DeIdentifyBeforeSharing).
has_need(patientExample, need_HumanReviewForAutomatedTriage).
has_need(patientExample, need_RetentionLimit3y).

importance(need_ConsentForResearch, 35).
importance(need_DeIdentifyBeforeSharing, 35).
importance(need_HumanReviewForAutomatedTriage, 25).
importance(need_RetentionLimit3y, 15).
max_retention_days(need_RetentionLimit3y, 1095).

clause_id(clauseH1, "H1").
clause_text(clauseH1, "Hospital may use EHR and genomic data for internal clinical research and publication.").
clause_id(clauseH2, "H2").
clause_text(clauseH2, "Hospital may share genomic data with pharmaceutical partners for drug discovery and R&D.").
clause_id(clauseH3, "H3").
clause_text(clauseH3, "Hospital may use automated triage and prioritisation systems using EHR data.").
clause_id(clauseH4, "H4").
clause_text(clauseH4, "Hospital retains patient health records for 10 years.").

agreement_policy_graph(agreementHC1, policyGraphHC1).

policy_graph(policyGraphHC1, (
  type(policyHC1, odrl_Policy),
  odrl_permission(policyHC1, permResearchUse),
  odrl_permission(policyHC1, permShareWithPharma),
  odrl_permission(policyHC1, permAutomatedTriage),
  odrl_permission(policyHC1, permRetention10y),

  type(permResearchUse, odrl_Permission),
  odrl_assigner(permResearchUse, hospital),
  odrl_assignee(permResearchUse, researchUnit),
  odrl_action(permResearchUse, hl7ca_use),
  odrl_target(permResearchUse, healthRecordData),
  odrl_target(permResearchUse, genomicData),
  odrl_constraint(permResearchUse, cResearchPurpose),
  odrl_leftOperand(cResearchPurpose, odrl_purpose),
  odrl_rightOperandReference(cResearchPurpose, purposeHMB),
  clause(permResearchUse, clauseH1),

  type(permShareWithPharma, odrl_Permission),
  odrl_assigner(permShareWithPharma, hospital),
  odrl_assignee(permShareWithPharma, pharmaPartner),
  odrl_action(permShareWithPharma, hl7ca_disclose),
  odrl_target(permShareWithPharma, genomicData),
  odrl_constraint(permShareWithPharma, cSharePurpose),
  odrl_leftOperand(cSharePurpose, odrl_purpose),
  odrl_rightOperandReference(cSharePurpose, purposeHMB),
  clause(permShareWithPharma, clauseH2),

  type(permAutomatedTriage, odrl_Permission),
  odrl_assigner(permAutomatedTriage, hospital),
  odrl_assignee(permAutomatedTriage, clinicalAIService),
  odrl_action(permAutomatedTriage, hl7ca_use),
  odrl_target(permAutomatedTriage, healthRecordData),
  odrl_constraint(permAutomatedTriage, cTriagePurpose),
  odrl_leftOperand(cTriagePurpose, odrl_purpose),
  odrl_rightOperandReference(cTriagePurpose, purposeCC),
  odrl_duty(permAutomatedTriage, dutyHumanReview),
  odrl_action(dutyHumanReview, humanReview),
  odrl_constraint(dutyHumanReview, cTriageEncryption),
  odrl_leftOperand(cTriageEncryption, encryptionAtRest),
  odrl_rightOperand(cTriageEncryption, true),
  clause(permAutomatedTriage, clauseH3),

  type(permRetention10y, odrl_Permission),
  odrl_assigner(permRetention10y, hospital),
  odrl_assignee(permRetention10y, hospital),
  odrl_action(permRetention10y, hl7ca_collect),
  odrl_target(permRetention10y, healthRecordData),
  odrl_constraint(permRetention10y, cRetentionPurpose),
  odrl_leftOperand(cRetentionPurpose, odrl_purpose),
  odrl_rightOperandReference(cRetentionPurpose, purposeCC),
  odrl_constraint(permRetention10y, cRetentionDays),
  odrl_leftOperand(cRetentionDays, retentionDays),
  odrl_rightOperand(cRetentionDays, 3650),
  clause(permRetention10y, clauseH4)
)).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
policy_statement(Graphname, Subject, Predicate, Object) :-
  policy_graph(Graphname, Context),
  holds(Context, Predicate, [Subject, Object]).

permission(Graph, Permission) :- policy_statement(Graph, policyHC1, odrl_permission, Permission).
clause(Graph, Permission, Clause) :- policy_statement(Graph, Permission, clause, Clause).
action(Graph, Permission, Action) :- policy_statement(Graph, Permission, odrl_action, Action).
target(Graph, Permission, Target) :- policy_statement(Graph, Permission, odrl_target, Target).
duty(Graph, Permission, Duty) :- policy_statement(Graph, Permission, odrl_duty, Duty).
duty_action(Graph, Duty, Action) :- policy_statement(Graph, Duty, odrl_action, Action).
constraint(Graph, Permission, Constraint) :- policy_statement(Graph, Permission, odrl_constraint, Constraint).
constraint_left(Graph, Constraint, Left) :- policy_statement(Graph, Constraint, odrl_leftOperand, Left).
constraint_right(Graph, Constraint, Right) :- policy_statement(Graph, Constraint, odrl_rightOperand, Right).

has_constraint(Graph, Permission, Left, Right) :-
  constraint(Graph, Permission, Constraint),
  constraint_left(Graph, Constraint, Left),
  constraint_right(Graph, Constraint, Right).

has_duty_action(Graph, Permission, Action) :-
  duty(Graph, Permission, Duty),
  duty_action(Graph, Duty, Action).

missing_explicit_consent(Graph, Permission) :-
  permission(Graph, Permission),
  \+ has_constraint(Graph, Permission, explicitConsent, true).

missing_deidentified(Graph, Permission) :-
  permission(Graph, Permission),
  \+ has_constraint(Graph, Permission, deIdentified, true).

missing_human_review(Graph, Permission) :-
  permission(Graph, Permission),
  \+ has_duty_action(Graph, Permission, humanReview).

retention_days(Graph, Permission, Days) :-
  has_constraint(Graph, Permission, retentionDays, Days).

risk(riskH1) :-
  agreement_policy_graph(agreementHC1, Graph),
  has_need(patientExample, need_ConsentForResearch),
  permission(Graph, permResearchUse),
  clause(Graph, permResearchUse, clauseH1),
  missing_explicit_consent(Graph, permResearchUse).

risk(riskH2) :-
  agreement_policy_graph(agreementHC1, Graph),
  has_need(patientExample, need_DeIdentifyBeforeSharing),
  permission(Graph, permShareWithPharma),
  target(Graph, permShareWithPharma, genomicData),
  clause(Graph, permShareWithPharma, clauseH2),
  missing_deidentified(Graph, permShareWithPharma).

risk(riskH3) :-
  agreement_policy_graph(agreementHC1, Graph),
  has_need(patientExample, need_HumanReviewForAutomatedTriage),
  permission(Graph, permAutomatedTriage),
  clause(Graph, permAutomatedTriage, clauseH3),
  missing_human_review(Graph, permAutomatedTriage).

risk(riskH4) :-
  agreement_policy_graph(agreementHC1, Graph),
  has_need(patientExample, need_RetentionLimit3y),
  max_retention_days(need_RetentionLimit3y, Max),
  permission(Graph, permRetention10y),
  clause(Graph, permRetention10y, clauseH4),
  retention_days(Graph, permRetention10y, Days),
  (Days > Max).

base_score(riskH1, 85).
base_score(riskH2, 90).
base_score(riskH3, 80).
base_score(riskH4, 55).
violates_need(riskH1, need_ConsentForResearch).
violates_need(riskH2, need_DeIdentifyBeforeSharing).
violates_need(riskH3, need_HumanReviewForAutomatedTriage).
violates_need(riskH4, need_RetentionLimit3y).
about_clause(riskH1, clauseH1).
about_clause(riskH2, clauseH2).
about_clause(riskH3, clauseH3).
about_clause(riskH4, clauseH4).
risk_source_of(riskH1, permResearchUse).
risk_source_of(riskH2, permShareWithPharma).
risk_source_of(riskH3, permAutomatedTriage).
risk_source_of(riskH4, permRetention10y).

description(riskH1, "Risk: health/genomic data may be used for research without explicit opt-in consent.").
description(riskH2, "Risk: genomic data may be shared with external pharma partners without a de-identification/pseudonymisation requirement.").
description(riskH3, "Risk: automated triage may affect care pathways without a human review/override safeguard.").
description(riskH4, "Risk: retention (3650 days) exceeds patient preference (1095 days).").

mitigation_graph(riskH1, mitigateConsent, (
  odrl_constraint(permResearchUse, cExplicitConsent),
  odrl_leftOperand(cExplicitConsent, explicitConsent),
  odrl_rightOperand(cExplicitConsent, true)
)).
mitigation_graph(riskH2, mitigateDeId, (
  odrl_constraint(permShareWithPharma, cDeIdentified),
  odrl_leftOperand(cDeIdentified, deIdentified),
  odrl_rightOperand(cDeIdentified, true),
  odrl_duty(permShareWithPharma, dutyDeIdentify),
  odrl_action(dutyDeIdentify, deIdentify)
)).
mitigation_graph(riskH3, mitigateHumanReview, (
  odrl_duty(permAutomatedTriage, dutyHumanReview),
  odrl_action(dutyHumanReview, humanReview)
)).
mitigation_graph(riskH4, mitigateRetention, (
  odrl_constraint(permRetention10y, cRetentionLimit),
  odrl_leftOperand(cRetentionLimit, retentionDays),
  odrl_rightOperand(cRetentionLimit, 1095)
)).

score_raw(Risk, Raw) :-
  risk(Risk),
  base_score(Risk, Base),
  violates_need(Risk, Need),
  importance(Need, Weight),
  (Raw is Base + Weight).

score(Risk, 100) :- score_raw(Risk, Raw), (Raw > 100).
score(Risk, Raw) :- score_raw(Risk, Raw), (100 >= Raw).

severity(Risk, risk_HighSeverity) :- score(Risk, Score), (Score > 79).
severity(Risk, risk_ModerateSeverity) :- score(Risk, Score), (Score < 80), (Score > 49).
risk_level(Risk, risk_HighRisk) :- score(Risk, Score), (Score > 79).
risk_level(Risk, risk_ModerateRisk) :- score(Risk, Score), (Score < 80), (Score > 49).

report_key(Risk, Key) :- score(Risk, Score), (Key is 1000 - Score).

policyGraph(agreementHC1, Graphterm) :-
  agreement_policy_graph(agreementHC1, Graph),
  policy_graph(Graph, Graphterm).

contains(policyGraphHC1, statement(Subject, Predicate, Object)) :-
  policy_statement(policyGraphHC1, Subject, Predicate, Object).

dpv_hasRisk(processContextHC1, Risk) :- risk(Risk).
type(Risk, dpv_Risk) :- risk(Risk).
scoreRaw(Risk, Raw) :- score_raw(Risk, Raw).
dpv_hasRiskLevel(Risk, Level) :- risk_level(Risk, Level).
dpv_hasSeverity(Risk, Severity) :- severity(Risk, Severity).
aboutClause(Risk, Clause) :- risk(Risk), about_clause(Risk, Clause).
violatesNeed(Risk, Need) :- risk(Risk), violates_need(Risk, Need).
dct_source(Risk, Source) :- risk(Risk), risk_source_of(Risk, Source).
dct_description(Risk, Description) :- risk(Risk), description(Risk, Description).
reportKey(Risk, Key) :- report_key(Risk, Key).
dpv_isMitigatedByMeasure(Risk, Mitigation) :- risk(Risk), mitigation_graph(Risk, Mitigation, _graph).
suggestAddGraph(Mitigation, Graph) :- mitigation_graph(Risk, Mitigation, Graph), risk(Risk).
firstRisk(report, riskH1) :- score(riskH1, 100), score(riskH2, 100).
retentionRiskScore(report, Score) :- score(riskH4, Score).
