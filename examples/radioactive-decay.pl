% Science example: radioactive decay.
%
% Activity remaining after elapsed time is initial_activity * 0.5^(t/half_life).
% The file querys half-lives elapsed, remaining activity, decayed activity,
% and a threshold-based low-activity status.
%% goal: halfLivesElapsed(X0, X1)

%% goal: remainingActivity_Bq(X0, X1)

%% goal: decayedActivity_Bq(X0, X1)

%% goal: status(X0, X1)

%% goal: reason(X0, X1)


% The iodine sample has elapsed for two half-lives, making the expected remaining
% activity one quarter of the initial activity.
sample(iodine_sample, initial_activity_bq, 80.0).
sample(iodine_sample, half_life_h, 8.0).
sample(iodine_sample, elapsed_h, 16.0).
threshold(iodine_sample, low_activity_bq, 25.0).

% The derivation first computes elapsed half-lives, then a remaining fraction,
% and finally converts that fraction into Bq.
half_lives(Sample, Count) :-
  sample(Sample, elapsed_h, Elapsed),
  sample(Sample, half_life_h, Halflife),
  (Count is Elapsed / Halflife).

remaining_fraction(Sample, Fraction) :-
  half_lives(Sample, Count),
  (Fraction is 0.5 ** Count).

remaining_activity(Sample, Remaining) :-
  sample(Sample, initial_activity_bq, Initial),
  remaining_fraction(Sample, Fraction),
  (Remaining is Initial * Fraction).

decayed_activity(Sample, Decayed) :-
  sample(Sample, initial_activity_bq, Initial),
  remaining_activity(Sample, Remaining),
  (Decayed is Initial - Remaining).

low_activity(Sample) :-
  remaining_activity(Sample, Remaining),
  threshold(Sample, low_activity_bq, Limit),
  (Remaining < Limit).

halfLivesElapsed(Sample, Count) :-
  half_lives(Sample, Count).

remainingActivity_Bq(Sample, Remaining) :-
  remaining_activity(Sample, Remaining).

decayedActivity_Bq(Sample, Decayed) :-
  decayed_activity(Sample, Decayed).

status(Sample, low_activity) :-
  low_activity(Sample).

reason(Sample, "two half-lives leave one quarter of the initial activity") :-
  low_activity(Sample).
