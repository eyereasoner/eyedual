%% goal: trigger

trigger :-
    current_input(Input),
    get_byte(Input, _).
