% Catalan numbers by automatically tabled convolution.
%
% catalan(N,C) sums all splits of N-1 into left and right substructures.  The same
% Catalan values appear in binary tree shapes, parenthesizations, and polygon
% triangulations, shown here with small wrapper predicates.
%% goal: catalan_answer(X0, X1)



% C_0 = 1; higher values are computed by the convolution sum.
catalan(0, 1).
catalan(N, C) :-
  (N > 0),
  (N1 is N - 1),
  sumall(Product,
    (between(0, N1, I),
     (J is N1 - I),
     catalan(I, A),
     catalan(J, B),
     (Product is A * B)),
    C).

% An n-gon has C_(n-2) triangulations.
polygon_triangulations(Sides, Count) :-
  (Sides >= 3),
  (N is Sides - 2),
  catalan(N, Count).

parenthesizations(Factors, Count) :-
  (Factors >= 1),
  (N is Factors - 1),
  catalan(N, Count).

catalan_answer(catalan_12, C) :- catalan(12, C).
catalan_answer(triangulations_14_gon, Count) :- polygon_triangulations(14, Count).
catalan_answer(parenthesizations_13_factors, Count) :- parenthesizations(13, Count).
catalan_answer(first_ten_sum, Sum) :- sumall(C, (between(0, 9, N), catalan(N, C)), Sum).
