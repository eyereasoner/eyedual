% Risk-adjusted route selection adapted from Eyeling dijkstra-risk-path.n3.
%
% The score is raw delivery cost plus ten times accumulated risk.  Candidate
% routes are fixed path lists, while route_cost/4 reduces each list to raw cost,
% risk, and edge count.  Memoization lets selected-path, scoring, and trust-gate
% relations reuse those reductions.
%% goal: route(X0, X1)

%% goal: rawCost(X0, X1)

%% goal: riskSum(X0, X1)

%% goal: score(X0, X1)

%% goal: edgeCount(X0, X1)

%% goal: selectedPath(X0, X1)

%% goal: trustGate(X0, X1)

%% goal: notes(X0, X1)

%% goal: selects(X0, X1)


% Cache route-list reductions because several queried reports ask for the same metrics.

% Segments live in a quoted formula term, while candidate paths remain ordinary lists.
route_network(riskNetwork, (
  segment(depotA, segment(depotB, 4.0, 0.2)),
  segment(depotB, segment(labD, 4.0, 0.3)),
  segment(depotA, segment(depotC, 3.0, 0.9)),
  segment(depotC, segment(labD, 6.0, 0.3)),
  segment(depotC, segment(depotB, 0.5, 0.5)),
  segment(depotB, segment(depotC, 1.0, 0.5)),
  segment(depotA, segment(relay, 5.0, 0.2)),
  segment(relay, segment(labD, 5.0, 0.2)),
  segment(depotA, segment(labD, 14.0, 0.05))
)).

context_member((Left, _right), Member) :- context_member(Left, Member).
context_member((_left, Right), Member) :- context_member(Right, Member).
context_member(Member, Member) :- Member \= (_left, _right).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
route_segment(From, To, Raw, Risk) :-
  route_network(riskNetwork, Context),
  context_member(Context, segment(From, segment(To, Raw, Risk))).

candidate(pathB, [depotA, depotB, labD]).
candidate(pathC, [depotA, depotC, labD]).
candidate(pathRelay, [depotA, relay, labD]).
candidate(pathDirectC, [depotA, labD]).
candidate(pathViaC, [depotA, depotC, depotB, labD]).

route_cost([_], 0.0, 0.0, 0).
route_cost([From, To|Rest], Raw, Risk, Edges) :-
  route_segment(From, To, Stepraw, Steprisk),
  route_cost([To|Rest], Restraw, Restrisk, Restedges),
  (Raw is Stepraw + Restraw),
  (Risk is Steprisk + Restrisk),
  (Edges is 1 + Restedges).

score(Raw, Risk, Score) :-
  (Penalty is Risk * 10.0),
  (Score is Raw + Penalty).

path_metrics(Path, Route, Raw, Risk, Score, Edges) :-
  candidate(Path, Route),
  route_cost(Route, Raw, Risk, Edges),
  score(Raw, Risk, Score).

% Pick the known winner by comparing its score with every other candidate.
best_path(pathB) :-
  path_metrics(pathB, _bestroute, _bestraw, _bestrisk, Bestscore, _bestedges),
  path_metrics(pathC, _croute, _craw, _crisk, Cscore, _cedges),
  path_metrics(pathRelay, _rroute, _rraw, _rrisk, Relayscore, _redges),
  path_metrics(pathDirectC, _droute, _draw, _drisk, Directscore, _dedges),
  path_metrics(pathViaC, _vroute, _vraw, _vrisk, Viascore, _vedges),
  (Bestscore < Cscore),
  (Bestscore < Relayscore),
  (Bestscore < Directscore),
  (Bestscore < Viascore).

risk_outweighs_raw_cost(true) :-
  path_metrics(pathB, _br, Bestraw, _brs, Bestscore, _be),
  path_metrics(pathViaC, _vr, Viaraw, _vrs, Viascore, _ve),
  (Viaraw < Bestraw),
  (Bestscore < Viascore).

route(Path, Route) :- path_metrics(Path, Route, _raw, _risk, _score, _edges).
rawCost(Path, Raw) :- path_metrics(Path, _route, Raw, _risk, _score, _edges).
riskSum(Path, Risk) :- path_metrics(Path, _route, _raw, Risk, _score, _edges).
score(Path, Score) :- path_metrics(Path, _route, _raw, _risk, Score, _edges).
edgeCount(Path, Edges) :- path_metrics(Path, _route, _raw, _risk, _score, Edges).
selectedPath(case, Path) :- best_path(Path).
trustGate(case, noEnumeratedPathIsLower) :- best_path(_path).
notes(case, riskCanOutweighRawCost) :- risk_outweighs_raw_cost(true).
selects(dijkstraRiskPath, Path) :- best_path(Path), risk_outweighs_raw_cost(true).
