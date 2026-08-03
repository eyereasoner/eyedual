% Linear logic emulation with explicit consumable resources.
%
% WebEntail predicates are reusable Horn clauses, so this example represents the
% linear part explicitly as a multiset-like state list.  A rule consumes its
% input resources with select/3 and produces a new state.  If a resource is not
% present, the step fails, which models the “use exactly once” discipline of
% linear implication.
%
% The successful plan turns wheat, yeast, and heat into bread.  The rejected
% double-spend check shows that one coin cannot be consumed by two purchases.
%% goal: linear_result(X0, X1, X2)

%% goal: linear_check(X0, X1)


initial(kitchen, [wheat, yeast, heat]).
initial(wallet, [coin]).

% linear_rule(Name, Inputs, Outputs) is an encoded linear implication:
% Inputs -o Outputs, evaluated against the current resource state.
linear_rule(mill, [wheat], [flour]).
linear_rule(mix, [flour, yeast], [dough]).
linear_rule(bake, [dough, heat], [bread]).
linear_rule(buy_flour, [coin], [flour]).
linear_rule(buy_yeast, [coin], [yeast]).

% consume_all/3 removes each required resource once.  This is the key linear
% operation: a second attempt to use the same token cannot succeed.
consume_all([], State, State).
consume_all([Need | Needs], State0, State2) :-
  select(Need, State0, State1),
  consume_all(Needs, State1, State2).

linear_step(State0, Rule, State2) :-
  linear_rule(Rule, Inputs, Outputs),
  consume_all(Inputs, State0, Rest),
  append(Outputs, Rest, State2).

run_linear(0, State, [], State).
run_linear(Steps, State0, [Rule | Plan], State2) :-
  (Steps > 0),
  linear_step(State0, Rule, State1),
  (Remaining is Steps - 1),
  run_linear(Remaining, State1, Plan, State2).

linear_result(kitchen, Plan, Finalstate) :-
  initial(kitchen, State),
  run_linear(3, State, Plan, Finalstate),
  (Finalstate = [bread]).

linear_check(double_spend_rejected, yes) :-
  initial(wallet, State),
  \+ run_linear(2, State, [buy_flour, buy_yeast], _finalstate).
