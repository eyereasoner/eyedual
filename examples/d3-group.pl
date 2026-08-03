% Eyelet-inspired D3 group example using findall/3 and sort/2.
% The six facts are the symmetries of an equilateral triangle, with compose/3 as
% the Cayley table and inverse/2 as the inverse relation.  Candidate subsets are
% generated as subsequences, then filtered for subgroup closure.

%% goal: subgroups(X0, X1)

%% goal: subgroupCount(X0, X1)

%% goal: reason(X0, X1)


% Six symmetries of an equilateral triangle: identity, rotations, reflections.
symmetry(identity).
symmetry(rotation_120).
symmetry(rotation_240).
symmetry(reflection_a).
symmetry(reflection_b).
symmetry(reflection_c).

% Cayley table for D3 composition.
compose(identity, identity, identity).
compose(identity, rotation_120, rotation_120).
compose(identity, rotation_240, rotation_240).
compose(identity, reflection_a, reflection_a).
compose(identity, reflection_b, reflection_b).
compose(identity, reflection_c, reflection_c).
compose(rotation_120, identity, rotation_120).
compose(rotation_120, rotation_120, rotation_240).
compose(rotation_120, rotation_240, identity).
compose(rotation_120, reflection_a, reflection_b).
compose(rotation_120, reflection_b, reflection_c).
compose(rotation_120, reflection_c, reflection_a).
compose(rotation_240, identity, rotation_240).
compose(rotation_240, rotation_120, identity).
compose(rotation_240, rotation_240, rotation_120).
compose(rotation_240, reflection_a, reflection_c).
compose(rotation_240, reflection_b, reflection_a).
compose(rotation_240, reflection_c, reflection_b).
compose(reflection_a, identity, reflection_a).
compose(reflection_a, rotation_120, reflection_c).
compose(reflection_a, rotation_240, reflection_b).
compose(reflection_a, reflection_a, identity).
compose(reflection_a, reflection_b, rotation_240).
compose(reflection_a, reflection_c, rotation_120).
compose(reflection_b, identity, reflection_b).
compose(reflection_b, rotation_120, reflection_a).
compose(reflection_b, rotation_240, reflection_c).
compose(reflection_b, reflection_a, rotation_120).
compose(reflection_b, reflection_b, identity).
compose(reflection_b, reflection_c, rotation_240).
compose(reflection_c, identity, reflection_c).
compose(reflection_c, rotation_120, reflection_b).
compose(reflection_c, rotation_240, reflection_a).
compose(reflection_c, reflection_a, rotation_240).
compose(reflection_c, reflection_b, rotation_120).
compose(reflection_c, reflection_c, identity).
% Each candidate subgroup must also contain inverses.
inverse(identity, identity).
inverse(rotation_120, rotation_240).
inverse(rotation_240, rotation_120).
inverse(reflection_a, reflection_a).
inverse(reflection_b, reflection_b).
inverse(reflection_c, reflection_c).

% Candidate subsets are generated as subsequences of the sorted symmetry list.
subsequence([], []).
subsequence([Head | Tail], [Head | Rest]) :-
  subsequence(Tail, Rest).
subsequence([_head | Tail], Rest) :-
  subsequence(Tail, Rest).

all_symmetries(Symmetries) :-
  findall(X, symmetry(X), Raw),
  sort(Raw, Symmetries).

% A valid subgroup is closed under both composition and inverse.
closed_under_composition(Group) :-
  \+ (member(X, Group), member(Y, Group), compose(X, Y, Z), \+ member(Z, Group)).

closed_under_inverse(Group) :-
  \+ (member(X, Group), inverse(X, Y), \+ member(Y, Group)).

valid_group(Group) :-
  all_symmetries(All),
  subsequence(All, Group),
  member(identity, Group),
  closed_under_composition(Group),
  closed_under_inverse(Group).

all_subgroups(Groups) :-
  findall(G, valid_group(G), Raw),
  sort(Raw, Groups).

subgroups(d3_group, Groups) :-
  all_subgroups(Groups).

subgroupCount(d3_group, Count) :-
  all_subgroups(Groups),
  length(Groups, Count).

reason(d3_group, "findall enumerates candidate subgroups and sort gives canonical subgroup order").
