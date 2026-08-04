% Representative example: manufacturing quality-control capability.
%
% The rules compute process capability indices from measurement summaries and
% classify production lines using a practical Cpk threshold.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: cpk(X0, X1)

%% goal: status(X0, X1)

%% goal: reason(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
run(line7_shift_a).
run(line8_shift_b).

spec(line7_shift_a, lower_mm, 10.0).
spec(line7_shift_a, upper_mm, 10.2).
summary(line7_shift_a, mean_mm, 10.12).
summary(line7_shift_a, sigma_mm, 0.04).

spec(line8_shift_b, lower_mm, 10.0).
spec(line8_shift_b, upper_mm, 10.2).
summary(line8_shift_b, mean_mm, 10.1).
summary(line8_shift_b, sigma_mm, 0.02).

capability_threshold(cpk, 1.33).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
upper_margin_mm(Run, Margin) :-
  spec(Run, upper_mm, Upper),
  summary(Run, mean_mm, Mean),
  (Margin is Upper - Mean).

lower_margin_mm(Run, Margin) :-
  summary(Run, mean_mm, Mean),
  spec(Run, lower_mm, Lower),
  (Margin is Mean - Lower).

nearest_spec_margin_mm(Run, Margin) :-
  upper_margin_mm(Run, Uppermargin),
  lower_margin_mm(Run, Lowermargin),
  (Uppermargin =< Lowermargin -> Margin = Uppermargin ; Margin = Lowermargin).

three_sigma_mm(Run, Threesigma) :-
  summary(Run, sigma_mm, Sigma),
  (Threesigma is 3.0 * Sigma).

cpk(Run, Cpk) :-
  nearest_spec_margin_mm(Run, Margin),
  three_sigma_mm(Run, Threesigma),
  (Cpk is Margin / Threesigma).

capable(Run) :-
  cpk(Run, Cpk),
  capability_threshold(cpk, Threshold),
  (Cpk >= Threshold).

needs_adjustment(Run) :-
  cpk(Run, Cpk),
  capability_threshold(cpk, Threshold),
  (Cpk < Threshold).


status(Run, capable_process) :-
  capable(Run).

status(Run, needs_process_adjustment) :-
  needs_adjustment(Run).

reason(Run, "Cpk meets the production capability threshold") :-
  capable(Run).

reason(Run, "Cpk is below the production capability threshold") :-
  needs_adjustment(Run).
