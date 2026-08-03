:- include('test/conformance/cases/iso/include_payload.inc').
:- ensure_loaded('test/conformance/cases/iso/include_payload.inc').
:- ensure_loaded('test/conformance/cases/iso/include_payload.inc').

%% goal: included_answer(X)

included_answer(X) :-
    included(X).
