% Population statistics for a small numeric sample.
%
% The sample is the textbook data set [2,4,4,4,5,5,7,9], whose population
% mean is 5, variance is 4, and standard dederivation is 2.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: count(X0, X1)

%% goal: mean(X0, X1)

%% goal: populationVariance(X0, X1)

%% goal: populationStddev(X0, X1)


% The sample is one list fact, which lets recursive list folds demonstrate
% aggregation without introducing a separate row relation.
sample(scores, [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0]).

sum([], 0.0).
% sum/2 and squared_error_sum/3 are recursive folds; the public relations then
% derive count, mean, population variance, and standard dederivation.
sum([X|Xs], Total) :-
  sum(Xs, Rest),
  (Total is X + Rest).

mean(Name, Mean) :-
  sample(Name, Values),
  sum(Values, Total),
  length(Values, Count),
  (Mean is Total / Count).

squared_error_sum([], _mean, 0.0).
squared_error_sum([X|Xs], Mean, Total) :-
  (Delta is X - Mean),
  (Squared is Delta ** 2.0),
  squared_error_sum(Xs, Mean, Rest),
  (Total is Squared + Rest).

population_variance(Name, Variance) :-
  sample(Name, Values),
  mean(Name, Mean),
  squared_error_sum(Values, Mean, Sumsquarederrors),
  length(Values, Count),
  (Variance is Sumsquarederrors / Count).

population_stddev(Name, Stddev) :-
  population_variance(Name, Variance),
  (Stddev is Variance ** 0.5).

count(Name, Count) :-
  sample(Name, Values),
  length(Values, Count).


populationVariance(Name, Variance) :-
  population_variance(Name, Variance).

populationStddev(Name, Stddev) :-
  population_stddev(Name, Stddev).
