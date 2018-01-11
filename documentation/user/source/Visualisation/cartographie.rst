.. Cartographie

Cartographie
============

Le centre de la page de visualisation des données est occupé par la cartographie (onglet **[Carte]**), avec à sa droite, la **liste des couches cartographiques**.

Couches et légendes
-------------------

Le panneau à droite de la carte est découpé en deux onglets : **[Couches] et [Légendes]** [1]. 

.. image:: /images/visualisation/couche_legende.png

Pour l’onglet **[Couches]**, seules sont affichées les couches sélectionnées et activées (non grisées). Il permet de masquer les couches que vous ne souhaitez pas afficher en les désélectionnant, et inversement.

* La couche **« Résultats de la recherche »** est activée lorsqu’une recherche est exécutée [2].
* Les couches regroupées dans les **« Limites administratives »** (“Régions”, “Départements”, “Communes”) [3] s’activent selon le **niveau de zoom**.
* Les couches correspondant à des **espaces naturels (EN)** [4] sont regroupées par catégories. Vous pouvez changer l’ordre de superposition des couches sur la carte, en effectuant un glisser-déposer des couches dans l’arbre.

.. note:: Les dates d’édition des couches EN sont disponibles `ici <https://www.geoportail.gouv.fr/depot/fiches/mnhn/actualite_donnees_mnhn.pdf>`_.

L’opacité des couches est modifiable en cliquant avec le bouton droit de la souris sur l’intitulé de la couche, puis en déplaçant le curseur.

Vous pouvez **masquer totalement le panneau** en cliquant sur le symbole représentant deux chevrons vert en haut à droite du panneau [5].


Affichage des résultats d'une recherche sur la carte
----------------------------------------------------

Lorsqu’une recherche est effectuée, les couches « Mailles », « Départements », « Géométries précises », et « Communes », sont activées. Ce sont les **bacs de visualisation des résultats de recherche**.

.. warning:: La couche « Géométries précises » n’est pas accessible pour l’utilisateur Grand public non authentifié.

Les résultats de la recherche sont affichés sur la carte en fonction de leurs géométries précises et de leurs rattachements géo-administratifs. Les départements sont affichés en bleu les mailles en vert, les communes en jaune, et les géométries précises en rouge.

.. image:: /images/visualisation/visu-carto-recherche.png

Selon le niveau de zoom, du plus haut au plus bas, le résultat sera placé soit dans son ou ses département(s), puis dans sa ou ses maille(s), puis dans sa ou ses commune(s), et enfin sa géométrie précise sera affichée.

Voici une idée de la visualisation des **résultats de recherche à la maille** :

.. image:: /images/visualisation/visu-carto-recherche-maille.png

Un zoom supplémentaire permet de visualiser la ou les **communes** du résultat :

.. image:: /images/visualisation/visu-carto-recherche-commune.png

Enfin un zoom maximal affiche la **géométrie précise** de l’observation (ici, un polygone situé sur plusieurs communes) :

.. image:: /images/visualisation/visu-carto-recherche-geometrie.png

.. warning:: Attention, certaines observations sensibles seront floutées (i.e : non affichées) à partir d’une certaine échelle. Par exemple, si l’application a déterminé qu’une observation est sensible et qu’elle ne peut pas être visualisée à une échelle plus précise que celle de la maille, un zoom poussé pour voir la commune de l’observation ou sa géométrie précise n’affichera rien.


Naviguer sur la carte
---------------------

En haut à droite de la carte : 

* Le premier bouton permet de **centrer la carte sur les résultats de la recherche**,
* Le deuxième de **dézoomer** au maximum, 
* Le troisième d’**imprimer la carte**.

.. image:: /images/visualisation/visu-carto-barre-outils.png


Table attributaire d'une localisation
-------------------------------------

A partir d’un niveau de zoom suffisamment précis, il est possible d’afficher la table attributaire des données d’une localisation en cliquant dessus. Lorsque plusieurs observations correspondent à l’endroit cliqué, elles apparaissent toutes dans la table.

.. image:: /images/visualisation/visu-carto-table-attributaire.png