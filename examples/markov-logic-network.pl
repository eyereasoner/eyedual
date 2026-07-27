% Markov Logic Network style scoring over a tiny finite domain.
%
% Eyepl is deterministic, so this is not a probabilistic MLN engine.  The
% example encodes the usual MLN MAP idea explicitly: enumerate possible worlds,
% mark which weighted soft formulas each world satisfies, sum the weights, and
% choose the highest-scoring world.  Weights are stored as integer tenths of a
% log weight so the example stays reproducible without floating-point noise.

query(mlnWeight(X0, X1)).
query(mlnWorld(X0, X1)).
query(mlnSatisfied(X0, X1)).
query(mlnViolated(X0, X1)).
query(mlnContribution(X0, X1, X2)).
query(mlnWorldScore(X0, X1)).
query(mlnMapWorld(X0, X1)).
query(mlnConclusion(X0, X1)).

% Evidence and candidate hidden assignments.
person(alice).
person(bob).
friend(alice, bob).
observed_smokes(alice).

candidate_world(w_bob_not_smokes_not_cancer, no, no).
candidate_world(w_bob_not_smokes_cancer, no, yes).
candidate_world(w_bob_smokes_not_cancer, yes, no).
candidate_world(w_bob_smokes_cancer, yes, yes).

% Soft formulas are weighted log features.
formula_weight_tenths(friend_smoking, 20).
formula_weight_tenths(smoking_causes_cancer, 13).
formula_weight_tenths(cancer_is_rare, 6).

% World interpretation for Bob.  Alice's smoking status is observed evidence.
smokes_in_world(World, alice) :-
  candidate_world(World, _, _),
  observed_smokes(alice).
smokes_in_world(World, bob) :- candidate_world(World, yes, _).
cancer_in_world(World, bob) :- candidate_world(World, _, yes).

% Grounded soft formulas for this tiny domain:
%   friend_smoking:        friend(alice,bob) and smokes(alice) => smokes(bob)
%   smoking_causes_cancer: smokes(bob) => cancer(bob)
%   cancer_is_rare:        not cancer(bob)
formula_satisfied(World, friend_smoking) :-
  friend(alice, bob),
  smokes_in_world(World, alice),
  smokes_in_world(World, bob).

formula_satisfied(World, smoking_causes_cancer) :-
  candidate_world(World, no, _).
formula_satisfied(World, smoking_causes_cancer) :-
  smokes_in_world(World, bob),
  cancer_in_world(World, bob).

formula_satisfied(World, cancer_is_rare) :-
  candidate_world(World, _, no).

formula_violated(World, Formula) :-
  candidate_world(World, _, _),
  formula_weight_tenths(Formula, _),
  \+ formula_satisfied(World, Formula).

contribution_tenths(World, Formula, Weight) :-
  formula_satisfied(World, Formula),
  formula_weight_tenths(Formula, Weight).

world_score_tenths(World, Score) :-
  candidate_world(World, _, _),
  sumall(Weight, contribution_tenths(World, Formula, Weight), Score).

map_world(World, Score) :-
  aggregate_max(Candidate_score, Candidate_world,
    world_score_tenths(Candidate_world, Candidate_score),
    Score, World).

mlnWeight(Formula, log_weight_tenths(Weight)) :- formula_weight_tenths(Formula, Weight).
mlnWorld(World, world(smokes(bob, Smokes), cancer(bob, Cancer))) :-
  candidate_world(World, Smokes, Cancer).
mlnSatisfied(World, Formula) :- formula_satisfied(World, Formula).
mlnViolated(World, Formula) :- formula_violated(World, Formula).
mlnContribution(World, Formula, log_weight_tenths(Weight)) :-
  contribution_tenths(World, Formula, Weight).
mlnWorldScore(World, log_weight_tenths(Score)) :- world_score_tenths(World, Score).
mlnMapWorld(World, log_weight_tenths(Score)) :- map_world(World, Score).
mlnConclusion(case, "MAP world predicts that Bob smokes and has cancer") :-
  map_world(w_bob_smokes_cancer, _).
