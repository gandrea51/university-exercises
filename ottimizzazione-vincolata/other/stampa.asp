1 { start(I, T) : tempo(T). T >= EST, T + D <= LCT } 1 :- task(I, EST, LCT, D).

:- start(I, S1), start(J, S2), I < J, task(I, _, _, D1), task(J, _, _, D2), S1 < S2+D2, S2 < S1+D1.

dist(I, J, D) :- start(I, S1), start(J, S2), task(I, _, _, D), S1+D <= S2, D = S2 - (S1+D).
dist(I, J, D) :- start(I, S1), start(J, S2), task(J, _, _, D), S2+D <= S1, D = S1 - (S2+D).

minimo(D) :- D #min { X, I, J : dist(I, J, X) }.

#maximize{ D : minimo(D) }.

% ... oppure con il makespan

end(I, E) :- start(I, S), task(I, _, _, D), E = S + D.
makespan(M) :- #max { E : end(_, E) } = M.
#minimize{M:makespan(M)}.