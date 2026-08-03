% Math example: least-squares linear regression.
%
% The rules reduce a list of points to sufficient statistics, then derive the
% fitted slope, intercept, and coefficient of determination R^2.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%
% Accumulating sufficient statistics keeps the regression formulas compact and
% makes the proof show the same intermediate values a hand calculation would use.
%% goal: slope(X0, X1)

%% goal: intercept(X0, X1)

%% goal: rSquared(X0, X1)

%% goal: status(X0, X1)

%% goal: reason(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
dataset(regression1, [point(1.0, 2.0), point(2.0, 3.0), point(3.0, 5.0), point(4.0, 4.0)]).
threshold(regression1, minimum_r_squared, 0.60).

% stats/7 folds points into N, Σx, Σy, Σx², Σxy, and Σy².
stats([], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0).
% Derivation rules: each rule below contributes one logical step toward the displayed results.
stats([point(X, Y)|Rest], N, Sumx, Sumy, Sumxx, Sumxy, Sumyy) :-
  stats(Rest, N0, Sumx0, Sumy0, Sumxx0, Sumxy0, Sumyy0),
  (N is N0 + 1.0),
  (Sumx is Sumx0 + X),
  (Sumy is Sumy0 + Y),
  (Xx is X * X),
  (Sumxx is Sumxx0 + Xx),
  (Xy is X * Y),
  (Sumxy is Sumxy0 + Xy),
  (Yy is Y * Y),
  (Sumyy is Sumyy0 + Yy).

sufficient_statistics(Data, N, Sumx, Sumy, Sumxx, Sumxy, Sumyy) :-
  dataset(Data, Points),
  stats(Points, N, Sumx, Sumy, Sumxx, Sumxy, Sumyy).

slope(Data, Slope) :-
  sufficient_statistics(Data, N, Sumx, Sumy, Sumxx, Sumxy, _sumyy),
  (Nsumxy is N * Sumxy),
  (Sumxsumy is Sumx * Sumy),
  (Numerator is Nsumxy - Sumxsumy),
  (Nsumxx is N * Sumxx),
  (Sumxsquared is Sumx * Sumx),
  (Denominator is Nsumxx - Sumxsquared),
  (Slope is Numerator / Denominator).

intercept(Data, Intercept) :-
  sufficient_statistics(Data, N, Sumx, Sumy, _sumxx, _sumxy, _sumyy),
  slope(Data, Slope),
  (Slopesumx is Slope * Sumx),
  (Numerator is Sumy - Slopesumx),
  (Intercept is Numerator / N).

r_squared(Data, R2) :-
  sufficient_statistics(Data, N, Sumx, Sumy, Sumxx, Sumxy, Sumyy),
  (Nsumxy is N * Sumxy),
  (Sumxsumy is Sumx * Sumy),
  (Numeratorbase is Nsumxy - Sumxsumy),
  (Numerator is Numeratorbase ** 2.0),
  (Nsumxx is N * Sumxx),
  (Sumxsquared is Sumx * Sumx),
  (Xspread is Nsumxx - Sumxsquared),
  (Nsumyy is N * Sumyy),
  (Sumysquared is Sumy * Sumy),
  (Yspread is Nsumyy - Sumysquared),
  (Denominator is Xspread * Yspread),
  (R2 is Numerator / Denominator).

accepted_fit(Data) :-
  r_squared(Data, R2),
  threshold(Data, minimum_r_squared, Minimum),
  (R2 >= Minimum).



rSquared(Data, R2) :-
  r_squared(Data, R2).

status(Data, accepted_linear_fit) :-
  accepted_fit(Data).

reason(Data, "R squared meets the minimum explanatory-power threshold") :-
  accepted_fit(Data).
