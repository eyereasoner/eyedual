confidence(message_a, 0.89375999999999989).
why(
  confidence(message_a, 0.89375999999999989),
  proof(
    goal(confidence(message_a, 0.89375999999999989)),
    by(rule("trust-flow-provenance-threshold.pl", clause(10))),
    bindings([binding("Message", message_a), binding("Confidence", 0.89375999999999989), binding("Publisher", publisher_a), binding("Transform", transform_a), binding("Signature", signature_a), binding("_receiver", receiver_app), binding("Publishertrust", 0.95), binding("Signaturetrust", 0.98), binding("Quality", 0.96), binding("A", 0.93099999999999994)]),
    uses([
      proof(
        goal(message(message_a, publisher_a, transform_a, signature_a, receiver_app)),
        by(fact("trust-flow-provenance-threshold.pl", clause(1)))
      ),
      proof(
        goal(publisher_trust(publisher_a, 0.95)),
        by(fact("trust-flow-provenance-threshold.pl", clause(3)))
      ),
      proof(
        goal(signature_strength(signature_a, 0.98)),
        by(fact("trust-flow-provenance-threshold.pl", clause(5)))
      ),
      proof(
        goal(quality_score(transform_a, 0.96)),
        by(fact("trust-flow-provenance-threshold.pl", clause(7)))
      ),
      proof(
        goal(is(0.93099999999999994, *(0.95, 0.98))),
        by(builtin(is, 2))
      ),
      proof(
        goal(is(0.89375999999999989, *(0.93099999999999994, 0.96))),
        by(builtin(is, 2))
      )
    ])
  )
).

confidence(message_b, 0.41999999999999993).
why(
  confidence(message_b, 0.41999999999999993),
  proof(
    goal(confidence(message_b, 0.41999999999999993)),
    by(rule("trust-flow-provenance-threshold.pl", clause(10))),
    bindings([binding("Message", message_b), binding("Confidence", 0.41999999999999993), binding("Publisher", publisher_b), binding("Transform", transform_b), binding("Signature", signature_b), binding("_receiver", receiver_app), binding("Publishertrust", 0.70), binding("Signaturetrust", 0.75), binding("Quality", 0.80), binding("A", 0.52499999999999991)]),
    uses([
      proof(
        goal(message(message_b, publisher_b, transform_b, signature_b, receiver_app)),
        by(fact("trust-flow-provenance-threshold.pl", clause(2)))
      ),
      proof(
        goal(publisher_trust(publisher_b, 0.70)),
        by(fact("trust-flow-provenance-threshold.pl", clause(4)))
      ),
      proof(
        goal(signature_strength(signature_b, 0.75)),
        by(fact("trust-flow-provenance-threshold.pl", clause(6)))
      ),
      proof(
        goal(quality_score(transform_b, 0.80)),
        by(fact("trust-flow-provenance-threshold.pl", clause(8)))
      ),
      proof(
        goal(is(0.52499999999999991, *(0.70, 0.75))),
        by(builtin(is, 2))
      ),
      proof(
        goal(is(0.41999999999999993, *(0.52499999999999991, 0.80))),
        by(builtin(is, 2))
      )
    ])
  )
).

trust_flow_state(message_a, fpv_accepted).
why(
  trust_flow_state(message_a, fpv_accepted),
  proof(
    goal(trust_flow_state(message_a, fpv_accepted)),
    by(rule("trust-flow-provenance-threshold.pl", clause(11))),
    bindings([binding("Message", message_a), binding("_publisher", publisher_a), binding("_transform", transform_a), binding("_signature", signature_a), binding("Receiver", receiver_app), binding("Confidence", 0.89375999999999989), binding("Threshold", 0.85)]),
    uses([
      proof(
        goal(message(message_a, publisher_a, transform_a, signature_a, receiver_app)),
        by(fact("trust-flow-provenance-threshold.pl", clause(1)))
      ),
      proof(
        goal(confidence(message_a, 0.89375999999999989)),
        by(rule("trust-flow-provenance-threshold.pl", clause(10))),
        bindings([binding("Message", message_a), binding("Confidence", 0.89375999999999989), binding("Publisher", publisher_a), binding("Transform", transform_a), binding("Signature", signature_a), binding("_receiver", receiver_app), binding("Publishertrust", 0.95), binding("Signaturetrust", 0.98), binding("Quality", 0.96), binding("A", 0.93099999999999994)]),
        uses([
          proof(
            goal(message(message_a, publisher_a, transform_a, signature_a, receiver_app)),
            by(fact("trust-flow-provenance-threshold.pl", clause(1)))
          ),
          proof(
            goal(publisher_trust(publisher_a, 0.95)),
            by(fact("trust-flow-provenance-threshold.pl", clause(3)))
          ),
          proof(
            goal(signature_strength(signature_a, 0.98)),
            by(fact("trust-flow-provenance-threshold.pl", clause(5)))
          ),
          proof(
            goal(quality_score(transform_a, 0.96)),
            by(fact("trust-flow-provenance-threshold.pl", clause(7)))
          ),
          proof(
            goal(is(0.93099999999999994, *(0.95, 0.98))),
            by(builtin(is, 2))
          ),
          proof(
            goal(is(0.89375999999999989, *(0.93099999999999994, 0.96))),
            by(builtin(is, 2))
          )
        ])
      ),
      proof(
        goal(acceptance_threshold(receiver_app, 0.85)),
        by(fact("trust-flow-provenance-threshold.pl", clause(9)))
      ),
      proof(
        goal(>=(0.89375999999999989, 0.85)),
        by(builtin(>=, 2))
      )
    ])
  )
).

trust_flow_state(message_b, fpv_quarantine).
why(
  trust_flow_state(message_b, fpv_quarantine),
  proof(
    goal(trust_flow_state(message_b, fpv_quarantine)),
    by(rule("trust-flow-provenance-threshold.pl", clause(12))),
    bindings([binding("Message", message_b), binding("_publisher", publisher_b), binding("_transform", transform_b), binding("_signature", signature_b), binding("Receiver", receiver_app), binding("Confidence", 0.41999999999999993), binding("Threshold", 0.85)]),
    uses([
      proof(
        goal(message(message_b, publisher_b, transform_b, signature_b, receiver_app)),
        by(fact("trust-flow-provenance-threshold.pl", clause(2)))
      ),
      proof(
        goal(confidence(message_b, 0.41999999999999993)),
        by(rule("trust-flow-provenance-threshold.pl", clause(10))),
        bindings([binding("Message", message_b), binding("Confidence", 0.41999999999999993), binding("Publisher", publisher_b), binding("Transform", transform_b), binding("Signature", signature_b), binding("_receiver", receiver_app), binding("Publishertrust", 0.70), binding("Signaturetrust", 0.75), binding("Quality", 0.80), binding("A", 0.52499999999999991)]),
        uses([
          proof(
            goal(message(message_b, publisher_b, transform_b, signature_b, receiver_app)),
            by(fact("trust-flow-provenance-threshold.pl", clause(2)))
          ),
          proof(
            goal(publisher_trust(publisher_b, 0.70)),
            by(fact("trust-flow-provenance-threshold.pl", clause(4)))
          ),
          proof(
            goal(signature_strength(signature_b, 0.75)),
            by(fact("trust-flow-provenance-threshold.pl", clause(6)))
          ),
          proof(
            goal(quality_score(transform_b, 0.80)),
            by(fact("trust-flow-provenance-threshold.pl", clause(8)))
          ),
          proof(
            goal(is(0.52499999999999991, *(0.70, 0.75))),
            by(builtin(is, 2))
          ),
          proof(
            goal(is(0.41999999999999993, *(0.52499999999999991, 0.80))),
            by(builtin(is, 2))
          )
        ])
      ),
      proof(
        goal(acceptance_threshold(receiver_app, 0.85)),
        by(fact("trust-flow-provenance-threshold.pl", clause(9)))
      ),
      proof(
        goal(<(0.41999999999999993, 0.85)),
        by(builtin(<, 2))
      )
    ])
  )
).

status(message_a, fpv_high_trust_flow).
why(
  status(message_a, fpv_high_trust_flow),
  proof(
    goal(status(message_a, fpv_high_trust_flow)),
    by(rule("trust-flow-provenance-threshold.pl", clause(13))),
    bindings([binding("Message", message_a)]),
    uses([
      proof(
        goal(trust_flow_state(message_a, fpv_accepted)),
        by(rule("trust-flow-provenance-threshold.pl", clause(11))),
        bindings([binding("Message", message_a), binding("_publisher", publisher_a), binding("_transform", transform_a), binding("_signature", signature_a), binding("Receiver", receiver_app), binding("Confidence", 0.89375999999999989), binding("Threshold", 0.85)]),
        uses([
          proof(
            goal(message(message_a, publisher_a, transform_a, signature_a, receiver_app)),
            by(fact("trust-flow-provenance-threshold.pl", clause(1)))
          ),
          proof(
            goal(confidence(message_a, 0.89375999999999989)),
            by(rule("trust-flow-provenance-threshold.pl", clause(10))),
            bindings([binding("Message", message_a), binding("Confidence", 0.89375999999999989), binding("Publisher", publisher_a), binding("Transform", transform_a), binding("Signature", signature_a), binding("_receiver", receiver_app), binding("Publishertrust", 0.95), binding("Signaturetrust", 0.98), binding("Quality", 0.96), binding("A", 0.93099999999999994)]),
            uses([
              proof(
                goal(message(message_a, publisher_a, transform_a, signature_a, receiver_app)),
                by(fact("trust-flow-provenance-threshold.pl", clause(1)))
              ),
              proof(
                goal(publisher_trust(publisher_a, 0.95)),
                by(fact("trust-flow-provenance-threshold.pl", clause(3)))
              ),
              proof(
                goal(signature_strength(signature_a, 0.98)),
                by(fact("trust-flow-provenance-threshold.pl", clause(5)))
              ),
              proof(
                goal(quality_score(transform_a, 0.96)),
                by(fact("trust-flow-provenance-threshold.pl", clause(7)))
              ),
              proof(
                goal(is(0.93099999999999994, *(0.95, 0.98))),
                by(builtin(is, 2))
              ),
              proof(
                goal(is(0.89375999999999989, *(0.93099999999999994, 0.96))),
                by(builtin(is, 2))
              )
            ])
          ),
          proof(
            goal(acceptance_threshold(receiver_app, 0.85)),
            by(fact("trust-flow-provenance-threshold.pl", clause(9)))
          ),
          proof(
            goal(>=(0.89375999999999989, 0.85)),
            by(builtin(>=, 2))
          )
        ])
      )
    ])
  )
).

risk(message_b, risk_low_trust_data_source).
why(
  risk(message_b, risk_low_trust_data_source),
  proof(
    goal(risk(message_b, risk_low_trust_data_source)),
    by(rule("trust-flow-provenance-threshold.pl", clause(14))),
    bindings([binding("Message", message_b)]),
    uses([
      proof(
        goal(trust_flow_state(message_b, fpv_quarantine)),
        by(rule("trust-flow-provenance-threshold.pl", clause(12))),
        bindings([binding("Message", message_b), binding("_publisher", publisher_b), binding("_transform", transform_b), binding("_signature", signature_b), binding("Receiver", receiver_app), binding("Confidence", 0.41999999999999993), binding("Threshold", 0.85)]),
        uses([
          proof(
            goal(message(message_b, publisher_b, transform_b, signature_b, receiver_app)),
            by(fact("trust-flow-provenance-threshold.pl", clause(2)))
          ),
          proof(
            goal(confidence(message_b, 0.41999999999999993)),
            by(rule("trust-flow-provenance-threshold.pl", clause(10))),
            bindings([binding("Message", message_b), binding("Confidence", 0.41999999999999993), binding("Publisher", publisher_b), binding("Transform", transform_b), binding("Signature", signature_b), binding("_receiver", receiver_app), binding("Publishertrust", 0.70), binding("Signaturetrust", 0.75), binding("Quality", 0.80), binding("A", 0.52499999999999991)]),
            uses([
              proof(
                goal(message(message_b, publisher_b, transform_b, signature_b, receiver_app)),
                by(fact("trust-flow-provenance-threshold.pl", clause(2)))
              ),
              proof(
                goal(publisher_trust(publisher_b, 0.70)),
                by(fact("trust-flow-provenance-threshold.pl", clause(4)))
              ),
              proof(
                goal(signature_strength(signature_b, 0.75)),
                by(fact("trust-flow-provenance-threshold.pl", clause(6)))
              ),
              proof(
                goal(quality_score(transform_b, 0.80)),
                by(fact("trust-flow-provenance-threshold.pl", clause(8)))
              ),
              proof(
                goal(is(0.52499999999999991, *(0.70, 0.75))),
                by(builtin(is, 2))
              ),
              proof(
                goal(is(0.41999999999999993, *(0.52499999999999991, 0.80))),
                by(builtin(is, 2))
              )
            ])
          ),
          proof(
            goal(acceptance_threshold(receiver_app, 0.85)),
            by(fact("trust-flow-provenance-threshold.pl", clause(9)))
          ),
          proof(
            goal(<(0.41999999999999993, 0.85)),
            by(builtin(<, 2))
          )
        ])
      )
    ])
  )
).

