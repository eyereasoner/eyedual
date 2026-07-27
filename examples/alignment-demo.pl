% Alignment demo, adapted from Eyeling's examples/alignment-demo.n3.
%
% The output is the Prolog-style counterpart of the Eyeling golden output:
% broader/narrower alignments, their transitive closure, the reflexive
% narrower-or-equal relation, and the concepts that roll up to ref_car.

% Output declarations: query/1 selects the relations written to this example's golden output.
query(broader(X0, X1)).
query(narrower(X0, X1)).
query(broaderTransitive(X0, X1)).
query(narrowerTransitive(X0, X1)).
query(narrowerOrEqualOf(X0, X1)).
query(rollsUpTo(X0, X1)).

% Program structure: facts set up the scenario, and rules derive the queried conclusions.
concept(ref_car).
concept(tel_car).
concept(tel_heavy_vehicle).
concept(anpr_vehicle_with_plate).
concept(anpr_passenger_car).

assertedBroader(tel_car, ref_car).
assertedBroader(tel_heavy_vehicle, ref_car).
assertedBroader(anpr_vehicle_with_plate, ref_car).
assertedNarrower(anpr_vehicle_with_plate, anpr_passenger_car).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
broader(X, Y) :- assertedBroader(X, Y).
broader(X, Y) :- assertedNarrower(Y, X).

narrower(X, Y) :- broader(Y, X).

broaderTransitive(X, Y) :- broader(X, Y).
broaderTransitive(X, Z) :- broader(X, Y), broaderTransitive(Y, Z).

narrowerTransitive(X, Y) :- narrower(X, Y).
narrowerTransitive(X, Z) :- narrower(X, Y), narrowerTransitive(Y, Z).

narrowerOrEqualOf(X, X) :- concept(X).
narrowerOrEqualOf(X, Y) :- broaderTransitive(X, Y).

rollsUpTo(X, ref_car) :-
  narrowerOrEqualOf(X, ref_car),
  (X \= ref_car).
