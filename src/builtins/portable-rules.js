// Relations that need no host primitive: they are ordinary ISO-style Prolog
// clauses bundled with --library for convenience.
export const portableLibrarySource = String.raw`
append([], Ys, Ys).
append([X | Xs], Ys, [X | Zs]) :- append(Xs, Ys, Zs).

member(X, [X | _]).
member(X, [_ | Xs]) :- member(X, Xs).

select(X, [X | Xs], Xs).
select(X, [Y | Ys], [Y | Zs]) :- select(X, Ys, Zs).

head([H | _], H).
rest([_ | T], T).
last([X], X).
last([_ | Xs], X) :- last(Xs, X).

nth0(0, [X | _], X).
nth0(N, [_ | Xs], X) :- nth0(N0, Xs, X), N is N0 + 1.

set_nth0(0, [_ | Xs], X, [X | Xs]).
set_nth0(N, [Y | Ys], X, [Y | Zs]) :-
  N > 0,
  N0 is N - 1,
  set_nth0(N0, Ys, X, Zs).

take(0, _, []).
take(N, [X | Xs], [X | Ys]) :-
  N > 0,
  N0 is N - 1,
  take(N0, Xs, Ys).

drop(0, Xs, Xs).
drop(N, [_ | Xs], Ys) :-
  N > 0,
  N0 is N - 1,
  drop(N0, Xs, Ys).

slice(Start, Count, Xs, Slice) :-
  drop(Start, Xs, Suffix),
  take(Count, Suffix, Slice).

reverse(Xs, Ys) :- reverse_acc(Xs, [], Ys).
reverse_acc([], Ys, Ys).
reverse_acc([X | Xs], Acc, Ys) :- reverse_acc(Xs, [X | Acc], Ys).

length([], 0).
length([_ | Xs], N) :- length(Xs, N0), N is N0 + 1.

sum_list([], 0).
sum_list([X | Xs], Sum) :- sum_list(Xs, Tail), Sum is X + Tail.

min_list([X | Xs], Min) :- min_list_acc(Xs, X, Min).
min_list_acc([], Min, Min).
min_list_acc([X | Xs], Acc, Min) :-
  (X @< Acc -> Next = X ; Next = Acc),
  min_list_acc(Xs, Next, Min).

max_list([X | Xs], Max) :- max_list_acc(Xs, X, Max).
max_list_acc([], Max, Max).
max_list_acc([X | Xs], Acc, Max) :-
  (X @> Acc -> Next = X ; Next = Acc),
  max_list_acc(Xs, Next, Max).

not_member(X, Xs) :- \+ member(X, Xs).

list_to_set([], []).
list_to_set([X | Xs], [X | Set]) :-
  findall(Y, (member(Y, Xs), Y \== X), Rest),
  list_to_set(Rest, Set).

sort(Xs, Set) :- sort_acc(Xs, [], Set).
sort_acc([], Set, Set).
sort_acc([X | Xs], Acc, Set) :-
  insert_unique(X, Acc, Next),
  sort_acc(Xs, Next, Set).
insert_unique(X, [], [X]).
insert_unique(X, [Y | Ys], [Y | Ys]) :- X == Y.
insert_unique(X, [Y | Ys], [X, Y | Ys]) :- X @< Y.
insert_unique(X, [Y | Ys], [Y | Zs]) :- X @> Y, insert_unique(X, Ys, Zs).

countall(Goal, Count) :-
  findall(1, Goal, Items),
  length(Items, Count).

sumall(Template, Goal, Sum) :-
  findall(Template, Goal, Items),
  sum_list(Items, Sum).

aggregate_min(Key, Value, Goal, BestKey, BestValue) :-
  findall(pair(Key, Value), Goal, Pairs),
  aggregate_min_pairs(Pairs, BestKey, BestValue).
aggregate_min_pairs([pair(K, V) | Pairs], BestKey, BestValue) :-
  aggregate_min_acc(Pairs, K, V, BestKey, BestValue).
aggregate_min_acc([], K, V, K, V).
aggregate_min_acc([pair(K, V) | Pairs], K0, V0, BestKey, BestValue) :-
  (K @< K0 -> K1 = K, V1 = V ; K1 = K0, V1 = V0),
  aggregate_min_acc(Pairs, K1, V1, BestKey, BestValue).

aggregate_max(Key, Value, Goal, BestKey, BestValue) :-
  findall(pair(Key, Value), Goal, Pairs),
  aggregate_max_pairs(Pairs, BestKey, BestValue).
aggregate_max_pairs([pair(K, V) | Pairs], BestKey, BestValue) :-
  aggregate_max_acc(Pairs, K, V, BestKey, BestValue).
aggregate_max_acc([], K, V, K, V).
aggregate_max_acc([pair(K, V) | Pairs], K0, V0, BestKey, BestValue) :-
  (K @> K0 -> K1 = K, V1 = V ; K1 = K0, V1 = V0),
  aggregate_max_acc(Pairs, K1, V1, BestKey, BestValue).

once(Goal) :- (Goal -> true).

between(Low, High, Low) :- Low =< High.
between(Low, High, Value) :-
  Low < High,
  Next is Low + 1,
  between_range(Next, High, Value).

min(A, B, A) :- A =< B.
min(A, B, B) :- A > B.
max(A, B, A) :- A >= B.
max(A, B, B) :- A < B.

smallest_divisor_from(N, Start, Divisor) :-
  (Start * Start > N ->
    Divisor = N
  ;
    (0 =:= N mod Start ->
      Divisor = Start
    ;
      Next is Start + 1,
      smallest_divisor_from(N, Next, Divisor)
    )
  ).

holds((Left, Right), Member) :- holds(Left, Member).
holds((Left, Right), Member) :- holds(Right, Member).
holds(Member, Member) :- Member \= (_, _).

holds(Context, Name, Arguments) :-
  holds(Context, Member),
  (atom(Member) ; compound(Member)),
  Member =.. [Name | Arguments].

% Split ranges in halves so enumeration remains linear without building a
% recursive call stack proportional to the width of the range.
between_range(Low, High, Low) :- Low =:= High.
between_range(Low, High, Value) :-
  Low < High,
  Span is High - Low,
  Half is Span // 2,
  Mid is Low + Half,
  between_range(Low, Mid, Value).
between_range(Low, High, Value) :-
  Low < High,
  Span is High - Low,
  Half is Span // 2,
  Mid is Low + Half,
  Next is Mid + 1,
  between_range(Next, High, Value).
`;
