% From The Art of EyeLang, Chapter 12.
invalid_assignment(Person, Role, Other) :-
  assigned(Person, Role),
  incompatible_roles(Role, Other),
  assigned(Person, Other).
