% EYE reasoning-inspired example: four-colour map check for the European Union.
%
% The source EYE example encodes the EU neighbourhood map and an answer assigning
% four colours. This eyeprolog version keeps the same map/assignment shape and adds
% a rule-level validation layer that rejects equal colours across borders.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%
% The countries form a small planar-style adjacency graph. The example is a
% constraint problem: assign colours, reject border conflicts, then query
% the canonical colour vector and validation status.
%% goal: color(X0, X1)

%% goal: status(X0, X1)

%% goal: reason(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
country(belgium). country(netherlands). country(luxemburg). country(france).
country(germany). country(italy). country(denmark). country(ireland).
country(greece). country(spain). country(portugal). country(austria).
country(sweden). country(finland). country(cyprus). country(malta).
country(poland). country(hungary). country(czech_republic). country(slovakia).
country(slovenia). country(estonia). country(latvia). country(lithuania).
country(bulgaria). country(romania). country(croatia).

% Undirected borders represented once.
border(belgium, france). border(belgium, netherlands). border(belgium, luxemburg). border(belgium, germany).
border(netherlands, germany).
border(luxemburg, france). border(luxemburg, germany).
border(france, spain). border(france, germany). border(france, italy).
border(germany, denmark). border(germany, austria). border(germany, poland). border(germany, czech_republic).
border(italy, austria). border(italy, slovenia).
border(greece, bulgaria).
border(spain, portugal).
border(austria, czech_republic). border(austria, hungary). border(austria, slovenia). border(austria, slovakia).
border(sweden, finland).
border(poland, czech_republic). border(poland, slovakia). border(poland, lithuania).
border(hungary, slovakia). border(hungary, romania). border(hungary, croatia). border(hungary, slovenia).
border(czech_republic, slovakia).
border(slovakia, austria).
border(slovenia, croatia).
border(estonia, latvia).
border(latvia, lithuania).
border(bulgaria, romania).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
adjacent(A, B) :- border(A, B).
adjacent(A, B) :- border(B, A).

color(red). color(green). color(blue). color(yellow).

assigned(belgium, yellow).
assigned(netherlands, green).
assigned(luxemburg, green).
assigned(france, blue).
assigned(germany, red).
assigned(italy, red).
assigned(denmark, green).
assigned(ireland, red).
assigned(greece, red).
assigned(spain, green).
assigned(portugal, red).
assigned(austria, yellow).
assigned(sweden, green).
assigned(finland, red).
assigned(cyprus, red).
assigned(malta, red).
assigned(poland, blue).
assigned(hungary, blue).
assigned(czech_republic, green).
assigned(slovakia, red).
assigned(slovenia, green).
assigned(estonia, red).
assigned(latvia, green).
assigned(lithuania, red).
assigned(bulgaria, green).
assigned(romania, red).
assigned(croatia, red).

% valid_assignment/1 checks that one country has an assigned colour from the palette.
valid_assignment(Country) :-
  country(Country),
  assigned(Country, Colour),
  color(Colour).

% bad_border/3 is the only forbidden pattern: adjacent countries sharing a colour.
bad_border(A, B, Colour) :-
  border(A, B),
  assigned(A, Colour),
  assigned(B, Colour).

border_colours_differ(A, B) :-
  border(A, B),
  assigned(A, Coloura),
  assigned(B, Colourb),
  (Coloura \= Colourb).

country_count(27).
border_count(36).

all_countries_coloured(map_eu) :-
  findall(Country, valid_assignment(Country), Countries),
  sort(Countries, Uniquecountries),
  length(Uniquecountries, Count),
  country_count(Count).

all_borders_checked(map_eu) :-
  findall([A, B], border_colours_differ(A, B), Borders),
  sort(Borders, Uniqueborders),
  length(Uniqueborders, Count),
  border_count(Count).

map_valid(map_eu) :-
  all_countries_coloured(map_eu),
  all_borders_checked(map_eu).

colouring([
  [belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue],
  [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red],
  [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red],
  [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green],
  [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red],
  [bulgaria, green], [romania, red], [croatia, red]
]).

color(map_eu, Colours) :-
  map_valid(map_eu),
  colouring(Colours).

status(map_eu, valid_four_colour_assignment) :-
  map_valid(map_eu).

reason(map_eu, "no neighbouring countries share a colour") :-
  map_valid(map_eu).
