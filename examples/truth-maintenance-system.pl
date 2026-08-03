% A tiny assumption-based truth maintenance system.
%
% An environment is a set of assumptions.  Justifications derive beliefs from
% assumptions and from other derived beliefs.  The TMS can therefore explain
% which environments support a belief and which environments are inconsistent
% because they support contradictory conclusions.

%% goal: tmsSupport(X0, X1)

%% goal: tmsJustification(X0, X1, X2)

%% goal: tmsInconsistent(X0)

%% goal: tmsConclusion(X0, X1)



% Candidate environments.
environment(clear_only, [sensor_clear]).
environment(blocked_only, [sensor_blocked]).
environment(conflicting_sensors, [sensor_clear, sensor_blocked]).
environment(override_blocked, [sensor_blocked, operator_override]).

assumes(Environment, Assumption) :-
  environment(Environment, Assumptions),
  member(Assumption, Assumptions).

% Justifications.  Preconditions are either assumption(Name) or another derived
% belief.  The last justification says an operator override can permit motion
% even when the blocked-path belief is also present.
justification(j_clear_path, [assumption(sensor_clear)], clear_path).
justification(j_blocked_path, [assumption(sensor_blocked)], blocked_path).
justification(j_permit_from_clear, [clear_path], permit_go).
justification(j_forbid_from_blocked, [blocked_path], forbid_go).
justification(j_override, [assumption(operator_override), blocked_path], permit_go).

all_hold(_, []).
all_hold(Environment, [assumption(Assumption) | Rest]) :-
  assumes(Environment, Assumption),
  all_hold(Environment, Rest).
all_hold(Environment, [Belief | Rest]) :-
  supported(Environment, Belief),
  all_hold(Environment, Rest).

supported(Environment, Belief) :-
  justification(_, Preconditions, Belief),
  all_hold(Environment, Preconditions).

contradicts(permit_go, forbid_go).
contradicts(forbid_go, permit_go).
inconsistent(Environment) :-
  supported(Environment, Left),
  supported(Environment, Right),
  contradicts(Left, Right).

% Show the actual justifications that fired, not just the final supported beliefs.
fires(Environment, Justification, Belief) :-
  justification(Justification, Preconditions, Belief),
  all_hold(Environment, Preconditions).

tmsSupport(Environment, Belief) :- supported(Environment, Belief).
tmsJustification(Environment, Justification, Belief) :- fires(Environment, Justification, Belief).
tmsInconsistent(Environment) :- inconsistent(Environment).
tmsConclusion(case, "truth maintenance separates support from consistency across assumption environments") :-
  inconsistent(conflicting_sensors).
