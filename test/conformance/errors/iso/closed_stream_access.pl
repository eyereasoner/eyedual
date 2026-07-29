query(trigger).
trigger :-
    open('/tmp/eyepl-iso-closed.txt', write, Stream, []),
    close(Stream),
    put_char(Stream, x).
