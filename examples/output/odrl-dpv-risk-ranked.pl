score(risk1, 100).
score(risk2, 85).
score(risk3, 97).
score(risk4, 70).
dct_title(agreement1, "Example Agreement").
dct_title(consumerExample, "Example consumer profile").
dct_title(processContext1, "Service operation under Agreement1").
dpv_hasRisk(processContext1, risk1).
dpv_hasRisk(processContext1, risk2).
dpv_hasRisk(processContext1, risk3).
dpv_hasRisk(processContext1, risk4).
type(risk1, dpv_Risk).
type(risk2, dpv_Risk).
type(risk3, dpv_Risk).
type(risk4, dpv_Risk).
type(risk1, risk_UnwantedDataDeletion).
type(risk1, risk_DataUnavailable).
type(risk1, risk_DataErasureError).
type(risk1, risk_DataLoss).
type(risk2, risk_PolicyRisk).
type(risk2, risk_CustomerConfidenceLoss).
type(risk3, risk_UnwantedDisclosureData).
type(risk3, risk_CustomerConfidenceLoss).
type(risk4, risk_PolicyRisk).
type(risk4, risk_CustomerConfidenceLoss).
type(src1, risk_RiskSource).
type(src2, risk_RiskSource).
type(src3, risk_RiskSource).
type(src4, risk_RiskSource).
type(src1, risk_LegalComplianceRisk).
type(src2, risk_PolicyRisk).
type(src3, risk_PolicyRisk).
type(src4, risk_PolicyRisk).
type(m11, dpv_RiskMitigationMeasure).
type(m21, dpv_RiskMitigationMeasure).
type(m12, dpv_RiskMitigationMeasure).
type(m13, dpv_RiskMitigationMeasure).
type(m14, dpv_RiskMitigationMeasure).
contains(policyGraph1, statement(policy1, type, odrl_Policy)).
contains(policyGraph1, statement(policy1, odrl_appliesTo, agreement1)).
contains(policyGraph1, statement(policy1, odrl_permission, permDeleteAccount)).
contains(policyGraph1, statement(policy1, odrl_permission, permChangeTerms)).
contains(policyGraph1, statement(policy1, odrl_permission, permShareData)).
contains(policyGraph1, statement(policy1, odrl_prohibition, prohibitExportData)).
contains(policyGraph1, statement(permDeleteAccount, odrl_assigner, provider)).
contains(policyGraph1, statement(permDeleteAccount, odrl_assignee, consumerExample)).
contains(policyGraph1, statement(permDeleteAccount, odrl_action, tosl_removeAccount)).
contains(policyGraph1, statement(permDeleteAccount, odrl_target, userAccount)).
contains(policyGraph1, statement(permDeleteAccount, clause, clauseC1)).
contains(policyGraph1, statement(permChangeTerms, odrl_assigner, provider)).
contains(policyGraph1, statement(permChangeTerms, odrl_assignee, consumerExample)).
contains(policyGraph1, statement(permChangeTerms, odrl_action, tosl_changeTerms)).
contains(policyGraph1, statement(permChangeTerms, odrl_target, agreementText)).
contains(policyGraph1, statement(permChangeTerms, clause, clauseC2)).
contains(policyGraph1, statement(permChangeTerms, odrl_duty, odrl_inform)).
contains(policyGraph1, statement(permChangeTerms, noticeDays, 3)).
contains(policyGraph1, statement(permShareData, odrl_assigner, provider)).
contains(policyGraph1, statement(permShareData, odrl_assignee, consumerExample)).
contains(policyGraph1, statement(permShareData, odrl_action, tosl_shareData)).
contains(policyGraph1, statement(permShareData, odrl_target, userData)).
contains(policyGraph1, statement(permShareData, clause, clauseC3)).
contains(policyGraph1, statement(prohibitExportData, odrl_assigner, provider)).
contains(policyGraph1, statement(prohibitExportData, odrl_assignee, consumerExample)).
contains(policyGraph1, statement(prohibitExportData, odrl_action, tosl_exportData)).
contains(policyGraph1, statement(prohibitExportData, odrl_target, userData)).
contains(policyGraph1, statement(prohibitExportData, clause, clauseC4)).
firstRisk(report, risk1).
before(riskRanking, pair(risk1, risk2)).
before(riskRanking, pair(risk1, risk3)).
before(riskRanking, pair(risk1, risk4)).
before(riskRanking, pair(risk2, risk4)).
before(riskRanking, pair(risk3, risk2)).
before(riskRanking, pair(risk3, risk4)).
dct_source(risk1, permDeleteAccount).
dct_source(risk2, permChangeTerms).
dct_source(risk3, permShareData).
dct_source(risk4, prohibitExportData).
dct_source(src1, permDeleteAccount).
dct_source(src2, permChangeTerms).
dct_source(src3, permShareData).
dct_source(src4, prohibitExportData).
risk_hasRiskSource(risk1, src1).
risk_hasRiskSource(risk2, src2).
risk_hasRiskSource(risk3, src3).
risk_hasRiskSource(risk4, src4).
dpv_hasConsequence(risk1, risk_DataLoss).
dpv_hasConsequence(risk1, risk_DataUnavailable).
dpv_hasConsequence(risk1, risk_CustomerConfidenceLoss).
dpv_hasConsequence(risk2, risk_CustomerConfidenceLoss).
dpv_hasConsequence(risk3, risk_CustomerConfidenceLoss).
dpv_hasConsequence(risk4, risk_CustomerConfidenceLoss).
dpv_hasImpact(risk1, risk_FinancialLoss).
dpv_hasImpact(risk1, risk_NonMaterialDamage).
dpv_hasImpact(risk2, risk_NonMaterialDamage).
dpv_hasImpact(risk3, risk_NonMaterialDamage).
dpv_hasImpact(risk3, risk_FinancialLoss).
dpv_hasImpact(risk4, risk_NonMaterialDamage).
aboutClause(risk1, clauseC1).
aboutClause(risk2, clauseC2).
aboutClause(risk3, clauseC3).
aboutClause(risk4, clauseC4).
violatesNeed(risk1, need_DataCannotBeRemoved).
violatesNeed(risk2, need_ChangeOnlyWithPriorNotice).
violatesNeed(risk3, need_NoSharingWithoutConsent).
violatesNeed(risk4, need_DataPortability).
scoreRaw(risk1, 110).
scoreRaw(risk2, 85).
scoreRaw(risk3, 97).
scoreRaw(risk4, 70).
dpv_hasSeverity(risk1, risk_HighSeverity).
dpv_hasSeverity(risk2, risk_HighSeverity).
dpv_hasSeverity(risk3, risk_HighSeverity).
dpv_hasSeverity(risk4, risk_ModerateSeverity).
dpv_hasRiskLevel(risk1, risk_HighRisk).
dpv_hasRiskLevel(risk2, risk_HighRisk).
dpv_hasRiskLevel(risk3, risk_HighRisk).
dpv_hasRiskLevel(risk4, risk_ModerateRisk).
dct_description(risk1, "Risk: account/data removal is permitted without notice safeguards (no notice constraint and no duty to inform). Clause C1: Provider may remove the user account (and associated data) at its discretion.").
dct_description(risk2, "Risk: terms may change with notice (3 days) below consumer requirement (14 days). Clause C2: Provider may change terms by informing users at least 3 days in advance.").
dct_description(risk3, "Risk: user data sharing is permitted without an explicit consent constraint. Clause C3: Provider may share user data with partners for business purposes.").
dct_description(risk4, "Risk: portability is restricted because exporting user data is prohibited. Clause C4: Users are not permitted to export their data.").
dct_description(m11, "Add a notice constraint (minimum noticeDays) before account removal.").
dct_description(m21, "Add a duty to inform the consumer prior to account removal.").
dct_description(m12, "Increase minimum noticeDays in the inform duty to meet the consumer requirement.").
dct_description(m13, "Add an explicit consent constraint before data sharing.").
dct_description(m14, "Add a permission allowing data export (or remove the prohibition) to support portability.").
reportKey(risk1, key(900, "C1")).
reportKey(risk2, key(915, "C2")).
reportKey(risk3, key(903, "C3")).
reportKey(risk4, key(930, "C4")).
dpv_isMitigatedByMeasure(risk1, m11).
dpv_isMitigatedByMeasure(risk1, m21).
dpv_isMitigatedByMeasure(risk2, m12).
dpv_isMitigatedByMeasure(risk3, m13).
dpv_isMitigatedByMeasure(risk4, m14).
dpv_mitigatesRisk(m11, risk1).
dpv_mitigatesRisk(m21, risk1).
dpv_mitigatesRisk(m12, risk2).
dpv_mitigatesRisk(m13, risk3).
dpv_mitigatesRisk(m14, risk4).
clauseId(clauseC1, "C1").
clauseId(clauseC2, "C2").
clauseId(clauseC3, "C3").
clauseId(clauseC4, "C4").
text(clauseC1, "Provider may remove the user account (and associated data) at its discretion.").
text(clauseC2, "Provider may change terms by informing users at least 3 days in advance.").
text(clauseC3, "Provider may share user data with partners for business purposes.").
text(clauseC4, "Users are not permitted to export their data.").
