holds_result(test, true).
arc(check1, "C1 OK - the starting classification n0 is present.").
arc(check2, "C2 OK - the first expansion produced n1 together with side labels i1 and j1.").
arc(check3, "C3 OK - the chain reaches the midpoint n5 and still carries both side-label branches.").
arc(check4, "C4 OK - the final taxonomy step from n9 to n10 was completed.").
arc(check5, "C5 OK - once n10 is reached, the terminal class a2 is derived.").
arc(check6, "C6 OK - the success flag is raised only after the terminal class a2 is present.").
answer(report, "The test succeeds: starting from one individual classified as n0, the rules eventually classify it as n10 and then as a2.").
reason(report, "The adjacent rules mirror the Eyeling N3 deep-taxonomy-10 chain: each rule advances one taxonomy level and adds the matching side labels.").
checkPassed(report, check1).
checkPassed(report, check2).
checkPassed(report, check3).
checkPassed(report, check4).
checkPassed(report, check5).
checkPassed(report, check6).
result(report, success).
