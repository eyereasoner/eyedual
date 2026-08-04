%% goal: trigger

trigger :-
    open('/tmp/eyedual-iso-closed.txt', write, Stream, []),
    close(Stream),
    put_char(Stream, x).
