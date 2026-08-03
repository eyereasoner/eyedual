% Translate a DPV-style personal-data processing description into an ODRL-style policy view.
% The source facts describe one care/research process: controller, recipient, data, action, purpose, and legal basis.
% The derived predicates query the corresponding ODRL policy, permission, target, party, action, and constraints.

%% goal: type(X0, X1)

%% goal: odrl_permission(X0, X1)

%% goal: odrl_assigner(X0, X1)

%% goal: odrl_assignee(X0, X1)

%% goal: odrl_target(X0, X1)

%% goal: odrl_action(X0, X1)

%% goal: odrl_constraint(X0, X1)

%% goal: odrl_leftOperand(X0, X1)

%% goal: odrl_operator(X0, X1)

%% goal: odrl_rightOperand(X0, X1)

%% goal: derived_from_process(X0, X1)


process(alpha_care_process).
data_controller(alpha_care_process, hospital_a).
recipient(alpha_care_process, research_partner).
personal_data(alpha_care_process, lab_result).
processing(alpha_care_process, dpv_use).
purpose(alpha_care_process, dpv_healthcare).
legal_basis(alpha_care_process, dpv_consent).

represents_process(alpha_policy, alpha_care_process).
permission_node(alpha_policy, alpha_permission).
purpose_constraint(alpha_policy, alpha_purpose_constraint).
basis_constraint(alpha_policy, alpha_basis_constraint).

type(Policy, odrl_policy) :- represents_process(Policy, _process).
odrl_permission(Policy, Permission) :- permission_node(Policy, Permission).
type(Permission, odrl_permission) :- permission_node(_policy, Permission).
derived_from_process(Permission, Process) :- represents_process(Policy, Process), permission_node(Policy, Permission).
odrl_assigner(Permission, Controller) :- represents_process(Policy, Process), permission_node(Policy, Permission), data_controller(Process, Controller).
odrl_assignee(Permission, Recipient) :- represents_process(Policy, Process), permission_node(Policy, Permission), recipient(Process, Recipient).
odrl_target(Permission, Data) :- represents_process(Policy, Process), permission_node(Policy, Permission), personal_data(Process, Data).
odrl_action(Permission, Action) :- represents_process(Policy, Process), permission_node(Policy, Permission), processing(Process, Action).

odrl_constraint(Permission, Constraint) :- permission_node(Policy, Permission), purpose_constraint(Policy, Constraint).
odrl_constraint(Permission, Constraint) :- permission_node(Policy, Permission), basis_constraint(Policy, Constraint).
type(Constraint, odrl_constraint) :- purpose_constraint(_policy, Constraint).
type(Constraint, odrl_constraint) :- basis_constraint(_policy, Constraint).
odrl_leftOperand(Constraint, dpv_odrl_purpose) :- purpose_constraint(_policy, Constraint).
odrl_leftOperand(Constraint, dpv_odrl_legal_basis) :- basis_constraint(_policy, Constraint).
odrl_operator(Constraint, odrl_isA) :- purpose_constraint(_policy, Constraint).
odrl_operator(Constraint, odrl_isA) :- basis_constraint(_policy, Constraint).
odrl_rightOperand(Constraint, Purpose) :- represents_process(Policy, Process), purpose_constraint(Policy, Constraint), purpose(Process, Purpose).
odrl_rightOperand(Constraint, Basis) :- represents_process(Policy, Process), basis_constraint(Policy, Constraint), legal_basis(Process, Basis).
