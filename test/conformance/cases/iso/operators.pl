% ISO 8.14: operator declarations affect the terms that follow them.
:- op(500, xfy, likes).
:- op(400, yfx, then).
:- op(300, fy, maybe).
:- op(200, yf, done).
:- op(650, xfx, [links, relates]).

%% goal: operator_terms(A, B, C, D)

operator_terms(A, B, C, D) :-
    A = (alice likes bob likes carol),
    B = (alice then bob then carol),
    C = (maybe maybe alice),
    D = (alice done done).

%% goal: declared_operator(P, S)

declared_operator(P, S) :-
    current_op(P, S, likes).

%% goal: operator_list_declaration(A, B)

operator_list_declaration(A, B) :-
    A = (alice links bob),
    B = (alice relates bob).

%% goal: runtime_operator(P, S)

runtime_operator(P, S) :-
    op(675, xfx, runtime_link),
    current_op(P, S, runtime_link).

%% goal: removed_operator(ok)

removed_operator(ok) :-
    op(675, xfx, temporary_link),
    op(0, xfx, temporary_link),
    \+ current_op(_, _, temporary_link).
