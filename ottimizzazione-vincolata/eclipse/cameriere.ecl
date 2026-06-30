:- lib(fd).
:- lib(fd_global).

cameriere(Errori) :-
    Ordini = [OB1, OB2, OD1, OD2, OC1, OC2, OF1, OF2, OA1, OA2],
    Ordini :: 1 .. 10,
    fd_global:alldifferent(Ordini),

    Arrivi = [AB1, AB2, AD1, AD2, AC1, AC2, AF1, AF2, AA1, AA2],
    Arrivi :: 1 .. 10,
    fd_global:alldifferent(Arrivi),

    AB1 #= OD1,

    (AC1 #= OD1 #\/ AC1 #= OD2) #<=> Bool1,
    (AC2 #= OD1 #\/ AC2 #= OD2) #<=> Bool2,
    Bool1 + Bool2 #= 1,

    AD1 #\= OC1, 
    AD1 #\= OC2,
    AD2 #\= OC1,
    AD2 #\= OC2,

    (AF1 #= OF1 #\/ AF1 #= OF2) #/\ (AF2 #= OF1 #\/ AF2 #= OF2) #/\ AF1 #\= AF2,

    (AA1 #= OB1 #\/ AA1 #= OB2) #<=> Bool3,
    (AA2 #= OB1 #\/ AA2 #= OB2) #<=> Bool4,
    Bool3 + Bool4 #>= 1,

    errori(Ordini, Arrivi, L),
    sum(L) #= Errori,
    append(Ordini, Arrivi, Z),
    minimize(labeling(Z), Errori).


errori([], [], []).
errori([O | OT], [A | AT], [E | ET]) :-
    E #<=> (O #\= A),
    errori(OT, AT, ET).

