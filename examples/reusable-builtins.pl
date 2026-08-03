% Reusable builtin tour for text, list, numeric, and quantifier helpers.
%
% Each report/2 clause demonstrates a small reusable operation: trimming and
% lowercasing text, splitting and joining tags, de-duplicating lists, slicing a
% window, aggregating scores, and validating facts with forall/2.
%% goal: report(X0, X1)


name_raw("  Ada Lovelace  ").
tag_csv("logic,math,logic,programming").
scores([8, 13, 21]).

report(normalized_name, Name) :-
  name_raw(Raw),
  trim(Raw, Trimmed),
  lowercase(Trimmed, Name).

report(unique_tags, Tags) :-
  tag_csv(Csv),
  split(Csv, ",", Parts),
  list_to_set(Parts, Tags).

report(tag_label, Label) :-
  tag_csv(Csv),
  split(Csv, ",", Parts),
  list_to_set(Parts, Tags),
  join(Tags, " / ", Label).

report(score_summary, summary(Total, Peak, Roottotal)) :-
  scores(Scores),
  sum_list(Scores, Total),
  max_list(Scores, Peak),
  (Roottotal is sqrt(Total)).

report(window, Slice) :-
  scores(Scores),
  slice(1, 2, Scores, Slice).
