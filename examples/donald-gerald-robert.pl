% A pandigital cryptarithm: DONALD + GERALD = ROBERT.
%
% Ten distinct letters must use all ten decimal digits. A naive assignment
% explores 10! permutations; this solver instead propagates carries from right
% to left and removes each chosen or derived digit from a shrinking domain.
query(pandigital_cryptarithm_answer(_, _)).

all_digits([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]).

pandigital_cryptarithm(solution(D, O, N, A, L, G, E, R, B, T)) :-
  all_digits(Digits),

  % Units: D + D = T, with carry C1.
  select(D, Digits, D0),
  D \= 0,
  UnitsSum is D + D,
  T is UnitsSum mod 10,
  C1 is UnitsSum // 10,
  select(T, D0, D1),

  % Tens: L + L + C1 = R, with carry C2.
  select(L, D1, D2),
  TensSum is L + L + C1,
  R is TensSum mod 10,
  C2 is TensSum // 10,
  R \= 0,
  select(R, D2, D3),

  % Hundreds: A + A + C2 = E, with carry C3.
  select(A, D3, D4),
  HundredsSum is A + A + C2,
  E is HundredsSum mod 10,
  C3 is HundredsSum // 10,
  select(E, D4, D5),

  % Thousands: N + R + C3 = B, with carry C4.
  select(N, D5, D6),
  ThousandsSum is N + R + C3,
  B is ThousandsSum mod 10,
  C4 is ThousandsSum // 10,
  select(B, D6, D7),

  % Ten-thousands: O cancels, so E + C4 must be exactly 10 * C5.
  CarrySum is E + C4,
  0 is CarrySum mod 10,
  C5 is CarrySum // 10,

  % Hundred-thousands: D + G + C5 = R, which derives G directly.
  G is R - D - C5,
  G > 0,
  select(G, D7, D8),

  % The sole remaining digit is O; it is also a leading digit.
  select(O, D8, []),
  O \= 0.

number6(A, B, C, D, E, F, Value) :-
  A5 is A * 100000,
  B4 is B * 10000,
  C3 is C * 1000,
  D2 is D * 100,
  E1 is E * 10,
  AB is A5 + B4,
  ABC is AB + C3,
  ABCD is ABC + D2,
  ABCDE is ABCD + E1,
  Value is ABCDE + F.

pandigital_cryptarithm_answer(naive_search_space, permutations(10, 3628800)) :-
  all_digits(Digits),
  length(Digits, 10).
pandigital_cryptarithm_answer(assignments, solution(D, O, N, A, L, G, E, R, B, T)) :-
  pandigital_cryptarithm(solution(D, O, N, A, L, G, E, R, B, T)).
pandigital_cryptarithm_answer(equation, equation(Donald, Gerald, Robert)) :-
  pandigital_cryptarithm(solution(D, O, N, A, L, G, E, R, B, T)),
  number6(D, O, N, A, L, D, Donald),
  number6(G, E, R, A, L, D, Gerald),
  number6(R, O, B, E, R, T, Robert).
pandigital_cryptarithm_answer(digit_usage, [D, O, N, A, L, G, E, R, B, T]) :-
  pandigital_cryptarithm(solution(D, O, N, A, L, G, E, R, B, T)).
pandigital_cryptarithm_answer(solution_count, Count) :-
  countall(pandigital_cryptarithm(_), Count).
