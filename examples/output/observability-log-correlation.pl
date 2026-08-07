captured_field(l1, ts, '2026-06-18T10:00:00Z').
captured_field(l1, level, warn).
captured_field(l1, event, login_failed).
captured_field(l1, user, alice).
captured_field(l1, ip, '203.0.113.9').
captured_field(l1, trace_id, '4bf92f3577b34da6a3ce929d0e0e4736').
captured_field(l1, span_id, '00f067aa0ba902b7').
captured_field(l1, flags, '01').
captured_field(l2, ts, '2026-06-18T10:00:03Z').
captured_field(l2, level, error).
captured_field(l2, event, payment_denied).
captured_field(l2, user, alice).
captured_field(l2, ip, '203.0.113.9').
captured_field(l2, trace_id, '4bf92f3577b34da6a3ce929d0e0e4736').
captured_field(l2, span_id, aaf067aa0ba90000).
captured_field(l2, flags, '01').
captured_field(l3, ts, '2026-06-18T10:01:12Z').
captured_field(l3, level, info).
captured_field(l3, event, login_success).
captured_field(l3, user, bob).
captured_field(l3, ip, '198.51.100.4').
captured_field(l3, trace_id, aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa).
captured_field(l3, span_id, bbbbbbbbbbbbbbbb).
captured_field(l3, flags, '01').
parsed_event(l1, login_failed, alice, '203.0.113.9', '4bf92f3577b34da6a3ce929d0e0e4736').
parsed_event(l2, payment_denied, alice, '203.0.113.9', '4bf92f3577b34da6a3ce929d0e0e4736').
parsed_event(l3, login_success, bob, '198.51.100.4', aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa).
trace_alert(alice, '4bf92f3577b34da6a3ce929d0e0e4736', '203.0.113.9').
