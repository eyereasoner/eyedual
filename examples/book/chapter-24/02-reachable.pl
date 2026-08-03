% From The Art of Eyepl, Chapter 24 — Existence, one witness, and all witnesses.
reachable(From, To).
once(simple_path(From, To, Path)).
findall(Path, simple_path(From, To, Path), Paths).
