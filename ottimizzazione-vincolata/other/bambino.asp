impegno(1,2).
impegno(1,3).
impegno(1,7).
impegno(1,8).
impegno(1,10).
impegno(1,11).
impegno(1,12).
impegno(1,15).
impegno(1,20).
impegno(1,21).
impegno(1,23).
impegno(1,25).
impegno(1,28).
impegno(1,30).
impegno(2,1).
impegno(2,3).
impegno(2,4).
impegno(2,6).
impegno(2,7).
impegno(2,10).
impegno(2,11).
impegno(2,13).
impegno(2,14).
impegno(2,16).
impegno(2,17).
impegno(2,18).
impegno(2,19).
impegno(2,20).
impegno(2,23).
impegno(2,27).
impegno(2,28).
impegno(2,29).
impegno(2,30).

giorno(1 .. 30).
opzione(1 .. 4).

1 {bambino(X, O) : opzione(O)} 1 :- giorno(X).

:- impegno(Gen, Giorno), bambino(Giorno, Gen).

:- #count {Giorno : bambino(Giorno, 1)} > 4.
:- #count {Giorno : bambino(Giorno, 2)} > 6.

:- bambino(Giorno1, 3), bambino(Giorno2, 3), Giorno2 - Giorno1 >= 7.

asilo :- bambino(Giorno, 3).

baby(P) :- #count {G : bambino(G, 4)} = Gbaby, P = Gbaby * 5.

prezzo(C) :- baby(C), not asilo.
prezzo(C) :- baby(C1), asilo, C = C1 + 10.

#minimize {C : prezzo(C)}.