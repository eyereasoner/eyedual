% Leg Length Discrepancy Measurement, adapted from Eyeling lldm.n3.
%
% The measurement and intermediate geometry are kept in helper predicates so
% the default relation query execution stays concise.  The visible output is
% the alarm plus the small set of relations explaining why the alarm fired.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: type(X0, X1)

%% goal: lld_left_length_cm(X0, X1)

%% goal: lld_right_length_cm(X0, X1)

%% goal: lld_discrepancy_cm(X0, X1)

%% goal: lld_threshold_cm(X0, X1)

%% goal: lld_reason(X0, X1)


:- discontiguous(val/3).

% val/3 stores raw landmark coordinates, derived deltas, line coefficients,
% projected landmarks, lengths, and alarm values in one measurement namespace.
measurement(meas47).

% measured landmark coordinates, in centimetres
val(meas47, p1xCm, 10.1).
val(meas47, p1yCm, 7.8).
val(meas47, p2xCm, 45.1).
val(meas47, p2yCm, 5.6).
val(meas47, p3xCm, 3.6).
val(meas47, p3yCm, 29.8).
val(meas47, p4xCm, 54.7).
val(meas47, p4yCm, 28.5).

% threshold used by the alarm rule, in centimetres
threshold(meas47, lld_alarm_threshold_cm, 1.25).

% geometric intermediate values
% The geometry rules build from coordinate differences to projected knee points,
% then compute left/right leg lengths and compare the discrepancy with a threshold.
val(M, dx12Cm, Z) :- measurement(M), val(M, p1xCm, X), val(M, p2xCm, Y), (Z is X - Y).
val(M, dx51Cm, Z) :- measurement(M), val(M, p5xCm, X), val(M, p1xCm, Y), (Z is X - Y).
val(M, dx53Cm, Z) :- measurement(M), val(M, p5xCm, X), val(M, p3xCm, Y), (Z is X - Y).
val(M, dx62Cm, Z) :- measurement(M), val(M, p6xCm, X), val(M, p2xCm, Y), (Z is X - Y).
val(M, dx64Cm, Z) :- measurement(M), val(M, p6xCm, X), val(M, p4xCm, Y), (Z is X - Y).
val(M, dy12Cm, Z) :- measurement(M), val(M, p1yCm, X), val(M, p2yCm, Y), (Z is X - Y).
val(M, dy13Cm, Z) :- measurement(M), val(M, p1yCm, X), val(M, p3yCm, Y), (Z is X - Y).
val(M, dy24Cm, Z) :- measurement(M), val(M, p2yCm, X), val(M, p4yCm, Y), (Z is X - Y).
val(M, dy53Cm, Z) :- measurement(M), val(M, p5yCm, X), val(M, p3yCm, Y), (Z is X - Y).
val(M, dy64Cm, Z) :- measurement(M), val(M, p6yCm, X), val(M, p4yCm, Y), (Z is X - Y).
val(M, cL1, Z) :- measurement(M), val(M, dy12Cm, Y), val(M, dx12Cm, X), (Z is Y / X).
val(M, dL3m, Z) :- measurement(M), val(M, cL1, X), (Z is 1 / X).
val(M, cL3, Z) :- measurement(M), val(M, dL3m, X), (Z is 0 - X).
val(M, pL1x1Cm, Z) :- measurement(M), val(M, cL1, X), val(M, p1xCm, Y), (Z is X * Y).
val(M, pL1x2Cm, Z) :- measurement(M), val(M, cL1, X), val(M, p2xCm, Y), (Z is X * Y).
val(M, pL3x3Cm, Z) :- measurement(M), val(M, cL3, X), val(M, p3xCm, Y), (Z is X * Y).
val(M, pL3x4Cm, Z) :- measurement(M), val(M, cL3, X), val(M, p4xCm, Y), (Z is X * Y).
val(M, dd13Cm, Z) :- measurement(M), val(M, pL1x1Cm, X), val(M, pL3x3Cm, Y), (Z is X - Y).
val(M, ddy13Cm, Z) :- measurement(M), val(M, dd13Cm, X), val(M, dy13Cm, Y), (Z is X - Y).
val(M, dd24Cm, Z) :- measurement(M), val(M, pL1x2Cm, X), val(M, pL3x4Cm, Y), (Z is X - Y).
val(M, ddy24Cm, Z) :- measurement(M), val(M, dd24Cm, X), val(M, dy24Cm, Y), (Z is X - Y).
val(M, ddL13, Z) :- measurement(M), val(M, cL1, X), val(M, cL3, Y), (Z is X - Y).
val(M, pL1dx51Cm, Z) :- measurement(M), val(M, cL1, X), val(M, dx51Cm, Y), (Z is X * Y).
val(M, pL1dx62Cm, Z) :- measurement(M), val(M, cL1, X), val(M, dx62Cm, Y), (Z is X * Y).
val(M, p5xCm, Z) :- measurement(M), val(M, ddy13Cm, X), val(M, ddL13, Y), (Z is X / Y).
val(M, p5yCm, Z) :- measurement(M), val(M, pL1dx51Cm, X), val(M, p1yCm, Y), (Z is X + Y).
val(M, p6xCm, Z) :- measurement(M), val(M, ddy24Cm, X), val(M, ddL13, Y), (Z is X / Y).
val(M, p6yCm, Z) :- measurement(M), val(M, pL1dx62Cm, X), val(M, p2yCm, Y), (Z is X + Y).
val(M, sdx53Cm2, Z) :- measurement(M), val(M, dx53Cm, X), (Z is X ** 2).
val(M, sdx64Cm2, Z) :- measurement(M), val(M, dx64Cm, X), (Z is X ** 2).
val(M, sdy53Cm2, Z) :- measurement(M), val(M, dy53Cm, X), (Z is X ** 2).
val(M, sdy64Cm2, Z) :- measurement(M), val(M, dy64Cm, X), (Z is X ** 2).
val(M, ssd53Cm2, Z) :- measurement(M), val(M, sdx53Cm2, X), val(M, sdy53Cm2, Y), (Z is X + Y).
val(M, ssd64Cm2, Z) :- measurement(M), val(M, sdx64Cm2, X), val(M, sdy64Cm2, Y), (Z is X + Y).
val(M, d53Cm, Z) :- measurement(M), val(M, ssd53Cm2, X), (Z is X ** 0.5).
val(M, d64Cm, Z) :- measurement(M), val(M, ssd64Cm2, X), (Z is X ** 0.5).
val(M, dCm, Z) :- measurement(M), val(M, d53Cm, X), val(M, d64Cm, Y), (Z is X - Y).

% concise output layer
type(M, lld_alarm) :- measurement(M), val(M, dCm, D), threshold(M, lld_alarm_threshold_cm, T), (Negt is 0 - T), (D < Negt).
type(M, lld_alarm) :- measurement(M), val(M, dCm, D), threshold(M, lld_alarm_threshold_cm, T), (D > T).
lld_left_length_cm(M, L) :- type(M, lld_alarm), val(M, d53Cm, L).
lld_right_length_cm(M, R) :- type(M, lld_alarm), val(M, d64Cm, R).
lld_discrepancy_cm(M, D) :- type(M, lld_alarm), val(M, dCm, D).
lld_threshold_cm(M, T) :- type(M, lld_alarm), threshold(M, lld_alarm_threshold_cm, T).
lld_reason(M, "discrepancy below negative threshold") :- type(M, lld_alarm).
