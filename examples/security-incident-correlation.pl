% Representative example: security incident correlation.
%
% The rules correlate endpoint, identity, vulnerability, and threat-intelligence
% signals into an escalation decision with concise reason relations.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: type(X0, X1)

%% goal: status(X0, X1)

%% goal: reason(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
incident(inc42).
incident(inc43).

asset(endpoint23, criticality, high).
asset(endpoint77, criticality, low).

assigned_user(endpoint23, user_alice).
assigned_user(endpoint77, user_bob).

privileged_user(user_alice).

alert(inc42, endpoint, endpoint23).
alert(inc42, suspicious_login, user_alice).
alert(inc42, malware_hash, hash_redline).
alert(inc42, outbound_ip, ip_203_0_113_17).

alert(inc43, endpoint, endpoint77).
alert(inc43, suspicious_login, user_bob).
alert(inc43, outbound_ip, ip_198_51_100_42).

vulnerability(endpoint23, cve_critical_rce).
threat_intel(ip_203_0_113_17, command_and_control).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
critical_asset(Endpoint) :-
  asset(Endpoint, criticality, high).

credential_abuse(Incident) :-
  alert(Incident, suspicious_login, User),
  privileged_user(User).

malware_on_critical_asset(Incident) :-
  alert(Incident, endpoint, Endpoint),
  alert(Incident, malware_hash, _hash),
  critical_asset(Endpoint).

c2_contact(Incident) :-
  alert(Incident, outbound_ip, Ip),
  threat_intel(Ip, command_and_control).

exploitable_endpoint(Incident) :-
  alert(Incident, endpoint, Endpoint),
  vulnerability(Endpoint, cve_critical_rce).

confirmed_compromise(Incident) :-
  credential_abuse(Incident),
  malware_on_critical_asset(Incident),
  c2_contact(Incident),
  exploitable_endpoint(Incident).

type(Incident, confirmed_compromise) :-
  confirmed_compromise(Incident).

status(Incident, escalate_to_incident_response) :-
  confirmed_compromise(Incident).

reason(Incident, "privileged credential abuse, malware on a critical endpoint, C2 contact, and exploitable RCE are correlated") :-
  confirmed_compromise(Incident).
