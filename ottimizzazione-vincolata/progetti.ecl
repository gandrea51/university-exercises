progetto(1).
progetto(2).
progetto(3).
progetto(4).

team(1).
team(2).
team(3).

% richiede(A, B) --> Progetto A va assegnato al team B
richiede(1, 1).
richiede(2, 2).

% incompatibile(A, B) --> Progetto A non va al team B
incompatibile(3, 1).
incompatibile(4, 2).

% collabora(A, B) --> Progetti A e B dovrebbero essere assegnati allo stesso team
collabora(1, 2).
collabora(2, 4).
