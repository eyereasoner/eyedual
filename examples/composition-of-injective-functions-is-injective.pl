% Composition of injective functions is injective, adapted from Eyeling's
% examples/composition-of-injective-functions-is-injective.n3.
%
% The output mirrors the Eyeling golden result shape:
% sameInputByCompositeInjectivity(h, a, b) and the symmetric counterpart.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: sameInputByCompositeInjectivity(X0, X1, X2)


:- discontiguous(app/3).
:- discontiguous(sameTerm/2).

% Program structure: facts set up the scenario, and rules derive the queried conclusions.
inX(a).
inX(b).
inY(c).
inY(d).
inZ(e).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
sameTerm(X, X) :- inX(X).
sameTerm(X, X) :- inY(X).
sameTerm(X, X) :- inZ(X).
sameTerm(Y, X) :- Y @< X, sameTerm(X, Y).

app(f, a, c).
app(f, b, d).
app(g, c, e).
app(g, d, e).

injective(f).
injective(g).
compositeOf(h, g, f).

app(H, X, Z) :-
  compositeOf(H, G, F),
  app(F, X, Y),
  app(G, Y, Z).

sameTerm(X, Y) :-
  injective(F),
  app(F, X, U),
  app(F, Y, V),
  sameTerm(U, V).

sameInputByCompositeInjectivity(H, X, Y) :-
  compositeOf(H, G, F),
  injective(G),
  injective(F),
  app(H, X, Z),
  app(H, Y, Z),
  sameTerm(X, Y),
  (X \= Y).
