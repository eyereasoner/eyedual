satModel([bind(d, true), bind(c, true), bind(b, true), bind(a, false)]).
satValue(d, true).
satValue(c, true).
satValue(b, true).
satValue(a, false).
satClauseStatus(c1, satisfied).
satClauseStatus(c2, satisfied).
satClauseStatus(c3, satisfied).
satClauseStatus(c4, satisfied).
satClauseStatus(c5, satisfied).
satConclusion(case, "DPLL finds a satisfying assignment after pruning clauses that become impossible").
