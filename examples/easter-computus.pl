% Gregorian Easter computus adapted from Eyeling's easter.n3.
% Each case is a year in a sample decade.  The rules derive the Meeus/Jones/
% Butcher remainders, the final month/day, and a separate window check showing
% that the result lies in the legal Gregorian Easter range.

%% goal: easterDate(X0, X1)

%% goal: computusRemainders(X0, X1)

%% goal: legalGregorianWindow(X0, X1)


% Sample years for which the computed Easter date is queried.
case(y2026, 2026).
case(y2027, 2027).
case(y2028, 2028).
case(y2029, 2029).
case(y2030, 2030).
case(y2031, 2031).
case(y2032, 2032).
case(y2033, 2033).
case(y2034, 2034).
case(y2035, 2035).

% These checks document the legal ranges of intermediate computus values.
valid_golden(N) :- between(0, 18, N).
valid_epact(N) :- between(0, 29, N).
valid_weekday(N) :- between(0, 6, N).
legal_easter_date(3, D) :- between(22, 31, D).
legal_easter_date(4, D) :- between(1, 25, D).
month_name(3, march).
month_name(4, april).

% Butcher/Meeus-style integer arithmetic, kept explicit for proof readability.
computus(Case, Year, Month, Day, J, K, Q, R, V, Z) :-
  case(Case, Year),
  (J is Year mod 19),
  (K is Year // 100),
  (H is Year mod 100),
  (M is K // 4),
  (N is K mod 4),
  (Kp8 is K + 8),
  (P is Kp8 // 25),
  (Kminusp is K - P),
  (Kminuspplus1 is Kminusp + 1),
  (Q is Kminuspplus1 // 3),
  (Nineteenj is 19 * J),
  (T1 is Nineteenj + K),
  (T2 is T1 - M),
  (T3 is T2 - Q),
  (T4 is T3 + 15),
  (R is T4 mod 30),
  (S is H // 4),
  (U is H mod 4),
  (Twon is 2 * N),
  (Twos is 2 * S),
  (L1 is 32 + Twon),
  (L2 is L1 + Twos),
  (L3 is L2 - R),
  (L4 is L3 - U),
  (V is L4 mod 7),
  (Elevenr is 11 * R),
  (Twentytwov is 22 * V),
  (W1 is J + Elevenr),
  (W2 is W1 + Twentytwov),
  (W is W2 // 451),
  (Sevenw is 7 * W),
  (X1 is R + V),
  (X2 is X1 - Sevenw),
  (X3 is X2 + 114),
  (Month is X3 // 31),
  (Z is X3 mod 31),
  (Day is Z + 1).

checks_pass(Case) :-
  computus(Case, _year, Month, Day, J, _k, _q, R, V, _z),
  valid_golden(J),
  valid_epact(R),
  valid_weekday(V),
  month_name(Month, _name),
  legal_easter_date(Month, Day).

easterDate(Case, date(Year, Monthname, Day)) :-
  computus(Case, Year, Month, Day, _j, _k, _q, _r, _v, _z),
  month_name(Month, Monthname).

computusRemainders(Case, remainders(J, R, V)) :-
  computus(Case, _year, _month, _day, J, _k, _q, R, V, _z).

legalGregorianWindow(Case, true) :-
  checks_pass(Case).
