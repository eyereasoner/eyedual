% Reference 3.2, 3.6: comments are ignored outside quoted text and atoms.
  item(quoted_percent, "% not a comment").    % trailing comment
item(quoted_atom, 'has % sign').
answer(K, V) :- item(K, V).
%% goal: answer(X0, X1)

