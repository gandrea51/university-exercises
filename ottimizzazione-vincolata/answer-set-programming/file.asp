% Esercizio CD-ROM

file(1, 120).
file(2, 200).
file(3, 350).
file(4, 100).

{ scegli(N) } :- file(N, _).

:- #sum { S, N : scegli(N), file(N, S) } < 600.
#maximize { S, N : scegli(N), file(N, S) }.