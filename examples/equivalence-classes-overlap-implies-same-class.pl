% Equivalence-class overlap example adapted from Eyeling.
%
% The finite classMember/2 facts represent an already-computed equivalence
% closure.  sameClassBecauseOfSharedMember/3 reports the witness Z proving that
% X and Y belong to the same class because both contain that shared member.
%
% This is useful for proof output: the conclusion is not just that two class
% labels coincide, but also which element explains the overlap.
%% goal: sameClassBecauseOfSharedMember(X0, X1, X2)


classMember(class_abc, a).
classMember(class_abc, b).
classMember(class_abc, c).

inClassOf(U, X) :-
  classMember(Class, U),
  classMember(Class, X).

sameClass(X, Y) :-
  classMember(Class, X),
  classMember(Class, Y).

sameClassBecauseOfSharedMember(X, Y, Z) :-
  inClassOf(Z, X),
  inClassOf(Z, Y),
  sameClass(X, Y),
  (X \= Y).
