:- dynamic yes/1.
yes(yes).

:- dynamic animal/1.

animal("Morcego").
animal("Porco").
animal("Gato").
animal("Golfinho").

:- dynamic node/4.
node(1, "Terrestre", 2, 3).
node(2,"Doméstico", 4, 5).
node(3, "Voa", "Morcego", "Golfinho").
node(4, "Estimação", "Gato", "Porco").
node(5, "Quinta", "Porco", "Gato").

:- dynamic start/0.
start :- ask(1).

:- dynamic ask/1.
ask(Id) :- 
    animal(Id) -> write(Id), !; true,
    node(Id,Q,_,_),
    write(Q),
	read(Ans),
    yes(Ans) -> node(Id,_,Y,_), ask(Y); node(Id,_,_,N), ask(N).

:- dynamic save/0.
save :-
    tell('mammal.pl'),
    listing(animal),
    listing(save),
    told.