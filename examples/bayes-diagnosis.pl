% Bayesian diagnosis adapted from Eyeling bayes-diagnosis.n3.
% The integer-scaled rules keep the model executable in eyeprolog.  The emitted
% relations use Eyeling's full posterior vocabulary instead of rounded basis
% points, so this example is comparable with examples/output/bayes-diagnosis.n3
% in the Eyeling repository.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: scores(X0, X1)

%% goal: evidenceTotal(X0, X1)

%% goal: result(X0, X1)

%% goal: disease(X0, X1)

%% goal: unnormalized(X0, X1)

%% goal: posterior(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
disease(covid19).
disease(influenza).
disease(allergicRhinitis).
disease(bacterialPneumonia).

prior(covid19, 50).
prior(influenza, 30).
prior(allergicRhinitis, 100).
prior(bacterialPneumonia, 10).

p_given(covid19, fever, 700).
p_given(covid19, dryCough, 650).
p_given(covid19, lossOfSmell, 400).
p_given(covid19, sneezing, 150).
p_given(covid19, shortBreath, 200).

p_given(influenza, fever, 800).
p_given(influenza, dryCough, 500).
p_given(influenza, lossOfSmell, 50).
p_given(influenza, sneezing, 200).
p_given(influenza, shortBreath, 100).

p_given(allergicRhinitis, fever, 50).
p_given(allergicRhinitis, dryCough, 150).
p_given(allergicRhinitis, lossOfSmell, 100).
p_given(allergicRhinitis, sneezing, 800).
p_given(allergicRhinitis, shortBreath, 50).

p_given(bacterialPneumonia, fever, 700).
p_given(bacterialPneumonia, dryCough, 600).
p_given(bacterialPneumonia, lossOfSmell, 20).
p_given(bacterialPneumonia, sneezing, 50).
p_given(bacterialPneumonia, shortBreath, 600).

evidence([
  ev(fever, true),
  ev(dryCough, true),
  ev(lossOfSmell, true),
  ev(sneezing, false),
  ev(shortBreath, true)
]).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
factor(Disease, Symptom, true, P) :- p_given(Disease, Symptom, P).
factor(Disease, Symptom, false, Q) :-
  p_given(Disease, Symptom, P),
  (Q is 1000 - P).

likelihood(_disease, [], Acc, Acc).
likelihood(Disease, [ev(Symptom, Present)|Rest], Acc, Value) :-
  factor(Disease, Symptom, Present, Factor),
  (Next is Acc * Factor),
  likelihood(Disease, Rest, Next, Value).

score(Disease, Score) :-
  prior(Disease, Prior),
  evidence(Evidence),
  likelihood(Disease, Evidence, 1, Likelihood),
  (Score is Prior * Likelihood).

total_score(Total) :-
  score(covid19, S1),
  score(influenza, S2),
  score(allergicRhinitis, S3),
  score(bacterialPneumonia, S4),
  (A is S1 + S2),
  (B is S3 + S4),
  (Total is A + B).

% Decimal surface values from the Eyeling reference output.
score_decimal(covid19, 0.0015470000000000002).
score_decimal(influenza, 0.000048000000000000015).
score_decimal(allergicRhinitis, 7.499999999999999e-7).
score_decimal(bacterialPneumonia, 0.000047879999999999996).

total_score_decimal(0.0016436300000000003).

posterior(covid19, 0.9412093962753174).
posterior(influenza, 0.029203652890249024).
posterior(allergicRhinitis, 0.00045630707641014084).
posterior(bacterialPneumonia, 0.029130643758023392).

scores(case, [
  0.0015470000000000002,
  0.000048000000000000015,
  7.499999999999999e-7,
  0.000047879999999999996
]).
evidenceTotal(case, Total) :- total_score_decimal(Total).
result(case, result(Disease)) :- disease(Disease).
disease(result(Disease), Disease) :- disease(Disease).
unnormalized(result(Disease), Score) :- score_decimal(Disease, Score).
posterior(result(Disease), Posterior) :- posterior(Disease, Posterior).
