% Science example: ideal gas law.
%
% A simple gas cell uses P*V = n*R*T.  The constants are chosen so that the
% computed pressure is exactly near one atmosphere in this small example.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: pressure_Pa(X0, X1)

%% goal: status(X0, X1)

%% goal: reason(X0, X1)


% gas_cell/5 records n, R, T, and V; pressure_limit/3 gives the tolerance band
% used to classify the result as near atmospheric.
gas_cell(cell1, 1.0, 8.0, 300.0, 0.024).
pressure_limit(cell1, low_Pa, 95000.0).
pressure_limit(cell1, high_Pa, 105000.0).

% pressure/2 computes nRT/V in three explicit arithmetic steps so the proof
% output exposes numerator construction and final division.
pressure(Cell, Pressure) :-
  gas_cell(Cell, Moles, Gasconstant, Temperature, Volume),
  (Nr is Moles * Gasconstant),
  (Nrt is Nr * Temperature),
  (Pressure is Nrt / Volume).

near_atmospheric(Cell) :-
  pressure(Cell, Pressure),
  pressure_limit(Cell, low_Pa, Low),
  pressure_limit(Cell, high_Pa, High),
  (Pressure > Low),
  (Pressure < High).

pressure_Pa(Cell, Pressure) :-
  pressure(Cell, Pressure).

status(Cell, near_atmospheric) :-
  near_atmospheric(Cell).

reason(Cell, "pressure is inside the one-atmosphere tolerance band") :-
  near_atmospheric(Cell).
