% Transitive graph paths over a small map of French cities.
%
% The base relation is directed: oneway(A, B) means there is a road from A
% to B.  The derived relation path(A, B) is the transitive closure: B is
% reachable from A by one or more directed legs.
%
% The recursive rule is written in a productive, right-recursive form:
%
%     path(A, C) :- oneway(A, B), path(B, C).
%
% That order matters in a goal-directed reasoner.  A left-recursive closure
% rule such as `path(A, C) :- path(A, B), path(B, C).` starts by asking for
% the same open relation it is currently proving, so eyeprolog's recursion guard
% must stop it to avoid an infinite loop.  The result is under-generation: only
% direct edges are printed.  Starting with the concrete generator `oneway/2`
% first makes each recursive step smaller and yields the complete closure.

%% goal: path(X0, X1)


oneway(paris, orleans).
oneway(paris, chartres).
oneway(paris, amiens).
oneway(orleans, blois).
oneway(orleans, bourges).
oneway(blois, tours).
oneway(chartres, lemans).
oneway(lemans, angers).
oneway(lemans, tours).
oneway(angers, nantes).

path(A, B) :-
    oneway(A, B).
path(A, C) :-
    oneway(A, B),
    path(B, C).
