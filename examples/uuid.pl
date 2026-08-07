% uuid/3 creates a version 4 UUID atom from explicit random state.
%
% The same initial seed reproduces the same UUID across runs. Threading the
% returned seed into another call produces the next UUID in the sequence.

%% goal: uuid_example(Result)

uuid_example(true) :-
  uuid(20260807, UUID, _),
  atom(UUID),
  atom_length(UUID, 36),
  sub_atom(UUID, 8, 1, 27, '-'),
  sub_atom(UUID, 13, 1, 22, '-'),
  sub_atom(UUID, 14, 1, 21, '4'),
  sub_atom(UUID, 18, 1, 17, '-'),
  sub_atom(UUID, 19, 1, 16, Variant),
  member(Variant, ['8', '9', a, b]),
  sub_atom(UUID, 23, 1, 12, '-').
