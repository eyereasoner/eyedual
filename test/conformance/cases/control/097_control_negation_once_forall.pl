% Reference 9.10: ISO negation and portable once/1 are scoped control operations.
%% goal: answer(X0, X1)

choice(a).
choice(b).
allowed(a).
allowed(b).
answer(once_choice, X) :- once(choice(X)).
answer(nested_once, ok) :- once(chosen).
chosen :- once(choice(a)).
answer(negated_missing, ok) :- \+ choice(c).
answer(negated_existing_rejected, ok) :- \+ \+ choice(a).
answer(all_allowed, ok) :- \+ disallowed_choice.
answer(not_all_allowed_after_extra, ok) :- disallowed_extra.
disallowed_choice :- choice(X), \+ allowed(X).
disallowed_extra :- extra(X), \+ allowed(X).
extra(a).
extra(c).
