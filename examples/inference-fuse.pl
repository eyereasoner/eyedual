% Inference fuse example.
%
% The same object cannot consistently have two exclusive colors. The query
% would normally report a status, but fuses are checked first and abort the run.
% expect-exit: 65

%% goal: status(X, Value)


color(stone, black).
color(stone, white).

false :-
  color(X, black),
  color(X, white).

status(stone, consistent) :- color(stone, black).
