item(one).

query(answer).
answer :-
    setof(Item, item(Item), not_a_list).
