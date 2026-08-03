% ISO control constructs and exception recovery.
%
% The example treats goals as data with call/1, commits to one answer with
% once/1, makes a local if-then-else decision, and turns a thrown domain term
% into an ordinary result with catch/3.
%% goal: report(X0, X1)


route(antwerp, ghent).
route(antwerp, brussels).

first_destination(From, To) :-
  once(route(From, To)).

preferred_destination(From, To) :-
  route(From, To),
  !.

travel_status(From, To, Status) :-
  (call(route(From, To)) -> Status = connected ; Status = disconnected).

require_route(From, To) :-
  (route(From, To) -> true ; throw(no_route(From, To))).

checked_route(From, To, Result) :-
  catch(
    (require_route(From, To), Result = accepted),
    no_route(From, To),
    Result = rejected
  ).

report(first_destination, To) :-
  first_destination(antwerp, To).

report(cut_destination, To) :-
  preferred_destination(antwerp, To).

report(existing_route, Status) :-
  travel_status(antwerp, ghent, Status).

report(missing_route, Status) :-
  travel_status(antwerp, paris, Status).

report(recovered_exception, Result) :-
  checked_route(antwerp, paris, Result).
