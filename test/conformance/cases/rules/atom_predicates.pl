% ISO-style atoms are callable predicates of arity zero.
query(derived_ready).
query(source_ready).

source_ready.
derived_ready :- source_ready.
