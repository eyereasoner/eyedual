% Andersen-style inclusion-based pointer analysis.
%
% The program being analyzed has address-taking, assignment, store, and load
% statements.  The logic rules compute a fixed point of points_to/2 and
% field_points_to/2 facts.  This is the classic Datalog shape used in scalable
% pointer-analysis papers, reduced to a small readable instance.

%% goal: pointsTo(X0, X1)

%% goal: heapField(X0, X1)

%% goal: pointerFlow(X0, X1)

%% goal: pointerConclusion(X0, X1)



:- discontiguous(assign/2).
:- discontiguous(points_to/2).

% Source-program statements:
%   x = &object_a
%   z = &object_b
%   y = x
%   *y = z
%   q = *x
%   r = q
addr(x, object_a).
addr(z, object_b).
assign(y, x).
store(y, z).
load(q, x).
assign(r, q).

% Address-taking and assignment constraints.
points_to(Var, Object) :- addr(Var, Object).
points_to(To, Object) :- assign(To, From), points_to(From, Object).

% Store and load constraints.  If y may point to object_a and z may point to
% object_b, then object_a's abstract field may point to object_b.  A later load
% from x therefore gives q the same target.
field_points_to(Heap_object, Value_object) :-
  store(Pointer, Value),
  points_to(Pointer, Heap_object),
  points_to(Value, Value_object).
points_to(To, Value_object) :-
  load(To, Pointer),
  points_to(Pointer, Heap_object),
  field_points_to(Heap_object, Value_object).

pointsTo(Var, Object) :- points_to(Var, Object).
heapField(Heap_object, Value_object) :- field_points_to(Heap_object, Value_object).
pointerFlow(load_q_from_x, Object) :- points_to(q, Object).
pointerConclusion(case, "the load q = *x recovers object_b through the store *y = z and y = x") :-
  points_to(q, object_b).
