:- lib(fd).
:- lib(fd_global).

titolare(Colori, Prezzi, Interni, Errori) :- 
    Colori = [CF, CA, CL, CM],
    Prezzi = [PF, PA, PL, PM],
    Interni = [IF, IA, IL, IM],

    Colori :: 1 .. 4,
    Prezzi :: 1 .. 4,
    Interni :: 1 .. 4,

    fd_global:alldifferent(Colori),
    fd_global:alldifferent(Prezzi),
    fd_global:alldifferent(Interni),

    % Errori nelle 5 telefonate
    def_mistakes(Colori, Prezzi, Interni, Errori),

    % Una sola ha interni verdi
    IF #= 4 #<=> C1,
    IA #= 4 #<=> C2,
    IL #= 4 #<=> C3,
    IM #= 4 #<=> C4,
    C1 + C2 + C3 + C4 #= 1,

    append(Colori, Prezzi, T),
    append(T, Interni, Vars),
    min_max(labeling(Vars), -Errori).


def_mistakes(Colori, Prezzi, Interni, Errori) :-
    one(Colori, Prezzi, Interni, B1),
    two(Colori, Prezzi, Interni, B2),
    three(Colori, Prezzi, Interni, B3),
    four(Colori, Prezzi, Interni, B4),
    five(Colori, Prezzi, Interni, B5),
    Errori #= B1 + B2 + B3 + B4 + B5.


one([_, _, CL, _], [_, _, PL, _], [_, _, IL, _], Err) :-
    CL #= 1 #<=> B1,
    PL #= 2 #<=> B2,
    IL #= 1 #<=> B3,
    Err #= B1 + B2 + B3.

two([CF, _, _, _], [PF, _, _, _], [IF, _, _, _], Err) :-
    CF #= 2 #<=> B1,
    PF #= 4 #<=> B2,
    IF #= 1 #<=> B3,
    Err #= B1 + B2 + B3.

three([CF, CA, CL, CM], [PF, PA, PL, PM], [IF, IA, IL, IM], Err) :-
    (
        (CF #= 3 #/\ PF #= 1 #/\ IF #= 2) #\/
        (CA #= 3 #/\ PA #= 1 #/\ IA #= 2) #\/
        (CL #= 3 #/\ PL #= 1 #/\ IL #= 2) #\/
        (CM #= 3 #/\ PM #= 1 #/\ IM #= 2)
    ) #<=> B,
    Err #= 1 - B.
    

four([_, _, CL, _], [_, _, PL, _], [_, _, IL, _], Err) :-
    (CL #= 2 #/\ PL #= 4 #/\ IL #= 3) #<=> B,
    Err #= 1 - B.

five([_, CA, _, _], [_, PA, _, _], [_, IA, _, _], Err) :-
    CA #= 4 #<=> B1,
    PA #= 3 #<=> B2,
    IA #= 3 #<=> B3,
    Err #= B1 + B2 + B3.
