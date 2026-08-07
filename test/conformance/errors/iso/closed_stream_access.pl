%% goal: trigger

trigger :-
    open('/tmp/eyeprolog-iso-closed.txt', write, Stream, []),
    close(Stream),
    put_char(Stream, x).
