time(1 .. T - 1) :- endtime(T).

1 { schedule(O, T) : time(T) } 1 :- ordine(O, _).

:- schedule(A, T), schedule(B, T), A != B.
:- precedenza(A, B), schedule(A, T), schedule(B, S), T + 1 > S.
:- schedule(A, T), endtime(S), T + 1 > S.

gain(O) :- ordine(O, Deadline), schedule(O, S), S + 1 <= Deadline.

#maximize { 1, O : gain(O) }.
#show schedule/2.
#show gain/1.