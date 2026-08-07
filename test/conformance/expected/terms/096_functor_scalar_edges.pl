answer(atom, pair(alpha, 0)).
answer(quoted_atom, pair('hello-world', 0)).
answer(char_list, pair('.', 2)).
answer(number, pair(123, 0)).
answer(list_functor, pair('.', 2)).
