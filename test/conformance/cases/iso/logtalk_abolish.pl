% Adapted from Logtalk iso_abolish_1_01 and eddbali_abolish_1_06.
% Modified for EyeProlog's conformance harness. See test/conformance/THIRD_PARTY.md.
:- dynamic(foo/1).
foo(a).
%% goal: abolish_result

abolish_result :-
    abolish(foo/1),
    \+ current_predicate(foo/1),
    abolish(missing/2).
