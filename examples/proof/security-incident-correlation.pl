type(inc42, confirmed_compromise).
why(
  type(inc42, confirmed_compromise),
  proof(
    goal(type(inc42, confirmed_compromise)),
    by(rule("security-incident-correlation.pl", clause(23))),
    bindings([binding("Incident", inc42)]),
    uses([
      proof(
        goal(confirmed_compromise(inc42)),
        by(rule("security-incident-correlation.pl", clause(22))),
        bindings([binding("Incident", inc42)]),
        uses([
          proof(
            goal(credential_abuse(inc42)),
            by(rule("security-incident-correlation.pl", clause(18))),
            bindings([binding("Incident", inc42), binding("User", user_alice)]),
            uses([
              proof(
                goal(alert(inc42, suspicious_login, user_alice)),
                by(fact("security-incident-correlation.pl", clause(9)))
              ),
              proof(
                goal(privileged_user(user_alice)),
                by(fact("security-incident-correlation.pl", clause(7)))
              )
            ])
          ),
          proof(
            goal(malware_on_critical_asset(inc42)),
            by(rule("security-incident-correlation.pl", clause(19))),
            bindings([binding("Incident", inc42), binding("Endpoint", endpoint23), binding("_hash", hash_redline)]),
            uses([
              proof(
                goal(alert(inc42, endpoint, endpoint23)),
                by(fact("security-incident-correlation.pl", clause(8)))
              ),
              proof(
                goal(alert(inc42, malware_hash, hash_redline)),
                by(fact("security-incident-correlation.pl", clause(10)))
              ),
              proof(
                goal(critical_asset(endpoint23)),
                by(rule("security-incident-correlation.pl", clause(17))),
                bindings([binding("Endpoint", endpoint23)]),
                uses([
                  proof(
                    goal(asset(endpoint23, criticality, high)),
                    by(fact("security-incident-correlation.pl", clause(3)))
                  )
                ])
              )
            ])
          ),
          proof(
            goal(c2_contact(inc42)),
            by(rule("security-incident-correlation.pl", clause(20))),
            bindings([binding("Incident", inc42), binding("Ip", ip_203_0_113_17)]),
            uses([
              proof(
                goal(alert(inc42, outbound_ip, ip_203_0_113_17)),
                by(fact("security-incident-correlation.pl", clause(11)))
              ),
              proof(
                goal(threat_intel(ip_203_0_113_17, command_and_control)),
                by(fact("security-incident-correlation.pl", clause(16)))
              )
            ])
          ),
          proof(
            goal(exploitable_endpoint(inc42)),
            by(rule("security-incident-correlation.pl", clause(21))),
            bindings([binding("Incident", inc42), binding("Endpoint", endpoint23)]),
            uses([
              proof(
                goal(alert(inc42, endpoint, endpoint23)),
                by(fact("security-incident-correlation.pl", clause(8)))
              ),
              proof(
                goal(vulnerability(endpoint23, cve_critical_rce)),
                by(fact("security-incident-correlation.pl", clause(15)))
              )
            ])
          )
        ])
      )
    ])
  )
).

status(inc42, escalate_to_incident_response).
why(
  status(inc42, escalate_to_incident_response),
  proof(
    goal(status(inc42, escalate_to_incident_response)),
    by(rule("security-incident-correlation.pl", clause(24))),
    bindings([binding("Incident", inc42)]),
    uses([
      proof(
        goal(confirmed_compromise(inc42)),
        by(rule("security-incident-correlation.pl", clause(22))),
        bindings([binding("Incident", inc42)]),
        uses([
          proof(
            goal(credential_abuse(inc42)),
            by(rule("security-incident-correlation.pl", clause(18))),
            bindings([binding("Incident", inc42), binding("User", user_alice)]),
            uses([
              proof(
                goal(alert(inc42, suspicious_login, user_alice)),
                by(fact("security-incident-correlation.pl", clause(9)))
              ),
              proof(
                goal(privileged_user(user_alice)),
                by(fact("security-incident-correlation.pl", clause(7)))
              )
            ])
          ),
          proof(
            goal(malware_on_critical_asset(inc42)),
            by(rule("security-incident-correlation.pl", clause(19))),
            bindings([binding("Incident", inc42), binding("Endpoint", endpoint23), binding("_hash", hash_redline)]),
            uses([
              proof(
                goal(alert(inc42, endpoint, endpoint23)),
                by(fact("security-incident-correlation.pl", clause(8)))
              ),
              proof(
                goal(alert(inc42, malware_hash, hash_redline)),
                by(fact("security-incident-correlation.pl", clause(10)))
              ),
              proof(
                goal(critical_asset(endpoint23)),
                by(rule("security-incident-correlation.pl", clause(17))),
                bindings([binding("Endpoint", endpoint23)]),
                uses([
                  proof(
                    goal(asset(endpoint23, criticality, high)),
                    by(fact("security-incident-correlation.pl", clause(3)))
                  )
                ])
              )
            ])
          ),
          proof(
            goal(c2_contact(inc42)),
            by(rule("security-incident-correlation.pl", clause(20))),
            bindings([binding("Incident", inc42), binding("Ip", ip_203_0_113_17)]),
            uses([
              proof(
                goal(alert(inc42, outbound_ip, ip_203_0_113_17)),
                by(fact("security-incident-correlation.pl", clause(11)))
              ),
              proof(
                goal(threat_intel(ip_203_0_113_17, command_and_control)),
                by(fact("security-incident-correlation.pl", clause(16)))
              )
            ])
          ),
          proof(
            goal(exploitable_endpoint(inc42)),
            by(rule("security-incident-correlation.pl", clause(21))),
            bindings([binding("Incident", inc42), binding("Endpoint", endpoint23)]),
            uses([
              proof(
                goal(alert(inc42, endpoint, endpoint23)),
                by(fact("security-incident-correlation.pl", clause(8)))
              ),
              proof(
                goal(vulnerability(endpoint23, cve_critical_rce)),
                by(fact("security-incident-correlation.pl", clause(15)))
              )
            ])
          )
        ])
      )
    ])
  )
).

reason(inc42, "privileged credential abuse, malware on a critical endpoint, C2 contact, and exploitable RCE are correlated").
why(
  reason(inc42, "privileged credential abuse, malware on a critical endpoint, C2 contact, and exploitable RCE are correlated"),
  proof(
    goal(reason(inc42, "privileged credential abuse, malware on a critical endpoint, C2 contact, and exploitable RCE are correlated")),
    by(rule("security-incident-correlation.pl", clause(25))),
    bindings([binding("Incident", inc42)]),
    uses([
      proof(
        goal(confirmed_compromise(inc42)),
        by(rule("security-incident-correlation.pl", clause(22))),
        bindings([binding("Incident", inc42)]),
        uses([
          proof(
            goal(credential_abuse(inc42)),
            by(rule("security-incident-correlation.pl", clause(18))),
            bindings([binding("Incident", inc42), binding("User", user_alice)]),
            uses([
              proof(
                goal(alert(inc42, suspicious_login, user_alice)),
                by(fact("security-incident-correlation.pl", clause(9)))
              ),
              proof(
                goal(privileged_user(user_alice)),
                by(fact("security-incident-correlation.pl", clause(7)))
              )
            ])
          ),
          proof(
            goal(malware_on_critical_asset(inc42)),
            by(rule("security-incident-correlation.pl", clause(19))),
            bindings([binding("Incident", inc42), binding("Endpoint", endpoint23), binding("_hash", hash_redline)]),
            uses([
              proof(
                goal(alert(inc42, endpoint, endpoint23)),
                by(fact("security-incident-correlation.pl", clause(8)))
              ),
              proof(
                goal(alert(inc42, malware_hash, hash_redline)),
                by(fact("security-incident-correlation.pl", clause(10)))
              ),
              proof(
                goal(critical_asset(endpoint23)),
                by(rule("security-incident-correlation.pl", clause(17))),
                bindings([binding("Endpoint", endpoint23)]),
                uses([
                  proof(
                    goal(asset(endpoint23, criticality, high)),
                    by(fact("security-incident-correlation.pl", clause(3)))
                  )
                ])
              )
            ])
          ),
          proof(
            goal(c2_contact(inc42)),
            by(rule("security-incident-correlation.pl", clause(20))),
            bindings([binding("Incident", inc42), binding("Ip", ip_203_0_113_17)]),
            uses([
              proof(
                goal(alert(inc42, outbound_ip, ip_203_0_113_17)),
                by(fact("security-incident-correlation.pl", clause(11)))
              ),
              proof(
                goal(threat_intel(ip_203_0_113_17, command_and_control)),
                by(fact("security-incident-correlation.pl", clause(16)))
              )
            ])
          ),
          proof(
            goal(exploitable_endpoint(inc42)),
            by(rule("security-incident-correlation.pl", clause(21))),
            bindings([binding("Incident", inc42), binding("Endpoint", endpoint23)]),
            uses([
              proof(
                goal(alert(inc42, endpoint, endpoint23)),
                by(fact("security-incident-correlation.pl", clause(8)))
              ),
              proof(
                goal(vulnerability(endpoint23, cve_critical_rce)),
                by(fact("security-incident-correlation.pl", clause(15)))
              )
            ])
          )
        ])
      )
    ])
  )
).

