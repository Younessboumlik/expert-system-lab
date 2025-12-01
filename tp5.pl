symptome(fievre).
symptome(toux).
symptome(mal_gorge).
symptome(fatigue).
symptome(courbatures).
symptome(mal_tete).
symptome(eternuements).
symptome(nez_qui_coule).

maladie_stat(grippe,    [fievre, courbatures, fatigue, toux]).
maladie_stat(angine,    [mal_gorge, fievre]).
maladie_stat(covid,     [fievre, toux, fatigue]).
maladie_stat(allergie,  [eternuements, nez_qui_coule]).

symptome(p1, fievre).
symptome(p1, toux).
symptome(p1, fatigue).

diagnostic(Patient, Maladie) :-
    maladie_stat(Maladie, ListeSymptomes),
    forall(member(S, ListeSymptomes), symptome(Patient, S)).



:- dynamic reponse/2.

a_symptome(S) :-
    reponse(S, oui), !.

a_symptome(S) :-
    reponse(S, non), !, fail.

a_symptome(S) :-
    format("Avez-vous ~w ? (o/n) ", [S]),
    read(Repl),
    traiter_reponse(S, Repl).

traiter_reponse(S, o) :-
    assertz(reponse(S, oui)), !.

traiter_reponse(S, n) :-
    assertz(reponse(S, non)), !, fail.

traiter_reponse(S, _) :-
    writeln("Réponse invalide. Répondez par o ou n."),
    a_symptome(S).


maladie(grippe) :-
    a_symptome(fievre),
    a_symptome(courbatures),
    a_symptome(fatigue).

maladie(angine) :-
    a_symptome(mal_gorge),
    a_symptome(fievre).

maladie(covid) :-
    a_symptome(fievre),
    a_symptome(toux),
    a_symptome(fatigue).

maladie(allergie) :-
    a_symptome(eternuements),
    a_symptome(nez_qui_coule).



trouver_maladies(Liste) :-
    findall(M, maladie(M), Liste).




afficher_resultats([]) :-
    writeln("Aucune maladie detectee."), !.

afficher_resultats([M|R]) :-
    writeln("Maladie possible :"),
    writeln(M),
    expliquer(M),
    nl,
    afficher_resultats_rec(R).

afficher_resultats_rec([]) :- !.
afficher_resultats_rec([M|R]) :-
    writeln("Maladie possible :"),
    writeln(M),
    expliquer(M),
    nl,
    afficher_resultats_rec(R).



expliquer(Maladie) :-
    maladie_stat(Maladie, Symptomes),
    findall(S, (member(S, Symptomes), reponse(S, oui)), ListeConfirme),
    format(" Vous pourriez avoir ~w car : ~w~n", [Maladie, ListeConfirme]).



expert :-
    set_prolog_flag(encoding, utf8),     % (fix accents)
    retractall(reponse(_, _)),
    writeln("=== SYSTEME EXPERT MEDICAL ==="),
    trouver_maladies(Liste),
    afficher_resultats(Liste).