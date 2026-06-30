:- lib(fd).

minore(A, B) :-

	dvar_domain(A, DomA), 
    	dom_range(DomA, MinA, MaxA),
    	MinA1 is MinA + 1, 
    	dvar_remove_smaller(B, MinA1),

  	dvar_domain(B, DomB),
    	dom_range(DomB, MinB, MaxB),
    	MaxB1 is MaxB - 1,
    	dvar_remove_greater(A, MaxB1),

    	(var(A), var(B)
        	-> suspend(minore(A, B), 5, [A -> fd:min, B -> fd:max])
        	; true
    	).

diverso(A, B) :- ground(A), !, dvar_remove_element(B, A).
diverso(A, B) :- nonvar(B), !, dvar_remove_element(A, B).
diverso(A, B) :- suspend(diverso(A, B), 3, [A, B] -> suspend:inst). 

% X #=< Y #<==> B
leq(X, Y, B) :- nonvar(B), B = 0, !, X #> Y.
leq(X, Y, B) :- nonvar(B), B = 1, !, X #=< Y.
leq(X, Y, B) :- 
	dvar_domain(X, DomX),
	dom_range(DomX, MinX, MaxX),
	dvar_domain(Y, DomY),
	dom_range(DomY, MinY, MaxY),
	(MaxX =< MinY
		-> B = 1
		; (MinX > MaxY 
			-> B = 0
			; suspend(leq(X, Y, B), 4, [[X, Y, B] -> fd:min, [X, Y, B] -> fd:max])
		 )
	).