% ODRL + DPV + local FPV trust-flow decisioning in WebEntail.
%
% Each flow has a source, recipient, data item, action, and purpose.  Permissions
% and prohibitions are checked together with source trust scores to produce
% permit, review, or deny decisions.
%
% The example separates the policy vocabulary from the local FPV-style report
% predicates, which keeps the final decision/confidence/status/risk facts easy to
% consume.

%% goal: decision(X0, X1)

%% goal: confidence(X0, X1)

%% goal: status(X0, X1)

%% goal: risk(X0, X1)


trust_score(hospital_a, 0.92).
trust_score(small_clinic, 0.63).
trust_score(ad_network, 0.28).

flow(flow_care, hospital_a, research_partner, lab_result, dpv_use, dpv_healthcare).
flow(flow_clinic, small_clinic, research_partner, lab_result, dpv_use, dpv_healthcare).
flow(flow_ads, hospital_a, ad_network, lab_result, dpv_share, dpv_marketing).

permission(permit_healthcare_research, research_partner, lab_result, dpv_use, dpv_healthcare, 0.80).
prohibition(prohibit_marketing_disclosure, ad_network, lab_result, dpv_share, dpv_marketing).

permitted_flow(Flow, Score) :-
  flow(Flow, Source, Recipient, Data, Action, Purpose),
  permission(_permission, Recipient, Data, Action, Purpose, Mintrust),
  trust_score(Source, Score),
  (Score >= Mintrust).

review_flow(Flow, Score) :-
  flow(Flow, Source, Recipient, Data, Action, Purpose),
  permission(_permission, Recipient, Data, Action, Purpose, Mintrust),
  trust_score(Source, Score),
  (Score < Mintrust).

denied_flow(Flow) :-
  flow(Flow, _source, Recipient, Data, Action, Purpose),
  prohibition(_prohibition, Recipient, Data, Action, Purpose).

decision(Flow, fpv_permit) :- permitted_flow(Flow, _score).
decision(Flow, fpv_review) :- review_flow(Flow, _score).
decision(Flow, fpv_deny) :- denied_flow(Flow).
confidence(Flow, Score) :- permitted_flow(Flow, Score).
confidence(Flow, Score) :- review_flow(Flow, Score).
status(Flow, fpv_executable_flow) :- permitted_flow(Flow, _score).
status(Flow, fpv_blocked_flow) :- denied_flow(Flow).
risk(Flow, risk_trustworthiness_risk) :- review_flow(Flow, _score).
risk(Flow, risk_unwanted_disclosure_data) :- denied_flow(Flow).
