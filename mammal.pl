:- dynamic animal/1.

animal("Morcego").
animal("Porco").
animal("Gato").
animal("Golfinho").

:- dynamic node/4.
node(1, "Terrestre", 2, 3).
node(2,"Bigodes", "Gato", "Porco").
node(3, "Voa", "Morcego", "Golfinho").

:- dynamic yes/1.
yes("Sim").

:- dynamic input/1.
input(Out) :- read(In),
    		  atom_length(In,L1), L is L1-1, 
    		  sub_atom(In, 0, 1, _, First),
    		  sub_atom(In, 1, L, _, Last),
    		  string_upper(First, Upper),
    		  atom_concat(Upper, Last, Atom),
    	      atom_string(Atom, Out).

:- dynamic start/0.
start :- write("Escreva sempre em minúscula com acentuação"), nl,
         ask(1).

:- dynamic ask/2.
ask(Id) :- animal(Id),
    	   end(Id).

ask(Id) :- 
    node(Id,Q,_,_),
    write(Q),
	input(Ans),
    yes(Ans) -> node(Id,_,Y,_), ask(Y); node(Id,_,_,N), ask(N).

:- dynamic end/1.
end(Id) :- write(Id), nl,
           write("É este animal?"),
    	   input(Ans),
    	   yes(Ans) -> write("Eu sabia!"); verify(Id).

:- dynamic verify/1.
verify(Id) :- write("Em que animal estavas a pensar?"),
    		  input(Ans),
    	      animal(Ans) -> path(Id, Ans); add(Ans).

:- dynamic path/2.
path(Id, Ans) :- write("--- "), write(Id), write(" ---"), nl,
                 showPath(Id),
				 write("--- "), write(Ans), write(" ---"), nl,
                 showPath(Ans),
                 write("Enganaste-te?"),
                 input(Ans),
                 yes(Ans) -> write("Eu sabia, eu estou sempre certo!"); add(Id).

:- dynamic showPath/1.
showPath(1).
showPath(Id) :- node(BY,QY,Id,_) -> write(QY), write(" Sim"), nl, showPath(BY);
    		    node(BN,QN,_,Id), write(QN), write(" Não"), nl, showPath(BN).

:- dynamic add/1.
add(Ans) :- write("Não o tenho: "), write(Ans).

:- dynamic save/0.
save :-
    tell('mammal.pl'),
    listing(animal),
    listing(node),
    listing(yes),
    listing(input),
    listing(start),
    listing(ask),
    listing(end),
    listing(verify),
    listing(path),
    listing(showPath),
    listing(add),
    listing(save),
    told.