% Graph Coloring 

near(1,2).
near(1,3).
near(2,3).
near(2,4).
near(2,5).
near(3,4).

nodo(1).
nodo(2).
nodo(3).
nodo(4).
nodo(5).

% --- Versione 1 con i colori

color(X, red) :- nodo(X), not color(X, green), not color(X, yellow).
color(X, green) :- nodo(X),not color(X, red), not color(X, yellow).
color(X, yellow) :- nodo(X),not color(X, green), not color(X, red).

:- near(X, Y), color(X, C), color(Y, C).

% --- Versione 2 con le palette

{ color(N, C) } :- nodo(N), palette(C).

:- nodo(N), not colorato(N).
:- near(X, Y), color(X, C), color(Y, C).
:- color(N, C), color(N, C1), C != C1.

colorato(N) :- color(N, C).

#show color/2.
#show near/2.
