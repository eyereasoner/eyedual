% Wolf, goat and cabbage puzzle, adapted from Eyelet's
% input/wolf-goat-cabbage.pl.
%
% A configuration is [man, wolf, goat, cabbage], where each item is on the west
% bank w or east bank e.  The recursive search keeps a visited list so eyepl
% explores the finite state space without looping.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: solution(X0, X1)

%% goal: solved(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.

% Derivation rules: each rule below contributes one logical step toward the displayed results.
solution(Moves) :-
  solve([w, w, w, w], [e, e, e, e], [[w, w, w, w]], Moves),
  length(Moves, 7).

solve(Config, Config, _visited, []).

solve(Config, Goal, Visited, [Move|Rest]) :-
  move(Config, Move, Nextconfig),
  safe(Nextconfig),
  not_member(Nextconfig, Visited),
  solve(Nextconfig, Goal, [Nextconfig|Visited], Rest).

% Each move transforms one configuration into another.
move([X, X, Goat, Cabbage], wolf, [Y, Y, Goat, Cabbage]) :-
  change(X, Y).

move([X, Wolf, X, Cabbage], goat, [Y, Wolf, Y, Cabbage]) :-
  change(X, Y).

move([X, Wolf, Goat, X], cabbage, [Y, Wolf, Goat, Y]) :-
  change(X, Y).

move([X, Wolf, Goat, Cabbage], nothing, [Y, Wolf, Goat, Cabbage]) :-
  change(X, Y).

change(e, w).
change(w, e).

% Safe if the goat is not left alone with the wolf or cabbage without the man.
safe([Man, Wolf, Goat, Cabbage]) :-
  one_eq(Man, Goat, Wolf),
  one_eq(Man, Goat, Cabbage).

one_eq(X, X, _).
one_eq(X, _, X).

solution(puzzle, Moves) :-
  solution(Moves).

solved(puzzle, true) :-
  solution(_moves).
