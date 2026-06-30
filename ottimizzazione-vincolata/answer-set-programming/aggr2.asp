% ASP sceglie un subset di {1, 2, ..., 10} la cui somma sia <= 10.

numeri(1).
numeri(N+1) :- numeri(N), N<100.

{scelto(N)} :- numeri(N).

:- sbagliato.

sbagliato :- #sum { X:scelto(X) } > 10.

#show scelto/1.

% #maximize { X : scelto(X) }.
#maximize { 1, X : scelto(X) }.

% Oppure

:~ scelto(X). [-X]
:~ scelto(X). [-1, X]
 