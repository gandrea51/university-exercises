ordine(1,10).
ordine(2,15).
ordine(3,12).
ordine(4,8).
ordine(5,13).
ordine(6,5).
ordine(7,10).
ordine(8,3).
ordine(9,6).
ordine(10,4).
ordine(11,7).
ordine(12,14).
ordine(13,8).
ordine(14,15).

precedenza(1,5).
precedenza(5,3).
precedenza(7,4).
precedenza(5,10).
precedenza(13,14).

endtime(20).

time(0 .. T - 1) :- endtime(T).

1 { choose(ID, T) : time(T) } 1 :- ordine(ID, _).

:- choose(I1, T), choose(I2, T), I1 != I2.
:- precedenza(One, Two), choose(One, T1), choose(Two, T2), T2 < T1 + 1.
:- choose(I, T), endtime(E), T + 1 > E.

guadagno(I) :- ordine(I, Deadline), choose(I, T), T + 1 <= Deadline.
#maximize { 1, I : guadagno(I) }.

#show choose/2.