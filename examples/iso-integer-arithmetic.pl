% ISO integer division, remainders, shifts, and bit operations.
%
% In EyeProlog's supported profile, div and // both truncate the quotient toward
% zero. mod normalizes by a positive divisor while rem keeps the dividend sign.
%% goal: report(X0, X1)


report(div_mod, quotient_remainder(Q, R)) :-
  Q is -7 div 3,
  R is -7 mod 3.

report(quotient_rem, quotient_remainder(Q, R)) :-
  Q is -7 // 3,
  R is -7 rem 3.

report(bit_mask, Masked) :-
  Masked is 13 /\ 6.

report(bit_union, Union) :-
  Union is 8 \/ 3.

report(left_shift, Shifted) :-
  Shifted is 3 << 2.
