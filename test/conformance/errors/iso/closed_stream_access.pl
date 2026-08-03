%% goal: trigger

trigger :-
    open('/tmp/webentail-iso-closed.txt', write, Stream, []),
    close(Stream),
    put_char(Stream, x).
