.. Tableau des résultats

Tableau des résultats
=====================

Affichage des résultats de la recherche
---------------------------------------

Sous l’onglet **[Résultats]**, les résultats de la recherche sont affichés sous forme de tableau. 

.. image:: ../../images/visualisation/visu-tableau.png

La liste des résultats est paginée, à raison de 20 lignes par page. La navigation entre les pages de résultats se fait via les flèches au bas de la grille.

En cliquant à côté des titres des colonnes, il est possible d’**ordonner l’affichage des résultats** selon les valeurs de la colonne sélectionnée.

.. image:: ../../images/visualisation/visu-tableau-tri.png

Il est aussi possible de **masquer des colonnes** en les décochant.

.. image:: ../../images/visualisation/visu-tableau-masquer-colonnes.png

Vous pouvez **déplacer les colonnes** si vous le souhaitez en les **glissant/déposant**.

Les icônes en début de ligne permettent d’afficher la fiche détaillée de l’observation, de la visualiser sur la carte, ou de l’éditer. Selon les droits de l’utilisateur, elles ne sont pas toujours toutes disponibles.

.. image:: ../../images/visualisation/visu-tableau-boutons.png

.. note:: Il est possible qu’une donnée ne comporte pas de géométrie, dans ce cas l’icône [Voir sur la carte] est grisée et inactive.

.. warning:: Attention, selon les droits de l’utilisateur, certaines valeurs de champs géométriques d’observations sensibles seront floutées (i.e : cachées). 

Par exemple, si l’application a déterminé qu’une observation est sensible et qu’elle ne peut pas être visualisée à une échelle plus précise que celle de la maille, les champs *codeCommune*, *codeCommuneCalcule*, *nomCommune*, *nomCommuneCalcule*, et *geometrie* afficheront une constante cachant l’information réelle.



Export des résultats
--------------------

En haut à droite du tableau, un menu déroulant permet d’exporter les résultats au format CSV. Les données sont sous forme tabulaire, les valeurs sont séparées par des ”;”.


.. note:: Les géométries seront exportées en Web Mercator (EPSG 3857).

.. note:: Le processus d’export des résultats est asynchrone pour les exports volumineux. Le processus peut être lancer sans être bloquant pour l’utilisateur qui peut continuer à naviguer sur l’application. Lorsque le processus d’export est terminé une notification est envoyée à l’utilisateur.
