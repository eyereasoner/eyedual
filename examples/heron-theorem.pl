% Heron's theorem: area = sqrt(s(s-a)(s-b)(s-c)).
%
% The sample is the classic 13-14-15 triangle, whose area is exactly 84.  The
% program querys the semiperimeter, Heron product, and final area so proof
% output can be checked against the familiar hand calculation.
%
% This is a compact example of theorem-shaped arithmetic: facts name a geometric
% object, reusable relations compute intermediates, and wrapper predicates choose
% the report vocabulary.
%% goal: semiperimeter(X0, X1)

%% goal: heronProduct(X0, X1)

%% goal: area(X0, X1)

%% goal: status(X0, X1)


% A single survey triangle is enough to demonstrate the formula; 13-14-15 has
% integer area 84, which makes the computed result easy to check.
triangle(field_plot, 13, 14, 15).

% semiperimeter/2 is the reusable first step in Heron's formula.
semiperimeter(Triangle, S) :-
  triangle(Triangle, A, B, C),
  (Ab is A + B),
  (Sum is Ab + C),
  (S is Sum / 2).

% Area is obtained by taking the square root of this Heron product.
heron_product(Triangle, Product) :-
  triangle(Triangle, A, B, C),
  semiperimeter(Triangle, S),
  (Sa is S - A),
  (Sb is S - B),
  (Sc is S - C),
  (T1 is S * Sa),
  (T2 is T1 * Sb),
  (Product is T2 * Sc).

area(Triangle, Area) :-
  heron_product(Triangle, Product),
  (Area is Product ** 0.5).

heronProduct(Triangle, P) :- heron_product(Triangle, P).
status(Triangle, valid_survey_triangle) :- area(Triangle, A), (A > 0).
