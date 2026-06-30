reachable(1).
reachable(X) :- 
    reachable(Y),
    edge(Y, X).

#show reachable/1.