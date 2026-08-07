% uuid/3 deterministically creates a canonical version 4 UUID atom from a seed.
answer(uuid_v4, true) :-
  uuid(1, UUID, _),
  atom(UUID),
  atom_length(UUID, 36),
  sub_atom(UUID, 8, 1, 27, '-'),
  sub_atom(UUID, 13, 1, 22, '-'),
  sub_atom(UUID, 14, 1, 21, '4'),
  sub_atom(UUID, 18, 1, 17, '-'),
  sub_atom(UUID, 19, 1, 16, Variant),
  member(Variant, ['8', '9', a, b]),
  sub_atom(UUID, 23, 1, 12, '-').
%% goal: answer(X0, X1)
