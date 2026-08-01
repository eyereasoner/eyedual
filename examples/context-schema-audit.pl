% Context schema audit.
%
% The audit rule does not know predicate names or arities in advance. It walks
% the context as ordinary comma-term data, decomposes each member with =../2,
% computes the arity, and checks that shape against an allowed schema.

% Output declarations: query/1 selects the relations written to this example's golden output.
query(context_shape(X0, X1, X2)).
query(schema_violation(X0, X1, X2)).

% Program structure: each message carries heterogeneous context data.  The
% members deliberately use different arities: heartbeat/0, source/1,
% temperature/2, gps/3, and signature/4.
message_context(msg_ok, (
  heartbeat,
  source(sensor17),
  temperature(sensor17, 38),
  gps(sensor17, 51, 4),
  signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")
)).

message_context(msg_bad, (
  heartbeat,
  source(sensor18),
  temperature(sensor18, 99),
  gps(sensor18, 51),
  tampered(sensor18)
)).

allowed_shape(heartbeat, 0).
allowed_shape(source, 1).
allowed_shape(temperature, 2).
allowed_shape(gps, 3).
allowed_shape(signature, 4).

context_member((Left, _right), Member) :- context_member(Left, Member).
context_member((_left, Right), Member) :- context_member(Right, Member).
context_member(Member, Member) :- Member \= (_left, _right).

% Derivation rules: =../2 exposes each context member as predicate name plus
% argument list, so one generic rule can audit mixed-arity data.
context_shape(Message, Name, Arity) :-
  message_context(Message, Context),
  context_member(Context, Statement),
  (Statement =.. [Name | Args]),
  length(Args, Arity).

schema_violation(Message, Name, Arity) :-
  context_shape(Message, Name, Arity),
  \+ allowed_shape(Name, Arity).
