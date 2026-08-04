% socket-family.pl
%
% A small runnable eyedual Socket example.
%
% The socket facts below are ordinary eyedual data. They document the
% semantic opening: this reasoning module expects a provider for parent/2.
% The plug fact says which provider is connected.
%
% Run:
%   eyedual socket-family.pl

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: ancestor(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
socket(family_source, provides(parent_2)).
plug(family_file, family_source).

parent(pat, jan).
parent(jan, emma).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
ancestor(X, Y) :-
    parent(X, Y).

ancestor(X, Z) :-
    parent(X, Y),
    ancestor(Y, Z).
