{ pip(P) } :- package(P).

pip(P) :- install(P).
:- pip(A), requires(A, B), not pip(B).
:- conflict(A, B), pip(A), pip(B).

switch(P) :- package(P), pip(P), not installed(P).
switch(P) :- package(P), not pip(P), installed(P).

#minimize { 1, P : switch(P) }.

#show pip/1.
#show switch/1.