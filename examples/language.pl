% Eyepl language-identity example.
%
% This file intentionally uses the modern Eyepl surface syntax:
%   - `.pl` source files instead of Prolog `.pl` files
%   - ISO Prolog-style uppercase variables
%   - automatic tabling for recursive predicates
%   - advisory `mode/3` and `semidet/2` declarations
%   - quoted angle-bracket atoms for web-shaped identifiers
%
% The declarations below are ordinary facts as well as metadata for tooling.
% They do not change the answers of the program.

%% goal: path(X0, X1)


mode(edge, 2, [in, out]).
mode(path, 2, [in, out]).
semidet(edge, 2).

edge('<urn:example:a>', '<urn:example:b>').
edge('<urn:example:b>', '<urn:example:c>').
edge('<urn:example:c>', '<urn:example:d>').

path(X, Y) :- edge(X, Y).
path(X, Z) :- edge(X, Y), path(Y, Z).
