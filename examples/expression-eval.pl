% Tiny expression evaluator adapted from Eyeling's expression-eval.n3 example.
%
% The expression tree represents (2 * 3) + (10 - 4).  value/2 recursively folds
% the tree, so proof output shows how the final result 12 is assembled from
% smaller arithmetic subexpressions.
%% goal: result(X0, X1)


% The expression tree is data: number/2 labels leaves, expr/4 labels internal
% operator nodes, and root/1 chooses the term to evaluate.
number(n2, 2).
number(n3, 3).
number(n10, 10).
number(n4, 4).

expr(eMul, mul, n2, n3).
expr(eSub, sub, n10, n4).
expr(eAdd, add, eMul, eSub).
root(eAdd).

% Each arithmetic operator has its own rule, which makes the proof tree mirror
% the shape of the expression tree.
value(Node, Value) :-
  number(Node, Value).

value(Node, Value) :-
  expr(Node, add, Left, Right),
  value(Left, Leftvalue),
  value(Right, Rightvalue),
  (Value is Leftvalue + Rightvalue).

value(Node, Value) :-
  expr(Node, sub, Left, Right),
  value(Left, Leftvalue),
  value(Right, Rightvalue),
  (Value is Leftvalue - Rightvalue).

value(Node, Value) :-
  expr(Node, mul, Left, Right),
  value(Left, Leftvalue),
  value(Right, Rightvalue),
  (Value is Leftvalue * Rightvalue).

result(root, Value) :-
  root(Node),
  value(Node, Value).
