dpv_odrl_purpose_mapping([mapping(data_controller, hospital_a, assigner), mapping(recipient, research_partner, assignee), mapping(personal_data, lab_result, target), mapping(processing, dpv_use, action), mapping(purpose, dpv_healthcare, constraint(alpha_purpose_constraint)), mapping(legal_basis, dpv_consent, constraint(alpha_basis_constraint))]).
why(
  dpv_odrl_purpose_mapping([mapping(data_controller, hospital_a, assigner), mapping(recipient, research_partner, assignee), mapping(personal_data, lab_result, target), mapping(processing, dpv_use, action), mapping(purpose, dpv_healthcare, constraint(alpha_purpose_constraint)), mapping(legal_basis, dpv_consent, constraint(alpha_basis_constraint))]),
  proof(
    goal(dpv_odrl_purpose_mapping([mapping(data_controller, hospital_a, assigner), mapping(recipient, research_partner, assignee), mapping(personal_data, lab_result, target), mapping(processing, dpv_use, action), mapping(purpose, dpv_healthcare, constraint(alpha_purpose_constraint)), mapping(legal_basis, dpv_consent, constraint(alpha_basis_constraint))])),
    by(rule("dpv-odrl-purpose-mapping.pl", clause(26))),
    bindings([binding("Mappings", [mapping(data_controller, hospital_a, assigner), mapping(recipient, research_partner, assignee), mapping(personal_data, lab_result, target), mapping(processing, dpv_use, action), mapping(purpose, dpv_healthcare, constraint(alpha_purpose_constraint)), mapping(legal_basis, dpv_consent, constraint(alpha_basis_constraint))])]),
    uses([
      proof(
        goal(findall(mapping(SourceRole, Value, TargetRole), mapped_role(SourceRole, Value, TargetRole), [mapping(data_controller, hospital_a, assigner), mapping(recipient, research_partner, assignee), mapping(personal_data, lab_result, target), mapping(processing, dpv_use, action), mapping(purpose, dpv_healthcare, constraint(alpha_purpose_constraint)), mapping(legal_basis, dpv_consent, constraint(alpha_basis_constraint))])),
        by(builtin(findall, 3))
      )
    ])
  )
).

