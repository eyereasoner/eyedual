% Four-colour search for the European Union neighbour graph.
%
% This is a finite executable version of the source map-colouring example.  The
% neighbour facts are the EU country graph from the original input, represented
% with lowercase atom names.  `once/1` asks for one valid colouring rather than
% enumerating all possible four-colour assignments.

%% goal: four_color_answer(X0, X1)


color(red).
color(green).
color(blue).
color(yellow).

place_order([belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia]).

neighbours(belgium, [france, netherlands, luxemburg, germany]).
neighbours(netherlands, [belgium, germany]).
neighbours(luxemburg, [belgium, france, germany]).
neighbours(france, [spain, belgium, luxemburg, germany, italy]).
neighbours(germany, [netherlands, belgium, luxemburg, denmark, france, austria, poland, czech_republic]).
neighbours(italy, [france, austria, slovenia]).
neighbours(denmark, [germany]).
neighbours(ireland, []).
neighbours(greece, [bulgaria]).
neighbours(spain, [france, portugal]).
neighbours(portugal, [spain]).
neighbours(austria, [czech_republic, germany, hungary, italy, slovenia, slovakia]).
neighbours(sweden, [finland]).
neighbours(finland, [sweden]).
neighbours(cyprus, []).
neighbours(malta, []).
neighbours(poland, [germany, czech_republic, slovakia, lithuania]).
neighbours(hungary, [austria, slovakia, romania, croatia, slovenia]).
neighbours(czech_republic, [germany, poland, slovakia, austria]).
neighbours(slovakia, [czech_republic, poland, hungary, austria]).
neighbours(slovenia, [austria, italy, hungary, croatia]).
neighbours(estonia, [latvia]).
neighbours(latvia, [estonia, lithuania]).
neighbours(lithuania, [latvia, poland]).
neighbours(bulgaria, [romania, greece]).
neighbours(romania, [hungary, bulgaria]).
neighbours(croatia, [slovenia, hungary]).

% Colour the tail first, like the source Prolog program.  That gives each
% colour choice the already-coloured suffix to check against and avoids
% generating many doomed prefixes.
valid_color(Place, Color, Assigned) :-
  neighbours(Place, Neighbors),
  \+ (member([Neighbor, Color], Assigned), member(Neighbor, Neighbors)).

place_pairs([], []).
place_pairs([Place|Rest], [[Place, _]|Pairs]) :-
  place_pairs(Rest, Pairs).

color_places([]).
color_places([[Place, Color]|Tail]) :-
  color_places(Tail),
  color(Color),
  valid_color(Place, Color, Tail).

four_color_answer(european_union, Coloring) :-
  place_order(Places),
  place_pairs(Places, Coloring),
  once(color_places(Coloring)).
