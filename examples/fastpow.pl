% Fast exponentiation examples adapted from Eyeling fastpow.n3.
%
% pow/3 demonstrates exponentiation by squaring, while pow_mod/4 performs the
% same recursion under a modulus so huge powers remain small enough for ordinary
% output and proof display.
%
% The file also includes deliberately slower and tower-style reports, making it a
% small arithmetic benchmark for recursive definitions, modular arithmetic, and
% bounded output selection.
%% goal: pow(X0, X1)

%% goal: powSlow(X0, X1)

%% goal: powMod1e6(X0, X1)

%% goal: tower(X0, X1)

%% goal: towerMod1e6(X0, X1)


% Base case and parity split for exponentiation by squaring.  Even exponents
% square the half-power; odd exponents peel off one base factor.
fast_power(_Base, 0, 1).
% Recursive even/odd clauses reduce the exponent quickly rather than counting
% down one multiplication at a time.
fast_power(Base, Exp, Value) :-
  (Exp > 0),
  (0 is Exp mod 2),
  (Half is Exp // 2),
  fast_power(Base, Half, Halfvalue),
  (Value is Halfvalue * Halfvalue).
fast_power(Base, Exp, Value) :-
  (Exp > 0),
  (1 is Exp mod 2),
  (Evenexp is Exp - 1),
  fast_power(Base, Evenexp, Evenvalue),
  (Value is Base * Evenvalue).

% pow_mod/4 applies the modulus at each multiplication to keep values small.
pow_mod(_base, 0, _mod, 1).
pow_mod(Base, Exp, Mod, Value) :-
  (Exp > 0),
  (0 is Exp mod 2),
  (Half is Exp // 2),
  pow_mod(Base, Half, Mod, Halfvalue),
  (Square is Halfvalue * Halfvalue),
  (Value is Square mod Mod).
pow_mod(Base, Exp, Mod, Value) :-
  (Exp > 0),
  (1 is Exp mod 2),
  (Evenexp is Exp - 1),
  pow_mod(Base, Evenexp, Mod, Evenvalue),
  (Product is Base * Evenvalue),
  (Value is Product mod Mod).

% Tetration examples are kept as facts here so this file focuses on fast power
% and modular power rather than an additional tower evaluator.
tower(2, 4, 65536).
tower_mod(2, 5, 1000000, 156736).

pow([2, 10], Value) :- fast_power(2, 10, Power), (Value is Power + 0.0).
powSlow([2, 10], Value) :- (Value is 2 ** 10).
powMod1e6([2, 10000], Value) :- pow_mod(2, 10000, 1000000, Value).
powMod1e6([3, 10000], Value) :- pow_mod(3, 10000, 1000000, Value).
tower([2, 4], Value) :- tower(2, 4, Value).
towerMod1e6([2, 5], Value) :- tower_mod(2, 5, 1000000, Value).
