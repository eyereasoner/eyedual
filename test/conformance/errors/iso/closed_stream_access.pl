%% goal: trigger

trigger :-
    open('/tmp/eyelang-iso-closed.txt', write, Stream, []),
    close(Stream),
    put_char(Stream, x).
