% Monkey and bananas planning problem, adapted from Eyelet's
% input/monkey-bananas.pl.
%
% A state is [bananas_location, monkey_location, box_location, on_box,
% has_bananas].  The selected output searches bounded move lists and derives successful
% plans.

% Output declarations: query/1 selects the relations written to this example's golden output.
query(plan(X0, X1)).
query(solved(X0, X1)).

% Program structure: facts set up the scenario, and rules derive the queried conclusions.

% Derivation rules: each rule below contributes one logical step toward the displayed results.
plan(Moves) :-
  candidate_plan(Moves),
  initial_state(I),
  goal_state(G),
  reachable(I, Moves, G).

candidate_plan([_, _, _]).
candidate_plan([_, _, _, _]).
candidate_plan([_, _, _, _, _]).

reachable(S, [], S).
reachable(S1, [M|L], S3) :-
  legal_move(S1, M, S2),
  reachable(S2, L, S3).

initial_state([loc1, loc2, loc3, n, n]).
goal_state([_, _, _, _, y]).

legal_move([B, M, M, n, H], climb_on, [B, M, M, y, H]).
legal_move([B, M, M, y, H], climb_off, [B, M, M, n, H]).
legal_move([B, B, B, y, n], grab, [B, B, B, y, y]).
legal_move([B, M, M, n, H], push(X), [B, X, X, n, H]) :-
  member(X, [loc1, loc2, loc3]),
  (X \= M).
legal_move([B, M, L, n, H], go(X), [B, X, L, n, H]) :-
  member(X, [loc1, loc2, loc3]),
  (X \= M).

plan(monkeyBananas, Moves) :- plan(Moves).
solved(monkeyBananas, true) :- plan(_moves).
