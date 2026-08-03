% IRI atoms can appear anywhere ordinary atoms can appear, including lists.
%% goal: answer(X0)

route(['<urn:example:a>', '<urn:example:b>', '<urn:example:c>']).
answer(Route) :- route(Route).
