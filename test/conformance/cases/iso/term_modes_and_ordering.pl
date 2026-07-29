% ISO 8.3-8.5: type tests, term order, functor/3, arg/3, and copy_term/2.
query(types(X0, X1, X2, X3)).
types(Variable, Integer, Float, Compound) :-
    Integer = 7,
    Float = 2.5,
    Compound = pair(a, 1),
    var(Variable),
    integer(Integer),
    float(Float),
    compound(Compound),
    number(Integer),
    number(Float),
    atomic(Integer),
    callable(Compound),
    nonvar(Compound),
    ground(Compound),
    Variable = was_variable.

query(ordering(X0, X1, X2)).
ordering(Less, Equal, Greater) :-
    compare(Less, a, b),
    compare(Equal, f(a), f(a)),
    compare(Greater, 3, 2),
    a @< b,
    f(a) @=< f(a),
    3 @> 2,
    z @>= z.

query(functors(X0, X1, X2, X3)).
functors(Built, Name, Arity, Second) :-
    functor(Built, node, 2),
    arg(1, Built, left),
    arg(2, Built, Second),
    Second = right,
    functor(Built, Name, Arity).

query(copied(X0, X1)).
copied(Original, Copy) :-
    Original = pair(Shared, Shared),
    copy_term(Original, Copy),
    Shared = source,
    Copy = pair(copy, copy).
