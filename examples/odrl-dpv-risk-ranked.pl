% Compact ODRL + DPV consumer risk ranking.
%
% ODRL facts describe permissions and prohibitions in an agreement. DPV needs
% express what the consumer requires. The rules derive one risk for each
% conflict, cap its score at 100, rank the risks, and suggest a mitigation.
%% goal: consumer_risk_report(_)

% DPV consumer needs and their importance.
dpv_need(no_deletion_without_notice, 20).
dpv_need(change_only_with_14_days_notice, 15).
dpv_need(no_sharing_without_consent, 12).
dpv_need(data_portability, 10).
dpv_min_notice(change_only_with_14_days_notice, 14).

% ODRL agreement facts.
odrl_permission(delete_account, c1).
odrl_action(delete_account, remove_account).

odrl_permission(change_terms, c2).
odrl_action(change_terms, change_terms).
odrl_duty(change_terms, inform).
odrl_constraint(change_terms, notice_days, 3).

odrl_permission(share_data, c3).
odrl_action(share_data, disclose).

odrl_prohibition(export_data, c4).
odrl_action(export_data, export).

% Missing safeguards and conflicting prohibitions become DPV risks.
dpv_risk(deletion_risk, delete_account, no_deletion_without_notice, 90,
         require_notice_before_deletion) :-
  odrl_permission(delete_account, _Clause),
  odrl_action(delete_account, remove_account),
  \+ odrl_duty(delete_account, inform),
  \+ odrl_constraint(delete_account, notice_days, _Days).

dpv_risk(terms_risk, change_terms, change_only_with_14_days_notice, 70,
         require_14_days_notice) :-
  odrl_permission(change_terms, _Clause),
  odrl_action(change_terms, change_terms),
  odrl_duty(change_terms, inform),
  odrl_constraint(change_terms, notice_days, Days),
  dpv_min_notice(change_only_with_14_days_notice, Minimum),
  Days < Minimum.

dpv_risk(sharing_risk, share_data, no_sharing_without_consent, 85,
         require_explicit_consent) :-
  odrl_permission(share_data, _Clause),
  odrl_action(share_data, disclose),
  \+ odrl_constraint(share_data, explicit_consent, true).

dpv_risk(portability_risk, export_data, data_portability, 60,
         permit_data_export) :-
  odrl_prohibition(export_data, _Clause),
  odrl_action(export_data, export).

risk_score(Risk, Score) :-
  dpv_risk(Risk, _Rule, Need, Base, _Mitigation),
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
  dpv_risk(Risk, Rule, _Need, _Base, Mitigation),
  (odrl_permission(Rule, Clause) ; odrl_prohibition(Rule, Clause)),
  risk_score(Risk, Score),
  risk_level(Risk, Level).

% Descending score, then clause identifier for deterministic ties.
consumer_risk_report(Ranked) :-
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
