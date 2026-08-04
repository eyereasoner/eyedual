answer(append_split, pair([], [a, b])).
answer(append_split, pair([a], [b])).
answer(append_split, pair([a, b], [])).
answer(nth, pair(0, x)).
answer(nth, pair(1, y)).
answer(select, pair(a, [b, a])).
answer(select, pair(b, [a, a])).
answer(select, pair(a, [a, b])).
answer(absent_atom, ok).
