% Reference 9.1: reusable built-ins compose without special host predicates.
%% goal: answer(X0, X1)

line('  red,green,blue  ').
answer(clean_join, X) :- line(Raw), trim(Raw, Trimmed), split(Trimmed, ',', Parts), join(Parts, '|', X).
answer(middle_upper, X) :- line(Raw), trim(Raw, Trimmed), split(Trimmed, ',', Parts), nth0(1, Parts, Middle), uppercase(Middle, X).
answer(summary, result(First, Last, Count)) :- line(Raw), trim(Raw, T), split(T, ',', Parts), Parts = [First|_tail], last(Parts, Last), length(Parts, Count).
answer(term_report, X) :- (Term =.. [measurement | [temperature, 21]]), term_string(Term, X).
answer(score_text, X) :- max_list([3, 9, 5], Max), number_string(Max, Text), string_concat('max=', Text, X).
