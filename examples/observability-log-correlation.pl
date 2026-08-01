% Observability example: parse unstructured service logs with named regex
% captures, then reason over the extracted context to correlate events that
% share a W3C trace id.
%
% The noisy health-check line is deliberately present to show that only logs
% matching the pattern become parsed events.
query(parsed_event(X0, X1, X2, X3, X4)).
query(captured_field(X0, X1, X2)).
query(trace_alert(X0, X1, X2)).

log_pattern("^ts=(?<ts>\\S+) level=(?<level>\\w+) event=(?<event>\\w+) user=(?<user>\\w+) ip=(?<ip>\\S+) traceparent=00-(?<trace_id>[0-9a-f]{32})-(?<span_id>[0-9a-f]{16})-(?<flags>[0-9a-f]{2})$").

raw_log(l1, "ts=2026-06-18T10:00:00Z level=warn event=login_failed user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01").
raw_log(l2, "ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01").
raw_log(l3, "ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01").
raw_log(noise, "healthcheck ok").

parsed(Log, Context) :-
  raw_log(Log, Text),
  log_pattern(Pattern),
  matches(Text, Pattern, Context).

context_member((Left, _right), Member) :- context_member(Left, Member).
context_member((_left, Right), Member) :- context_member(Right, Member).
context_member(Member, Member) :- Member \= (_left, _right).

% matches/3 returns a context term containing named captures. The rules walk
% that term and use =../2 when the predicate name is itself data.
captured_field(Log, Name, Value) :-
  parsed(Log, Context),
  context_member(Context, Field),
  (Field =.. [Name, Value]).

parsed_event(Log, Event, User, Ip, Traceid) :-
  parsed(Log, Context),
  context_member(Context, event(Event)),
  context_member(Context, user(User)),
  context_member(Context, ip(Ip)),
  context_member(Context, trace_id(Traceid)).

trace_alert(User, Traceid, Ip) :-
  parsed_event(Loginlog, "login_failed", User, Ip, Traceid),
  parsed_event(Paymentlog, "payment_denied", User, Ip, Traceid),
  (Loginlog \= Paymentlog).
