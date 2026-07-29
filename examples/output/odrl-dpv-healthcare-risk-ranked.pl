score(riskH1, 100).
score(riskH2, 100).
score(riskH3, 100).
score(riskH4, 70).
policyGraph(agreementHC1, (type(policyHC1, odrl_Policy), odrl_permission(policyHC1, permResearchUse), odrl_permission(policyHC1, permShareWithPharma), odrl_permission(policyHC1, permAutomatedTriage), odrl_permission(policyHC1, permRetention10y), type(permResearchUse, odrl_Permission), odrl_assigner(permResearchUse, hospital), odrl_assignee(permResearchUse, researchUnit), odrl_action(permResearchUse, hl7ca_use), odrl_target(permResearchUse, healthRecordData), odrl_target(permResearchUse, genomicData), odrl_constraint(permResearchUse, cResearchPurpose), odrl_leftOperand(cResearchPurpose, odrl_purpose), odrl_rightOperandReference(cResearchPurpose, purposeHMB), clause(permResearchUse, clauseH1), type(permShareWithPharma, odrl_Permission), odrl_assigner(permShareWithPharma, hospital), odrl_assignee(permShareWithPharma, pharmaPartner), odrl_action(permShareWithPharma, hl7ca_disclose), odrl_target(permShareWithPharma, genomicData), odrl_constraint(permShareWithPharma, cSharePurpose), odrl_leftOperand(cSharePurpose, odrl_purpose), odrl_rightOperandReference(cSharePurpose, purposeHMB), clause(permShareWithPharma, clauseH2), type(permAutomatedTriage, odrl_Permission), odrl_assigner(permAutomatedTriage, hospital), odrl_assignee(permAutomatedTriage, clinicalAIService), odrl_action(permAutomatedTriage, hl7ca_use), odrl_target(permAutomatedTriage, healthRecordData), odrl_constraint(permAutomatedTriage, cTriagePurpose), odrl_leftOperand(cTriagePurpose, odrl_purpose), odrl_rightOperandReference(cTriagePurpose, purposeCC), odrl_duty(permAutomatedTriage, dutyHumanReview), odrl_action(dutyHumanReview, humanReview), odrl_constraint(dutyHumanReview, cTriageEncryption), odrl_leftOperand(cTriageEncryption, encryptionAtRest), odrl_rightOperand(cTriageEncryption, true), clause(permAutomatedTriage, clauseH3), type(permRetention10y, odrl_Permission), odrl_assigner(permRetention10y, hospital), odrl_assignee(permRetention10y, hospital), odrl_action(permRetention10y, hl7ca_collect), odrl_target(permRetention10y, healthRecordData), odrl_constraint(permRetention10y, cRetentionPurpose), odrl_leftOperand(cRetentionPurpose, odrl_purpose), odrl_rightOperandReference(cRetentionPurpose, purposeCC), odrl_constraint(permRetention10y, cRetentionDays), odrl_leftOperand(cRetentionDays, retentionDays), odrl_rightOperand(cRetentionDays, 3650), clause(permRetention10y, clauseH4))).
contains(policyGraphHC1, statement(policyHC1, type, odrl_Policy)).
contains(policyGraphHC1, statement(policyHC1, odrl_permission, permResearchUse)).
contains(policyGraphHC1, statement(policyHC1, odrl_permission, permShareWithPharma)).
contains(policyGraphHC1, statement(policyHC1, odrl_permission, permAutomatedTriage)).
contains(policyGraphHC1, statement(policyHC1, odrl_permission, permRetention10y)).
contains(policyGraphHC1, statement(permResearchUse, type, odrl_Permission)).
contains(policyGraphHC1, statement(permResearchUse, odrl_assigner, hospital)).
contains(policyGraphHC1, statement(permResearchUse, odrl_assignee, researchUnit)).
contains(policyGraphHC1, statement(permResearchUse, odrl_action, hl7ca_use)).
contains(policyGraphHC1, statement(permResearchUse, odrl_target, healthRecordData)).
contains(policyGraphHC1, statement(permResearchUse, odrl_target, genomicData)).
contains(policyGraphHC1, statement(permResearchUse, odrl_constraint, cResearchPurpose)).
contains(policyGraphHC1, statement(cResearchPurpose, odrl_leftOperand, odrl_purpose)).
contains(policyGraphHC1, statement(cResearchPurpose, odrl_rightOperandReference, purposeHMB)).
contains(policyGraphHC1, statement(permResearchUse, clause, clauseH1)).
contains(policyGraphHC1, statement(permShareWithPharma, type, odrl_Permission)).
contains(policyGraphHC1, statement(permShareWithPharma, odrl_assigner, hospital)).
contains(policyGraphHC1, statement(permShareWithPharma, odrl_assignee, pharmaPartner)).
contains(policyGraphHC1, statement(permShareWithPharma, odrl_action, hl7ca_disclose)).
contains(policyGraphHC1, statement(permShareWithPharma, odrl_target, genomicData)).
contains(policyGraphHC1, statement(permShareWithPharma, odrl_constraint, cSharePurpose)).
contains(policyGraphHC1, statement(cSharePurpose, odrl_leftOperand, odrl_purpose)).
contains(policyGraphHC1, statement(cSharePurpose, odrl_rightOperandReference, purposeHMB)).
contains(policyGraphHC1, statement(permShareWithPharma, clause, clauseH2)).
contains(policyGraphHC1, statement(permAutomatedTriage, type, odrl_Permission)).
contains(policyGraphHC1, statement(permAutomatedTriage, odrl_assigner, hospital)).
contains(policyGraphHC1, statement(permAutomatedTriage, odrl_assignee, clinicalAIService)).
contains(policyGraphHC1, statement(permAutomatedTriage, odrl_action, hl7ca_use)).
contains(policyGraphHC1, statement(permAutomatedTriage, odrl_target, healthRecordData)).
contains(policyGraphHC1, statement(permAutomatedTriage, odrl_constraint, cTriagePurpose)).
contains(policyGraphHC1, statement(cTriagePurpose, odrl_leftOperand, odrl_purpose)).
contains(policyGraphHC1, statement(cTriagePurpose, odrl_rightOperandReference, purposeCC)).
contains(policyGraphHC1, statement(permAutomatedTriage, odrl_duty, dutyHumanReview)).
contains(policyGraphHC1, statement(dutyHumanReview, odrl_action, humanReview)).
contains(policyGraphHC1, statement(dutyHumanReview, odrl_constraint, cTriageEncryption)).
contains(policyGraphHC1, statement(cTriageEncryption, odrl_leftOperand, encryptionAtRest)).
contains(policyGraphHC1, statement(cTriageEncryption, odrl_rightOperand, true)).
contains(policyGraphHC1, statement(permAutomatedTriage, clause, clauseH3)).
contains(policyGraphHC1, statement(permRetention10y, type, odrl_Permission)).
contains(policyGraphHC1, statement(permRetention10y, odrl_assigner, hospital)).
contains(policyGraphHC1, statement(permRetention10y, odrl_assignee, hospital)).
contains(policyGraphHC1, statement(permRetention10y, odrl_action, hl7ca_collect)).
contains(policyGraphHC1, statement(permRetention10y, odrl_target, healthRecordData)).
contains(policyGraphHC1, statement(permRetention10y, odrl_constraint, cRetentionPurpose)).
contains(policyGraphHC1, statement(cRetentionPurpose, odrl_leftOperand, odrl_purpose)).
contains(policyGraphHC1, statement(cRetentionPurpose, odrl_rightOperandReference, purposeCC)).
contains(policyGraphHC1, statement(permRetention10y, odrl_constraint, cRetentionDays)).
contains(policyGraphHC1, statement(cRetentionDays, odrl_leftOperand, retentionDays)).
contains(policyGraphHC1, statement(cRetentionDays, odrl_rightOperand, 3650)).
contains(policyGraphHC1, statement(permRetention10y, clause, clauseH4)).
dpv_hasRisk(processContextHC1, riskH1).
dpv_hasRisk(processContextHC1, riskH2).
dpv_hasRisk(processContextHC1, riskH3).
dpv_hasRisk(processContextHC1, riskH4).
type(riskH1, dpv_Risk).
type(riskH2, dpv_Risk).
type(riskH3, dpv_Risk).
type(riskH4, dpv_Risk).
scoreRaw(riskH1, 120).
scoreRaw(riskH2, 125).
scoreRaw(riskH3, 105).
scoreRaw(riskH4, 70).
dpv_hasRiskLevel(riskH1, risk_HighRisk).
dpv_hasRiskLevel(riskH2, risk_HighRisk).
dpv_hasRiskLevel(riskH3, risk_HighRisk).
dpv_hasRiskLevel(riskH4, risk_ModerateRisk).
dpv_hasSeverity(riskH1, risk_HighSeverity).
dpv_hasSeverity(riskH2, risk_HighSeverity).
dpv_hasSeverity(riskH3, risk_HighSeverity).
dpv_hasSeverity(riskH4, risk_ModerateSeverity).
aboutClause(riskH1, clauseH1).
aboutClause(riskH2, clauseH2).
aboutClause(riskH3, clauseH3).
aboutClause(riskH4, clauseH4).
violatesNeed(riskH1, need_ConsentForResearch).
violatesNeed(riskH2, need_DeIdentifyBeforeSharing).
violatesNeed(riskH3, need_HumanReviewForAutomatedTriage).
violatesNeed(riskH4, need_RetentionLimit3y).
dct_source(riskH1, permResearchUse).
dct_source(riskH2, permShareWithPharma).
dct_source(riskH3, permAutomatedTriage).
dct_source(riskH4, permRetention10y).
dct_description(riskH1, "Risk: health/genomic data may be used for research without explicit opt-in consent.").
dct_description(riskH2, "Risk: genomic data may be shared with external pharma partners without a de-identification/pseudonymisation requirement.").
dct_description(riskH3, "Risk: automated triage may affect care pathways without a human review/override safeguard.").
dct_description(riskH4, "Risk: retention (3650 days) exceeds patient preference (1095 days).").
reportKey(riskH1, 900).
reportKey(riskH2, 900).
reportKey(riskH3, 900).
reportKey(riskH4, 930).
dpv_isMitigatedByMeasure(riskH1, mitigateConsent).
dpv_isMitigatedByMeasure(riskH2, mitigateDeId).
dpv_isMitigatedByMeasure(riskH3, mitigateHumanReview).
dpv_isMitigatedByMeasure(riskH4, mitigateRetention).
suggestAddGraph(mitigateConsent, (odrl_constraint(permResearchUse, cExplicitConsent), odrl_leftOperand(cExplicitConsent, explicitConsent), odrl_rightOperand(cExplicitConsent, true))).
suggestAddGraph(mitigateDeId, (odrl_constraint(permShareWithPharma, cDeIdentified), odrl_leftOperand(cDeIdentified, deIdentified), odrl_rightOperand(cDeIdentified, true), odrl_duty(permShareWithPharma, dutyDeIdentify), odrl_action(dutyDeIdentify, deIdentify))).
suggestAddGraph(mitigateHumanReview, (odrl_duty(permAutomatedTriage, dutyHumanReview), odrl_action(dutyHumanReview, humanReview))).
suggestAddGraph(mitigateRetention, (odrl_constraint(permRetention10y, cRetentionLimit), odrl_leftOperand(cRetentionLimit, retentionDays), odrl_rightOperand(cRetentionLimit, 1095))).
firstRisk(report, riskH1).
retentionRiskScore(report, 70).
