.. Le floutage des données

Le floutage des données
=======================

Le floutage des données est une fonctionnalité mise en place en accord avec les **règles de diffusion et de floutage du SINP**.

Il consiste à masquer certaines informations de localisation via des filtres qui agissent sur :

* les critères de requête
* les résultats affichés dans le tableau de résultats
* les résultats affichés sur la carte
* le contenu des fiches de détails
* le contenu des exports de résultats

Selon les principes établis dans le cadre du SINP, un **niveau de sensibilité** est calculé et attribué automatiquement aux données. Le niveau de sensibilité, qui correspond à un degré de menace à la diffusion de la donnée, détermine dynamiquement l’affichage des données dans chaque bac de visualisation.

*Exemple* : Si un niveau 2 de sensibilité est attribué à une donnée, seules les informations à la maille et aux échelles inférieures (Département) sont affichées. 

Cela se matérialise par :

* l’impossibilité de voir la donnée sur la couche « Géométrie précise » et sur la couche « Commune »
* le remplacement dans le tableau de résultats, dans les fiches de détails et les exports des valeurs non-visualisables par une valeur constante ne donnant aucune information.
