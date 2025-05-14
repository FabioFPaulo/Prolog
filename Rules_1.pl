% john likes anyone who likes wine

likes(mary,wine).
likes(bob,beer).
likes(wini,apple).
likes(charlie,wine).

likes(john,X):-likes(X,wine).
