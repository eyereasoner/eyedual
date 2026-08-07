% Reference 9.6 and 9.9: matches/3 turns named captures into context terms.
%% goal: answer(X0, X1)

line('level=warn code=E42 user=bob').
context_member((Left, _right), Member) :- context_member(Left, Member).
context_member((_left, Right), Member) :- context_member(Right, Member).
context_member(Member, Member) :- Member \= (_left, _right).
answer(level, X) :- line(L), matches(L, 'level=(?<level>\\w+) code=(?<code>\\w+) user=(?<user>\\w+)', C), context_member(C, level(X)).
answer(code, X) :- line(L), matches(L, 'level=(?<level>\\w+) code=(?<code>\\w+) user=(?<user>\\w+)', C), context_member(C, code(X)).
answer(user, X) :- line(L), matches(L, 'level=(?<level>\\w+) code=(?<code>\\w+) user=(?<user>\\w+)', C), context_member(C, user(X)).
answer(no_named_groups_rejected, ok) :- \+ matches('abc', 'a(b)c', C).
answer(bad_regex_rejected, ok) :- \+ matches('abc', '(', C).
