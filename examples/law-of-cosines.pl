% Law of cosines: c^2 = a^2 + b^2 - 2ab cos(C).
%
% This pure-geometry example keeps trigonometry outside the language by storing
% cos(C) as data.  EyeProlog then performs the algebraic part of the theorem with
% ordinary arithmetic predicates and querys both c^2 and c.
%
% The 60-degree sample uses cos(C) = 0.5, so the proof shows each intermediate
% numeric step rather than hiding the computation in one builtin.
%% goal: sideCSquared(X0, X1)

%% goal: sideC(X0, X1)

%% goal: status(X0, X1)


% The triangle fact stores the two known sides and the cosine of the included
% angle.  Storing cos(C) directly avoids needing trigonometric built-ins while
% still demonstrating the geometric formula.
triangle(tri60, 7, 9, 0.5).

% Compute c^2 first so both squared and square-rooted outputs can be shown.
% side_c_squared/2 follows the law of cosines step by step, then side_c/2
% takes the square root for the reported side length.
side_c_squared(Triangle, C2) :-
  triangle(Triangle, A, B, Cosc),
  (A2 is A * A),
  (B2 is B * B),
  (Sum is A2 + B2),
  (Twoa is 2 * A),
  (Twoab is Twoa * B),
  (Projection is Twoab * Cosc),
  (C2 is Sum - Projection).

side_c(Triangle, C) :-
  side_c_squared(Triangle, C2),
  (C is C2 ** 0.5).

sideCSquared(Triangle, C2) :- side_c_squared(Triangle, C2).
sideC(Triangle, C) :- side_c(Triangle, C).
status(Triangle, acute_triangle) :- side_c_squared(Triangle, C2), (C2 > 0).
