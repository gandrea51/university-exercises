linea(cl).
linea(ac).
linea(ns).

durata(cl, 20).
durata(ac, 80).
durata(ns, 50).
tempo(0 .. 1000).

task(T) :- rich(T, _, CL, AC, NS), CL = 1.
task(T) :- rich(T, _, CL, AC, NS), AC = 1.
task(T) :- rich(T, _, CL, AC, NS), NS = 1.

task(T, cl) :- rich(T, _, 1, _, _).
task(T, ac) :- rich(T, _, _, 1, _).
task(T, ns) :- rich(T, _, _, _, 1).

consegna(T, C) :- rich(T, C, _, _, _).

{start(T, L, S) : tempo(S)} 1 :- task(T, L).

:- start(T, L, S), consegna(T, C), durata(L, D), S + D > C.

