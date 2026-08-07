% Common pure-Prolog library predicates for EyeProlog.
%
% EyeProlog autoloads this file together with eyeprolog-library.pl. Other
% Prolog systems should load eyeprolog-library.pl only and use their native or
% library versions of these widespread predicates, avoiding redefinition of
% protected procedures.

maplist(_, [], []).
maplist(Closure, [A|As], [B|Bs]) :-
    apply(Closure, A, B),
    maplist(Closure, As, Bs).

append([], Ys, Ys).
append([X|Xs], Ys, [X|Zs]) :- append(Xs, Ys, Zs).

member(X, [X|_]).
member(X, [_|Xs]) :- member(X, Xs).

select(X, [X|Xs], Xs).
select(X, [Y|Ys], [Y|Zs]) :- select(X, Ys, Zs).

last([X], X).
last([_|Xs], X) :- last(Xs, X).

nth0(0, [X|_], X).
nth0(N, [_|Xs], X) :- var(N), nth0(N0, Xs, X), N is N0 + 1.
nth0(N, [_|Xs], X) :- nonvar(N), N > 0, N1 is N - 1, nth0(N1, Xs, X).

nth1(N, List, X) :- nth0(N0, List, X), N is N0 + 1.

reverse(List, Reversed) :- eyeprolog__reverse(List, [], Reversed).

length(List, Length) :- nonvar(List), eyeprolog__length_count(List, 0, Length).
length(List, Length) :- var(List), integer(Length), Length >= 0, eyeprolog__length_make(Length, List).

sum_list(List, Sum) :- eyeprolog__sum_list(List, 0, Sum).

min_list([X|Xs], Min) :- eyeprolog__min_list(Xs, X, Min).

max_list([X|Xs], Max) :- eyeprolog__max_list(Xs, X, Max).

list_to_set(List, Set) :- eyeprolog__list_to_set(List, [], Set).

countall(Goal, Count) :- findall(1, Goal, Ones), eyeprolog__length_count(Ones, 0, Count).
