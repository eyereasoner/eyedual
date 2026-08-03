% Dog-license compliance rule adapted from Eyeling dog.n3.
%
% hasDog/2 records individual dogs.  dogCount/2 uses countall/2 to aggregate all
% dogs per subject, and mustHave/2 derives the license obligation exactly for
% subjects with more than four registered dogs.
%
% The example is intentionally tiny but useful as an aggregate-counting pattern.
%% goal: mustHave(X0, X1)


hasDog(alice, dog1).
hasDog(alice, dog2).
hasDog(alice, dog3).
hasDog(alice, dog4).
hasDog(alice, dog5).
hasDog(bob, dog6).
hasDog(bob, dog7).

% countall/2 counts all matching dogs for the same subject.
dogCount(Subject, Count) :-
  hasDog(Subject, _any),
  countall(hasDog(Subject, _dog), Count).

mustHave(Subject, dogLicense) :-
  dogCount(Subject, Count),
  (Count > 4).
