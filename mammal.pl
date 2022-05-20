:- dynamic animal/1.
animal("Morcego").
animal("Porco").
animal("Gato").
animal("Golfinho").

:- dynamic node/4.
node(1, "Terrestre", 2, 3).
node(2,"Bigodes", "Gato", "Porco").
node(3, "Voa", "Morcego", "Golfinho").

:- dynamic userPath/3. %Only stored while running

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
start :- write("> Escreva sempre em minúscula com acentuação entre áspas <"), nl,
         ask(0,1), retractall(userPath(_,_,_)).

:- dynamic ask/2.
ask(Last, Id) :- animal(Id),
    	           end(Last, Id).

ask(_,Id) :- node(Id,Q,_,_),
   		 write(Q),
		 input(Ans),
    		 yes(Ans) -> node(Id,_,Y,_), assert(userPath(Id,Y,true)), ask(Id,Y); 
    				 node(Id,_,_,N), assert(userPath(Id,N,false)), ask(Id,N).

:- dynamic end/1.
end(Id, An) :- write(An), nl,
           	   write("É este animal? "),
    	         input(Ans),
    	         yes(Ans) -> write("Eu sabia!"); verify(Id, An).

:- dynamic verify/1.
verify(Id, An) :- write("Em que animal estavas a pensar? "),
    		      input(Ans),
    			verify(Id,An,Ans).

verify(Id,An,Ans) :- animal(Ans) -> path(Id, An, Ans); add(Id, An, Ans).

:- dynamic path/2.
path(Id, An, NewAn) :- write("--- "), write(NewAn), write(" ---"), nl,
                       showAllPath(NewAn),
		           write("--- "), write("As tuas respostas"), write(" ---"), nl,
                       showUserPath(Id),
                       write("Enganaste-te? "),
                       input(Ans),
    		     	     path(Id, An, NewAn, Ans).

path(Id, An, NewAn, Ans) :- yes(Ans) -> write("Eu sabia, eu estou sempre certo!"); 
     						    add(Id, An, NewAn).

:- dynamic showAllPath/1.
showAllPath(An) :- getAllPath(An, List),
    			 showAll(List, An, 1).

:- dynamic getAllPath/2.
getAllPath(Input, List) :- findall(B, node(B,_,Input,_); node(B,_,_,Input), List).

:- dynamic showAll/2.
showAll([],_,_).

showAll([X|XS], An, Num) :- write("Caminho "), write(Num), nl,
    				    showFirst(X, An),
    				    showPath(X), nl,
    				    N is Num + 1,
    				    showAll(XS,An,N).

:- dynamic showFirst/2.
showFirst(Id, An) :- node(Id,Q,_,An), write(Q), write(" Não"), nl.

showFirst(Id, An) :- node(Id,Q,An,_), write(Q), write(" Sim"), nl.

:- dynamic showPath/1.
showPath(1).

showPath(Id) :- node(BY,QY,Id,_) -> write(QY), write(" Sim"), nl, showPath(BY);
    		    node(BN,QN,_,Id), write(QN), write(" Não"), nl, showPath(BN).

:- dynamic showUserPath/1.
showUserPath(Id) :- animal(Id) ,
    			  write(Id), nl.

showUserPath(Id) :- node(Id,Q,_,_),
    			  userPath(Id,Nxt,Ans),
    			  showUserPath(Nxt),
    			  write(Q), write(": "),
    		        (Ans == true) -> write("Sim"), nl; 
    					       write("Não"), nl.
    				
:- dynamic add/3.
add(Id, An, NewAn) :- write("Não tenho esse animal, faça uma pergunta que o animal "), write(NewAn),
    			    write(" tenha e que o animal "), write(An), write(" não tenha: "),
    		          input(Ans),
    			    add(Id, An, NewAn, Ans).

:- dynamic add/4.
add(Id, An, NewAn, Ans) :- node(Id,Q,An,Other),
    			         getId(L),
				   retract(node(Id,Q,An,Other)),
    				   assert(node(Id,Q,L,Other)),
    				   assert(node(L,Ans,NewAn,Ans)),
    				   assert(animal(NewAn)).

add(Id, An, NewAn, Ans) :- node(Id,Q,Other,An),
    				   getId(L),
				   retract(node(Id,Q,Other,An)),
    				   assert(node(Id,Q,Other,L)),
    				   assert(node(L,Ans,NewAn,Ans)),
    				   assert(animal(NewAn)).

:- dynamic getId/1.
getId(L) :- findall(X,animal(X),P), length(P,L1), L is L1 + 1.

:- dynamic save/0.
save :-
    tell('mammal.pl'),
    listing(animal),
    listing(node),
    listing(userPath),
    listing(yes),
    listing(input),
    listing(start),
    listing(ask),
    listing(end),
    listing(verify),
    listing(path),
    listing(showAllPath),
    listing(getAllPath),
    listing(showAll),
    listing(showFirst),
    listing(showPath),
    listing(showUserPath),
    listing(add),
    listing(getId),
    listing(save),
    told.