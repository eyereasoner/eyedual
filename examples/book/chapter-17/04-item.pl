% From The Art of EyeDual, Chapter 17.
item(X, [X | _]).
item(X, [_ | Rest]) :- item(X, Rest).
