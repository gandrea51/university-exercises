1 { abbina(P, T) : team(T) } 1 :- progetto(P).

:- team(T), #count { abbina(P, T) : progetto(P) } > 3.
:- richiede(P, T), not abbina(P, T).
:- incompatibile(P, T), abbina(P, T).

gain(A, B) :- collabora(A, B), abbina(A, T), abbina(B, T).
#maximize { 1, A, B : gain(A, B) }.

#show abbina/2.
#show gain/2.

