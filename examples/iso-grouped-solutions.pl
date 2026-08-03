% ISO findall/3, bagof/3, setof/3, and clause/2.
%
% findall/3 makes one flat collection. bagof/3 groups answers by free
% variables, while setof/3 additionally sorts and removes duplicates.
%% goal: report(X0, X1)


sale(north, ada, 7).
sale(north, ada, 7).
sale(north, ben, 5).
sale(south, clara, 9).

regional_total(Region, Total) :-
  bagof(Amount, Seller^sale(Region, Seller, Amount), Amounts),
  sum_amounts(Amounts, Total).

sum_amounts([], 0).
sum_amounts([Amount | Rest], Total) :-
  sum_amounts(Rest, Partial),
  Total is Amount + Partial.

report(all_amounts, Amounts) :-
  findall(Amount, sale(_, _, Amount), Amounts).

report(regional_total(Region), Total) :-
  regional_total(Region, Total).

report(regions, Regions) :-
  setof(Region, Seller^Amount^sale(Region, Seller, Amount), Regions).

report(source_clause, visible) :-
  clause(sale(north, ada, 7), true).
