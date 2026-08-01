answer(term, kind(alert)).
answer(term, severity(high)).
answer(term, owner(alice)).
answer(parts, pair(kind, [alert])).
answer(parts, pair(severity, [high])).
answer(parts, pair(owner, [alice])).
answer(filter, alice).
answer(missing_rejected, ok).
