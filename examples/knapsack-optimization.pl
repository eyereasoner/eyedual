% 0/1 knapsack optimization with aggregate_max/5.
%
% subset/2 enumerates candidate expedition packs; total_weight/2 and total_value/2
% score each pack.  feasible_pack/3 applies the capacity limit, and best_pack/3
% keeps the highest-value feasible choice together with its weight.
query(knapsack_answer(X0, X1)).

% Capacity and item table are separated from the optimization rule for easy tuning.
capacity(15).
items([atlas, battery, camera, drone, emergency_radio, field_laptop, medkit, sensor]).

item(atlas, 2, 6).
item(battery, 4, 10).
item(camera, 3, 8).
item(drone, 6, 13).
item(emergency_radio, 5, 11).
item(field_laptop, 7, 16).
item(medkit, 4, 9).
item(sensor, 2, 7).

% The include/exclude subset generator explores every 0/1 choice once.
subset([], []).
subset([Item|Rest], [Item|Chosen]) :- subset(Rest, Chosen).
subset([_item|Rest], Chosen) :- subset(Rest, Chosen).

item_weight(Item, Weight) :- item(Item, Weight, _value).
item_value(Item, Value) :- item(Item, _weight, Value).

total_weight(Items, Weight) :- findall(W, (member(Item, Items), item_weight(Item, W)), Weights), sum_list(Weights, Weight).
total_value(Items, Value) :- findall(V, (member(Item, Items), item_value(Item, V)), Values), sum_list(Values, Value).

feasible_pack(Pack, Weight, Value) :-
  items(All),
  subset(All, Pack),
  total_weight(Pack, Weight),
  capacity(Capacity),
  (Weight =< Capacity),
  total_value(Pack, Value).

best_pack(Pack, Weight, Value) :-
  aggregate_max(Value, pack(Pack, Weight), feasible_pack(Pack, Weight, Value), Value, pack(Pack, Weight)).

knapsack_answer(best_pack, Pack) :- best_pack(Pack, _weight, _value).
knapsack_answer(total_weight, Weight) :- best_pack(_pack, Weight, _value).
knapsack_answer(total_value, Value) :- best_pack(_pack, _weight, Value).
knapsack_answer(feasible_pack_count, Count) :- countall(feasible_pack(_pack, _weight, _value), Count).
