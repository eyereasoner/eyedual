% Data negotiation with policies, adapted from Eyelet input/data-negotiation.pl.
% Two agents own different datasets.  A negotiation succeeds only when the
% requester lacks the data, the provider has it, the requester policy allows
% asking for it, and the provider policy allows sharing it.

query(negotiate(X0, X1)).

% Each agent has local data, desired remote data, and a simple policy.
hasData(agent1, [data1, data2, data3]).
hasData(agent2, [data4, data5, data6]).

want_negotiate(agent1, [agent2, data4]).
want_negotiate(agent1, [agent2, data5]).
want_negotiate(agent1, [agent2, data7]).

policy(agent1, [request, Data]) :-
  member(Data, [data4, data6]).
policy(agent2, [accept, Data]) :-
  (Data \= data5).

% A request is possible only if A lacks the data and A's policy allows asking for it.
request_data(Agenta, Agentb, Data) :-
  hasData(Agenta, Datalista),
  hasData(Agentb, Datalistb),
  member(Data, Datalistb),
  not_member(Data, Datalista),
  policy(Agenta, [request, Data]).

% B accepts only requests for data it has and its own policy permits sharing.
accept_request(Agentb, _agenta, Data) :-
  hasData(Agentb, Datalistb),
  member(Data, Datalistb),
  policy(Agentb, [accept, Data]).

negotiate(Agenta, [Agentb, Data]) :-
  want_negotiate(Agenta, [Agentb, Data]),
  request_data(Agenta, Agentb, Data),
  accept_request(Agentb, Agenta, Data).
