type(alpha_policy, odrl_policy).
why(
  type(alpha_policy, odrl_policy),
  proof(
    goal(type(alpha_policy, odrl_policy)),
    by(rule("dpv-odrl-purpose-mapping.pl", clause(12))),
    bindings([binding("Policy", alpha_policy), binding("_process", alpha_care_process)]),
    uses([
      proof(
        goal(represents_process(alpha_policy, alpha_care_process)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(8)))
      )
    ])
  )
).

type(alpha_permission, odrl_permission).
why(
  type(alpha_permission, odrl_permission),
  proof(
    goal(type(alpha_permission, odrl_permission)),
    by(rule("dpv-odrl-purpose-mapping.pl", clause(14))),
    bindings([binding("Permission", alpha_permission), binding("_policy", alpha_policy)]),
    uses([
      proof(
        goal(permission_node(alpha_policy, alpha_permission)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(9)))
      )
    ])
  )
).

type(alpha_purpose_constraint, odrl_constraint).
why(
  type(alpha_purpose_constraint, odrl_constraint),
  proof(
    goal(type(alpha_purpose_constraint, odrl_constraint)),
    by(rule("dpv-odrl-purpose-mapping.pl", clause(22))),
    bindings([binding("Constraint", alpha_purpose_constraint), binding("_policy", alpha_policy)]),
    uses([
      proof(
        goal(purpose_constraint(alpha_policy, alpha_purpose_constraint)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(10)))
      )
    ])
  )
).

type(alpha_basis_constraint, odrl_constraint).
why(
  type(alpha_basis_constraint, odrl_constraint),
  proof(
    goal(type(alpha_basis_constraint, odrl_constraint)),
    by(rule("dpv-odrl-purpose-mapping.pl", clause(23))),
    bindings([binding("Constraint", alpha_basis_constraint), binding("_policy", alpha_policy)]),
    uses([
      proof(
        goal(basis_constraint(alpha_policy, alpha_basis_constraint)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(11)))
      )
    ])
  )
).

odrl_permission(alpha_policy, alpha_permission).
why(
  odrl_permission(alpha_policy, alpha_permission),
  proof(
    goal(odrl_permission(alpha_policy, alpha_permission)),
    by(rule("dpv-odrl-purpose-mapping.pl", clause(13))),
    bindings([binding("Policy", alpha_policy), binding("Permission", alpha_permission)]),
    uses([
      proof(
        goal(permission_node(alpha_policy, alpha_permission)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(9)))
      )
    ])
  )
).

derived_from_process(alpha_permission, alpha_care_process).
why(
  derived_from_process(alpha_permission, alpha_care_process),
  proof(
    goal(derived_from_process(alpha_permission, alpha_care_process)),
    by(rule("dpv-odrl-purpose-mapping.pl", clause(15))),
    bindings([binding("Permission", alpha_permission), binding("Process", alpha_care_process), binding("Policy", alpha_policy)]),
    uses([
      proof(
        goal(represents_process(alpha_policy, alpha_care_process)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(8)))
      ),
      proof(
        goal(permission_node(alpha_policy, alpha_permission)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(9)))
      )
    ])
  )
).

odrl_assigner(alpha_permission, hospital_a).
why(
  odrl_assigner(alpha_permission, hospital_a),
  proof(
    goal(odrl_assigner(alpha_permission, hospital_a)),
    by(rule("dpv-odrl-purpose-mapping.pl", clause(16))),
    bindings([binding("Permission", alpha_permission), binding("Controller", hospital_a), binding("Policy", alpha_policy), binding("Process", alpha_care_process)]),
    uses([
      proof(
        goal(represents_process(alpha_policy, alpha_care_process)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(8)))
      ),
      proof(
        goal(permission_node(alpha_policy, alpha_permission)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(9)))
      ),
      proof(
        goal(data_controller(alpha_care_process, hospital_a)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(2)))
      )
    ])
  )
).

odrl_assignee(alpha_permission, research_partner).
why(
  odrl_assignee(alpha_permission, research_partner),
  proof(
    goal(odrl_assignee(alpha_permission, research_partner)),
    by(rule("dpv-odrl-purpose-mapping.pl", clause(17))),
    bindings([binding("Permission", alpha_permission), binding("Recipient", research_partner), binding("Policy", alpha_policy), binding("Process", alpha_care_process)]),
    uses([
      proof(
        goal(represents_process(alpha_policy, alpha_care_process)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(8)))
      ),
      proof(
        goal(permission_node(alpha_policy, alpha_permission)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(9)))
      ),
      proof(
        goal(recipient(alpha_care_process, research_partner)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(3)))
      )
    ])
  )
).

odrl_target(alpha_permission, lab_result).
why(
  odrl_target(alpha_permission, lab_result),
  proof(
    goal(odrl_target(alpha_permission, lab_result)),
    by(rule("dpv-odrl-purpose-mapping.pl", clause(18))),
    bindings([binding("Permission", alpha_permission), binding("Data", lab_result), binding("Policy", alpha_policy), binding("Process", alpha_care_process)]),
    uses([
      proof(
        goal(represents_process(alpha_policy, alpha_care_process)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(8)))
      ),
      proof(
        goal(permission_node(alpha_policy, alpha_permission)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(9)))
      ),
      proof(
        goal(personal_data(alpha_care_process, lab_result)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(4)))
      )
    ])
  )
).

odrl_action(alpha_permission, dpv_use).
why(
  odrl_action(alpha_permission, dpv_use),
  proof(
    goal(odrl_action(alpha_permission, dpv_use)),
    by(rule("dpv-odrl-purpose-mapping.pl", clause(19))),
    bindings([binding("Permission", alpha_permission), binding("Action", dpv_use), binding("Policy", alpha_policy), binding("Process", alpha_care_process)]),
    uses([
      proof(
        goal(represents_process(alpha_policy, alpha_care_process)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(8)))
      ),
      proof(
        goal(permission_node(alpha_policy, alpha_permission)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(9)))
      ),
      proof(
        goal(processing(alpha_care_process, dpv_use)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(5)))
      )
    ])
  )
).

odrl_constraint(alpha_permission, alpha_purpose_constraint).
why(
  odrl_constraint(alpha_permission, alpha_purpose_constraint),
  proof(
    goal(odrl_constraint(alpha_permission, alpha_purpose_constraint)),
    by(rule("dpv-odrl-purpose-mapping.pl", clause(20))),
    bindings([binding("Permission", alpha_permission), binding("Constraint", alpha_purpose_constraint), binding("Policy", alpha_policy)]),
    uses([
      proof(
        goal(permission_node(alpha_policy, alpha_permission)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(9)))
      ),
      proof(
        goal(purpose_constraint(alpha_policy, alpha_purpose_constraint)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(10)))
      )
    ])
  )
).

odrl_constraint(alpha_permission, alpha_basis_constraint).
why(
  odrl_constraint(alpha_permission, alpha_basis_constraint),
  proof(
    goal(odrl_constraint(alpha_permission, alpha_basis_constraint)),
    by(rule("dpv-odrl-purpose-mapping.pl", clause(21))),
    bindings([binding("Permission", alpha_permission), binding("Constraint", alpha_basis_constraint), binding("Policy", alpha_policy)]),
    uses([
      proof(
        goal(permission_node(alpha_policy, alpha_permission)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(9)))
      ),
      proof(
        goal(basis_constraint(alpha_policy, alpha_basis_constraint)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(11)))
      )
    ])
  )
).

odrl_leftOperand(alpha_purpose_constraint, dpv_odrl_purpose).
why(
  odrl_leftOperand(alpha_purpose_constraint, dpv_odrl_purpose),
  proof(
    goal(odrl_leftOperand(alpha_purpose_constraint, dpv_odrl_purpose)),
    by(rule("dpv-odrl-purpose-mapping.pl", clause(24))),
    bindings([binding("Constraint", alpha_purpose_constraint), binding("_policy", alpha_policy)]),
    uses([
      proof(
        goal(purpose_constraint(alpha_policy, alpha_purpose_constraint)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(10)))
      )
    ])
  )
).

odrl_leftOperand(alpha_basis_constraint, dpv_odrl_legal_basis).
why(
  odrl_leftOperand(alpha_basis_constraint, dpv_odrl_legal_basis),
  proof(
    goal(odrl_leftOperand(alpha_basis_constraint, dpv_odrl_legal_basis)),
    by(rule("dpv-odrl-purpose-mapping.pl", clause(25))),
    bindings([binding("Constraint", alpha_basis_constraint), binding("_policy", alpha_policy)]),
    uses([
      proof(
        goal(basis_constraint(alpha_policy, alpha_basis_constraint)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(11)))
      )
    ])
  )
).

odrl_operator(alpha_purpose_constraint, odrl_isA).
why(
  odrl_operator(alpha_purpose_constraint, odrl_isA),
  proof(
    goal(odrl_operator(alpha_purpose_constraint, odrl_isA)),
    by(rule("dpv-odrl-purpose-mapping.pl", clause(26))),
    bindings([binding("Constraint", alpha_purpose_constraint), binding("_policy", alpha_policy)]),
    uses([
      proof(
        goal(purpose_constraint(alpha_policy, alpha_purpose_constraint)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(10)))
      )
    ])
  )
).

odrl_operator(alpha_basis_constraint, odrl_isA).
why(
  odrl_operator(alpha_basis_constraint, odrl_isA),
  proof(
    goal(odrl_operator(alpha_basis_constraint, odrl_isA)),
    by(rule("dpv-odrl-purpose-mapping.pl", clause(27))),
    bindings([binding("Constraint", alpha_basis_constraint), binding("_policy", alpha_policy)]),
    uses([
      proof(
        goal(basis_constraint(alpha_policy, alpha_basis_constraint)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(11)))
      )
    ])
  )
).

odrl_rightOperand(alpha_purpose_constraint, dpv_healthcare).
why(
  odrl_rightOperand(alpha_purpose_constraint, dpv_healthcare),
  proof(
    goal(odrl_rightOperand(alpha_purpose_constraint, dpv_healthcare)),
    by(rule("dpv-odrl-purpose-mapping.pl", clause(28))),
    bindings([binding("Constraint", alpha_purpose_constraint), binding("Purpose", dpv_healthcare), binding("Policy", alpha_policy), binding("Process", alpha_care_process)]),
    uses([
      proof(
        goal(represents_process(alpha_policy, alpha_care_process)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(8)))
      ),
      proof(
        goal(purpose_constraint(alpha_policy, alpha_purpose_constraint)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(10)))
      ),
      proof(
        goal(purpose(alpha_care_process, dpv_healthcare)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(6)))
      )
    ])
  )
).

odrl_rightOperand(alpha_basis_constraint, dpv_consent).
why(
  odrl_rightOperand(alpha_basis_constraint, dpv_consent),
  proof(
    goal(odrl_rightOperand(alpha_basis_constraint, dpv_consent)),
    by(rule("dpv-odrl-purpose-mapping.pl", clause(29))),
    bindings([binding("Constraint", alpha_basis_constraint), binding("Basis", dpv_consent), binding("Policy", alpha_policy), binding("Process", alpha_care_process)]),
    uses([
      proof(
        goal(represents_process(alpha_policy, alpha_care_process)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(8)))
      ),
      proof(
        goal(basis_constraint(alpha_policy, alpha_basis_constraint)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(11)))
      ),
      proof(
        goal(legal_basis(alpha_care_process, dpv_consent)),
        by(fact("dpv-odrl-purpose-mapping.pl", clause(7)))
      )
    ])
  )
).

