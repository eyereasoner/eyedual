% Illegitimate reasoning detector.
%
% The input facts describe arguments and their surface reasoning pattern. Helper
% predicates identify common invalid inference forms. The output layer emits only
% concise report relations: the argument is illegitimate, which fallacy was found,
% the challenged conclusion, and a short reason why.

% Affirming the consequent:
%   If it rained, the street is wet. The street is wet. Therefore it rained.
% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: type(X0, X1)

%% goal: fallacy(X0, X1)

%% goal: conclusion(X0, X1)

%% goal: reason(X0, X1)

%% goal: sampleSize(X0, X1)

%% goal: requiredSampleSize(X0, X1)

%% goal: omittedAlternative(X0, X1)


:- discontiguous(argument/1).
:- discontiguous(implication/3).
:- discontiguous(observed/2).
:- discontiguous(concludes/2).
:- discontiguous(reason/2).

% Program structure: facts set up the scenario, and rules derive the queried conclusions.
argument(arg_affirming_consequent).
implication(arg_affirming_consequent, rain, street_wet).
observed(arg_affirming_consequent, street_wet).
concludes(arg_affirming_consequent, rain).

% Denying the antecedent:
%   If the key is present, the door opens. The key is not present. Therefore the door does not open.
argument(arg_denying_antecedent).
implication(arg_denying_antecedent, key_present, door_opens).
observed(arg_denying_antecedent, neg(key_present)).
concludes(arg_denying_antecedent, neg(door_opens)).

% Hasty generalization:
%   Three sampled cases are treated as enough for a universal conclusion.
argument(arg_hasty_generalization).
sample_size(arg_hasty_generalization, 3).
required_sample_size(arg_hasty_generalization, 30).
concludes(arg_hasty_generalization, all(crows, black)).

% False dilemma:
%   Only two choices are presented even though a relevant third option exists.
argument(arg_false_dilemma).
presented_alternatives(arg_false_dilemma, [approve_now, reject_forever]).
omitted_alternative(arg_false_dilemma, revise_proposal).
concludes(arg_false_dilemma, approve_now).

% A contrast case: modus ponens is not flagged.
argument(arg_modus_ponens).
implication(arg_modus_ponens, subscription_paid, access_allowed).
observed(arg_modus_ponens, subscription_paid).
concludes(arg_modus_ponens, access_allowed).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
fallacy(A, affirming_consequent) :-
  argument(A),
  implication(A, Antecedent, Consequent),
  observed(A, Consequent),
  concludes(A, Antecedent).

fallacy(A, denying_antecedent) :-
  argument(A),
  implication(A, Antecedent, Consequent),
  observed(A, neg(Antecedent)),
  concludes(A, neg(Consequent)).

fallacy(A, hasty_generalization) :-
  argument(A),
  sample_size(A, N),
  required_sample_size(A, Min),
  (N < Min),
  concludes(A, all(_, _)).

fallacy(A, false_dilemma) :-
  argument(A),
  presented_alternatives(A, _),
  omitted_alternative(A, _),
  concludes(A, _).

reason(arg_affirming_consequent, "observing the consequent does not prove the antecedent").
reason(arg_denying_antecedent, "denying the antecedent does not disprove the consequent").
reason(arg_hasty_generalization, "sample size is below the threshold for a universal conclusion").
reason(arg_false_dilemma, "a relevant alternative is omitted").

type(A, illegitimate_reasoning) :- fallacy(A, _).
conclusion(A, C) :- fallacy(A, _), concludes(A, C).
reason(A, R) :- fallacy(A, _), reason(A, R).
sampleSize(A, N) :- fallacy(A, hasty_generalization), sample_size(A, N).
requiredSampleSize(A, Min) :- fallacy(A, hasty_generalization), required_sample_size(A, Min).
omittedAlternative(A, Alt) :- fallacy(A, false_dilemma), omitted_alternative(A, Alt).
