% Modal logic emulation with a finite Kripke frame.
%
% Worlds and accessibility edges are ordinary facts.  mforces/2 interprets modal
% formula terms such as box(clear) and diamond(repaired).  box(F) is true at a
% world when every accessible world satisfies F; diamond(F) is true when at
% least one accessible world satisfies F.
%% goal: modal_truth(X0, X1, X2)

%% goal: modal_countermodel(X0, X1)


world(w0).
world(w1).
world(w2).
world(w3).

accessible(w0, w1).
accessible(w0, w2).
accessible(w1, w1).
accessible(w1, w3).
accessible(w2, w2).
accessible(w3, w3).

true_at(w1, clear).
true_at(w2, clear).
true_at(w3, clear).
true_at(w2, repaired).

mforces(_world, top).
mforces(World, atom(Prop)) :- true_at(World, Prop).
mforces(World, and(Left, Right)) :- mforces(World, Left), mforces(World, Right).
mforces(World, diamond(Formula)) :- accessible(World, Next), mforces(Next, Formula).
mforces(World, box(Formula)) :-
  world(World),
  \+ box_counterexample(World, Formula).
box_counterexample(World, Formula) :-
  accessible(World, Next),
  \+ mforces(Next, Formula).

modal_truth(all_accessible_worlds_clear, w0, box(atom(clear))) :-
  mforces(w0, box(atom(clear))).

modal_truth(repair_is_possible, w0, diamond(atom(repaired))) :-
  mforces(w0, diamond(atom(repaired))).

modal_truth(nested_possibility, w1, diamond(and(atom(clear), atom(clear)))) :-
  mforces(w1, diamond(and(atom(clear), atom(clear)))).

modal_countermodel(repair_not_necessary, w0) :-
  \+ mforces(w0, box(atom(repaired))).
