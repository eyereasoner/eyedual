% Vector dot product, Euclidean norm, and cosine similarity.
%
% Recursive list folds compute the dot product and squared-length sums.  The
% public cosineSimilarity/2 report then combines those folds as
% dot(A,B)/(norm(A)*norm(B)) for a named vector pair.
%
% The example keeps vectors as ordinary EyeProlog lists, so it doubles as a compact
% demonstration of numeric recursion over list structure.

%% goal: dotProduct(X0, X1)

%% goal: normA(X0, X1)

%% goal: normB(X0, X1)

%% goal: cosineSimilarity(X0, X1)


% Two named vectors form the single cosine-similarity case.
vector(pair1, a, [1.0, 2.0, 3.0]).
vector(pair1, b, [4.0, -5.0, 6.0]).

% Recursive list folds compute dot products and sums of squares.
dot([], [], 0.0).
dot([A|As], [B|Bs], Dot) :-
  (Product is A * B),
  dot(As, Bs, Rest),
  (Dot is Product + Rest).

sum_squares([], 0.0).
sum_squares([X|Xs], Total) :-
  (Squared is X ** 2.0),
  sum_squares(Xs, Rest),
  (Total is Squared + Rest).

norm(Vector, Norm) :-
  sum_squares(Vector, Sumsquares),
  (Norm is Sumsquares ** 0.5).

% cosine = dot(A,B) / (norm(A) * norm(B)).
cosine_similarity(Case, Similarity) :-
  vector(Case, a, A),
  vector(Case, b, B),
  dot(A, B, Dot),
  norm(A, Norma),
  norm(B, Normb),
  (Denominator is Norma * Normb),
  (Similarity is Dot / Denominator).

dotProduct(Case, Dot) :-
  vector(Case, a, A),
  vector(Case, b, B),
  dot(A, B, Dot).

normA(Case, Norma) :-
  vector(Case, a, A),
  norm(A, Norma).

normB(Case, Normb) :-
  vector(Case, b, B),
  norm(B, Normb).

cosineSimilarity(Case, Similarity) :-
  cosine_similarity(Case, Similarity).
