/* ───────────────────────────────────────────────────────────────────────────
   Quine-McCluskey Logic Minimizer for Eyelet
   
   Problem:  f(A,B,C,D) = Σ m(1,3,7,11,15) + d(0,2,5)
   Goal:     Find the minimal Sum-of-Products (SOP) cover.
   
   Deterministic Rules:
   1. Start with all Prime Implicants (PIs).
   2. Select Essential PIs.
   3. For remaining minterms, find the smallest subset of remaining PIs.
   4. Tie-breaking: If multiple covers have the same size, pick the one 
      lexicographically first using the key: 0 < 1 < - (don't care).
   ─────────────────────────────────────────────────────────────────────────── */

% Eyelet Directives
%% goal: answer(_)

%% goal: reason(_)

%% goal: check(_, _, _)


:- dynamic(solution_cache/2).

% ─────────────────────────── Problem Instance ───────────────────────────
minterm(1). minterm(3). minterm(7). minterm(11). minterm(15).
dont_care(0). dont_care(2). dont_care(5).
width(4).
vars(['A', 'B', 'C', 'D']).

% ───────────────────────────── Interface ─────────────────────────────

answer(String) :-
    get_results(Primes, Cover),
    pats_to_string(Primes, PStr),
    pats_to_string(Cover, CStr),
    cover_to_sop(Cover, SopStr),
    atom_concat_list([
        'PROBLEM INSTANCE\n',
        'Minterms: {1, 3, 7, 11, 15}\n',
        'Don\'t Cares: {0, 2, 5}\n\n',
        'PRIME IMPLICANTS (Ordered):\n', PStr, '\n',
        'MINIMAL COVER (Lexicographically First):\n', CStr, '\n',
        'EQUATION:\n',
        ' f = ', SopStr
    ], String).

reason(String) :-
    String = '1. Generated Prime Implicants by iteratively combining adjacent minterms/groups.\n2. Built Prime Implicant Chart for minterms only (excluding don\'t cares).\n3. Extracted Essential Prime Implicants.\n4. Performed exhaustive search on remaining primes to find the smallest cover, breaking ties with the lexicographical key (0 < 1 < -).'.

% ─── Checks ───

check(1, 'Functional Correctness (All minterms covered)', Status) :-
    get_results(_, Cover),
    findall(M, minterm(M), Minterms),
    coverage_status(Cover, Minterms, Status).

check(2, 'Safety Check (No false positives outside DCs)', Status) :-
    get_results(_, Cover),
    findall(Z, is_true_zero(Z), Zeros),
    safety_status(Cover, Zeros, Status).

check(3, 'Minimality (Cardinality) Proof', Status) :-
    get_results(Primes, Cover),
    length_list(Cover, Size),
    Limit is Size - 1,
    findall(M, minterm(M), Minterms),
    minimality_status(Primes, Minterms, Limit, Status).

check(4, 'Canonical Tie-Breaking (Lexicographical First)', Status) :-
    get_results(Primes, Cover),
    length_list(Cover, Size),
    findall(M, minterm(M), Minterms),
    findall(C, (
        find_combination(Size, Primes, C),
        covers_all(C, Minterms)
    ), Alternatives),
    sort(Alternatives, [Best|_]),
    equality_status(Cover, Best, Status).

check(5, 'Consistency (Solution is subset of Primes)', Status) :-
    get_results(Primes, Cover),
    subset_status(Cover, Primes, Status).

coverage_status(Cover, Minterms, true) :-
    covers_all(Cover, Minterms), !.
coverage_status(_, _, false).

safety_status(Cover, Zeros, true) :-
    zeros_safe(Cover, Zeros), !.
safety_status(_, _, false).

minimality_status(Primes, Minterms, Limit, false) :-
    between_range(1, Limit, N),
    find_combination(N, Primes, Combo),
    covers_all(Combo, Minterms), !.
minimality_status(_, _, _, true).

equality_status(X, X, true) :- !.
equality_status(_, _, false).

subset_status(Subset, Set, true) :-
    is_subset(Subset, Set), !.
subset_status(_, _, false).

% ───────────────────────────── Utilities ─────────────────────────────

get_results(Primes, Cover) :-
    solution_cache(Primes, Cover), !.
get_results(Primes, Cover) :-
    compute_primes(Primes),
    solve_minimal_cover(Primes, Cover),
    assertz(solution_cache(Primes, Cover)).

atom_concat_list([], '').
atom_concat_list([H|T], S) :-
    atom_concat_list(T, Rest),
    atom_concat(H, Rest, S).

length_list([], 0).
length_list([_|T], N) :- length_list(T, N1), N is N1 + 1.

between_range(Min, Max, Min) :- Min =< Max.
between_range(Min, Max, N) :- 
    Min < Max, 
    Next is Min + 1, 
    between_range(Next, Max, N).

is_subset([], _).
is_subset([H|T], List) :- member(H, List), is_subset(T, List).

% ────────────────────────── Logic Core ──────────────────────────

int_to_bits(N, Bits) :- width(W), format_bits(N, W, Bits).
format_bits(_, 0, []) :- !.
format_bits(N, W, [B|Rest]) :-
    W > 0, W1 is W - 1,
    Val is (N >> W1) /\ 1,
    (Val = 1 -> B = '1' ; B = '0'),
    NRem is N - (Val << W1),
    format_bits(NRem, W1, Rest).

% 'x' is used for Don't Care to ensure sort order 0 < 1 < x
covers([], []).
covers(['x'|Ps], [_|Bs]) :- covers(Ps, Bs).
covers([B|Ps], [B|Bs])   :- B \= 'x', covers(Ps, Bs).

covers_int(Pat, Int) :- int_to_bits(Int, Bits), covers(Pat, Bits).

combine(A, B, Res) :-
    diff_count(A, B, 0, 1, [], RRev),
    reverse_list(RRev, Res).

reverse_list([], []).
reverse_list([H|T], R) :- reverse_list(T, Rev), append(Rev, [H], R).

diff_count([], [], _, _, Acc, Acc).
diff_count([X|T1], [X|T2], C, Max, Acc, Res) :- !, diff_count(T1, T2, C, Max, [X|Acc], Res).
diff_count([X|T1], [Y|T2], C, Max, Acc, Res) :-
    X \= Y, C1 is C + 1, C1 =< Max,
    diff_count(T1, T2, C1, Max, ['x'|Acc], Res).

% ──────────────────────── Algorithm ────────────────────────

compute_primes(Primes) :-
    findall(B, (minterm(M), int_to_bits(M, B)), Mts),
    findall(B, (dont_care(D), int_to_bits(D, B)), Dcs),
    append(Mts, Dcs, All),
    sort(All, Init),
    generate_loop(Init, [], RawPrimes),
    sort(RawPrimes, Primes).

generate_loop(Group, Acc, Final) :-
    findall(Nx-[P1,P2], (
        member(P1, Group), member(P2, Group), P1 @< P2, combine(P1, P2, Nx)
    ), Pairs),
    findall(N, member(N-_, Pairs), NextRaw),
    findall(P, (member(_-Pars, Pairs), member(P, Pars)), UsedRaw),
    sort(NextRaw, NextGen),
    sort(UsedRaw, Used),
    findall(P, (member(P, Group), \+ member(P, Used)), New),
    append(Acc, New, AccUpd),
    (NextGen = [] -> Final = AccUpd ; generate_loop(NextGen, AccUpd, Final)).

solve_minimal_cover(Primes, MinimalCover) :-
    findall(M, minterm(M), Minterms),
    % 1. Essentials
    findall(M-Ps, (member(M, Minterms), findall(P, (member(P, Primes), covers_int(P, M)), Ps)), Chart),
    findall(P, member(_-[P], Chart), EssRaw),
    sort(EssRaw, Essentials),
    % 2. Remaining
    remaining_minterms(Minterms, Essentials, RemMts),
    subtract_list(Primes, Essentials, NonEss),
    (RemMts = [] -> BestRest = [] ; find_smallest_subset(NonEss, RemMts, BestRest)),
    append(Essentials, BestRest, Total),
    sort(Total, MinimalCover).

remaining_minterms([], _, []).
remaining_minterms([M|Ms], Essentials, Rest) :-
    prime_covers_any(Essentials, M), !,
    remaining_minterms(Ms, Essentials, Rest).
remaining_minterms([M|Ms], Essentials, [M|Rest]) :-
    remaining_minterms(Ms, Essentials, Rest).

prime_covers_any(Primes, Minterm) :-
    member(P, Primes),
    covers_int(P, Minterm).

subtract_list([], _, []).
subtract_list([H|T], S, R) :- member(H, S), !, subtract_list(T, S, R).
subtract_list([H|T], S, [H|R]) :- subtract_list(T, S, R).

find_smallest_subset(Cands, Targets, Subset) :-
    length_list(Cands, Len),
    between_range(1, Len, N),
    find_combination(N, Cands, Combo),
    covers_all(Combo, Targets), !, Subset = Combo.

find_combination(0, _, []).
find_combination(N, [H|T], [H|R]) :- N > 0, N1 is N - 1, find_combination(N1, T, R).
find_combination(N, [_|T], R) :- N > 0, find_combination(N, T, R).

covers_all(_, []).
covers_all(Primes, [T|Targets]) :-
    prime_covers_any(Primes, T),
    covers_all(Primes, Targets).

is_true_zero(Z) :-
    width(W), Max is (1 << W) - 1,
    between_range(0, Max, Z),
    \+ minterm(Z), \+ dont_care(Z).

zeros_safe(_, []).
zeros_safe(Cover, [Z|Zeros]) :-
    no_prime_covers(Cover, Z),
    zeros_safe(Cover, Zeros).

no_prime_covers([], _).
no_prime_covers([P|Ps], Value) :-
    \+ covers_int(P, Value),
    no_prime_covers(Ps, Value).

% ──────────────────────── Output Formatting ────────────────────────

pats_to_string([], '').
pats_to_string([H], S) :-
    pat_to_str(H, S).
pats_to_string([H,N|T], S) :-
    pat_to_str(H, Hs),
    pats_to_string([N|T], Ts),
    atom_concat_list([Hs, ', ', Ts], S).

pat_to_str(P, S) :- atom_concat_list(P, S).

cover_to_sop(Cover, S) :-
    findall(Part, (member(Pat, Cover), term_sop(Pat, Part)), Terms),
    intersperse_sop(Terms, Parts),
    atom_concat_list(Parts, S).

intersperse_sop([H], [H]).
intersperse_sop([H,N|T], [H, ' + '|Rest]) :-
    intersperse_sop([N|T], Rest).

term_sop(Pat, S) :-
    vars(Vs), term_build(Pat, Vs, 0, L),
    (L = [] -> S = '1' ; atom_concat_list(L, S)).

term_build([], [], _, []).
term_build(['1'|Ps], [V|Vs], _, [V|Rest]) :- !, term_build(Ps, Vs, 1, Rest).
term_build(['0'|Ps], [V|Vs], _, [NV|Rest]) :- !, atom_concat('~', V, NV), term_build(Ps, Vs, 1, Rest).
term_build(['x'|Ps], [_|Vs], C, Rest) :- !, term_build(Ps, Vs, C, Rest).
