% From The Art of EyeDual, Chapter 20 — Move invariant work outward.
search(Request, Answer) :-
  normalized_request(Request, Normalized),
  search_normalized(Normalized, initial_state, Answer).
