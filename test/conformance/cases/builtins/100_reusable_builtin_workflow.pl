% Reference 9: standard built-ins compose into a reusable data-processing workflow.
%% goal: answer(X0, X1)

row(' alice : 3,5,7 ').
row(' bob : 2,4 ').
field(Name, Scores) :- row(Raw), trim(Raw, T), split(T, ':', [Nameraw, Scoresraw]), trim(Nameraw, Nametext), atom_string(Name, Nametext), trim(Scoresraw, Cleanscores), split(Cleanscores, ',', Scoretexts), scores(Scoretexts, Scores).
scores([], []).
scores([Text | Resttext], [N | Rest]) :- number_string(N, Text), scores(Resttext, Rest).
answer(total(Name), Total) :- field(Name, Scores), sum_list(Scores, Total).
answer(maximum(Name), Max) :- field(Name, Scores), max_list(Scores, Max).
answer(report(Name), Text) :- field(Name, Scores), length(Scores, Count), number_string(Count, Counttext), atom_string(Name, Nametext), string_concat(Nametext, ':', Prefix), string_concat(Prefix, Counttext, Text).
