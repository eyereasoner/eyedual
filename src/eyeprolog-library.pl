% EyeProlog portable library.
%
% This file is autoloaded for the EyeProlog runtime and is intentionally
% written against the project's ISO compatibility profile.  Text-facing
% predicates accept ISO atoms or proper lists of one-character atoms; newly
% produced text defaults to atoms.  Only uuid/1 and local_time/1 remain native
% host built-ins because ISO Prolog has no entropy or wall-clock primitive.

% ---------- text representation helpers ----------

eyeprolog__char_list([]).
eyeprolog__char_list([C|Cs]) :- atom(C), atom_length(C, 1), eyeprolog__char_list(Cs).

eyeprolog__text_chars(Text, []) :- nonvar(Text), Text = [], !.
eyeprolog__text_chars(Text, Chars) :-
    atom(Text),
    atom_chars(Text, Chars).
eyeprolog__text_chars(Text, Chars) :-
    nonvar(Text),
    eyeprolog__char_list(Text),
    Text = Chars.
eyeprolog__text_chars(Text, Chars) :-
    var(Text),
    atom_chars(Text, Chars).

eyeprolog__atomic_chars(Value, []) :- nonvar(Value), Value = [], !.
eyeprolog__atomic_chars(Value, Chars) :-
    atom(Value),
    atom_chars(Value, Chars).
eyeprolog__atomic_chars(Value, Chars) :-
    number(Value),
    number_chars(Value, Chars).
eyeprolog__atomic_chars(Value, Chars) :-
    nonvar(Value),
    eyeprolog__char_list(Value),
    Value = Chars.

% ---------- core/meta ----------

call(Closure, A, B) :-
    Closure =.. Parts,
    append(Parts, [A, B], CallParts),
    Goal =.. CallParts,
    call(Goal).

maplist(_, [], []).
maplist(Closure, [A|As], [B|Bs]) :-
    call(Closure, A, B),
    maplist(Closure, As, Bs).

% ---------- arithmetic helpers ----------

tan(X, Y) :- Y is sin(X) / cos(X).

asin(1, Y) :- Y is pi / 2.
asin(-1, Y) :- Y is -pi / 2.
asin(X, Y) :- X > -1, X < 1, Y is atan(X / sqrt(1 - X * X)).

acos(X, Y) :- asin(X, A), Y is pi / 2 - A.

atan2(Y, X, A) :- X > 0, A is atan(Y / X).
atan2(Y, X, A) :- X < 0, Y >= 0, A is atan(Y / X) + pi.
atan2(Y, X, A) :- X < 0, Y < 0, A is atan(Y / X) - pi.
atan2(Y, 0, A) :- Y > 0, A is pi / 2.
atan2(Y, 0, A) :- Y < 0, A is -pi / 2.
atan2(0, 0, 0).

eyeprolog__atom_number(Text, Number) :-
    eyeprolog__text_chars(Text, Chars),
    catch(number_chars(Number, Chars), _, fail).

eyeprolog__duration(Text, Years, Months, Days) :-
    eyeprolog__text_chars(Text, ['P'|Chars]),
    Chars \= [],
    eyeprolog__duration_fields(Chars, 0, 0, 0, Years, Months, Days).

eyeprolog__duration_fields([], Y, M, D, Y, M, D).
eyeprolog__duration_fields(Chars, Y0, M0, D0, Y, M, D) :-
    eyeprolog__duration_field(Chars, Digits, Unit, Rest),
    Digits \= [],
    number_chars(N, Digits),
    eyeprolog__duration_assign(Unit, N, Y0, M0, D0, Y1, M1, D1),
    eyeprolog__duration_fields(Rest, Y1, M1, D1, Y, M, D).

eyeprolog__duration_field([C|Cs], [C|Ds], Unit, Rest) :-
    char_code(C, Code), Code >= 48, Code =< 57,
    eyeprolog__duration_field(Cs, Ds, Unit, Rest).
eyeprolog__duration_field([Unit|Rest], [], Unit, Rest) :-
    member(Unit, ['Y', 'M', 'D']).

eyeprolog__duration_assign('Y', N, 0, M, D, N, M, D).
eyeprolog__duration_assign('M', N, Y, 0, D, Y, N, D).
eyeprolog__duration_assign('D', N, Y, M, 0, Y, M, N).

eyeprolog__duration_compare(A, B, Cmp) :-
    eyeprolog__duration(A, AY, AM, AD),
    eyeprolog__duration(B, BY, BM, BD),
    eyeprolog__triple_compare(AY, AM, AD, BY, BM, BD, Cmp).

eyeprolog__triple_compare(A, _, _, B, _, _, -1) :- A < B.
eyeprolog__triple_compare(A, _, _, B, _, _, 1) :- A > B.
eyeprolog__triple_compare(A, C, _, A, D, _, -1) :- C < D.
eyeprolog__triple_compare(A, C, _, A, D, _, 1) :- C > D.
eyeprolog__triple_compare(A, C, E, A, C, F, -1) :- E < F.
eyeprolog__triple_compare(A, C, E, A, C, F, 1) :- E > F.
eyeprolog__triple_compare(A, C, E, A, C, E, 0).

eyeprolog__compare(A, B, Cmp) :-
    number(A), number(B), !,
    eyeprolog__number_compare(A, B, Cmp).
eyeprolog__compare(A, B, Cmp) :-
    eyeprolog__atom_number(A, AN), eyeprolog__atom_number(B, BN), !,
    eyeprolog__number_compare(AN, BN, Cmp).
eyeprolog__compare(A, B, Cmp) :-
    eyeprolog__duration_compare(A, B, Cmp), !.
eyeprolog__compare(A, B, -1) :- A @< B.
eyeprolog__compare(A, B, 1) :- A @> B.
eyeprolog__compare(A, A, 0).

eyeprolog__number_compare(A, B, -1) :- A < B.
eyeprolog__number_compare(A, B, 1) :- A > B.
eyeprolog__number_compare(A, B, 0) :- A =:= B.

lt(A, B) :- eyeprolog__compare(A, B, -1).
gt(A, B) :- eyeprolog__compare(A, B, 1).
le(A, B) :- eyeprolog__compare(A, B, C), C =< 0.
ge(A, B) :- eyeprolog__compare(A, B, C), C >= 0.

between(Low, High, Value) :-
    Low =< High,
    eyeprolog__between(Low, High, Value).

eyeprolog__between(Low, _, Low).
eyeprolog__between(Low, High, Value) :-
    Low < High,
    Next is Low + 1,
    % This is a green cut: after the base answer has been tried, the recursive
    % clause is the only remaining route. It also keeps this finite generator
    % out of automatic answer tabling, which would retain every range suffix.
    !,
    eyeprolog__between(Next, High, Value).

smallest_divisor_from(N, Start, Divisor) :-
    N >= 0,
    Start > 0,
    eyeprolog__smallest_divisor_fast(N, Start, Divisor).

% A deterministic Miller-Rabin screen avoids long trial scans for prime values
% in the exact range covered by bases 2,3,5,7,11,13,17. Above that range the
% implementation falls back to exact trial division, preserving semantics for
% arbitrary-size integers.
eyeprolog__smallest_divisor_fast(N, Start, N) :-
    N >= 2,
    N < 341550071728321,
    eyeprolog__mr_prime(N),
    !.
eyeprolog__smallest_divisor_fast(N, Start, Divisor) :-
    eyeprolog__smallest_divisor(N, Start, Divisor).

eyeprolog__smallest_divisor(N, Candidate, N) :- Candidate * Candidate > N.
eyeprolog__smallest_divisor(N, Candidate, Candidate) :-
    Candidate * Candidate =< N,
    0 is N mod Candidate.
eyeprolog__smallest_divisor(N, Candidate, Divisor) :-
    Candidate * Candidate =< N,
    N mod Candidate =\= 0,
    Next is Candidate + 1,
    eyeprolog__smallest_divisor(N, Next, Divisor).

eyeprolog__mr_prime(2).
eyeprolog__mr_prime(3).
eyeprolog__mr_prime(N) :-
    N > 3,
    1 is N mod 2,
    eyeprolog__factor_twos(N, S, D),
    eyeprolog__mr_bases([2,3,5,7,11,13,17], N, S, D).

eyeprolog__factor_twos(N, S, D) :-
    M is N - 1,
    eyeprolog__factor_twos_loop(M, 0, S, D).

eyeprolog__factor_twos_loop(D, S, S, D) :- 1 is D mod 2.
eyeprolog__factor_twos_loop(Value, S0, S, D) :-
    0 is Value mod 2,
    Next is Value // 2,
    S1 is S0 + 1,
    eyeprolog__factor_twos_loop(Next, S1, S, D).

eyeprolog__mr_bases([], _, _, _).
eyeprolog__mr_bases([A|As], N, S, D) :-
    ( A >= N -> true ; eyeprolog__mr_passes(A, N, S, D) ),
    eyeprolog__mr_bases(As, N, S, D).

eyeprolog__mr_passes(A, N, _, D) :-
    eyeprolog__pow_mod(A, D, N, X),
    ( X =:= 1 ; X =:= N - 1 ),
    !.
eyeprolog__mr_passes(A, N, S, D) :-
    eyeprolog__pow_mod(A, D, N, X),
    eyeprolog__mr_square_chain(X, N, 1, S).

eyeprolog__mr_square_chain(X, N, R, S) :-
    R < S,
    X1 is (X * X) mod N,
    ( X1 =:= N - 1
    ; R1 is R + 1,
      eyeprolog__mr_square_chain(X1, N, R1, S)
    ).

eyeprolog__pow_mod(_, 0, _, 1).
eyeprolog__pow_mod(Base, Exp, Mod, Result) :-
    Exp > 0,
    HalfExp is Exp // 2,
    eyeprolog__pow_mod(Base, HalfExp, Mod, Half),
    Square is (Half * Half) mod Mod,
    ( 0 is Exp mod 2 -> Result = Square ; Result is (Square * Base) mod Mod ).

% ---------- dates ----------

difference(EndText, StartText, Duration) :-
    eyeprolog__date(EndText, EY0, EM0, ED0),
    eyeprolog__date(StartText, SY, SM, SD),
    eyeprolog__date_not_before(EY0, EM0, ED0, SY, SM, SD),
    eyeprolog__borrow_days(EY0, EM0, ED0, SD, EY1, EM1, ED1),
    eyeprolog__borrow_months(EY1, EM1, SM, EY2, EM2),
    Y is EY2 - SY,
    M is EM2 - SM,
    D is ED1 - SD,
    eyeprolog__format_duration(Y, M, D, Duration).

eyeprolog__date(Text, Y, M, D) :-
    eyeprolog__text_chars(Text, [Y1,Y2,Y3,Y4,'-',M1,M2,'-',D1,D2|_]),
    number_chars(Y, [Y1,Y2,Y3,Y4]),
    number_chars(M, [M1,M2]),
    number_chars(D, [D1,D2]),
    M >= 1, M =< 12,
    eyeprolog__days_in_month(Y, M, MaxD),
    D >= 1, D =< MaxD.

eyeprolog__date_not_before(EY, _, _, SY, _, _) :- EY > SY.
eyeprolog__date_not_before(Y, EM, _, Y, SM, _) :- EM > SM.
eyeprolog__date_not_before(Y, M, ED, Y, M, SD) :- ED >= SD.

eyeprolog__borrow_days(EY, EM, ED, SD, EY, EM, ED) :- ED >= SD.
eyeprolog__borrow_days(EY0, EM0, ED0, SD, EY, EM, ED) :-
    ED0 < SD,
    eyeprolog__previous_month(EY0, EM0, PY, PM),
    eyeprolog__days_in_month(PY, PM, Days),
    ED is ED0 + Days,
    EY = PY,
    EM = PM.

eyeprolog__borrow_months(EY, EM, SM, EY, EM) :- EM >= SM.
eyeprolog__borrow_months(EY0, EM0, SM, EY, EM) :-
    EM0 < SM,
    EY is EY0 - 1,
    EM is EM0 + 12.

eyeprolog__previous_month(Y, M, Y, PM) :- M > 1, PM is M - 1.
eyeprolog__previous_month(Y, 1, PY, 12) :- PY is Y - 1.

eyeprolog__days_in_month(Y, 2, 29) :- eyeprolog__leap_year(Y).
eyeprolog__days_in_month(Y, 2, 28) :- \+ eyeprolog__leap_year(Y).
eyeprolog__days_in_month(_, M, 30) :- member(M, [4,6,9,11]).
eyeprolog__days_in_month(_, M, 31) :- member(M, [1,3,5,7,8,10,12]).

eyeprolog__leap_year(Y) :- 0 is Y mod 400.
eyeprolog__leap_year(Y) :- Y mod 100 =\= 0, 0 is Y mod 4.

eyeprolog__format_duration(0, 0, 0, Duration) :-
    eyeprolog__text_chars(Duration, ['P','0','D']).
eyeprolog__format_duration(Y, M, D, Duration) :-
    Magnitude is abs(Y) + abs(M) + abs(D), Magnitude > 0,
    eyeprolog__duration_part(Y, 'Y', YC),
    eyeprolog__duration_part(M, 'M', MC),
    eyeprolog__duration_part(D, 'D', DC),
    append(['P'|YC], MC, A),
    append(A, DC, Chars),
    eyeprolog__text_chars(Duration, Chars).

eyeprolog__duration_part(0, _, []).
eyeprolog__duration_part(N, Unit, Chars) :-
    N =\= 0,
    number_chars(N, Digits),
    append(Digits, [Unit], Chars).

% ---------- portable named-capture matcher ----------
%
% matches/3 supports the portable subset used by EyeProlog examples:
% literals, ^/$ anchors, named groups (?<name>...), optional named groups ?,
% \w+, \S+, bracket classes with + or {N}, and literal group bodies.  Captures are returned as
% the same conjunction-of-Name(Value) context shape as before.

matches(Text, Pattern, Context) :-
    eyeprolog__text_chars(Text, TextChars),
    eyeprolog__text_chars(Pattern, PatternChars),
    eyeprolog__regex_parse(PatternChars, StartAnchor, EndAnchor, Tokens),
    eyeprolog__has_capture(Tokens),
    eyeprolog__regex_start(StartAnchor, TextChars, Candidate),
    eyeprolog__regex_tokens(Tokens, Candidate, Rest, Captures),
    eyeprolog__regex_end(EndAnchor, Rest),
    !,
    eyeprolog__captures_context(Captures, Context).

eyeprolog__regex_start(yes, Chars, Chars).
eyeprolog__regex_start(no, Chars, Chars).
eyeprolog__regex_start(no, [_|Cs], Candidate) :- eyeprolog__regex_start(no, Cs, Candidate).

eyeprolog__regex_end(yes, []).
eyeprolog__regex_end(no, _).

eyeprolog__regex_parse(Chars0, Start, End, Tokens) :-
    eyeprolog__strip_start_anchor(Chars0, Start, Chars1),
    eyeprolog__strip_end_anchor(Chars1, End, Chars2),
    eyeprolog__regex_tokens_parse(Chars2, Tokens).

eyeprolog__strip_start_anchor(['^'|Cs], yes, Cs).
eyeprolog__strip_start_anchor(Cs, no, Cs).

eyeprolog__strip_end_anchor(Cs0, yes, Cs) :- append(Cs, ['$'], Cs0).
eyeprolog__strip_end_anchor(Cs, no, Cs) :- \+ append(_, ['$'], Cs).

eyeprolog__regex_tokens_parse([], []).
eyeprolog__regex_tokens_parse(['('|Cs], [capture(Name, Kind, Optional)|Tokens]) :-
    Cs = ['?','<'|AfterOpen],
    eyeprolog__take_until('>', AfterOpen, NameChars, AfterName),
    NameChars \= [],
    atom_chars(Name, NameChars),
    eyeprolog__take_until(')', AfterName, Body, AfterGroup),
    eyeprolog__capture_kind(Body, Kind),
    eyeprolog__optional_marker(AfterGroup, Optional, Rest),
    eyeprolog__regex_tokens_parse(Rest, Tokens).
eyeprolog__regex_tokens_parse(['('|_], _) :- fail.
eyeprolog__regex_tokens_parse([C|Cs], [literal(C)|Tokens]) :-
    C \= '(',
    eyeprolog__regex_tokens_parse(Cs, Tokens).

eyeprolog__take_until(Stop, [Stop|Rest], [], Rest).
eyeprolog__take_until(Stop, [C|Cs], [C|Out], Rest) :-
    C \= Stop,
    eyeprolog__take_until(Stop, Cs, Out, Rest).

eyeprolog__optional_marker(['?'|Rest], yes, Rest).
eyeprolog__optional_marker(Rest, no, Rest).

eyeprolog__capture_kind(Body, word_plus) :-
    Body = [Slash,'w','+'], char_code(Slash, 92).
eyeprolog__capture_kind(Body, nonspace_plus) :-
    Body = [Slash,'S','+'], char_code(Slash, 92).
eyeprolog__capture_kind(['['|Body], class_plus(Class)) :-
    eyeprolog__take_until(']', Body, Class, ['+']),
    Class \= [].
eyeprolog__capture_kind(['['|Body], class_exact(Class, Count)) :-
    eyeprolog__take_until(']', Body, Class, ['{'|CountAndClose]),
    eyeprolog__take_until('}', CountAndClose, CountChars, []),
    CountChars \= [],
    number_chars(Count, CountChars),
    integer(Count), Count > 0,
    Class \= [].
eyeprolog__capture_kind(Body, literal(Body)) :-
    Body \= [],
    \+ member('(', Body),
    \+ member(')', Body),
    \+ member('[', Body),
    \+ member(']', Body),
    \+ member('+', Body),
    \+ member('*', Body).

eyeprolog__has_capture([capture(_,_,_)|_]).
eyeprolog__has_capture([_|Ts]) :- eyeprolog__has_capture(Ts).

eyeprolog__regex_tokens([], Chars, Chars, []).
eyeprolog__regex_tokens([literal(C)|Ts], [C|Cs], Rest, Captures) :-
    eyeprolog__regex_tokens(Ts, Cs, Rest, Captures).
eyeprolog__regex_tokens([capture(Name,Kind,no)|Ts], Chars, Rest, [capture(Name,Value)|Captures]) :-
    eyeprolog__capture_match(Kind, Chars, After, ValueChars),
    atom_chars(Value, ValueChars),
    eyeprolog__regex_tokens(Ts, After, Rest, Captures).
eyeprolog__regex_tokens([capture(Name,Kind,yes)|Ts], Chars, Rest, [capture(Name,Value)|Captures]) :-
    eyeprolog__capture_match(Kind, Chars, After, ValueChars),
    atom_chars(Value, ValueChars),
    eyeprolog__regex_tokens(Ts, After, Rest, Captures).
eyeprolog__regex_tokens([capture(_,_,yes)|Ts], Chars, Rest, Captures) :-
    eyeprolog__regex_tokens(Ts, Chars, Rest, Captures).

eyeprolog__capture_match(literal(Literal), Chars, Rest, Literal) :- append(Literal, Rest, Chars).
eyeprolog__capture_match(word_plus, Chars, Rest, Value) :- eyeprolog__take_class_plus(word, Chars, Value, Rest).
eyeprolog__capture_match(nonspace_plus, Chars, Rest, Value) :- eyeprolog__take_class_plus(nonspace, Chars, Value, Rest).
eyeprolog__capture_match(class_plus(Class), Chars, Rest, Value) :- eyeprolog__take_class_plus(class(Class), Chars, Value, Rest).
eyeprolog__capture_match(class_exact(Class, Count), Chars, Rest, Value) :- eyeprolog__take_class_exact(Count, Class, Chars, Value, Rest).

eyeprolog__take_class_plus(Kind, [C|Cs], [C|Taken], Rest) :-
    eyeprolog__class_char(Kind, C),
    eyeprolog__take_class_more(Kind, Cs, Taken, Rest).

eyeprolog__take_class_more(Kind, [C|Cs], [C|Taken], Rest) :-
    eyeprolog__class_char(Kind, C),
    eyeprolog__take_class_more(Kind, Cs, Taken, Rest).
eyeprolog__take_class_more(_, Rest, [], Rest).

eyeprolog__take_class_exact(0, _, Chars, [], Chars).
eyeprolog__take_class_exact(N, Class, [C|Cs], [C|Taken], Rest) :-
    N > 0,
    eyeprolog__class_char(class(Class), C),
    N1 is N - 1,
    eyeprolog__take_class_exact(N1, Class, Cs, Taken, Rest).

eyeprolog__class_char(alpha, C) :- char_code(C, Code), ((Code >= 65, Code =< 90) ; (Code >= 97, Code =< 122)).
eyeprolog__class_char(digit, C) :- char_code(C, Code), Code >= 48, Code =< 57.
eyeprolog__class_char(word, C) :- eyeprolog__class_char(alpha, C).
eyeprolog__class_char(word, C) :- eyeprolog__class_char(digit, C).
eyeprolog__class_char(word, '_').
eyeprolog__class_char(nonspace, C) :- char_code(C, Code), \+ eyeprolog__space_code(Code).
eyeprolog__class_char(class(Class), C) :- eyeprolog__class_spec_char(Class, C).

eyeprolog__class_spec_char([Low,'-',High|_], C) :-
    char_code(Low, LowCode), char_code(High, HighCode), char_code(C, Code),
    Code >= LowCode, Code =< HighCode.
eyeprolog__class_spec_char([X|_], X).
eyeprolog__class_spec_char([_,_,_|Rest], C) :- eyeprolog__class_spec_char(Rest, C).
eyeprolog__class_spec_char([_|Rest], C) :- eyeprolog__class_spec_char(Rest, C).

eyeprolog__captures_context([capture(Name,Value)], Term) :- Term =.. [Name, Value].
eyeprolog__captures_context([capture(Name,Value)|Rest], (Term,Context)) :-
    Rest \= [],
    Term =.. [Name, Value],
    eyeprolog__captures_context(Rest, Context).

% ---------- text/list processing ----------

append([], Ys, Ys).
append([X|Xs], Ys, [X|Zs]) :- append(Xs, Ys, Zs).

string_concat(A, B, Whole) :-
    nonvar(A), nonvar(B),
    !,
    eyeprolog__text_chars(A, AC),
    eyeprolog__text_chars(B, BC),
    append(AC, BC, WC),
    eyeprolog__text_chars(Whole, WC).
string_concat(A, B, Whole) :-
    nonvar(Whole),
    eyeprolog__text_chars(Whole, WC),
    append(AC, BC, WC),
    eyeprolog__text_chars(A, AC),
    eyeprolog__text_chars(B, BC).

contains(Text, Needle) :-
    eyeprolog__text_chars(Text, TextChars),
    eyeprolog__text_chars(Needle, NeedleChars),
    append(_, Tail, TextChars),
    append(NeedleChars, _, Tail),
    !.

matches(Text, Pattern) :-
    split(Pattern, '|', Alternatives),
    member(Needle, Alternatives),
    contains(Text, Needle),
    !.

split(Text, Separator, Parts) :-
    eyeprolog__text_chars(Text, TextChars),
    eyeprolog__text_chars(Separator, SeparatorChars),
    eyeprolog__split_chars(TextChars, SeparatorChars, PartChars),
    eyeprolog__parts_text(PartChars, Parts).

eyeprolog__split_chars(Chars, [], Parts) :- eyeprolog__split_each_char(Chars, Parts).
eyeprolog__split_chars(Chars, Separator, [Prefix|Parts]) :-
    Separator \= [],
    append(Prefix, Tail, Chars),
    append(Separator, Rest, Tail),
    !,
    eyeprolog__split_chars(Rest, Separator, Parts).
eyeprolog__split_chars(Chars, Separator, [Chars]) :- Separator \= [].

eyeprolog__split_each_char([], []).
eyeprolog__split_each_char([C|Cs], [[C]|Rest]) :- eyeprolog__split_each_char(Cs, Rest).

eyeprolog__parts_text([], []).
eyeprolog__parts_text([Chars|Rest], [Text|Texts]) :-
    eyeprolog__text_chars(Text, Chars),
    eyeprolog__parts_text(Rest, Texts).

replace(Text, Search, Replacement, Out) :-
    eyeprolog__text_chars(Search, SearchChars),
    ( SearchChars = [] -> Out = Text
    ; split(Text, Search, Parts), join(Parts, Replacement, Out)
    ).

lowercase(Text, Lower) :-
    eyeprolog__text_chars(Text, Chars),
    eyeprolog__lower_chars(Chars, LowerChars),
    eyeprolog__text_chars(Lower, LowerChars).

eyeprolog__lower_chars([], []).
eyeprolog__lower_chars([C|Cs], [L|Ls]) :-
    char_code(C, Code),
    eyeprolog__lower_code(Code, LowerCode),
    char_code(L, LowerCode),
    eyeprolog__lower_chars(Cs, Ls).

eyeprolog__lower_code(Code, Lower) :- Code >= 65, Code =< 90, Lower is Code + 32.
eyeprolog__lower_code(Code, Code) :- (Code < 65 ; Code > 90).

uppercase(Text, Upper) :-
    eyeprolog__text_chars(Text, Chars),
    eyeprolog__upper_chars(Chars, UpperChars),
    eyeprolog__text_chars(Upper, UpperChars).

eyeprolog__upper_chars([], []).
eyeprolog__upper_chars([C|Cs], [U|Us]) :-
    char_code(C, Code),
    eyeprolog__upper_code(Code, UpperCode),
    char_code(U, UpperCode),
    eyeprolog__upper_chars(Cs, Us).

eyeprolog__upper_code(Code, Upper) :- Code >= 97, Code =< 122, Upper is Code - 32.
eyeprolog__upper_code(Code, Code) :- (Code < 97 ; Code > 122).

trim(Text, Trimmed) :-
    eyeprolog__text_chars(Text, Chars),
    eyeprolog__drop_space(Chars, Left),
    reverse(Left, Reversed),
    eyeprolog__drop_space(Reversed, RightReversed),
    reverse(RightReversed, TrimmedChars),
    eyeprolog__text_chars(Trimmed, TrimmedChars).

eyeprolog__drop_space([C|Cs], Out) :-
    char_code(C, Code), eyeprolog__space_code(Code), !,
    eyeprolog__drop_space(Cs, Out).
eyeprolog__drop_space(Chars, Chars).

eyeprolog__space_code(9).
eyeprolog__space_code(10).
eyeprolog__space_code(11).
eyeprolog__space_code(12).
eyeprolog__space_code(13).
eyeprolog__space_code(32).

number_string(Number, Text) :-
    number(Number),
    number_chars(Number, Chars),
    eyeprolog__text_chars(Text, Chars).
number_string(Number, Text) :-
    var(Number),
    eyeprolog__text_chars(Text, Chars),
    catch(number_chars(Number, Chars), _, fail).

atom_string(Atom, Text) :-
    atom(Atom),
    atom_chars(Atom, Chars),
    eyeprolog__text_chars(Text, Chars).
atom_string(Atom, Text) :-
    var(Atom),
    nonvar(Text),
    eyeprolog__atomic_chars(Text, Chars),
    atom_chars(Atom, Chars).

term_string(Term, Text) :-
    nonvar(Term),
    eyeprolog__term_chars(Term, Chars),
    eyeprolog__text_chars(Text, Chars).

eyeprolog__term_chars(Term, Chars) :- number(Term), number_chars(Term, Chars).
eyeprolog__term_chars(Term, Chars) :- atom(Term), atom_chars(Term, Chars).
eyeprolog__term_chars([], ['[',']']).
eyeprolog__term_chars([H|T], Chars) :-
    eyeprolog__list_term_chars([H|T], Body),
    append(['['|Body], [']'], Chars).
eyeprolog__term_chars(Term, Chars) :-
    compound(Term),
    Term \= [_|_],
    Term =.. [Name|Args],
    atom_chars(Name, NameChars),
    eyeprolog__term_args_chars(Args, ArgsChars),
    append(NameChars, ['('|ArgsChars], A),
    append(A, [')'], Chars).

eyeprolog__list_term_chars([H], Chars) :-
    eyeprolog__term_chars(H, Chars).
eyeprolog__list_term_chars([H|T], Chars) :-
    T = [_|_],
    eyeprolog__term_chars(H, HC),
    eyeprolog__list_term_chars(T, TC),
    append(HC, [',',' '|TC], Chars).
eyeprolog__list_term_chars([H|T], Chars) :-
    T \= [], T \= [_|_],
    eyeprolog__term_chars(H, HC),
    eyeprolog__term_chars(T, TC),
    append(HC, [' ','|',' '|TC], Chars).

eyeprolog__term_args_chars([A], Chars) :- eyeprolog__term_chars(A, Chars).
eyeprolog__term_args_chars([A|As], Chars) :-
    As \= [],
    eyeprolog__term_chars(A, AC),
    eyeprolog__term_args_chars(As, Rest),
    append(AC, [',',' '|Rest], Chars).

join([], _, Out) :- eyeprolog__text_chars(Out, []).
join([Item|Items], Separator, Out) :-
    eyeprolog__atomic_chars(Item, ItemChars),
    eyeprolog__text_chars(Separator, SeparatorChars),
    eyeprolog__join_chars(Items, SeparatorChars, ItemChars, Chars),
    eyeprolog__text_chars(Out, Chars).

eyeprolog__join_chars([], _, Chars, Chars).
eyeprolog__join_chars([Item|Items], Separator, Prefix, Out) :-
    eyeprolog__atomic_chars(Item, ItemChars),
    append(Prefix, Separator, A),
    append(A, ItemChars, B),
    eyeprolog__join_chars(Items, Separator, B, Out).

substring(Text, Start, Count, Out) :-
    integer(Start), integer(Count), Start >= 0, Count >= 0,
    eyeprolog__text_chars(Text, Chars),
    drop(Start, Chars, Tail),
    take(Count, Tail, Slice),
    eyeprolog__text_chars(Out, Slice).

% ---------- list relations ----------

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

set_nth0(0, [_|Xs], X, [X|Xs]).
set_nth0(N, [Y|Ys], X, [Y|Zs]) :- N > 0, N1 is N - 1, set_nth0(N1, Ys, X, Zs).

take(0, _, []).
take(N, [X|Xs], [X|Ys]) :- N > 0, N1 is N - 1, take(N1, Xs, Ys).

drop(0, Xs, Xs).
drop(N, [_|Xs], Ys) :- N > 0, N1 is N - 1, drop(N1, Xs, Ys).

slice(Start, Count, List, Slice) :- drop(Start, List, Tail), take(Count, Tail, Slice).

reverse(List, Reversed) :- eyeprolog__reverse(List, [], Reversed).
eyeprolog__reverse([], Acc, Acc).
eyeprolog__reverse([X|Xs], Acc, Out) :- eyeprolog__reverse(Xs, [X|Acc], Out).

length(List, Length) :- nonvar(List), eyeprolog__length_count(List, 0, Length).
length(List, Length) :- var(List), integer(Length), Length >= 0, eyeprolog__length_make(Length, List).

eyeprolog__length_count([], N, N).
eyeprolog__length_count([_|Xs], N0, N) :- N1 is N0 + 1, eyeprolog__length_count(Xs, N1, N).
eyeprolog__length_make(0, []).
eyeprolog__length_make(N, [_|Xs]) :- N > 0, N1 is N - 1, eyeprolog__length_make(N1, Xs).

sum_list(List, Sum) :- eyeprolog__sum_list(List, 0, Sum).
eyeprolog__sum_list([], Sum, Sum).
eyeprolog__sum_list([X|Xs], Acc, Sum) :- Next is Acc + X, eyeprolog__sum_list(Xs, Next, Sum).

min_list([X|Xs], Min) :- eyeprolog__min_list(Xs, X, Min).
eyeprolog__min_list([], Min, Min).
eyeprolog__min_list([X|Xs], Current, Min) :- X @< Current, eyeprolog__min_list(Xs, X, Min).
eyeprolog__min_list([X|Xs], Current, Min) :- X @>= Current, eyeprolog__min_list(Xs, Current, Min).

max_list([X|Xs], Max) :- eyeprolog__max_list(Xs, X, Max).
eyeprolog__max_list([], Max, Max).
eyeprolog__max_list([X|Xs], Current, Max) :- X @> Current, eyeprolog__max_list(Xs, X, Max).
eyeprolog__max_list([X|Xs], Current, Max) :- X @=< Current, eyeprolog__max_list(Xs, Current, Max).

list_to_set(List, Set) :- eyeprolog__list_to_set(List, [], Set).
eyeprolog__list_to_set([], _, []).
eyeprolog__list_to_set([X|Xs], Seen, Set) :-
    eyeprolog__identical_member(X, Seen),
    eyeprolog__list_to_set(Xs, Seen, Set).
eyeprolog__list_to_set([X|Xs], Seen, [X|Set]) :-
    \+ eyeprolog__identical_member(X, Seen),
    eyeprolog__list_to_set(Xs, [X|Seen], Set).

eyeprolog__identical_member(X, [Y|_]) :- X == Y.
eyeprolog__identical_member(X, [_|Ys]) :- eyeprolog__identical_member(X, Ys).

sort(List, Sorted) :- eyeprolog__sort(List, [], Sorted).
eyeprolog__sort([], Sorted, Sorted).
eyeprolog__sort([X|Xs], Acc, Sorted) :-
    eyeprolog__insert_sorted(X, Acc, Next),
    eyeprolog__sort(Xs, Next, Sorted).

eyeprolog__insert_sorted(X, [], [X]).
eyeprolog__insert_sorted(X, [Y|Ys], [Y|Ys]) :- X == Y.
eyeprolog__insert_sorted(X, [Y|Ys], [X,Y|Ys]) :- X @< Y.
eyeprolog__insert_sorted(X, [Y|Ys], [Y|Zs]) :- X @> Y, eyeprolog__insert_sorted(X, Ys, Zs).

% ---------- aggregation ----------

countall(Goal, Count) :- findall(1, Goal, Ones), length(Ones, Count).

sumall(Expression, Goal, Sum) :-
    findall(Value, (Goal, Value is Expression), Values),
    sum_list(Values, Sum).

aggregate_min(Key, Value, Goal, BestKey, BestValue) :-
    findall(pair(Key, Value), Goal, Pairs),
    eyeprolog__aggregate_min(Pairs, BestKey, BestValue).

eyeprolog__aggregate_min([pair(K,V)|Pairs], BestKey, BestValue) :-
    eyeprolog__aggregate_min_rest(Pairs, K, V, BestKey, BestValue).
eyeprolog__aggregate_min_rest([], K, V, K, V).
eyeprolog__aggregate_min_rest([pair(K,V)|Pairs], CK, CV, BK, BV) :-
    K @< CK,
    eyeprolog__aggregate_min_rest(Pairs, K, V, BK, BV).
eyeprolog__aggregate_min_rest([pair(K,_)|Pairs], CK, CV, BK, BV) :-
    K @>= CK,
    eyeprolog__aggregate_min_rest(Pairs, CK, CV, BK, BV).

aggregate_max(Key, Value, Goal, BestKey, BestValue) :-
    findall(pair(Key, Value), Goal, Pairs),
    eyeprolog__aggregate_max(Pairs, BestKey, BestValue).

eyeprolog__aggregate_max([pair(K,V)|Pairs], BestKey, BestValue) :-
    eyeprolog__aggregate_max_rest(Pairs, K, V, BestKey, BestValue).
eyeprolog__aggregate_max_rest([], K, V, K, V).
eyeprolog__aggregate_max_rest([pair(K,V)|Pairs], CK, CV, BK, BV) :-
    K @> CK,
    eyeprolog__aggregate_max_rest(Pairs, K, V, BK, BV).
eyeprolog__aggregate_max_rest([pair(K,_)|Pairs], CK, CV, BK, BV) :-
    K @=< CK,
    eyeprolog__aggregate_max_rest(Pairs, CK, CV, BK, BV).
