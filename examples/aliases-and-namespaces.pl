% Built-ins use one native spelling each, while vocabulary-style predicate names
% remain ordinary user predicates.
%
% This keeps the language small: add/3, lt/2, matches/3, and rest/2 are native
% operations, but labels such as nativeMath or vocabularyExample are just data.
%% goal: value(X0, X1)

%% goal: ok(X0, X1)

%% goal: tail(X0, X1)

%% goal: label(X0, X1)


% The first four rules call native built-ins; the last two rules show that
% application vocabulary is modeled with ordinary facts and rules.
value(nativeMath, X) :- (X is 0.125 + 0.875).
ok(nativeCompare, true) :- (2 < 3).
ok(nativeString, true) :- matches("scoped retail insight", "retail|medical").
tail(nativeList, Tail) :- rest([a, b, c], Tail).

% These names are just user data; eyedual does not give them special meaning.
example_label(vocabularyExample, "vocabulary names are ordinary predicate names").
label(vocabularyExample, Text) :- example_label(vocabularyExample, Text).
