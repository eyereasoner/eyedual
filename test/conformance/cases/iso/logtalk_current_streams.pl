% Adapted from Logtalk current_input/1 and current_output/1 tests 01, 03, 05, 06.
% Modified for Eyepl's conformance harness. See test/conformance/THIRD_PARTY.md.
query(current_streams).
current_streams :-
    current_input(Input),
    current_input(Input),
    current_output(Output),
    current_output(Output),
    ground(Input),
    ground(Output),
    Input \== Output.
