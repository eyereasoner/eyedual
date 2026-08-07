% Reference 9.6: matches/3 extracts named regular-expression captures into a context.
%% goal: answer(X0, X1, X2)


line('event=login_failed user=alice trace=4bf92f3577b34da6a3ce929d0e0e4736').
pattern('^event=(?<event>\\w+) user=(?<user>\\w+) trace=(?<trace_id>[0-9a-f]{32})$').

context_member((Left, _right), Member) :- context_member(Left, Member).
context_member((_left, Right), Member) :- context_member(Right, Member).
context_member(Member, Member) :- Member \= (_left, _right).

answer(User, Event, Traceid) :-
  line(Text),
  pattern(Pattern),
  matches(Text, Pattern, Context),
  context_member(Context, event(Event)),
  context_member(Context, user(User)),
  context_member(Context, trace_id(Traceid)).
