answer(take_zero, []).
answer(drop_all, []).
answer(slice_empty, []).
answer(last_single, only).
answer(first_tail, pair(a, "bc")).
answer(take_too_many_rejected, ok).
answer(drop_too_many_rejected, ok).
answer(last_empty_rejected, ok).
