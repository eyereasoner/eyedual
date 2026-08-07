answer(split, pair([], "xyz")).
answer(split, pair("x", "yz")).
answer(split, pair("xy", "z")).
answer(split, pair("xyz", [])).
answer(select_middle, "xz").
answer(select_duplicate, pair(a, "ba")).
answer(select_duplicate, pair(b, "aa")).
answer(select_duplicate, pair(a, "ab")).
answer(rebuild, "abcd").
answer(no_select_rejected, ok).
