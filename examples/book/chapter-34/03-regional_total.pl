% From The Art of Eyepl, Chapter 34.
regional_total(Region, Total) :-
  bagof(Amount, Seller^sale(Region, Seller, Amount), Amounts),
  sum_amounts(Amounts, Total).
