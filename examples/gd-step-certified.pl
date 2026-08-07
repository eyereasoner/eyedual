% Memoize interval computations reused across width, midpoint, gradient, step,
% objective, and contraction report relations.
% Output declarations: host-supplied goals select the relations written to this example's golden output.
%
% This is a proof-friendly optimization trace: every numeric fact needed to
% justify the step is queried, so proof output can certify why the update
% is accepted.
%% goal: eta(X0, X1)

%% goal: etaLeHalf(X0, X1)

%% goal: xBounds(X0, X1)

%% goal: midpoint(X0, X1)

%% goal: width(X0, X1)

%% goal: gradientBounds(X0, X1)

%% goal: stepBounds(X0, X1)

%% goal: objectiveBounds(X0, X1)

%% goal: widthContractsAt(X0, X1)


:- discontiguous(x_bounds/3).
:- discontiguous(width/2).

% Program structure: facts set up the scenario, and rules derive the queried conclusions.

% Adapted from Eyeling's gd-step-certified.n3.
% One-dimensional gradient descent over certified interval bounds.

max_k(10).
target(1.0).
% Derivation rules: each rule below contributes one logical step toward the displayed results.
eta(Eta) :- (Eta is 1.0 / 5).
x_bounds(0, 0.0, 2.0).

index(0). index(1). index(2). index(3). index(4). index(5).
index(6). index(7). index(8). index(9). index(10).

previous(1, 0). previous(2, 1). previous(3, 2). previous(4, 3). previous(5, 4).
previous(6, 5). previous(7, 6). previous(8, 7). previous(9, 8). previous(10, 9).

g_bounds(K, Gl, Gu) :-
  target(A),
  x_bounds(K, L, U),
  (Dl is L - A),
  (Du is U - A),
  (Gl is 2 * Dl),
  (Gu is 2 * Du).

p_bounds(K, Pl, Pu) :-
  eta(Eta),
  g_bounds(K, Gl, Gu),
  (Pl is Eta * Gl),
  (Pu is Eta * Gu).

x_bounds(K1, L1, U1) :-
  previous(K1, K),
  x_bounds(K, L, U),
  target(A),
  eta(Eta),
  (Dl is L - A),
  (Du is U - A),
  (Gl is 2 * Dl),
  (Gu is 2 * Du),
  (Pl is Eta * Gl),
  (Pu is Eta * Gu),
  (L1 is L - Pu),
  (U1 is U - Pl).

width(K, W) :-
  x_bounds(K, L, U),
  (W is U - L).

midpoint(K, M, Halfw) :-
  x_bounds(K, L, U),
  width(K, W),
  (Halfw is W / 2),
  (Sum is L + U),
  (M is Sum / 2).

eta_le_half(true) :-
  eta(Eta),
  (Half is 1.0 / 2),
  (Eta =< Half).

width_contracts_at(K1, true) :-
  eta_le_half(true),
  previous(K1, K),
  width(K, W),
  width(K1, W1),
  (W1 =< W).

max2(A, B, A) :- (A >= B).
max2(A, B, B) :- (A < B).
min2(A, B, A) :- (A =< B).
min2(A, B, B) :- (A > B).

end_squares(K, Sl, Su) :-
  target(A),
  x_bounds(K, L, U),
  (Dl is L - A),
  (Du is U - A),
  (Sl is Dl * Dl),
  (Su is Du * Du).

f_upper(K, Fu) :-
  end_squares(K, Sl, Su),
  max2(Sl, Su, Fu).

f_lower(K, 0.0) :-
  target(A),
  x_bounds(K, L, U),
  (L =< A),
  (A =< U).

f_lower(K, Fl) :-
  target(A),
  x_bounds(K, L, U),
  (U < A),
  end_squares(K, Sl, Su),
  min2(Sl, Su, Fl).

f_lower(K, Fl) :-
  target(A),
  x_bounds(K, L, U),
  (A < L),
  end_squares(K, Sl, Su),
  min2(Sl, Su, Fl).

eta(result, Eta) :-
  eta(Eta).

etaLeHalf(result, true) :-
  eta_le_half(true).

xBounds(result, bounds(K, L, U)) :-
  index(K),
  x_bounds(K, L, U).

midpoint(result, midpoint(K, M, Halfw)) :-
  index(K),
  midpoint(K, M, Halfw).

width(result, width(K, W)) :-
  index(K),
  width(K, W).

gradientBounds(result, gradient(K, Gl, Gu)) :-
  index(K),
  g_bounds(K, Gl, Gu).

stepBounds(result, step(K, Pl, Pu)) :-
  index(K),
  p_bounds(K, Pl, Pu).

objectiveBounds(result, f(K, Fl, Fu)) :-
  index(K),
  f_lower(K, Fl),
  f_upper(K, Fu).

widthContractsAt(result, K) :-
  width_contracts_at(K, true).
