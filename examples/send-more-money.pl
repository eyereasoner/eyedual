% Cryptarithm search for SEND + MORE = MONEY.
%
% The solver assigns distinct decimal digits to letters while enforcing the
% column-by-column carries.  Rather than generate all digit assignments first,
% each column constraint is applied as soon as its letters are chosen.
%% goal: cryptarithm_answer(X0, X1)


% The search domain is a shrinking digit list threaded through select/3 calls.
all_digits([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]).

send_more_money(solution(S, E, N, D, M, O, R, Y)) :-
  all_digits(Digits),
  (M = 1),
  (O = 0),
  select(M, Digits, D0),
  select(O, D0, D1),

  select(D, D1, D2),
  select(E, D2, D3),
  (Onessum is D + E),
  (Y is Onessum mod 10),
  (Carry1 is Onessum // 10),
  select(Y, D3, D4),

  select(N, D4, D5),
  select(R, D5, D6),
  (Tenspartial is N + R),
  (Tenssum is Tenspartial + Carry1),
  (E is Tenssum mod 10),
  (Carry2 is Tenssum // 10),

  (Hundredspartial is E + O),
  (Hundredssum is Hundredspartial + Carry2),
  (N is Hundredssum mod 10),
  (Carry3 is Hundredssum // 10),

  select(S, D6, _d7),
  (S \= 0),
  (Thousandspartial is S + M),
  (Thousandssum is Thousandspartial + Carry3),
  (O is Thousandssum mod 10),
  (M is Thousandssum // 10).

% Number constructors are used only for readable output after a solution is found.
number4(A, B, C, D, Value) :-
  (Apart is A * 1000),
  (Bpart is B * 100),
  (Cpart is C * 10),
  (Ab is Apart + Bpart),
  (Abc is Ab + Cpart),
  (Value is Abc + D).

number5(A, B, C, D, E, Value) :-
  (Apart is A * 10000),
  (Bpart is B * 1000),
  (Cpart is C * 100),
  (Dpart is D * 10),
  (Ab is Apart + Bpart),
  (Abc is Ab + Cpart),
  (Abcd is Abc + Dpart),
  (Value is Abcd + E).

cryptarithm_answer(assignments, solution(S, E, N, D, M, O, R, Y)) :-
  send_more_money(solution(S, E, N, D, M, O, R, Y)).
cryptarithm_answer(equation, equation(Send, More, Money)) :-
  send_more_money(solution(S, E, N, D, M, O, R, Y)),
  number4(S, E, N, D, Send),
  number4(M, O, R, E, More),
  number5(M, O, N, E, Y, Money).
cryptarithm_answer(solution_count, Count) :-
  countall(send_more_money(_solution), Count).
