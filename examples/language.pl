% EyeProlog language-identity example.
%
% This file intentionally uses the modern EyeProlog surface syntax:
%   - `.pl` source files instead of Prolog `.pl` files
%   - ISO Prolog-style uppercase variables
%   - automatic tabling for recursive predicates
%   - quoted angle-bracket atoms for web-shaped identifiers

%% goal: path(X0, X1)

edge('<urn:example:a>', '<urn:example:b>').
edge('<urn:example:b>', '<urn:example:c>').
edge('<urn:example:c>', '<urn:example:d>').

path(X, Y) :- edge(X, Y).
path(X, Z) :- edge(X, Y), path(Y, Z).
