% Missionaries-and-cannibals river crossing as guarded state-space search.
%
% A state records missionaries and cannibals on the left bank plus the boat side.
% crossing/3 applies one legal boat load and state_safe/1 checks both banks.
% journey/4 carries a visited list to avoid loops in the finite state graph.
%% goal: missionaries_cannibals_answer(X0, X1)


% Boat loads: one or two passengers, with at least one passenger per crossing.
move(1, 0).
move(0, 1).
move(2, 0).
move(0, 2).
move(1, 1).

% A bank is safe if there are no missionaries or missionaries are not outnumbered.
bank_safe(0, _c).
bank_safe(M, C) :- (M > 0), (M >= C).

state_safe(state(Mleft, Cleft, _boat)) :-
  between(0, 3, Mleft),
  between(0, 3, Cleft),
  (Mright is 3 - Mleft),
  (Cright is 3 - Cleft),
  bank_safe(Mleft, Cleft),
  bank_safe(Mright, Cright).

crossing(state(Mleft, Cleft, left), state(Nextm, Nextc, right), carry(Movem, Movec)) :-
  move(Movem, Movec),
  (Nextm is Mleft - Movem),
  (Nextc is Cleft - Movec),
  state_safe(state(Nextm, Nextc, right)).
crossing(state(Mleft, Cleft, right), state(Nextm, Nextc, left), carry(Movem, Movec)) :-
  move(Movem, Movec),
  (Nextm is Mleft + Movem),
  (Nextc is Cleft + Movec),
  state_safe(state(Nextm, Nextc, left)).

journey(Goal, Goal, Visited, Visited).
journey(State, Goal, Visited, Path) :-
  crossing(State, Next, _carry),
  not_member(Next, Visited),
  journey(Next, Goal, [Next|Visited], Path).

solution(Path) :-
  journey(state(3, 3, left), state(0, 0, right), [state(3, 3, left)], Reversepath),
  reverse(Reversepath, Path).

missionaries_cannibals_answer(first_solution, Path) :- once(solution(Path)).
missionaries_cannibals_answer(state_count, Count) :- countall(state_safe(state(_m, _c, _boat)), Count).
missionaries_cannibals_answer(step_count, Steps) :-
  once(solution(Path)),
  length(Path, States),
  (Steps is States - 1).
