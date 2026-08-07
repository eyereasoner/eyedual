% Workplace compliance from explicit action facts.
%
% The source example generated a large dynamic dataset.  EyeProlog keeps the data
% explicit and reproducible: each `does/2` fact records an observed employee
% action, and the rules classify compliant and non-compliant behaviour.

%% goal: status(X0, X1)


employee(alice).
employee(bob).
employee(carol).
employee(dave).

does(alice, log_off_at_end_of_shift).
does(bob, work_related_task).
does(bob, log_off_at_end_of_shift).
does(carol, access_social_media).
does(dave, work_related_task).

% Work-related activity is compliant when the employee also logs off.
status(Person, compliant) :-
  employee(Person),
  does(Person, work_related_task),
  does(Person, log_off_at_end_of_shift).

% Logging off is compliant by itself when no work task was observed.
status(Person, compliant) :-
  employee(Person),
  does(Person, log_off_at_end_of_shift),
  \+ does(Person, work_related_task).

% A work task without the required log-off is non-compliant.
status(Person, non_compliant) :-
  employee(Person),
  does(Person, work_related_task),
  \+ does(Person, log_off_at_end_of_shift).

% Accessing social media is non-compliant in this policy.
status(Person, non_compliant) :-
  employee(Person),
  does(Person, access_social_media).
