% Modular exponentiation by repeated squaring.
%
% pow_mod(Base, Exp, Modulus, Result) uses the even/odd exponent split, giving
% logarithmic-depth arithmetic.  Memoization matters when the same modular powers
% are reused by Fermat-style congruence checks.
%% goal: modular_answer(X0, X1)



% Base case: any nonzero base to exponent zero is 1 modulo Mod.
pow_mod(_base, 0, Mod, Result) :- (Result is 1 mod Mod).
pow_mod(Base, Exp, Modulus, Result) :-
  (Exp > 0),
  (0 is Exp mod 2),
  (Half is Exp // 2),
  pow_mod(Base, Half, Modulus, Halfpower),
  (Square is Halfpower * Halfpower),
  (Result is Square mod Modulus).
pow_mod(Base, Exp, Modulus, Result) :-
  (Exp > 0),
  (1 is Exp mod 2),
  (Evenexp is Exp - 1),
  pow_mod(Base, Evenexp, Modulus, Evenpower),
  (Product is Base * Evenpower),
  (Result is Product mod Modulus).

% This is a Fermat congruence check, not a full primality proof.
fermat_witness(Base, Primecandidate) :-
  (Exponent is Primecandidate - 1),
  pow_mod(Base, Exponent, Primecandidate, 1).

modular_answer(pow_7_560_mod_561, R) :- pow_mod(7, 560, 561, R).
modular_answer(pow_2_1000_mod_1009, R) :- pow_mod(2, 1000, 1009, R).
modular_answer(fermat_2_101, true) :- fermat_witness(2, 101).
modular_answer(fermat_3_101, true) :- fermat_witness(3, 101).
