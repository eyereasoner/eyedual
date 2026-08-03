% Universal Turing machine example adapted from Eyelet's input/turing.pl.
%
% The machine below adds 1 to a binary number represented as a list of bits.
% A tape is split into a reversed left side, current cell, and right side; move/7
% updates that zipper representation.  The blank tape symbol is #.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: input(X0, X1)

%% goal: output(X0, X1)

%% goal: addsOne(X0, X1)


% compute/2 initializes the tape and starts from the machine's start state.
compute([], Outtape) :-
  start(_machine, I),
  find(I, [], #, [], Outtape).

compute([Head|Tail], Outtape) :-
  start(_machine, I),
  find(I, [], Head, Tail, Outtape).

% find/5 executes one transition, moves the head, and either halts or recurses.
find(State, Left, Cell, Right, Outtape) :-
  t([State, Cell, Write, Move], Next),
  move(Move, Left, Write, Right, A, B, C),
  continue(Next, A, B, C, Outtape).

continue(halt, Left, Cell, Right, Outtape) :-
  rever(Left, R),
  append(R, [Cell|Right], Outtape).

continue(State, Left, Cell, Right, Outtape) :-
  find(State, Left, Cell, Right, Outtape).

% Head movement defines the tape zipper update, including blank extension.
move(l, [], Cell, Right, [], #, [Cell|Right]).
move(l, [Head|Tail], Cell, Right, Tail, Head, [Cell|Right]).
move(s, Left, Cell, Right, Left, Cell, Right).
move(r, Left, Cell, [], [Cell|Left], #, []).
move(r, Left, Cell, [Head|Tail], [Cell|Left], Head, Tail).

rever([], []).
rever([A|B], C) :-
  rever(B, D),
  append(D, [A], C).

% A Turing machine to add 1 to a binary number.
start(add1, 0).
t([0, 0, 0, r], 0).
t([0, 1, 1, r], 0).
t([0, #, #, l], 1).
t([1, 0, 1, s], halt).
t([1, 1, 0, l], 1).
t([1, #, 1, s], halt).

case(case1, [1, 0, 1, 0, 0, 1]).
case(case2, [1, 0, 1, 1, 1, 1]).
case(case3, [1, 1, 1, 1, 1, 1]).
case(case4, []).

input(Case, Intape) :-
  case(Case, Intape).

output(Case, Outtape) :-
  case(Case, Intape),
  compute(Intape, Outtape).

addsOne(Case, true) :-
  case(Case, Intape),
  compute(Intape, _outtape).
