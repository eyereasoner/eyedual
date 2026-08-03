% Practical cyclic recursion: incident impact analysis for a service dependency graph.
% The payment stack has a real-world feedback cycle: payment_service calls
% fraud_service, fraud_service calls risk_rules, and risk_rules calls payment_service
% for authorization data. A payment outage should still produce a finite impact set.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: impactedByFailureOf(X0, X1)

%% goal: status(X0, X1)

%% goal: businessFunctionAtRisk(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
depends_on(web_store, checkout_api).
depends_on(mobile_app, checkout_api).
depends_on(checkout_api, payment_service).
depends_on(checkout_api, inventory_service).
depends_on(payment_service, fraud_service).
depends_on(fraud_service, risk_rules).
depends_on(risk_rules, payment_service).
depends_on(inventory_service, stock_db).
depends_on(stock_db, inventory_service).

business_function(place_order, web_store).
business_function(mobile_checkout, mobile_app).
business_function(collect_payment, payment_service).
business_function(screen_fraud, fraud_service).
business_function(show_stock, inventory_service).

failed(payment_service).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
impacted(Service, Failed) :- depends_on(Service, Failed).
impacted(Service, Failed) :- depends_on(Service, Dependency), impacted(Dependency, Failed).

affected(Service) :- failed(Failed), impacted(Service, Failed).
affected(Service) :- failed(Service).

affected_function(Function) :- business_function(Function, Service), affected(Service).

impactedByFailureOf(Service, Failed) :- failed(Failed), impacted(Service, Failed).
status(Service, failed) :- failed(Service).
businessFunctionAtRisk(Function, true) :- affected_function(Function).
