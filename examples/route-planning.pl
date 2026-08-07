% Route planning with explicit route terms.
%
% This is the EyeProlog version of the classic Paris-to-Nantes path example: the
% facts describe one-way road links, and `path/2` derives both the endpoint pair
% and a structured `go(..., ..., ...)` plan.  The plan is ordinary data, so the
% route can be inspected, stored, or used by later rules.

%% goal: route_to_nantes(X0, X1)

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

% A direct edge is a one-step plan.
path([A, B], go(A, B, goal)) :-
  oneway(A, B).

% A longer path prepends one edge to the remaining plan.
path([A, C], go(A, B, Rest)) :-
  oneway(A, B),
  path([B, C], Rest).

route_to_nantes(From, Plan) :-
  path([From, nantes], Plan).
