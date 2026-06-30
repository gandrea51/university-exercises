time(0 .. 30).

1 { start(T, S) : time(S) } 1 :- task(T, _, _, _).

:- task(T, _, Prec, _), start(T, S), Prec = [P | _], start(P, SP), task(P, DP), SP + DP > S.

:- task(T, _, Prec, _), start(T, S), member(P, Prec), start(P, PS), task(P, DP, _, _), PS + DP > S.

:- task(T1, D1, _, M1), task(T2, D2, _, M2), T1 != T2, start(T1, S1), start(T2, S2), S1 < S2 + D2, S2 < S1 + D1.

gain(M) :- #max { E, T: end(T, E) } = M.
#minimize{ 1, M : gain(M) }. 