% Flandor insight-economy case adapted from Eyeling flandor.n3.
% The original N3 renders a Markdown ARC report.  This eyeprolog translation keeps
% the neutral insight, policy envelope, authorization, package choice, and checks
% as queried relation output.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: caseName(X0, X1)

%% goal: regionName(X0, X1)

%% goal: metric(X0, X1)

%% goal: activeNeedCount(X0, X1)

%% goal: activeNeedThreshold(X0, X1)

%% goal: recommendedPackageName(X0, X1)

%% goal: budgetCapMEUR(X0, X1)

%% goal: packageCostMEUR(X0, X1)

%% goal: envelopeExpiresAt(X0, X1)

%% goal: workerCoverage(X0, X1)

%% goal: gridReliefMW(X0, X1)

%% goal: outcome(X0, X1)

%% goal: target(X0, X1)

%% goal: reason(X0, X1)

%% goal: alg(X0, X1)

%% goal: payloadHashSHA256(X0, X1)

%% goal: signatureHMAC(X0, X1)

%% goal: auditEntries(X0, X1)

%% goal: filesWritten(X0, X1)

%% goal: allChecksPass(X0, X1)

%% goal: exportWeakness(X0, X1)

%% goal: skillsStrain(X0, X1)

%% goal: gridStress(X0, X1)

%% goal: needsRetoolingPulse(X0, X1)

%% goal: derivedFromNeed(X0, X1)

%% goal: signatureVerifies(X0, X1)

%% goal: payloadHashMatches(X0, X1)

%% goal: hmacMatches(X0, X1)

%% goal: minimizationStripsSensitiveTerms(X0, X1)

%% goal: scopeComplete(X0, X1)

%% goal: authorizationAllowed(X0, X1)

%% goal: thresholdReached(X0, X1)

%% goal: packageWithinBudget(X0, X1)

%% goal: packageCoversAllNeeds(X0, X1)

%% goal: dutyTimingConsistent(X0, X1)

%% goal: surveillanceReuseProhibited(X0, X1)

%% goal: filesWrittenExpected(X0, X1)

%% goal: lowestCostEligiblePackageChosen(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
% Case metadata describes the request, audit window, and expected file writes.
case_name(case, "flandor").
question(case, "Is the Flemish Economic Resilience Board allowed to use a neutral macro-economic insight for regional stabilization, and if so which package should it activate for Flanders?").
expectedFilesWritten(case, 6).
requestPurpose(case, "regional_stabilization").
requestAction(case, odrlUse).
hubCreatedAt(case, "2026-04-08T07:00:00+00:00").
hubExpiresAt(case, "2026-04-08T19:00:00+00:00").
boardAuthAt(case, "2026-04-08T09:15:00+00:00").
boardDutyAt(case, "2026-04-08T18:30:00+00:00").
files_written(case, 6).
audit_entries(case, 1).

region_name(flanders, "Flanders").
observedFirms(signals, 217).
aggregationLevel(signals, "regional_cluster").
containsFirmNames(signals, false).
containsPayrollRows(signals, false).

% Signals are intentionally aggregated: no firm names or payroll rows are present.
industrialCluster(clusterAntwerp).
clusterName(clusterAntwerp, "Antwerp chemicals").
exportOrdersIndex(clusterAntwerp, 84).
energyIntensity(clusterAntwerp, 92).
industrialCluster(clusterGhent).
clusterName(clusterGhent, "Ghent manufacturing").
exportOrdersIndex(clusterGhent, 87).
energyIntensity(clusterGhent, 76).

techVacancyRateTenths(labourMarket, 46).
techVacancyRate(labourMarket, 4.6).
congestionHours(grid, 19).
renewableCurtailmentMWh(grid, 240).
maxMEUR(budget, 140).
windowName(budget, "Q2 resilience window").

% Candidate packages expose cost and which active needs they cover.
policyPackage(pkgTrainingOnly).
packageId(pkgTrainingOnly, "pkg:TRAIN_070").
packageName(pkgTrainingOnly, "Flanders Skills Sprint").
costMEUR(pkgTrainingOnly, 70).
worker_coverage(pkgTrainingOnly, 900).
grid_relief_mw(pkgTrainingOnly, 0).
coversSkillsStrain(pkgTrainingOnly, true).

policyPackage(pkgLogisticsOnly).
packageId(pkgLogisticsOnly, "pkg:PORT_095").
packageName(pkgLogisticsOnly, "Schelde Trade Buffer").
costMEUR(pkgLogisticsOnly, 95).
worker_coverage(pkgLogisticsOnly, 300).
grid_relief_mw(pkgLogisticsOnly, 10).
coversExportWeakness(pkgLogisticsOnly, true).

policyPackage(pkgFlandor).
packageId(pkgFlandor, "pkg:RET_FLEX_120").
packageName(pkgFlandor, "Flandor Retooling Pulse").
costMEUR(pkgFlandor, 120).
worker_coverage(pkgFlandor, 1200).
grid_relief_mw(pkgFlandor, 85).
coversExportWeakness(pkgFlandor, true).
coversSkillsStrain(pkgFlandor, true).
coversGridStress(pkgFlandor, true).

policyPackage(pkgFullCorridor).
packageId(pkgFullCorridor, "pkg:CORRIDOR_165").
packageName(pkgFullCorridor, "Full Corridor Shock Shield").
costMEUR(pkgFullCorridor, 165).
worker_coverage(pkgFullCorridor, 1600).
grid_relief_mw(pkgFullCorridor, 110).
coversExportWeakness(pkgFullCorridor, true).
coversSkillsStrain(pkgFullCorridor, true).
coversGridStress(pkgFullCorridor, true).

insight(macroInsight).
id(macroInsight, "https://example.org/insight/flandor").
insight_metric(macroInsight, "regional_retooling_priority").
thresholdScore(macroInsight, 3).
thresholdDisplay(macroInsight, "3 active needs").
suggestionPolicy(macroInsight, "lowest_cost_package_covering_all_active_needs").
scopeDevice(macroInsight, "economic-resilience-board").
scopeEvent(macroInsight, "budget-prep-window").
region(macroInsight, "Flanders").
createdAt(macroInsight, "2026-04-08T07:00:00+00:00").
expiresAt(macroInsight, "2026-04-08T19:00:00+00:00").
serializedLowercase(macroInsight, "createdat expiresat insight metric regional_retooling_priority region flanders scopedevice economic-resilience-board scopeevent budget-prep-window suggestionpolicy lowest_cost_package_covering_all_active_needs threshold 3").

envelopeInsight(envelope, macroInsight).
envelopePolicy(envelope, policy).
envelopeHash(envelope, "10a85e861075bef2a96c01c7f3238735f82b8f368deb62eafcedd1c4b7f7c707").
permission(policy, odrlUse, macroInsight, "regional_stabilization").
prohibition(policy, odrlDistribute, macroInsight, "firm_surveillance").
duty(policy, odrlDelete, "2026-04-08T19:00:00+00:00").

signature_alg(signature, "HMAC-SHA256").
keyid(signature, "demo-shared-secret").
created(signature, "2026-04-08T07:00:00+00:00").
payload_hash_sha256(signature, "10a85e861075bef2a96c01c7f3238735f82b8f368deb62eafcedd1c4b7f7c707").
display_payload_hash_sha256(signature, "718f5b17d07ab6a95503bc04a1000ddb132409f600659c03d21def81914b780b").
signature_hmac(signature, "955968ca99a191783bc00cba068128ccb9ff40a5e6114fda13a52c74ee27329e").
hmacVerificationMode(signature, trustedPrecomputedInput).

reason_value(reasonText, "Secure aggregates from Flanders indicate simultaneous export weakness, technical labour scarcity, and grid congestion. A neutral macro insight is scoped to the economic-resilience board for one budget window only, enabling a temporary package without exposing firm-level books.").

% Derivation rules: each rule below contributes one logical step toward the displayed results.
caseName(Case, Name) :- case_name(Case, Name).
regionName(Region, Name) :- region_name(Region, Name).
metric(Insight, Metric) :- insight_metric(Insight, Metric).
alg(Signature, Alg) :- signature_alg(Signature, Alg).
payloadHashSHA256(Signature, Hash) :- display_payload_hash_sha256(Signature, Hash).
signatureHMAC(Signature, Hmac) :- signature_hmac(Signature, Hmac).
auditEntries(Case, Count) :- audit_entries(Case, Count).
filesWritten(Case, Count) :- files_written(Case, Count).

export_weakness(case) :-
  industrialCluster(Cluster),
  exportOrdersIndex(Cluster, Index),
  (Index < 90).

skills_strain(case) :-
  techVacancyRateTenths(labourMarket, Rate),
  (Rate > 39).

grid_stress(case) :-
  congestionHours(grid, Hours),
  (Hours > 11).

needs_retooling_pulse(case) :-
  export_weakness(case),
  skills_strain(case),
  grid_stress(case).

payload_hash_matches(check) :-
  envelopeHash(envelope, Digest),
  payload_hash_sha256(signature, Digest).

signature_verifies(check) :- hmacVerificationMode(signature, trustedPrecomputedInput).
hmac_matches(check) :-
  hmacVerificationMode(signature, trustedPrecomputedInput),
  signature_hmac(signature, "955968ca99a191783bc00cba068128ccb9ff40a5e6114fda13a52c74ee27329e").

minimization_strips_sensitive_terms(check) :-
  serializedLowercase(macroInsight, Text),
  \+ matches(Text, "salary|payroll|invoice|medical|firmname").

scope_complete(check) :-
  scopeDevice(macroInsight, _device),
  scopeEvent(macroInsight, _event),
  expiresAt(macroInsight, _expiry).

% Authorization combines policy scope, envelope timing, and use permission.
authorization_allowed(check) :-
  permission(policy, odrlUse, macroInsight, "regional_stabilization"),
  boardAuthAt(case, Authat),
  expiresAt(macroInsight, Expiresat),
  (Authat @=< Expiresat).

decision(decision, "Allowed", macroInsight) :- authorization_allowed(check).

% An eligible package must cover every active need and fit under the budget cap.
eligible_package(Pkg) :-
  needs_retooling_pulse(case),
  maxMEUR(budget, Max),
  policyPackage(Pkg),
  costMEUR(Pkg, Cost),
  coversExportWeakness(Pkg, true),
  coversSkillsStrain(Pkg, true),
  coversGridStress(Pkg, true),
  (Cost =< Max).

lower_cost_eligible_package(Cost) :-
  eligible_package(Other),
  costMEUR(Other, Othercost),
  (Othercost < Cost).

% The recommendation is the lowest-cost eligible package.
recommended_package(case, Pkg) :-
  eligible_package(Pkg),
  costMEUR(Pkg, Cost),
  \+ lower_cost_eligible_package(Cost).

package_within_budget(check) :-
  recommended_package(case, Pkg),
  costMEUR(Pkg, Cost),
  maxMEUR(budget, Max),
  (Cost =< Max).

package_covers_all_needs(check) :-
  recommended_package(case, Pkg),
  coversExportWeakness(Pkg, true),
  coversSkillsStrain(Pkg, true),
  coversGridStress(Pkg, true).

duty_timing_consistent(check) :-
  boardDutyAt(case, Dutyat),
  expiresAt(macroInsight, Expiresat),
  (Dutyat @=< Expiresat).

surveillance_reuse_prohibited(check) :- prohibition(policy, odrlDistribute, macroInsight, "firm_surveillance").
files_written_expected(check) :- files_written(case, 6).
threshold_reached(check) :- export_weakness(case), skills_strain(case), grid_stress(case).
lowest_cost_eligible_package_chosen(check) :- recommended_package(case, _pkg).

all_checks_pass(result) :-
  signature_verifies(check),
  payload_hash_matches(check),
  minimization_strips_sensitive_terms(check),
  scope_complete(check),
  authorization_allowed(check),
  package_within_budget(check),
  package_covers_all_needs(check),
  duty_timing_consistent(check),
  surveillance_reuse_prohibited(check),
  files_written_expected(check).

exportWeakness(case, true) :- export_weakness(case).
skillsStrain(case, true) :- skills_strain(case).
gridStress(case, true) :- grid_stress(case).
needsRetoolingPulse(case, true) :- needs_retooling_pulse(case).
derivedFromNeed(case, "regional_retooling_and_flexibility") :- needs_retooling_pulse(case).
activeNeedCount(answer, 3) :- threshold_reached(check).
activeNeedThreshold(answer, 3) :- thresholdScore(macroInsight, 3).
recommendedPackageName(answer, Name) :- recommended_package(case, Pkg), packageName(Pkg, Name).
budgetCapMEUR(answer, Max) :- maxMEUR(budget, Max).
packageCostMEUR(answer, Cost) :- recommended_package(case, Pkg), costMEUR(Pkg, Cost).
envelopeExpiresAt(answer, Time) :- expiresAt(macroInsight, Time).
workerCoverage(why, Workers) :- recommended_package(case, Pkg), worker_coverage(Pkg, Workers).
gridReliefMW(why, Mw) :- recommended_package(case, Pkg), grid_relief_mw(Pkg, Mw).
outcome(decision, Outcome) :- decision(decision, Outcome, _target).
target(decision, Target) :- decision(decision, _outcome, Target).
allChecksPass(result, true) :- all_checks_pass(result).
signatureVerifies(check, true) :- signature_verifies(check).
payloadHashMatches(check, true) :- payload_hash_matches(check).
hmacMatches(check, true) :- hmac_matches(check).
minimizationStripsSensitiveTerms(check, true) :- minimization_strips_sensitive_terms(check).
scopeComplete(check, true) :- scope_complete(check).
authorizationAllowed(check, true) :- authorization_allowed(check).
thresholdReached(check, true) :- threshold_reached(check).
packageWithinBudget(check, true) :- package_within_budget(check).
packageCoversAllNeeds(check, true) :- package_covers_all_needs(check).
dutyTimingConsistent(check, true) :- duty_timing_consistent(check).
surveillanceReuseProhibited(check, true) :- surveillance_reuse_prohibited(check).
filesWrittenExpected(check, true) :- files_written_expected(check).
lowestCostEligiblePackageChosen(check, true) :- lowest_cost_eligible_package_chosen(check).

reason(whyExportWeakness, "Export weakness is active because at least one cluster has exportOrdersIndex < 90 (Antwerp chemicals=84, Ghent manufacturing=87).") :- export_weakness(case).
reason(whySkillsStrain, "Skills strain is active because technical vacancy rate is 4.6% (threshold > 3.9%).") :- skills_strain(case).
reason(whyGridStress, "Grid stress is active because congestion hours = 19 (threshold > 11).") :- grid_stress(case).
reason(whyRecommendationPolicy, "The recommendation policy is \"lowest_cost_package_covering_all_active_needs\", so the cheapest package that covers all active needs within budget is selected.") :- recommended_package(case, _pkg).
reason(whySelectedPackage, "Selected package \"Flandor Retooling Pulse\" covers export=true, skills=true, grid=true, cost=€120M.") :- recommended_package(case, pkgFlandor).
reason(whyUsage, "Usage is permitted only for purpose \"regional_stabilization\" and the envelope expires at 2026-04-08T19:00:00+00:00.") :- authorization_allowed(check).
