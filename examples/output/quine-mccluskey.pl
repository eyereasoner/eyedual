answer('PROBLEM INSTANCE\nMinterms: {1, 3, 7, 11, 15}\nDon''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD').
reason('1. Generated Prime Implicants by iteratively combining adjacent minterms/groups.\n2. Built Prime Implicant Chart for minterms only (excluding don''t cares).\n3. Extracted Essential Prime Implicants.\n4. Performed exhaustive search on remaining primes to find the smallest cover, breaking ties with the lexicographical key (0 < 1 < -).').
check(1, 'Functional Correctness (All minterms covered)', true).
check(2, 'Safety Check (No false positives outside DCs)', true).
check(3, 'Minimality (Cardinality) Proof', true).
check(4, 'Canonical Tie-Breaking (Lexicographical First)', true).
check(5, 'Consistency (Solution is subset of Primes)', true).
