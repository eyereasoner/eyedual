% GPS route-planning example translated from Eyeling's gps.n3.
% The map is stored as quoted formula data and projected with holds/3.  Route
% paths accumulate action sequence, duration, cost, belief, and comfort; table
% keeps repeated comparison and explanation queries from recomputing paths.

query(recommendedRoute(X0, X1)).
query(outcome(X0, X1)).
query(statement(X0, X1, X2)).
query(label(X0, X1)).
query(actionSequence(X0, X1)).
query(durationSeconds(X0, X1)).
query(cost(X0, X1)).
query(belief(X0, X1)).
query(comfort(X0, X1)).
query(selectedRoute(X0, X1)).
query(comparison(X0, X1)).


case_graph(caseGraph, (
  location(i1, gent),
  text(question, "Which route should we take from Gent to Oostende?"),
  label(routeDirect, "Gent -> Brugge -> Oostende"),
  label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")
)).

map_graph(mapBE, (
  gps_description(mapBE, description(location(S, gent), true, location(S, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)),
  gps_description(mapBE, description(location(S, gent), true, location(S, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)),
  gps_description(mapBE, description(location(S, kortrijk), true, location(S, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)),
  gps_description(mapBE, description(location(S, brugge), true, location(S, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))
)).

case_statement(S, P, O) :-
  case_graph(caseGraph, Context),
  holds(Context, P, [S, O]).

map_description(From, To, Action, Duration, Cost, Belief, Comfort) :-
  map_graph(mapBE, Context),
  holds(Context, gps_description(mapBE, description(From, true, To, Action, Duration, Cost, Belief, Comfort))).

path(From, To, [Action], Duration, Cost, Belief, Comfort) :-
  map_description(From, To, Action, Duration, Cost, Belief, Comfort).

path(From, To, Actions, Duration, Cost, Belief, Comfort) :-
  map_description(From, Mid, Action, D1, C1, B1, F1),
  path(Mid, To, Restactions, D2, C2, B2, F2),
  append([Action], Restactions, Actions),
  (Duration is D1 + D2),
  (Cost is C1 + C2),
  (Belief is B1 * B2),
  (Comfort is F1 * F2).

traveller_start(i1, location(i1, gent)).
traveller_goal(i1, location(i1, oostende)).

traveller_path(Traveller, Actions, Duration, Cost, Belief, Comfort) :-
  traveller_start(Traveller, From),
  traveller_goal(Traveller, To),
  path(From, To, Actions, Duration, Cost, Belief, Comfort).

route_metrics(routeDirect, Duration, Cost, Belief, Comfort) :-
  traveller_path(i1, [drive_gent_brugge, drive_brugge_oostende], Duration, Cost, Belief, Comfort).

route_metrics(routeViaKortrijk, Duration, Cost, Belief, Comfort) :-
  traveller_path(i1, [drive_gent_kortrijk, drive_kortrijk_brugge, drive_brugge_oostende], Duration, Cost, Belief, Comfort).

recommended_route(routeDirect) :-
  route_metrics(routeDirect, Directduration, Directcost, Directbelief, Directcomfort),
  route_metrics(routeViaKortrijk, Viaduration, Viacost, Viabelief, Viacomfort),
  (Directduration < Viaduration),
  (Directcost < Viacost),
  (Directbelief > Viabelief),
  (Directcomfort > Viacomfort).

outcome(routeDirect, "Take the direct route via Brugge.").

% Verification checks, analogous to the false-producing guards in gps.n3.
check(c1, true) :-
  traveller_path(i1, [drive_gent_brugge, drive_brugge_oostende], _, _, _, _).

check(c2, true) :-
  traveller_path(i1, [drive_gent_kortrijk, drive_kortrijk_brugge, drive_brugge_oostende], _, _, _, _).

check(c3, true) :-
  route_metrics(routeDirect, D1, _, _, _),
  route_metrics(routeViaKortrijk, D2, _, _, _),
  (D1 < D2).

check(c4, true) :-
  route_metrics(routeDirect, _, C1, _, _),
  route_metrics(routeViaKortrijk, _, C2, _, _),
  (C1 < C2).

check(c5, true) :-
  route_metrics(routeDirect, _, _, B1, F1),
  route_metrics(routeViaKortrijk, _, _, B2, F2),
  (B1 > B2),
  (F1 > F2).

recommendedRoute(decision, Route) :-
  recommended_route(Route).

outcome(decision, Outcome) :-
  recommended_route(Route),
  outcome(Route, Outcome).

statement(check, Check, true) :-
  check(Check, true).

route_actions(routeDirect, [drive_gent_brugge, drive_brugge_oostende]).
route_actions(routeViaKortrijk, [drive_gent_kortrijk, drive_kortrijk_brugge, drive_brugge_oostende]).

% Derived route and report relations.  These are consequences of the route search
% and comparison, not pre-written markdown output.
label(Route, Label) :-
  case_statement(Route, label, Label),
  route_metrics(Route, _duration, _cost, _belief, _comfort).

actionSequence(Route, Actions) :-
  route_actions(Route, Actions),
  route_metrics(Route, _duration, _cost, _belief, _comfort).

durationSeconds(Route, Duration) :-
  route_metrics(Route, Duration, _cost, _belief, _comfort).

cost(Route, Cost) :-
  route_metrics(Route, _duration, Cost, _belief, _comfort).

belief(Route, Belief) :-
  route_metrics(Route, _duration, _cost, Belief, _comfort).

comfort(Route, Comfort) :-
  route_metrics(Route, _duration, _cost, _belief, Comfort).

selectedRoute(report, route(Route, Actions, Duration, Cost, Belief, Comfort)) :-
  recommended_route(Route),
  route_actions(Route, Actions),
  route_metrics(Route, Duration, Cost, Belief, Comfort).

comparison(report, dominates(routeDirect, routeViaKortrijk)) :-
  recommended_route(routeDirect),
  check(c3, true),
  check(c4, true),
  check(c5, true).
