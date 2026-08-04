% Blocks-world planning without cut.
%
% A finite-depth planner searches for a five-move plan over five blocks.  States
% are sorted lists of on(Block, Support) facts so equality and visited-state
% checks are purely structural.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: status(X0, X1)

%% goal: plan(X0, X1)

%% goal: finalState(X0, X1)

%% goal: blockCount(X0, X1)


% The initial and goal states are lists of on/2 facts.  Sorting successor states
% gives canonical terms for equality and visited-state checks.
initial([on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]).
goal([on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]).

block(a).
block(b).
block(c).
block(d).
block(e).

support(table, _state).
% move/3 chooses a clear block and a clear support; the bounded planner chains
% those legal moves while avoiding previously seen states.
support(Block, State) :-
  block(Block),
  member(on(Block, _below), State).

clear(Block, State) :-
  \+ member(on(_other, Block), State).

clear_support(table, _state).
clear_support(Block, State) :-
  block(Block),
  clear(Block, State).

move(State, move(Block, From, To), Newstate) :-
  member(on(Block, From), State),
  clear(Block, State),
  support(To, State),
  clear_support(To, State),
  (Block \= To),
  (From \= To),
  select(on(Block, From), State, Rest),
  sort([on(Block, To)|Rest], Newstate).

plan(State, Goal, 0, _visited, [], State) :-
  (State = Goal).

plan(State, Goal, Depth, Visited, [Move|Moves], Final) :-
  (Depth > 0),
  move(State, Move, Next),
  \+ member(Next, Visited),
  (Restdepth is Depth - 1),
  plan(Next, Goal, Restdepth, [Next|Visited], Moves, Final).

five_move_plan(Moves, Final) :-
  initial(Start),
  goal(Goal),
  sort(Start, Sortedstart),
  sort(Goal, Sortedgoal),
  plan(Sortedstart, Sortedgoal, 5, [Sortedstart], Moves, Final).

status(blocks_world, planned) :-
  once(five_move_plan(_moves, _final)).

plan(blocks_world, Moves) :-
  once(five_move_plan(Moves, _final)).

finalState(blocks_world, Final) :-
  once(five_move_plan(_moves, Final)).

blockCount(blocks_world, Count) :-
  findall(Block, block(Block), Blocks),
  length(Blocks, Count).
