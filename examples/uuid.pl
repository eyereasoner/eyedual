% uuid/1 creates exactly one fresh version 4 UUID atom.
%
% The UUID itself varies between runs, so this example checks its type and
% canonical shape while returning a stable, reviewable answer.

%% goal: uuid_example(Result)

uuid_example(true) :-
  uuid(UUID),
  atom(UUID),
  atom_length(UUID, 36),
  sub_atom(UUID, 8, 1, 27, '-'),
  sub_atom(UUID, 13, 1, 22, '-'),
  sub_atom(UUID, 14, 1, 21, '4'),
  sub_atom(UUID, 18, 1, 17, '-'),
  sub_atom(UUID, 19, 1, 16, Variant),
  member(Variant, ['8', '9', a, b]),
  sub_atom(UUID, 23, 1, 12, '-').
