boom(X) :-
    =(X, 7),
    throw(ball(X)).

choice(first).
choice(second).

%% goal: answer(X0, X1, X2, X3, X4)

answer(Caught, Nested, ProcessorError, Normal, UnknownCaught) :-
    catch(boom(Value), ball(Caught), =(Caught, Value)),
    catch(catch(throw(red), blue, fail), Nested, true),
    catch(atom_length(1, Length), error(type_error(atom, 1), Context), =(ProcessorError, caught(Context))),
    catch(choice(Normal), Ball, fail),
    var(Ball),
    set_prolog_flag(unknown, error),
    catch(missing_goal, error(existence_error(procedure, missing_goal/0), ErrorContext),
        =(UnknownCaught, caught(ErrorContext))),
    set_prolog_flag(unknown, fail).

%% goal: flags(X0, X1, X2)

flags(DebugBefore, DebugAfter, All) :-
    current_prolog_flag(debug, DebugBefore),
    set_prolog_flag(debug, on),
    current_prolog_flag(debug, DebugAfter),
    set_prolog_flag(debug, off),
    findall(pair(Flag, Value), current_prolog_flag(Flag, Value), All).
