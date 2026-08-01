% From The Art of Eyepl, Chapter 39.
answer(words, Words) :-
  trim("  Logic Made Visible  ", Clean),
  lowercase(Clean, Lower),
  split(Lower, " ", Words).

answer(captures, Context) :-
  matches("2026-07", "^(?<year>[0-9]{4})-(?<month>[0-9]{2})$", Context).

query(answer(Kind, Value)).
