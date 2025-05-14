%---------------------------------------
% Actor Definitions
%---------------------------------------

actor('User').
actor('Student').
actor('Staff').
actor('Database').
actor('Librarian').

%---------------------------------------
% Use Case Definitions
%---------------------------------------
usecase('Authenticate').
usecase('Reserve a Book').
usecase('Request New Book').
usecase('Renew a Book').
usecase('Pay Fine').
usecase('Feedback').
usecase('Register New User').

usecase('Invalid Username or Password').
usecase('Invalid Renewal').
usecase('Fill up Feedback Form').
usecase('Get Library Card ID').
usecase('Fill up Register Form').

usecase('Add Book Item').
usecase('Delete Book Item').
usecase('Edit Book Item').
usecase('Update Catalog').

usecase('Send Overdue Notification').
usecase('Send Reservation Available Notification').
usecase('Send Reservation Canceled Notification').

%---------------------------------------
% Generalizations (Actor Inheritance)
%---------------------------------------
generalization('User', 'Student').
generalization('User', 'Staff').

%---------------------------------------
% Associations (Actor ↔ Use Case)
%---------------------------------------
association('User', 'Authenticate').
association('User', 'Reserve a Book').
association('User', 'Request New Book').
association('User', 'Renew a Book').
association('User', 'Pay Fine').
association('User', 'Feedback').
association('User', 'Register New User').

association('Send Overdue Notification', 'Database').
association('Send Reservation Available Notification', 'Database').
association('Send Reservation Canceled Notification', 'Database').

association('Add Book Item', 'Librarian').
association('Delete Book Item', 'Librarian').
association('Edit Book Item', 'Librarian').

%---------------------------------------
% Include Relationships
%---------------------------------------
include('Feedback', 'Fill up Feedback Form').
include('Register New User', 'Fill up Register Form').
include('Register New User', 'Get Library Card ID').
include('Add Book Item', 'Update Catalog').
include('Delete Book Item', 'Update Catalog').
include('Edit Book Item', 'Update Catalog').

%---------------------------------------
% Extend Relationships
%---------------------------------------
extend('Authenticate', 'Invalid Username or Password').
extend('Request New Book', 'Invalid Renewal').

%---------------------------------------
% Utility Predicates
%---------------------------------------

% Check if input is a valid actor or usecase.
actor_or_uc_in_list(A) :- (
    actor(A);
    usecase(A);
    false
).

% Format output for actors and usecases for UML
format_label(A) :- (
    actor(A) ->
        format('~w', [A]);
        usecase(A) ->
            format('(~w)', [A]);
            throw(format('Error: The actor or usecase ~w doesn\'t exists in actors or usecases list!~n', [A]))
).

%---------------------------------------
% Statistical Utilities
%---------------------------------------

% Combined statistics predicate
statistics(Cactors, Cusecases) :-
    findall(X, actor(X), List1),
    length(List1, Cactors),
    findall(X, usecase(X), List2),
    length(List2, Cusecases).


%---------------------------------------
% UML Code Generation
%---------------------------------------

% Print actors in plantUML format
write_actors :-
    forall(actor(A), (write('actor '), format_label(A), nl)).

% Print usecases in plantUML format
write_usecases :-
    forall(usecase(U),(tab(4), write('usecase '), format_label(U), nl)).

% Print associations in plantUML format
write_associations :-
    forall(
        association(A1, A2), 
        (tab(4), format_label(A1), write(' -- '), format_label(A2), nl)
    ).

% Print generalizations in plantUML format
write_generalizations :-
    forall(
        generalization(A1, A2), 
        (format_label(A1), write(' <|- '), format_label(A2), nl)
    ).

% Print includes in plantUML format
write_includes :-
    forall(
        include(A1, A2), 
        (tab(4), format_label(A1), write(' ..> '), format_label(A2), write(' : <<include>>'), nl)
    ).

% Print extends in plantUML format
write_extends :-
    forall(
        extend(A1, A2), 
        (tab(4), format_label(A1), write(' <.. '), format_label(A2), write(' : <<extend>>'), nl)
    ).


%---------------------------------------------
% Main Predicate to Generate plantUML Diagram
%---------------------------------------------
generate_uml:-
    write('#############################################\n'),
    nl,
    nl,
    (write('@startuml top_to_bottom'), nl),
    (write('skinparam packageStyle rectangle'), nl),
    (write('left to right direction'), nl, nl),
    write_actors,
    nl,
    write_generalizations,
    nl,
    (write('rectangle {'), nl),
    write_usecases,
    nl,
    nl,
    write_associations,
    nl,
    nl,
    write_includes,
    nl,
    nl,
    write_extends,
    (write('}'), nl),
    (write('@enduml'), nl),
    nl,
    nl,
    write('#############################################\n').


%---------------------------------------
% Display Statistics
%---------------------------------------
print_counts:-
    write('#############################################\n'),
    nl,
    nl,
    statistics(Cactors, Cusecases),
    format('Actors: ~w~n', [Cactors]),
    format('Usecases: ~w', [Cusecases]),
    nl,
    nl,
    write('#############################################\n').



%---------------------------------------
% Simple Menu System
%---------------------------------------
init :-menu.

menu :-
    write('#############################################\n'),
    nl,
    write('>> 1. Generate UML'),
    nl,
    write('>> 2. Statistics'),
    nl,
    write('>> 0. End Session'),
    nl,
    write('#############################################\n'),
    nl,
    read(A),
    doing(A).

% Perform action based on menu input
doing(A) :-
    ( A==1,
    generate_uml,
    nl,
    menu
    ; A == 2,
    print_counts,
    nl,
    nl,
    menu
    ; A==0,
    exit,
    true
).

% Exit the Prolog session
exit :-
    halt.