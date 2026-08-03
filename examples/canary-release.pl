% Technology example: canary release decision.
%
% A canary deployment is rolled back when its measured error rate exceeds the
% allowed budget, even when latency is still acceptable.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: errorRate(X0, X1)

%% goal: p95Latency_ms(X0, X1)

%% goal: latencyCheck(X0, X1)

%% goal: status(X0, X1)

%% goal: reason(X0, X1)


% canary/4 records request count, error count, and p95 latency; thresholds
% make the rollout policy explicit data rather than constants hidden in rules.
canary(canary42, 5000.0, 75.0, 180.0).
threshold(canary42, maximum_error_rate, 0.01).
threshold(canary42, maximum_p95_latency_ms, 200.0).

% The latency and error-budget checks are independent so the final rollback
% reason can point to the failing guard.
error_rate(Release, Rate) :-
  canary(Release, Requests, Errors, _p95latency),
  (Rate is Errors / Requests).

latency_ok(Release) :-
  canary(Release, _requests, _errors, P95latency),
  threshold(Release, maximum_p95_latency_ms, Maximum),
  (P95latency < Maximum).

error_budget_exceeded(Release) :-
  error_rate(Release, Rate),
  threshold(Release, maximum_error_rate, Maximum),
  (Rate > Maximum).

rollback_recommended(Release) :-
  error_budget_exceeded(Release).

errorRate(Release, Rate) :-
  error_rate(Release, Rate).

p95Latency_ms(Release, P95latency) :-
  canary(Release, _requests, _errors, P95latency).

latencyCheck(Release, ok) :-
  latency_ok(Release).

status(Release, rollback_recommended) :-
  rollback_recommended(Release).

reason(Release, "canary error rate exceeds the allowed budget") :-
  rollback_recommended(Release).
