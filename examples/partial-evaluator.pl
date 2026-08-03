% A tiny partial evaluator for expression terms.
%
% Real partial evaluation can specialize interpreters, control unfolding, avoid
% code explosion, and even approach self-application.  This bounded WebEntail
% version specializes a miniature expression language with known static inputs:
% constants are folded, known variables are substituted, and dynamic variables
% remain as residual code.

%% goal: partialEvalAnswer(X0, X1)



% Expression language: const/1, bool/1, var/1, add/2, mul/2, and if/3.
% Static environments are lists of bind(Name, ResidualValue) terms.
program(poly_y,
  add(mul(var(x), var(y)), add(var(x), const(3))),
  [bind(x, const(10))]).
program(static_branch,
  if(bool(true), add(var(x), const(1)), mul(var(y), const(999))),
  [bind(x, const(10))]).
program(dynamic_branch,
  if(var(flag), add(var(x), const(1)), mul(var(y), const(2))),
  [bind(x, const(10))]).

lookup(Name, [bind(Name, Value) | _], Value).
lookup(Name, [bind(_, _) | Rest], Value) :- lookup(Name, Rest, Value).

known_var(Env, Name, Value) :- lookup(Name, Env, Value).
unknown_var(Env, Name) :- \+ known_var(Env, Name, _).

pe(_, const(N), const(N)).
pe(_, bool(B), bool(B)).
pe(Env, var(Name), Value) :- known_var(Env, Name, Value).
pe(Env, var(Name), var(Name)) :- unknown_var(Env, Name).

% Constant folding for arithmetic when both residual operands became constants.
pe(Env, add(Left, Right), const(Sum)) :-
  pe(Env, Left, const(A)),
  pe(Env, Right, const(B)),
  (Sum is A + B).
pe(Env, mul(Left, Right), const(Product)) :-
  pe(Env, Left, const(A)),
  pe(Env, Right, const(B)),
  (Product is A * B).

% Residual arithmetic when at least one operand remains dynamic.
pe(Env, add(Left, Right), add(Left_residual, Right_residual)) :-
  pe(Env, Left, Left_residual),
  pe(Env, Right, Right_residual),
  \+ ((Left_residual = const(A)), (Right_residual = const(B))).
pe(Env, mul(Left, Right), mul(Left_residual, Right_residual)) :-
  pe(Env, Left, Left_residual),
  pe(Env, Right, Right_residual),
  \+ ((Left_residual = const(A)), (Right_residual = const(B))).

% Static conditionals choose a branch; dynamic conditionals keep both residual
% branches after specializing their contents.
pe(Env, if(Cond, Then, Else), Residual) :-
  pe(Env, Cond, bool(true)),
  pe(Env, Then, Residual).
pe(Env, if(Cond, Then, Else), Residual) :-
  pe(Env, Cond, bool(false)),
  pe(Env, Else, Residual).
pe(Env, if(Cond, Then, Else), if(Cond_residual, Then_residual, Else_residual)) :-
  pe(Env, Cond, Cond_residual),
  \+ (Cond_residual = bool(true)),
  \+ (Cond_residual = bool(false)),
  pe(Env, Then, Then_residual),
  pe(Env, Else, Else_residual).

residual_program(Name, Residual) :- program(Name, Expr, Env), pe(Env, Expr, Residual).

partialEvalAnswer(residual(Name), Residual) :- residual_program(Name, Residual).
partialEvalAnswer(note, "static inputs are folded while dynamic variables remain as residual code") :- residual_program(poly_y, _).
