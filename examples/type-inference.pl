% Hindley-Milner-style type inference for a tiny lambda language.
%
% The example is intentionally small and deterministic.  Lambda binders carry
% explicit type variables or annotations, and ordinary logic unification solves
% the constraints created by application, arithmetic, conditionals, and pairs.
% The symbolic names t0, t1, and t2 stand for schematic type variables in the
% displayed answers; concrete examples such as apply_id annotate the argument as
% int so the application can be checked.
%% goal: type_answer(X0, X1)

%% goal: type_reason(X0, X1)



% Tiny expression language: int_lit/1, bool_lit/1, var/1, lam/3, app/2,
% add/2, if/3, pair/2, fst/1, and snd/1.
program(id, lam(x, t0, var(x))).
program(const, lam(x, t0, lam(y, t1, var(x)))).
program(apply_id, app(lam(x, int, var(x)), int_lit(42))).
program(compose,
  lam(f, fun(t1, t2),
    lam(g, fun(t0, t1),
      lam(x, t0,
        app(var(f), app(var(g), var(x))))))).
program(branch,
  if(bool_lit(true), add(int_lit(20), int_lit(22)), int_lit(0))).
program(first_of_pair, fst(pair(bool_lit(true), int_lit(7)))).

lookup(Name, [[Name, Type] | _], Type).
lookup(Name, [[_, _] | Rest], Type) :- lookup(Name, Rest, Type).

type_expr(_, int_lit(_), int).
type_expr(_, bool_lit(_), bool).
type_expr(Env, var(Name), Type) :- lookup(Name, Env, Type).
type_expr(Env, lam(Name, Arg_type, Body), fun(Arg_type, Body_type)) :-
  type_expr([[Name, Arg_type] | Env], Body, Body_type).
type_expr(Env, app(Fn, Arg), Result_type) :-
  type_expr(Env, Fn, fun(Arg_type, Result_type)),
  type_expr(Env, Arg, Arg_type).
type_expr(Env, add(Left, Right), int) :-
  type_expr(Env, Left, int),
  type_expr(Env, Right, int).
type_expr(Env, if(Cond, Then, Else), Type) :-
  type_expr(Env, Cond, bool),
  type_expr(Env, Then, Type),
  type_expr(Env, Else, Type).
type_expr(Env, pair(Left, Right), pair(Left_type, Right_type)) :-
  type_expr(Env, Left, Left_type),
  type_expr(Env, Right, Right_type).
type_expr(Env, fst(Pair), Left_type) :-
  type_expr(Env, Pair, pair(Left_type, _)).
type_expr(Env, snd(Pair), Right_type) :-
  type_expr(Env, Pair, pair(_, Right_type)).

type_answer(Name, Type) :- program(Name, Expr), type_expr([], Expr, Type).
type_reason(compose, "application unifies f with t1 -> t2 and g with t0 -> t1") :-
  type_answer(compose, _).
type_reason(apply_id, "the identity function's parameter type is unified with int") :-
  type_answer(apply_id, int).
