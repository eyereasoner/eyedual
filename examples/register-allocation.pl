% Register allocation as bounded graph coloring with spilling.
%
% Production allocators combine liveness analysis, interference graphs, register
% classes, coalescing, requery execution, and spill-code insertion.  This EyeDual
% example reduces the problem to its logical core: enumerate assignments of a
% few temporaries to two registers or memory, reject register conflicts, and use
% aggregate_min/5 to choose the cheapest spill plan.

%% goal: registerAnswer(X0, X1)


% Two physical registers are available.  The synthetic place spill means the
% temporary is kept in memory instead of a register.
register(r1).
register(r2).
place(Reg) :- register(Reg).
place(spill).

% Temporaries and the cost of spilling each one.  The triangle a-b-c cannot be
% colored with only two registers, so at least one of them must spill.
temporary(a, 10).
temporary(b, 1).
temporary(c, 10).
temporary(d, 2).

interferes(a, b).
interferes(b, c).
interferes(c, a).
interferes(c, d).

% A candidate allocation is an immutable list of bindings.  This is deliberately
% brute force: three choices for each of four temporaries.
candidate_allocation([
  bind(a, A_place),
  bind(b, B_place),
  bind(c, C_place),
  bind(d, D_place)
]) :-
  place(A_place),
  place(B_place),
  place(C_place),
  place(D_place).

assigned(Var, [[Var, Place] | _], Place).
assigned(Var, [bind(Var, Place) | _], Place).
assigned(Var, [bind(_, _) | Rest], Place) :- assigned(Var, Rest, Place).

% A conflict exists only when both interfering temporaries choose the same real
% register.  Spilled temporaries do not occupy registers.
allocation_conflict(Allocation) :-
  interferes(Left, Right),
  assigned(Left, Allocation, Reg),
  assigned(Right, Allocation, Reg),
  register(Reg).

valid_allocation(Allocation) :-
  candidate_allocation(Allocation),
  \+ allocation_conflict(Allocation).

spill_cost_of_place(Var, spill, Cost) :- temporary(Var, Cost).
spill_cost_of_place(Var, Reg, 0) :- temporary(Var, _), register(Reg).

allocation_cost(Allocation, Cost) :-
  findall(Item_cost,
    (member(bind(Var, Place), Allocation), spill_cost_of_place(Var, Place, Item_cost)),
    Costs),
  sum_list(Costs, Cost).

best_allocation(Allocation, Cost) :-
  aggregate_min([Candidate_cost, Candidate], Candidate,
    (valid_allocation(Candidate), allocation_cost(Candidate, Candidate_cost)),
    [Cost, Allocation], Allocation).

registerAnswer(best_allocation, Allocation) :- best_allocation(Allocation, _).
registerAnswer(spill_cost, Cost) :- best_allocation(_, Cost).
registerAnswer(place(Var), Place) :- best_allocation(Allocation, _), assigned(Var, Allocation, Place).
registerAnswer(valid_allocation_count, Count) :- countall(valid_allocation(_), Count).
registerAnswer(note, "the cheapest solution spills b to color the a-b-c triangle with two registers") :- best_allocation(_, _).
