% Technology example: Hamming(7,4) single-bit error correction.
%
% The received word has one corrupted bit. Syndrome bits identify the bad
% position, then the corrected codeword and decoded payload are derived.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%
% Positions are one-based to match the textbook parity-check layout. The
% syndrome value is both the error certificate and the index of the bit to fix.
%% goal: syndrome(X0, X1)

%% goal: errorBit(X0, X1)

%% goal: correctedCodeword(X0, X1)

%% goal: decodedPayload(X0, X1)

%% goal: status(X0, X1)

%% goal: reason(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
received_bit(packet1, 1, 1).
received_bit(packet1, 2, 0).
received_bit(packet1, 3, 1).
received_bit(packet1, 4, 1).
received_bit(packet1, 5, 1).
received_bit(packet1, 6, 1).
received_bit(packet1, 7, 0).

flip(0, 1).
flip(1, 0).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
parity4(A, B, C, D, Parity) :-
  (Ab is A + B),
  (Abc is Ab + C),
  (Sum is Abc + D),
  (Parity is Sum mod 2).

syndrome_bit1(Code, S1) :-
  received_bit(Code, 1, B1),
  received_bit(Code, 3, B3),
  received_bit(Code, 5, B5),
  received_bit(Code, 7, B7),
  parity4(B1, B3, B5, B7, S1).

syndrome_bit2(Code, S2) :-
  received_bit(Code, 2, B2),
  received_bit(Code, 3, B3),
  received_bit(Code, 6, B6),
  received_bit(Code, 7, B7),
  parity4(B2, B3, B6, B7, S2).

syndrome_bit4(Code, S4) :-
  received_bit(Code, 4, B4),
  received_bit(Code, 5, B5),
  received_bit(Code, 6, B6),
  received_bit(Code, 7, B7),
  parity4(B4, B5, B6, B7, S4).

% syndrome/2 combines parity checks as S1 + 2*S2 + 4*S4.
syndrome(Code, Syndrome) :-
  syndrome_bit1(Code, S1),
  syndrome_bit2(Code, S2),
  syndrome_bit4(Code, S4),
  (Weighteds2 is S2 * 2),
  (Weighteds4 is S4 * 4),
  (Partial is S1 + Weighteds2),
  (Syndrome is Partial + Weighteds4).

corrected_bit(Code, Position, Corrected) :-
  syndrome(Code, Position),
  received_bit(Code, Position, Bit),
  flip(Bit, Corrected).

corrected_bit(Code, Position, Bit) :-
  syndrome(Code, Errorposition),
  (Position \= Errorposition),
  received_bit(Code, Position, Bit).

corrected_codeword(Code, [B1, B2, B3, B4, B5, B6, B7]) :-
  corrected_bit(Code, 1, B1),
  corrected_bit(Code, 2, B2),
  corrected_bit(Code, 3, B3),
  corrected_bit(Code, 4, B4),
  corrected_bit(Code, 5, B5),
  corrected_bit(Code, 6, B6),
  corrected_bit(Code, 7, B7).

decoded_payload(Code, [D1, D2, D3, D4]) :-
  corrected_bit(Code, 3, D1),
  corrected_bit(Code, 5, D2),
  corrected_bit(Code, 6, D3),
  corrected_bit(Code, 7, D4).


errorBit(Code, Position) :-
  syndrome(Code, Position),
  (Position > 0).

correctedCodeword(Code, Codeword) :-
  corrected_codeword(Code, Codeword).

decodedPayload(Code, Payload) :-
  decoded_payload(Code, Payload).

status(Code, single_bit_corrected) :-
  syndrome(Code, Position),
  (Position > 0).

reason(Code, "Hamming syndrome identifies the flipped bit position") :-
  syndrome(Code, Position),
  (Position > 0).
