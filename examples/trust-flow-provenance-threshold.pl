% Provenance-derived trust-flow thresholding in EyeProlog.
%
% Each message combines publisher trust, signature strength, and transform quality
% into one confidence score.  Receiver-specific thresholds then classify messages
% as accepted or quarantined and derive status/risk facts.
%
% The multiplication chain is intentionally explicit so proof output shows how a
% provenance trail becomes a single trust decision.

%% goal: confidence(X0, X1)

%% goal: trust_flow_state(X0, X1)

%% goal: status(X0, X1)

%% goal: risk(X0, X1)


message(message_a, publisher_a, transform_a, signature_a, receiver_app).
message(message_b, publisher_b, transform_b, signature_b, receiver_app).

publisher_trust(publisher_a, 0.95).
publisher_trust(publisher_b, 0.70).
signature_strength(signature_a, 0.98).
signature_strength(signature_b, 0.75).
quality_score(transform_a, 0.96).
quality_score(transform_b, 0.80).
acceptance_threshold(receiver_app, 0.85).

confidence(Message, Confidence) :-
  message(Message, Publisher, Transform, Signature, _receiver),
  publisher_trust(Publisher, Publishertrust),
  signature_strength(Signature, Signaturetrust),
  quality_score(Transform, Quality),
  (A is Publishertrust * Signaturetrust),
  (Confidence is A * Quality).

trust_flow_state(Message, fpv_accepted) :-
  message(Message, _publisher, _transform, _signature, Receiver),
  confidence(Message, Confidence),
  acceptance_threshold(Receiver, Threshold),
  (Confidence >= Threshold).

trust_flow_state(Message, fpv_quarantine) :-
  message(Message, _publisher, _transform, _signature, Receiver),
  confidence(Message, Confidence),
  acceptance_threshold(Receiver, Threshold),
  (Confidence < Threshold).

status(Message, fpv_high_trust_flow) :- trust_flow_state(Message, fpv_accepted).
risk(Message, risk_low_trust_data_source) :- trust_flow_state(Message, fpv_quarantine).
