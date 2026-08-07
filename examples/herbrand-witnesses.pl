% Existential-style consequences as explicit Herbrand witness terms.
%
% EyeProlog has no blank nodes and no existential variables in rule heads.  The
% practical executable form is to put a named functional term directly in the
% rule head.  The term is ordinary data: stable, visible, and proof-friendly.

%% goal: has_parent(X0, X1)

%% goal: registration(X0, X1, X2)

%% goal: same_witness(X0, X1)

%% goal: distinct_witnesses(X0, X1)


person(alice).
person(bob).

takes(alice, logic).
takes(alice, math).
takes(bob, logic).

% One variable: every person has a deterministic parent witness.
has_parent(Child, parent_of(Child)) :-
  person(Child).

% Two variables: every student/course pair has its own registration witness.
registration(Student, Course, registration_of(Student, Course)) :-
  takes(Student, Course).

same_witness(parent_of_alice, true) :-
  (parent_of(alice) = parent_of(alice)).

distinct_witnesses(alice_logic_vs_alice_math, true) :-
  (registration_of(alice, logic) \= registration_of(alice, math)).
