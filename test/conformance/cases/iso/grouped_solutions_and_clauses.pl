b(2, two).
b(1, one).
b(1, one).
b(3, two).
b(2, one).

parent(alice, bob).
parent(alice, carol).
same(X) :-
    pair(X, X).
missing(_) :-
    fail.

query(grouped(X0, X1)).
grouped(Key, Bag) :-
    bagof(Value, b(Value, Key), Bag).

query(grouped_set(X0, X1)).
grouped_set(Key, Set) :-
    setof(Value, b(Value, Key), Set).

query(existential(X0, X1)).
existential(Bag, Set) :-
    bagof(Value, Key^b(Value, Key), Bag),
    setof(Value, Key^b(Value, Key), Set).

query(no_solutions).
no_solutions :-
    \+(bagof(Value, missing(Value), Bag)).

query(retrieved(X0, X1)).
retrieved(Child, Body) :-
    clause(parent(alice, Child), Body).

query(shared_clause(X0)).
shared_clause(Body) :-
    clause(same(Value), Body),
    =(Value, ok).

query(shared_set_variables(X0)).
shared_set_variables(Set) :-
    setof(Value, (=(Value, Left); =(Value, Right)), Set),
    =(Left, a),
    =(Right, b).
