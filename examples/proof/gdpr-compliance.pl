status(case_alpha, gdpr_compliant).
why(
  status(case_alpha, gdpr_compliant),
  proof(
    goal(status(case_alpha, gdpr_compliant)),
    by(rule("gdpr-compliance.pl", clause(25))),
    bindings([binding("Case", case_alpha)]),
    uses([
      proof(
        goal(compliant(case_alpha)),
        by(rule("gdpr-compliance.pl", clause(20))),
        bindings([binding("Case", case_alpha)]),
        uses([
          proof(
            goal(processing(case_alpha)),
            by(fact("gdpr-compliance.pl", clause(1)))
          ),
          proof(
            goal(has_required_basis(case_alpha)),
            by(rule("gdpr-compliance.pl", clause(15))),
            bindings([binding("Case", case_alpha)]),
            uses([
              proof(
                goal(legal_basis(case_alpha, explicit_consent)),
                by(fact("gdpr-compliance.pl", clause(5)))
              )
            ])
          ),
          proof(
            goal(minimized(case_alpha)),
            by(fact("gdpr-compliance.pl", clause(6)))
          ),
          proof(
            goal(has_health_safeguards(case_alpha)),
            by(rule("gdpr-compliance.pl", clause(17))),
            bindings([binding("Case", case_alpha)]),
            uses([
              proof(
                goal(special_category(case_alpha, health_data)),
                by(fact("gdpr-compliance.pl", clause(8)))
              ),
              proof(
                goal(safeguard(case_alpha, encryption)),
                by(fact("gdpr-compliance.pl", clause(10)))
              ),
              proof(
                goal(safeguard(case_alpha, access_logging)),
                by(fact("gdpr-compliance.pl", clause(11)))
              )
            ])
          ),
          proof(
            goal(transfer_ok(case_alpha)),
            by(rule("gdpr-compliance.pl", clause(18))),
            bindings([binding("Case", case_alpha)]),
            uses([
              proof(
                goal('\\+'(third_country_transfer(case_alpha))),
                by(builtin('\\+', 1))
              )
            ])
          )
        ])
      )
    ])
  )
).

status(case_beta, gdpr_noncompliant).
why(
  status(case_beta, gdpr_noncompliant),
  proof(
    goal(status(case_beta, gdpr_noncompliant)),
    by(rule("gdpr-compliance.pl", clause(26))),
    bindings([binding("Case", case_beta), binding("_reason", missing_legal_basis)]),
    uses([
      proof(
        goal(noncompliance_reason(case_beta, missing_legal_basis)),
        by(rule("gdpr-compliance.pl", clause(21))),
        bindings([binding("Case", case_beta)]),
        uses([
          proof(
            goal(processing(case_beta)),
            by(fact("gdpr-compliance.pl", clause(2)))
          ),
          proof(
            goal('\\+'(has_required_basis(case_beta))),
            by(builtin('\\+', 1))
          )
        ])
      )
    ])
  )
).

reason(case_beta, missing_legal_basis).
why(
  reason(case_beta, missing_legal_basis),
  proof(
    goal(reason(case_beta, missing_legal_basis)),
    by(rule("gdpr-compliance.pl", clause(27))),
    bindings([binding("Case", case_beta), binding("Reason", missing_legal_basis)]),
    uses([
      proof(
        goal(noncompliance_reason(case_beta, missing_legal_basis)),
        by(rule("gdpr-compliance.pl", clause(21))),
        bindings([binding("Case", case_beta)]),
        uses([
          proof(
            goal(processing(case_beta)),
            by(fact("gdpr-compliance.pl", clause(2)))
          ),
          proof(
            goal('\\+'(has_required_basis(case_beta))),
            by(builtin('\\+', 1))
          )
        ])
      )
    ])
  )
).

reason(case_beta, not_minimized).
why(
  reason(case_beta, not_minimized),
  proof(
    goal(reason(case_beta, not_minimized)),
    by(rule("gdpr-compliance.pl", clause(27))),
    bindings([binding("Case", case_beta), binding("Reason", not_minimized)]),
    uses([
      proof(
        goal(noncompliance_reason(case_beta, not_minimized)),
        by(rule("gdpr-compliance.pl", clause(22))),
        bindings([binding("Case", case_beta)]),
        uses([
          proof(
            goal(not_minimized(case_beta)),
            by(fact("gdpr-compliance.pl", clause(7)))
          )
        ])
      )
    ])
  )
).

reason(case_beta, missing_access_logging).
why(
  reason(case_beta, missing_access_logging),
  proof(
    goal(reason(case_beta, missing_access_logging)),
    by(rule("gdpr-compliance.pl", clause(27))),
    bindings([binding("Case", case_beta), binding("Reason", missing_access_logging)]),
    uses([
      proof(
        goal(noncompliance_reason(case_beta, missing_access_logging)),
        by(rule("gdpr-compliance.pl", clause(23))),
        bindings([binding("Case", case_beta)]),
        uses([
          proof(
            goal(special_category(case_beta, health_data)),
            by(fact("gdpr-compliance.pl", clause(9)))
          ),
          proof(
            goal('\\+'(safeguard(case_beta, access_logging))),
            by(builtin('\\+', 1))
          )
        ])
      )
    ])
  )
).

reason(case_beta, transfer_without_adequacy).
why(
  reason(case_beta, transfer_without_adequacy),
  proof(
    goal(reason(case_beta, transfer_without_adequacy)),
    by(rule("gdpr-compliance.pl", clause(27))),
    bindings([binding("Case", case_beta), binding("Reason", transfer_without_adequacy)]),
    uses([
      proof(
        goal(noncompliance_reason(case_beta, transfer_without_adequacy)),
        by(rule("gdpr-compliance.pl", clause(24))),
        bindings([binding("Case", case_beta)]),
        uses([
          proof(
            goal(third_country_transfer(case_beta)),
            by(fact("gdpr-compliance.pl", clause(13)))
          ),
          proof(
            goal('\\+'(adequacy_decision(case_beta))),
            by(builtin('\\+', 1))
          )
        ])
      )
    ])
  )
).

