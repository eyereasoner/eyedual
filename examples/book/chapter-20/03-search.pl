% From The Art of EyeProlog, Chapter 20 — Move invariant work outward.
search(Request, Answer) :-
  normalized_request(Request, Normalized),
  search_normalized(Normalized, initial_state, Answer).
