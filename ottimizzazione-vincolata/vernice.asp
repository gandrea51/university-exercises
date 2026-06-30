car(1,red).
car(2,blue).
car(3,yellow).
car(4,red).
car(5,yellow).
car(6,blue).
car(7,red).

maxd(2).

% --- Start ---

pos(N) :- car(N, _).
1 { position(Now, Before, Color) :  pos(Now)} 1 :- car(Before, Color).

:- position(Now, Before, _), | Now - Before | >= D, maxd(D).
:- position(Now, Before1, _), position(Now, Before2, _), Before1 != Before2.

switch(N) :- position(N, _, Color1), position(N + 1, _, Color2), Color1 != Color2.
#minimize { 1, N : switch(N) }.

#show position/3.