% Deontic logic: obligations, prohibitions, compensations, and violations.
% The example separates normative facts from observed actions.  Missing an
% obligation and performing a prohibited action are violations, but a prohibited
% action can be marked compensated when the configured repair action occurred.

%% goal: violation(X0, X1)

%% goal: compensation(X0, X1)

%% goal: status(X0, X1)


% Facts state what the actor was obliged/prohibited to do and what happened.
actor(alice).
action(share_record).
action(delete_unneeded_copy).

obliged(alice, obtain_consent).
prohibited(alice, share_record).
compensates(share_record, notify_dpo).

performed(alice, share_record).
performed(alice, notify_dpo).
not_performed(alice, obtain_consent).
not_performed(alice, delete_unneeded_copy).

% Missing an obligation and performing a prohibited action are both violations.
violation(Actor, missed_obligation(Action)) :-
  obliged(Actor, Action),
  not_performed(Actor, Action).

violation(Actor, prohibited_action(Action)) :-
  prohibited(Actor, Action),
  performed(Actor, Action).

% Some prohibited actions can be repaired by a configured compensation action.
compensated_violation(Actor, Action, Compensation) :-
  prohibited(Actor, Action),
  performed(Actor, Action),
  compensates(Action, Compensation),
  performed(Actor, Compensation).

uncompensated_violation(Actor, missed_obligation(Action)) :-
  violation(Actor, missed_obligation(Action)).

uncompensated_violation(Actor, prohibited_action(Action)) :-
  violation(Actor, prohibited_action(Action)),
  \+ compensated_violation(Actor, Action, _compensation).


compensation(Actor, compensation(Action, Compensation)) :-
  compensated_violation(Actor, Action, Compensation).

status(Actor, requires_review) :-
  uncompensated_violation(Actor, _violation).
