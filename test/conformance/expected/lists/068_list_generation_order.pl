answer(append_split, pair([], "ab")).
answer(append_split, pair("a", "b")).
answer(append_split, pair("ab", [])).
answer(nth, pair(0, x)).
answer(nth, pair(1, y)).
answer(select, pair(a, "ba")).
answer(select, pair(b, "aa")).
answer(select, pair(a, "ab")).
answer(absent_atom, ok).
