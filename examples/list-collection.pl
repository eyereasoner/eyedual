% List collections inspired by the Eyeling collection example.
% Demonstrates list literals, member/2, length/2, append/3, and [Head|Tail].
% Each queried relation demonstrates one list operation.
% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: collectionLength(X0, X1)

%% goal: collectionMember(X0, X1)

%% goal: collectionAppend(X0, X1)

%% goal: head(X0, X1)

%% goal: tail(X0, X1)


% The collection/2 facts keep complete lists as first-class terms rather than
% expanding them into separate item facts.
% Lists are first-class terms in facts and rule heads/bodies.
collection(numbers, [1, 2, 3]).
collection(letters, [a, b]).

% The derived predicates show list length, membership, append, and pattern
% matching with [Head|Tail] in the smallest possible setting.
collectionLength(numbers, N) :-
  collection(numbers, List),
  length(List, N).

collectionMember(numbers, X) :-
  collection(numbers, List),
  member(X, List).

collectionAppend(letters, Extended) :-
  collection(letters, List),
  append(List, [c], Extended).

head(letters, Head) :-
  collection(letters, [Head|_tail]).

tail(letters, Tail) :-
  collection(letters, [_head|Tail]).
