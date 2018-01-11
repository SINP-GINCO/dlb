.. Requêtes

Requêtes
========

Le volet gauche du module de visualisation des données comprend un **requêteur** [1], un **formulaire de requêtes simples** [2] qui permet de sélectionner et de croiser les critères d’une recherche sur l’ensemble des champs du standard de données brutes de biodiversité. Le formulaire de requêtes permet aussi de sélectionner les champs affichés dans le tableau de résultat des requêtes.

.. image:: /images/visualisation/accueil_requeteur.png
   :scale: 50%


Organisation du formulaire de requêtes simples
----------------------------------------------

L’ensemble des champs du standard de données brutes de biodiversité sont organisés en sous-groupes logiques dans le formulaire : 

* Observation, 
* Localisation, 
* Regroupements, 
* Standardisation, 
* Autres.

Pour chacun de ces sous-groupes, il est possible de sélectionner :

**1.** Dans le menu déroulant **[Critères]**, un ou plusieurs champs sur lesquels requêter 

**2.** Dans le menu déroulant **[Résultats]**, un ou plusieurs champs à afficher dans l’onglet [Résultats] où apparaîtra le tableau des résultats.


Critères de recherche
"""""""""""""""""""""

Selon le critère sélectionné, le type de champ de saisie sera différent (menu déroulant, champ texte, calendrier…)

Par exemple dans le formulaire [Observation], en choisissant le critère « jourDateDebut » il est possible de saisir le champ recherché soit directement via le champ texte soit via un calendrier.

.. warning:: Si aucun critère de recherche n’est sélectionné, toutes les données possibles sont retournées.

.. note:: Il existe 2 processus de filtrage sur les critères de type texte :

   * Sur la plupart des champs, le processus de filtrage du motif saisi est réalisé sur l’intégralité de la chaîne de caractère du champ sélectionné. Par exemple une recherche sur le motif “Pierre” peut donner comme résultat “Jean-Pierre”, “Pierre MARTIN”...
   * Sur les champs texte correspondant à des clés ou à des identifiants de données, le processus de filtrage est réalisé sur le motif exact saisi.  Une recherche sur le motif “1234” ne retourne pas les données dont le champ comprend le motif (exemple “12345”).

.. tip:: Pour sélectionner une heure entre 20:00 et 5:00 du matin il faut utiliser deux fois le critère de recherche sur l’heure. La première fois entre 20:00 et 23:59 et la seconde fois entre 00:00 et 5:00.


Critère de recherche géométrique
""""""""""""""""""""""""""""""""

Dans le **formulaire [Localisation]** le critère **« geometrie »** permet de définir un **polygone** que les géométries des observations doivent intersecter pour correspondre au critère.

.. image:: /images/visualisation/requete_polygone.png
   
**Définir un polygone**

**1.** Sélectionnez le critère « geometrie » [1]

**2.** Cliquez sur l’icône représentant un crayon à côté du champ « geometrie » [2]

Cela active le traçage d’une géométrie sur la carte, que vous pouvez moduler en utilisant votre souris et fait apparaître une barre d’icônes en haut de la carte, dont le fonctionnement est le suivant. 

**Fonctionnement du traçage d’une géométrie sur la carte**

* **Zoomer sur la sélection** [3] : Lorsque l’on clique sur cette icone, l’emprise de la carte est redéfinie à celle de la géométrie de recherche si elle existe.
* **Snapping** [4] : Ce bouton active la saisie le long d’une autre géométrie. La liste déroulante à côté de l’icône permet de choisir la couche sur laquelle accrocher la géométrie. Les contours des entités de la couche sélectionnée apparaissent en bleu sur la carte, et lorsqu’on approche la souris de l’un d’eux, le point bleu correspondant à la géométrie que l’on va tracer se positionne dessus.
* **Modifier la géométrie** [5] : Lorsque cette icone est active, la souris permet de modifier le contour de la géométrie de recherche. Pour cela, il faut cliquer sur le contour avec la souris, puis la déplacer sans relâcher le clic.
* **Sélectionner une géométrie** [6] : Une géométrie non sélectionnée a un contour jaune. Une géométrie se sélectionne en cliquant dessus avec la souris. Une fois sélectionnée, le contour apparaît en bleu.
* **Dessiner un polygone** [7] : Un clic simple sur la carte ajoute un sommet au polygone, un double clic ferme le polygone en ajoutant un sommet. Il est possible de dessiner plusieurs polygones pour un même critère de recherche.
* **Sélectionner un contour sur la couche sélectionnée** [8] : Au lieu de dessiner un polygone à la main sur la carte, cet outil permet de sélectionner une couche dans la liste déroulante (espace naturel ou limite administrative), puis de sélectionner une entité sur la couche choisie en cliquant avec la souris sur la carte. Pour visualiser les entités, il est préférable d’afficher également la couche sur la carte via l’arbre des couches du panneau [Couches & légendes], à droite.
* **Effacer la géométrie** [9] : Lorsqu’une géométrie de recherche est sélectionnée, il est possible de la supprimer en cliquant sur cette icone.


Résultats à afficher dans le tableau de résultat
""""""""""""""""""""""""""""""""""""""""""""""""

Il est possible de filtrer les colonnes de résultats. Pour ce faire, plusieurs moyens sont disponibles :

* De la même façon que pour ajouter un critère, on ajoute une colonne au tableau des résultats en le sélectionnant dans la liste déroulante **[Résultats]** [1].
* Le **bouton [+]** est un raccourci permettant d’ajouter tous les champs (colonnes) disponibles d’un coup [2].
* Le **bouton [-]** est un raccourci permettant de supprimer tous les champs d’un coup [3].
* Chaque **bouton [corbeille]** permet de désélectionner le champ correspondant [4].

.. image:: /images/visualisation/requete_resultat.png

Par défaut, certains champs de résultats sont sélectionnés. Il s’agit des champs obligatoires du standard de donnée brute de biodiversité.

.. warning:: Afin de pouvoir effectuer une requête, il faut sélectionner dans le menu déroulant [Résultats] au moins une colonne à afficher dans l’onglet des résultats [5].


Exécuter une recherche
----------------------

* Le bouton **[Rechercher]** au bas du requêteur permet de lancer la recherche [1]. 
* Le bouton **[Annuler]** permet d’arrêter une recherche en cours [2]. 
* Enfin, **[Réinitialiser]** permet de recharger les valeurs par défaut du requêteur [3].

.. image:: /images/visualisation/recherche.png

Les résultats de la recherche sont visibles au centre de la page de visualisation, sous forme cartographique dans l’onglet **[Carte]** [4], et sous forme tabulaire dans l’onglet **[Résultats]** [5].

.. note:: En fonction du nombre de données en base, une recherche basée sur des critères de filtre très larges peut prendre jusqu’à plusieurs minutes à s’exécuter.


Requêtes enregistrées
---------------------

L’onglet **[Requêtes enregistrées]** se situe en haut à gauche de la page, et à gauche de l’onglet **[Consultation]**.

Il permet d’accéder à :

* Quelques recherches courantes pré-enregistrées dans l’application ;
* Les requêtes privées enregistrées par l’utilisateur ;
* Les requêtes publiques pré-enregistrées.

Requêtes pré-enregistrées
"""""""""""""""""""""""""

*Page en cours de construction*

Permissions sur les requêtes
""""""""""""""""""""""""""""

Un utilisateur de la plateforme peut :

* Gérer ses requêtes privées ; il peut donc les créer, les éditer et les supprimer.
* Utiliser (i.e. rechercher avec) les requêtes publiques pré-enregistrées


Rechercher en utilisant une requête enregistrée
"""""""""""""""""""""""""""""""""""""""""""""""

Le panneau des requêtes enregistrées range les requêtes dans différents groupes :

* Groupe **“Recherches sauvegardées privées”** ;
* Groupe **“Recherches sauvegardées publiques”** ;

Sur l’onglet des requêtes enregistrées, lorsqu’on sélectionne une requête en cliquant dessus, les critères de recherche pré-enregistrés correspondants apparaissent à droite de la page. Il est alors possible de modifier une ou plusieurs valeurs ou de les laisser telles quelles (vides ou avec leur valeur par défaut), puis de lancer la recherche en cliquant sur le bouton “Rechercher”.
Une fois la recherche lancée, le module de visualisation a le même comportement que lorsque la recherche est effectuée via le requêteur.

Sauvegarder une recherche
"""""""""""""""""""""""""

Après avoir défini une requête dans le requêteur (choix des critères et de leur valeur, choix des colonnes à afficher dans le tableau des résultats), il est possible d’enregistrer cette requête. Pour cela, il faut déplier le panneau “Enregistrer la requête”. Il permet d’indiquer :

* le nom de la requête enregistrée,
* sa description.

La requête est sauvegardée en cliquant sur **[Enregistrer]**. L’application charge alors l’onglet **[Requêtes prédéfinies]**, et enregistre la requête dans le groupe **[Recherches sauvegardées]**.


Modifier une recherche
""""""""""""""""""""""

Pour modifier une recherche enregistrée :

**1.** Allez sur l’onglet **[Requêtes prédéfinies]**.

**2.** Cliquez sur l’icône **[Modifier]** de la requête à éditer.

   # L’application redirige alors sur l’onglet **[Consultation]**, et charge les paramètres de la recherche dans le requêteur. 

**3.** Vous pouvez alors modifier les critères ou colonnes de recherche, ainsi que le nom et la description de la recherche via le panneau **[Enregistrer la recherche]**. 

**4.** Lorsque vous cliquez sur **[Enregistrer]**, l’onglet **[Requêtes enregistrées]** apparaît à nouveau avec la requête mise à jour.


Supprimer une recherche
"""""""""""""""""""""""

**1.** Cliquez sur l’onglet **[Requêtes enregistrées]**. 

**2.** Cliquez sur le bouton **[Supprimer]** d’une requête enregistrée. 

L’application supprime alors la requête et rafraîchit la page.


