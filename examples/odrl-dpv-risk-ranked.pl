% ODRL + DPV ranked-risk assessment adapted from Eyeling odrl-dpv-risk-ranked.n3.
% Eyeling keeps the ODRL rules inside an N3 quoted policy formula and prints a
% Markdown report.  This webentail translation also keeps the
% policy as a formula-valued term, projects local predicates from that formula for
% reasoning, and querys the derived DPV risks as relation output.

% Consumer profile and needs.
% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: dct_title(X0, X1)

%% goal: dpv_hasRisk(X0, X1)

%% goal: type(X0, X1)

%% goal: policyGraph(X0, X1)

%% goal: contains(X0, X1)

%% goal: source(X0, X1)

%% goal: profile(X0, X1)

%% goal: firstRisk(X0, X1)

%% goal: before(X0, X1)

%% goal: dct_source(X0, X1)

%% goal: risk_hasRiskSource(X0, X1)

%% goal: dpv_hasConsequence(X0, X1)

%% goal: dpv_hasImpact(X0, X1)

%% goal: aboutClause(X0, X1)

%% goal: violatesNeed(X0, X1)

%% goal: scoreRaw(X0, X1)

%% goal: score(X0, X1)

%% goal: dpv_hasSeverity(X0, X1)

%% goal: dpv_hasRiskLevel(X0, X1)

%% goal: dct_description(X0, X1)

%% goal: reportKey(X0, X1)

%% goal: dpv_isMitigatedByMeasure(X0, X1)

%% goal: dpv_mitigatesRisk(X0, X1)

%% goal: clauseId(X0, X1)

%% goal: text(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
consumer(consumerExample).
title(consumerExample, "Example consumer profile").
has_need(consumerExample, need_DataCannotBeRemoved).
has_need(consumerExample, need_ChangeOnlyWithPriorNotice).
has_need(consumerExample, need_NoSharingWithoutConsent).
has_need(consumerExample, need_DataPortability).

importance(need_DataCannotBeRemoved, 20).
description(need_DataCannotBeRemoved, "Provider must not remove the consumer account/data.").
importance(need_ChangeOnlyWithPriorNotice, 15).
min_notice_days(need_ChangeOnlyWithPriorNotice, 14).
description(need_ChangeOnlyWithPriorNotice, "Agreement may change only with prior notice (>= 14 days).").
importance(need_NoSharingWithoutConsent, 12).
description(need_NoSharingWithoutConsent, "No data sharing without explicit consent.").
importance(need_DataPortability, 10).
description(need_DataPortability, "Consumer must be able to export their data.").

% Agreement and ODRL-style policy structure.
agreement(agreement1).
title(agreement1, "Example Agreement").
process_context(processContext1, agreement1).
title(processContext1, "Service operation under Agreement1").

% The ODRL policy is kept as a graph value.  The clauses below are not asserted
% globally as permission/2, prohibition/2, action/2, ... facts; they are
% binary terms inside policyGraph1.  The local projection predicates below read from the
% formula when evaluating this agreement.  This mirrors N3 quoted formulae and avoids
% making policy statements true outside the formula that contains them.
policy_graph(policyGraph1, (
  type(policy1, odrl_Policy),
  odrl_appliesTo(policy1, agreement1),
  odrl_permission(policy1, permDeleteAccount),
  odrl_permission(policy1, permChangeTerms),
  odrl_permission(policy1, permShareData),
  odrl_prohibition(policy1, prohibitExportData),

  odrl_assigner(permDeleteAccount, provider),
  odrl_assignee(permDeleteAccount, consumerExample),
  odrl_action(permDeleteAccount, tosl_removeAccount),
  odrl_target(permDeleteAccount, userAccount),
  clause(permDeleteAccount, clauseC1),

  odrl_assigner(permChangeTerms, provider),
  odrl_assignee(permChangeTerms, consumerExample),
  odrl_action(permChangeTerms, tosl_changeTerms),
  odrl_target(permChangeTerms, agreementText),
  clause(permChangeTerms, clauseC2),
  odrl_duty(permChangeTerms, odrl_inform),
  noticeDays(permChangeTerms, 3),

  odrl_assigner(permShareData, provider),
  odrl_assignee(permShareData, consumerExample),
  odrl_action(permShareData, tosl_shareData),
  odrl_target(permShareData, userData),
  clause(permShareData, clauseC3),

  odrl_assigner(prohibitExportData, provider),
  odrl_assignee(prohibitExportData, consumerExample),
  odrl_action(prohibitExportData, tosl_exportData),
  odrl_target(prohibitExportData, userData),
  clause(prohibitExportData, clauseC4)
)).

context_member((Left, _right), Member) :- context_member(Left, Member).
context_member((_left, Right), Member) :- context_member(Right, Member).
context_member(Member, Member) :- Member \= (_left, _right).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
policy_statement(Subject, Predicate, Object) :-
  policy_graph(_graph, Context),
  context_member(Context, Statement),
  (Statement =.. [Predicate, Subject, Object]).

policy(Policy, Agreement) :- policy_statement(Policy, odrl_appliesTo, Agreement).
permission(Policy, Rule) :- policy_statement(Policy, odrl_permission, Rule).
prohibition(Policy, Rule) :- policy_statement(Policy, odrl_prohibition, Rule).
assigner(Rule, Party) :- policy_statement(Rule, odrl_assigner, Party).
assignee(Rule, Party) :- policy_statement(Rule, odrl_assignee, Party).
action(Rule, Action) :- policy_statement(Rule, odrl_action, Action).
target(Rule, Target) :- policy_statement(Rule, odrl_target, Target).
clause(Rule, Clause) :- policy_statement(Rule, clause, Clause).
duty(Rule, Duty) :- policy_statement(Rule, odrl_duty, Duty).
notice_days(Rule, Days) :- policy_statement(Rule, noticeDays, Days).
consent_constraint(Rule, Value) :- policy_statement(Rule, consentConstraint, Value).

clause_id(clauseC1, "C1").
clause_text(clauseC1, "Provider may remove the user account (and associated data) at its discretion.").
clause_id(clauseC2, "C2").
clause_text(clauseC2, "Provider may change terms by informing users at least 3 days in advance.").
clause_id(clauseC3, "C3").
clause_text(clauseC3, "Provider may share user data with partners for business purposes.").
clause_id(clauseC4, "C4").
clause_text(clauseC4, "Users are not permitted to export their data.").

% Missing-safeguard checks corresponding to the log_notIncludes tests in N3.
missing_notice_constraint(Perm) :-
  permission(policy1, Perm),
  \+ notice_days(Perm, _days).

missing_inform_duty(Perm) :-
  permission(policy1, Perm),
  \+ duty(Perm, odrl_inform).

missing_consent_constraint(Perm) :-
  permission(policy1, Perm),
  action(Perm, tosl_shareData),
  \+ consent_constraint(Perm, true).

% ODRL -> DPV risk derivation.
risk(risk1) :-
  has_need(consumerExample, need_DataCannotBeRemoved),
  permission(policy1, permDeleteAccount),
  action(permDeleteAccount, tosl_removeAccount),
  missing_notice_constraint(permDeleteAccount),
  missing_inform_duty(permDeleteAccount).

risk_source(risk1, src1).
risk_class(risk1, risk_UnwantedDataDeletion).
risk_class(risk1, risk_DataUnavailable).
risk_class(risk1, risk_DataErasureError).
risk_class(risk1, risk_DataLoss).
risk_source_class(src1, risk_LegalComplianceRisk).
risk_source_of(src1, permDeleteAccount).
risk_consequence(risk1, risk_DataLoss).
risk_consequence(risk1, risk_DataUnavailable).
risk_consequence(risk1, risk_CustomerConfidenceLoss).
risk_impact(risk1, risk_FinancialLoss).
risk_impact(risk1, risk_NonMaterialDamage).
about_clause(risk1, clauseC1).
violates_need(risk1, need_DataCannotBeRemoved).
risk_description(risk1, "Risk: account/data removal is permitted without notice safeguards (no notice constraint and no duty to inform). Clause C1: Provider may remove the user account (and associated data) at its discretion.").
base_score(risk1, 90).
mitigation(risk1, m11, "Add a notice constraint (minimum noticeDays) before account removal.").
mitigation(risk1, m21, "Add a duty to inform the consumer prior to account removal.").

risk(risk2) :-
  has_need(consumerExample, need_ChangeOnlyWithPriorNotice),
  min_notice_days(need_ChangeOnlyWithPriorNotice, Required),
  permission(policy1, permChangeTerms),
  action(permChangeTerms, tosl_changeTerms),
  duty(permChangeTerms, odrl_inform),
  notice_days(permChangeTerms, Days),
  (Days < Required).

risk_source(risk2, src2).
risk_class(risk2, risk_PolicyRisk).
risk_class(risk2, risk_CustomerConfidenceLoss).
risk_source_class(src2, risk_PolicyRisk).
risk_source_of(src2, permChangeTerms).
risk_consequence(risk2, risk_CustomerConfidenceLoss).
risk_impact(risk2, risk_NonMaterialDamage).
about_clause(risk2, clauseC2).
violates_need(risk2, need_ChangeOnlyWithPriorNotice).
risk_description(risk2, "Risk: terms may change with notice (3 days) below consumer requirement (14 days). Clause C2: Provider may change terms by informing users at least 3 days in advance.").
base_score(risk2, 70).
mitigation(risk2, m12, "Increase minimum noticeDays in the inform duty to meet the consumer requirement.").

risk(risk3) :-
  has_need(consumerExample, need_NoSharingWithoutConsent),
  permission(policy1, permShareData),
  action(permShareData, tosl_shareData),
  missing_consent_constraint(permShareData).

risk_source(risk3, src3).
risk_class(risk3, risk_UnwantedDisclosureData).
risk_class(risk3, risk_CustomerConfidenceLoss).
risk_source_class(src3, risk_PolicyRisk).
risk_source_of(src3, permShareData).
risk_consequence(risk3, risk_CustomerConfidenceLoss).
risk_impact(risk3, risk_NonMaterialDamage).
risk_impact(risk3, risk_FinancialLoss).
about_clause(risk3, clauseC3).
violates_need(risk3, need_NoSharingWithoutConsent).
risk_description(risk3, "Risk: user data sharing is permitted without an explicit consent constraint. Clause C3: Provider may share user data with partners for business purposes.").
base_score(risk3, 85).
mitigation(risk3, m13, "Add an explicit consent constraint before data sharing.").

risk(risk4) :-
  has_need(consumerExample, need_DataPortability),
  prohibition(policy1, prohibitExportData),
  action(prohibitExportData, tosl_exportData).

risk_source(risk4, src4).
risk_class(risk4, risk_PolicyRisk).
risk_class(risk4, risk_CustomerConfidenceLoss).
risk_source_class(src4, risk_PolicyRisk).
risk_source_of(src4, prohibitExportData).
risk_consequence(risk4, risk_CustomerConfidenceLoss).
risk_impact(risk4, risk_NonMaterialDamage).
about_clause(risk4, clauseC4).
violates_need(risk4, need_DataPortability).
risk_description(risk4, "Risk: portability is restricted because exporting user data is prohibited. Clause C4: Users are not permitted to export their data.").
base_score(risk4, 60).
mitigation(risk4, m14, "Add a permission allowing data export (or remove the prohibition) to support portability.").

score_raw(Risk, Raw) :-
  risk(Risk),
  base_score(Risk, Base),
  violates_need(Risk, Need),
  importance(Need, Weight),
  (Raw is Base + Weight).

score(Risk, 100) :-
  score_raw(Risk, Raw),
  (Raw > 100).

score(Risk, Raw) :-
  score_raw(Risk, Raw),
  (100 >= Raw).

severity(Risk, risk_HighSeverity) :-
  score(Risk, Score),
  (Score > 79).

risk_level(Risk, risk_HighRisk) :-
  score(Risk, Score),
  (Score > 79).

severity(Risk, risk_ModerateSeverity) :-
  score(Risk, Score),
  (Score < 80),
  (Score > 49).

risk_level(Risk, risk_ModerateRisk) :-
  score(Risk, Score),
  (Score < 80),
  (Score > 49).

severity(Risk, risk_LowSeverity) :-
  score(Risk, Score),
  (Score < 50).

risk_level(Risk, risk_LowRisk) :-
  score(Risk, Score),
  (Score < 50).

report_key(Risk, key(Invscore, Clauseid)) :-
  risk(Risk),
  score(Risk, Score),
  (Invscore is 1000 - Score),
  about_clause(Risk, Clause),
  clause_id(Clause, Clauseid).

ranked_before(Left, Right) :-
  report_key(Left, key(Leftinv, _leftclause)),
  report_key(Right, key(Rightinv, _rightclause)),
  (Leftinv < Rightinv).

ranked_before(Left, Right) :-
  report_key(Left, key(Inv, Leftclause)),
  report_key(Right, key(Inv, Rightclause)),
  \+ matches(Leftclause, Rightclause),
  (Leftclause @< Rightclause).

% Output layer.
dct_title(agreement1, Title) :- title(agreement1, Title).
dct_title(consumerExample, Title) :- title(consumerExample, Title).
dct_title(processContext1, Title) :- title(processContext1, Title).
dpv_hasRisk(processContext1, Risk) :- risk(Risk).
type(policyGraph1, policyGraph).
policyGraph(agreement1, policyGraph1).
contains(policyGraph1, statement(Subject, Predicate, Object)) :-
  policy_statement(Subject, Predicate, Object).
source(report, agreement1).
profile(report, consumerExample).
firstRisk(report, Risk) :- risk(Risk), \+ ranked_before(_other, Risk).
before(riskRanking, pair(Left, Right)) :- ranked_before(Left, Right).

type(Risk, dpv_Risk) :- risk(Risk).
type(Risk, Class) :- risk(Risk), risk_class(Risk, Class).
dct_source(Risk, Source) :- risk(Risk), risk_source(Risk, Src), risk_source_of(Src, Source).
risk_hasRiskSource(Risk, Src) :- risk(Risk), risk_source(Risk, Src).
type(Src, risk_RiskSource) :- risk_source(_risk, Src).
type(Src, Class) :- risk_source_class(Src, Class).
dct_source(Src, Source) :- risk_source_of(Src, Source).
dpv_hasConsequence(Risk, Consequence) :- risk(Risk), risk_consequence(Risk, Consequence).
dpv_hasImpact(Risk, Impact) :- risk(Risk), risk_impact(Risk, Impact).
aboutClause(Risk, Clause) :- risk(Risk), about_clause(Risk, Clause).
violatesNeed(Risk, Need) :- risk(Risk), violates_need(Risk, Need).
scoreRaw(Risk, Raw) :- score_raw(Risk, Raw).
dpv_hasSeverity(Risk, Severity) :- severity(Risk, Severity).
dpv_hasRiskLevel(Risk, Level) :- risk_level(Risk, Level).
dct_description(Risk, Text) :- risk(Risk), risk_description(Risk, Text).
reportKey(Risk, Key) :- report_key(Risk, Key).
dpv_isMitigatedByMeasure(Risk, Measure) :- mitigation(Risk, Measure, _text).
type(Measure, dpv_RiskMitigationMeasure) :- mitigation(_risk, Measure, _text).
dpv_mitigatesRisk(Measure, Risk) :- mitigation(Risk, Measure, _text).
dct_description(Measure, Text) :- mitigation(_risk, Measure, Text).
clauseId(Clause, Id) :- clause_id(Clause, Id).
text(Clause, Text) :- clause_text(Clause, Text).
