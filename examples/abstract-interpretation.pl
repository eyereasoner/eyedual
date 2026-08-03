% Abstract interpretation over a tiny imperative program.
%
% The concrete program is:
%
%   x := input();
%   if x < 0 then y := -x else y := x;
%   z := 10 / y;
%
% Instead of executing the program for every integer input, this example tracks
% only the abstract sign of each variable: neg, zero, or pos.  The analysis is
% deliberately conservative: if the join point can see y = zero on any path, the
% division is reported as a possible division-by-zero warning.

%% goal: absState(X0, X1, X2)

%% goal: absWarning(X0, X1)

%% goal: absConclusion(X0, X1)



% The abstract domain.
input_sign(neg).
input_sign(zero).
input_sign(pos).

% The input statement gives x any of the three abstract signs.
abs_state(input, x, Sign) :- input_sign(Sign).

% The branch refines the sign of x.  The negative branch only receives neg; the
% non-negative branch receives zero or pos.
abs_state(negative_branch, x, neg) :- abs_state(input, x, neg).
abs_state(nonnegative_branch, x, zero) :- abs_state(input, x, zero).
abs_state(nonnegative_branch, x, pos) :- abs_state(input, x, pos).

% Transfer functions for assignments.  In the negative branch, y := -x turns a
% negative x into a positive y.  In the non-negative branch, y := x preserves the
% zero/positive information.
abs_state(negative_branch, y, pos) :- abs_state(negative_branch, x, neg).
abs_state(nonnegative_branch, y, Sign) :- abs_state(nonnegative_branch, x, Sign).

% The join point merges abstract states from both branches.
abs_state(join, Var, Sign) :- abs_state(negative_branch, Var, Sign).
abs_state(join, Var, Sign) :- abs_state(nonnegative_branch, Var, Sign).

% A possible zero denominator is enough to raise a conservative warning.
possible_division_by_zero(join) :- abs_state(join, y, zero).

absState(Point, Var, sign(Sign)) :- abs_state(Point, Var, Sign).
absWarning(division_by_zero, Point) :- possible_division_by_zero(Point).
absConclusion(case, "abstract interpretation keeps all feasible signs and warns because y may be zero") :-
  possible_division_by_zero(join).
