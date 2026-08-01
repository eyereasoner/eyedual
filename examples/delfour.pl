% Delfour insight-economy case adapted from Eyeling delfour.n3.
% The original N3 emits a Markdown answer.  This eyepl
% translation derives the same authorization, shopping banner, alternative, and
% checklist facts as relation query execution.
%
% Static input is kept as scoped data: the case, insight, policy, envelope, and
% signature are context terms, while the product catalog is a list of records.
% Rules project only the fields they need, avoiding global permission/prohibition
% facts that could contradict another policy formula in the same program.

% Output declarations: query/1 selects the relations written to this example's golden output.
query(caseName(X0, X1)).
query(needsLowSugar(X0, X1)).
query(derivedFromNeed(X0, X1)).
query(outcome(X0, X1)).
query(target(X0, X1)).
query(metric(X0, X1)).
query(threshold(X0, X1)).
query(scope(X0, X1)).
query(retailer(X0, X1)).
query(expiresAt(X0, X1)).
query(scannedProduct(X0, X1)).
query(suggestedAlternative(X0, X1)).
query(headline(X0, X1)).
query(note(X0, X1)).
query(reason(X0, X1)).
query(value(X0, X1)).
query(alg(X0, X1)).
query(auditEntries(X0, X1)).
query(filesWritten(X0, X1)).
query(allChecksPass(X0, X1)).
query(signatureVerifies(X0, X1)).
query(payloadHashMatches(X0, X1)).
query(minimizationStripsSensitiveTerms(X0, X1)).
query(scopeComplete(X0, X1)).
query(authorizationAllowed(X0, X1)).
query(bannerFlagsHighSugar(X0, X1)).
query(alternativeIsLowerSugar(X0, X1)).
query(dutyTimingConsistent(X0, X1)).
query(marketingProhibited(X0, X1)).
query(filesWrittenExpected(X0, X1)).

% Program structure: facts set up the scenario, and rules derive the queried conclusions.
% Context-valued facts keep each input graph scoped and easy to project.
case_graph(delfourCaseGraph, (
  caseName(case, "delfour"),
  requestPurpose(case, "shopping_assist"),
  requestAction(case, odrl_use),
  phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"),
  phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"),
  scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"),
  scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"),
  filesWritten(case, 6),
  auditEntries(case, 1),
  condition(householdProfile, "Diabetes"),
  scannedProduct(scan, prod_BIS_001)
)).

% Catalog rows are product(IdTerm, DisplayId, Name, SugarTenths, SugarG).
product_catalog(delfourCatalog, [
  product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0),
  product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0),
  product(prod_CHOC_050, "prod_CHOC_050", "Milk Chocolate Bar", 150, 15.0),
  product(prod_CHOC_150, "prod_CHOC_150", "85% Dark Chocolate", 60, 6.0)
]).

insight_graph(delfourInsightGraph, (
  metric(insight, "sugar_g_per_serving"),
  thresholdTenths(insight, 100),
  thresholdDisplay(insight, "10.0"),
  thresholdG(insight, 10.0),
  suggestionPolicy(insight, "lower_metric_first_higher_price_ok"),
  scopeDevice(insight, "self-scanner"),
  scopeEvent(insight, "pick_up_scanner"),
  retailer(insight, "Delfour"),
  createdAt(insight, "2025-10-05T20:33:48.907163+00:00"),
  expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"),
  serializedLowercase(insight, "createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner")
)).

policy_graph(delfourPolicyGraph, (
  odrl_permission(policy, permission(odrl_use, insight, "shopping_assist")),
  odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")),
  odrl_duty(policy, duty(odrl_delete, "2025-10-05T22:33:48.907185+00:00"))
)).

envelope_graph(delfourEnvelopeGraph, (
  insight(envelope, delfourInsightGraph),
  policy(envelope, delfourPolicyGraph),
  hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")
)).

signature_graph(delfourSignatureGraph, (
  alg(signature, "HMAC-SHA256"),
  keyid(signature, "demo-shared-secret"),
  created(signature, "2025-10-05T20:33:48.907163+00:00"),
  payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"),
  hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"),
  hmacVerificationMode(signature, trustedPrecomputedInput)
)).

reason_text(reasonText, "Household requires low-sugar guidance (diabetes in POD). A neutral Insight is scoped to device 'self-scanner', event 'pick_up_scanner', retailer 'Delfour', and expires soon; the policy confines use to shopping assistance.").

context_member((Left, _right), Member) :- context_member(Left, Member).
context_member((_left, Right), Member) :- context_member(Right, Member).
context_member(Member, Member) :- Member \= (_left, _right).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
case_statement(S, P, O) :- case_graph(delfourCaseGraph, Context), context_member(Context, Statement), (Statement =.. [P, S, O]).
insight_statement(S, P, O) :- insight_graph(delfourInsightGraph, Context), context_member(Context, Statement), (Statement =.. [P, S, O]).
policy_statement(S, P, O) :- policy_graph(delfourPolicyGraph, Context), context_member(Context, Statement), (Statement =.. [P, S, O]).
envelope_statement(S, P, O) :- envelope_graph(delfourEnvelopeGraph, Context), context_member(Context, Statement), (Statement =.. [P, S, O]).
signature_statement(S, P, O) :- signature_graph(delfourSignatureGraph, Context), context_member(Context, Statement), (Statement =.. [P, S, O]).

case_name(case, Name) :- case_statement(case, caseName, Name).
request_purpose(case, Purpose) :- case_statement(case, requestPurpose, Purpose).
request_action(case, Action) :- case_statement(case, requestAction, Action).
phone_created_at(case, Time) :- case_statement(case, phoneCreatedAt, Time).
phone_expires_at(case, Time) :- case_statement(case, phoneExpiresAt, Time).
scanner_auth_at(case, Time) :- case_statement(case, scannerAuthAt, Time).
scanner_duty_at(case, Time) :- case_statement(case, scannerDutyAt, Time).
files_written(case, Count) :- case_statement(case, filesWritten, Count).
audit_entries(case, Count) :- case_statement(case, auditEntries, Count).
condition(householdProfile, Condition) :- case_statement(householdProfile, condition, Condition).
scanned_product(scan, Product) :- case_statement(scan, scannedProduct, Product).

product(Product) :- product_catalog(delfourCatalog, Products), member(product(Product, _id, _name, _sugartenths, _sugarg), Products).
product_id(Product, Id) :- product_catalog(delfourCatalog, Products), member(product(Product, Id, _name, _sugartenths, _sugarg), Products).
product_name(Product, Name) :- product_catalog(delfourCatalog, Products), member(product(Product, _id, Name, _sugartenths, _sugarg), Products).
sugar_tenths(Product, Sugar) :- product_catalog(delfourCatalog, Products), member(product(Product, _id, _name, Sugar, _sugarg), Products).
sugar_per_serving(Product, Sugar) :- product_catalog(delfourCatalog, Products), member(product(Product, _id, _name, _sugartenths, Sugar), Products).

insight(insight).
metric(insight, Metric) :- insight_statement(insight, metric, Metric).
threshold_tenths(insight, Threshold) :- insight_statement(insight, thresholdTenths, Threshold).
threshold_display(insight, Threshold) :- insight_statement(insight, thresholdDisplay, Threshold).
threshold_g(insight, Threshold) :- insight_statement(insight, thresholdG, Threshold).
suggestion_policy(insight, Policy) :- insight_statement(insight, suggestionPolicy, Policy).
scope_device(insight, Device) :- insight_statement(insight, scopeDevice, Device).
scope_event(insight, Event) :- insight_statement(insight, scopeEvent, Event).
retailer(insight, Retailer) :- insight_statement(insight, retailer, Retailer).
created_at(insight, Time) :- insight_statement(insight, createdAt, Time).
expires_at(insight, Time) :- insight_statement(insight, expiresAt, Time).
serialized_lowercase(insight, Text) :- insight_statement(insight, serializedLowercase, Text).

policy(policy).
permission(policy, Action, Target, Purpose) :- policy_statement(policy, odrl_permission, permission(Action, Target, Purpose)).
prohibition(policy, Action, Target, Purpose) :- policy_statement(policy, odrl_prohibition, prohibition(Action, Target, Purpose)).
duty(policy, Action, Time) :- policy_statement(policy, odrl_duty, duty(Action, Time)).

envelope_insight(envelope, Insight) :- envelope_statement(envelope, insight, Insight).
envelope_policy(envelope, Policy) :- envelope_statement(envelope, policy, Policy).
envelope_hash(envelope, Hash) :- envelope_statement(envelope, hash, Hash).
signature_alg(signature, Alg) :- signature_statement(signature, alg, Alg).
signature_keyid(signature, Keyid) :- signature_statement(signature, keyid, Keyid).
signature_created(signature, Time) :- signature_statement(signature, created, Time).
payload_hash_sha256(signature, Hash) :- signature_statement(signature, payloadHashSha256, Hash).
signature_hmac(signature, Hmac) :- signature_statement(signature, hmac, Hmac).
hmac_verification_mode(signature, Mode) :- signature_statement(signature, hmacVerificationMode, Mode).

% The household profile creates the low-sugar need used by the insight.
needs_low_sugar(case) :-
  condition(householdProfile, "Diabetes").

derived_from_need(insight, "low_sugar") :-
  needs_low_sugar(case).

payload_hash_matches(check) :-
  envelope_hash(envelope, Digest),
  payload_hash_sha256(signature, Digest).

signature_verifies(check) :-
  hmac_verification_mode(signature, trustedPrecomputedInput).

minimization_strips_sensitive_terms(check) :-
  serialized_lowercase(insight, Text),
  \+ matches(Text, "diabetes|medical").

scope_complete(check) :-
  scope_device(insight, _device),
  scope_event(insight, _event),
  expires_at(insight, _expiry).

authorization_allowed(check) :-
  permission(policy, odrl_use, insight, "shopping_assist"),
  request_purpose(case, "shopping_assist"),
  scanner_auth_at(case, Authat),
  expires_at(insight, Expiresat),
  (Authat @=< Expiresat).

decision(decision, "Allowed", insight) :-
  authorization_allowed(check).

banner_flags_high_sugar(check) :-
  decision(decision, "Allowed", insight),
  scanned_product(scan, Product),
  sugar_per_serving(Product, Sugar),
  threshold_g(insight, Threshold),
  (Sugar >= Threshold).

banner_headline(banner, "Track sugar per serving while you scan") :-
  banner_flags_high_sugar(check).

banner_note(banner, "High sugar") :-
  banner_flags_high_sugar(check).

better_lower_sugar(Scannedsugar, Candidatesugar) :-
  product(Other),
  sugar_tenths(Other, Othersugar),
  (Scannedsugar > Othersugar),
  (Othersugar < Candidatesugar).

% Pick the lowest-sugar alternative according to the insight suggestion policy.
suggested_alternative(case, Candidate) :-
  scanned_product(scan, Scanned),
  sugar_tenths(Scanned, Scannedsugar),
  product(Candidate),
  sugar_tenths(Candidate, Candidatesugar),
  (Scannedsugar > Candidatesugar),
  \+ better_lower_sugar(Scannedsugar, Candidatesugar).

banner_suggested_alternative(banner, Name) :-
  banner_note(banner, "High sugar"),
  suggested_alternative(case, Alternative),
  product_name(Alternative, Name).

alternative_is_lower_sugar(check) :-
  scanned_product(scan, Scanned),
  sugar_tenths(Scanned, Scannedsugar),
  suggested_alternative(case, Alternative),
  sugar_tenths(Alternative, Alternativesugar),
  (Scannedsugar > Alternativesugar).

duty_timing_consistent(check) :-
  scanner_duty_at(case, Dutyat),
  expires_at(insight, Expiresat),
  (Dutyat @=< Expiresat).

marketing_prohibited(check) :-
  prohibition(policy, odrl_distribute, insight, "marketing").

files_written_expected(check) :-
  files_written(case, 6).

all_checks_pass(result) :-
  signature_verifies(check),
  payload_hash_matches(check),
  minimization_strips_sensitive_terms(check),
  scope_complete(check),
  authorization_allowed(check),
  banner_flags_high_sugar(check),
  alternative_is_lower_sugar(check),
  duty_timing_consistent(check),
  marketing_prohibited(check),
  files_written_expected(check).

caseName(case, Name) :- case_name(case, Name).
needsLowSugar(case, true) :- needs_low_sugar(case).
derivedFromNeed(insight, Need) :- derived_from_need(insight, Need).
outcome(decision, Outcome) :- decision(decision, Outcome, _target).
target(decision, Target) :- decision(decision, _outcome, Target).
scannedProduct(scan, Productname) :- scanned_product(scan, Product), product_name(Product, Productname).
suggestedAlternative(case, Name) :- suggested_alternative(case, Alternative), product_name(Alternative, Name).
threshold(insight, Threshold) :- threshold_display(insight, Threshold).
scope(insight, "self-scanner @ pick_up_scanner") :- scope_device(insight, "self-scanner"), scope_event(insight, "pick_up_scanner").
expiresAt(insight, Time) :- expires_at(insight, Time).
reason(why, "The phone desensitizes a diabetes-related household condition into a scoped low-sugar need, wraps it in an expiring Insight + Policy envelope, signs it, and the scanner consumes that envelope for shopping assistance.") :- authorization_allowed(check).
headline(banner, Headline) :- banner_headline(banner, Headline).
note(banner, Note) :- banner_note(banner, Note).
suggestedAlternative(banner, Name) :- banner_suggested_alternative(banner, Name).
value(reasonText, Text) :- reason_text(reasonText, Text).
alg(signature, Alg) :- signature_alg(signature, Alg).
auditEntries(case, Count) :- audit_entries(case, Count).
filesWritten(case, Count) :- files_written(case, Count).
allChecksPass(result, true) :- all_checks_pass(result).
signatureVerifies(check, true) :- signature_verifies(check).
payloadHashMatches(check, true) :- payload_hash_matches(check).
minimizationStripsSensitiveTerms(check, true) :- minimization_strips_sensitive_terms(check).
scopeComplete(check, true) :- scope_complete(check).
authorizationAllowed(check, true) :- authorization_allowed(check).
bannerFlagsHighSugar(check, true) :- banner_flags_high_sugar(check).
alternativeIsLowerSugar(check, true) :- alternative_is_lower_sugar(check).
dutyTimingConsistent(check, true) :- duty_timing_consistent(check).
marketingProhibited(check, true) :- marketing_prohibited(check).
filesWrittenExpected(check, true) :- files_written_expected(check).
