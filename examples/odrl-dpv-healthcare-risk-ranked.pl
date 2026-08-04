% Compact ODRL + DPV healthcare risk ranking.
%
% ODRL facts describe three permitted healthcare data uses. DPV patient needs
% supply the importance of the missing safeguard. The rules derive, score, and
% rank the resulting risks, then suggest one mitigation for each risk.
%% goal: healthcare_risk_report(_)

% DPV patient needs and their importance.
dpv_need(explicit_consent_for_research, 35).
dpv_need(deidentify_before_sharing, 35).
dpv_need(retention_limit_3_years, 15).
dpv_retention_limit(retention_limit_3_years, 1095).

% ODRL policy facts.
odrl_permission(research_use, h1).
odrl_action(research_use, use).

odrl_permission(genomic_sharing, h2).
odrl_action(genomic_sharing, disclose).
odrl_target(genomic_sharing, genomic_data).

odrl_permission(record_retention, h4).
odrl_constraint(record_retention, retention_days, 3650).

% Missing safeguards and excessive retention become DPV risks.
dpv_risk(consent_risk, research_use, explicit_consent_for_research, 85,
         require_explicit_consent) :-
  odrl_permission(research_use, _Clause),
  odrl_action(research_use, use),
  \+ odrl_constraint(research_use, explicit_consent, true).

dpv_risk(sharing_risk, genomic_sharing, deidentify_before_sharing, 90,
         require_deidentification) :-
  odrl_permission(genomic_sharing, _Clause),
  odrl_action(genomic_sharing, disclose),
  odrl_target(genomic_sharing, genomic_data),
  \+ odrl_constraint(genomic_sharing, deidentified, true).

dpv_risk(retention_risk, record_retention, retention_limit_3_years, 55,
         limit_retention_to_1095_days) :-
  odrl_permission(record_retention, _Clause),
  odrl_constraint(record_retention, retention_days, Days),
  dpv_retention_limit(retention_limit_3_years, Maximum),
  Days > Maximum.

risk_score(Risk, Score) :-
  dpv_risk(Risk, _Permission, Need, Base, _Mitigation),
  dpv_need(Need, Importance),
  Raw is Base + Importance,
  (Raw > 100 -> Score = 100 ; Score = Raw).

risk_level(Risk, high) :-
  risk_score(Risk, Score),
  Score > 79.
risk_level(Risk, moderate) :-
  risk_score(Risk, Score),
  Score > 49,
  Score < 80.

risk_report(Risk, Score, Level, Clause, Mitigation) :-
  dpv_risk(Risk, Permission, _Need, _Base, Mitigation),
  odrl_permission(Permission, Clause),
  risk_score(Risk, Score),
  risk_level(Risk, Level).

% Sort by descending score, then by clause identifier for deterministic ties.
healthcare_risk_report(Ranked) :-
  findall(
    key(InverseScore, Clause)-dpv_risk(Risk, Score, Level, Clause, Mitigation),
    (
      risk_report(Risk, Score, Level, Clause, Mitigation),
      InverseScore is 1000 - Score
    ),
    Unsorted
  ),
  sort(Unsorted, Sorted),
  ranked_values(Sorted, 1, Ranked).

ranked_values([], _Rank, []).
ranked_values([_Key-Risk|Rest], Rank, [rank(Rank, Risk)|Ranked]) :-
  NextRank is Rank + 1,
  ranked_values(Rest, NextRank, Ranked).
