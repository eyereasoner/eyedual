prime_result(range_2_30, [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]).
why(
  prime_result(range_2_30, [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]),
  proof(
    goal(prime_result(range_2_30, [2, 3, 5, 7, 11, 13, 17, 19, 23, 29])),
    by(rule("prime-range.pl", clause(8))),
    bindings([binding("Primes", [2, 3, 5, 7, 11, 13, 17, 19, 23, 29])]),
    uses([
      proof(
        goal(findall(P, prime(P), [2, 3, 5, 7, 11, 13, 17, 19, 23, 29])),
        by(builtin(findall, 3))
      )
    ])
  )
).

prime_result(count_2_30, 10).
why(
  prime_result(count_2_30, 10),
  proof(
    goal(prime_result(count_2_30, 10)),
    by(rule("prime-range.pl", clause(9))),
    bindings([binding("Count", 10)]),
    uses([
      proof(
        goal(countall(prime(P), 10)),
        by(library(countall, 2))
      )
    ])
  )
).

prime_result(totient_271, 270).
why(
  prime_result(totient_271, 270),
  proof(
    goal(prime_result(totient_271, 270)),
    by(rule("prime-range.pl", clause(10))),
    bindings([binding("Phi", 270)]),
    uses([
      proof(
        goal(totient(271, 270)),
        by(rule("prime-range.pl", clause(7))),
        bindings([binding("N", 271), binding("Phi", 270)]),
        uses([
          proof(
            goal(countall(coprime(271, _k), 270)),
            by(library(countall, 2))
          )
        ])
      )
    ])
  )
).

