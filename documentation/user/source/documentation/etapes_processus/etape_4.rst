.. Etape 4 : Versement des données sur la plateforme de Dépôt légal de biodiversité

.. _versement_jdd:

Etape 4 : Versement des données sur la plateforme de Dépôt légal de biodiversité
================================================================================

I. Présentation générale du processus de versement des données
--------------------------------------------------------------

.. |icone_verser| image:: ../../images/icone_verser.png
               :width: 3 em

.. raw:: html

   <video controls src="../../_static/processus_dbb_ginco.mp4" width=100% frameborder="0" allowfullscreen></video>
   
   
**1.** Allez sur la plateforme de Dépôt, en cliquant via Métadonnées sur le lien « Voir dans Ginco » |icone_verser| ou directement via https://depot-legal-biodiversite.naturefrance.fr/test/ 

**2.** Sélectionnez le jeu de données à importer, puis choisissez le format de fichier à importer (CSV ou SHAPEFILE), le système de référence (SRID) utilisé, et validez.

.. warning:: Les fichiers exportés via GeoNature ont pour système de référence WGS 84 : 4326

**3.** Si votre fichier ne comporte pas d’erreur, déposez vos jeux de données. Sinon téléchargez le rapport d’erreur et corrigez votre fichier selon les indications du rapport.

**4.** A la suite du dépôt téléchager le certificat de dépôt du jeu de données.


II. Présentation détaillée du processus de versement des données
----------------------------------------------------------------

Une fois que le cadre d’acquisition du(des) jeu(x) de données et le(les) jeu(x) de données correspondant(s) à l’étude d’impact indiquée sur demarches-simplifiees.fr sont édités, les données peuvent être versées dans la plateforme Ginco de Dépôt légal de biodiversité.

Pour accéder à la plateforme de Dépôt légal de biodiversité, cliquez sur `ici <https://depot-legal-biodiversite.naturefrance.fr/>`_.
Une fois connecté avec votre identifiant INPN, plusieurs onglets sont visibles.

.. image:: ../../images/DLB_accueil_connexion.png

II.1. Sélectionner et importer un jeu de données via l'identifiant du dossier de demarches-simplifiees.fr 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

.. note:: Il est possible de passer cette étape en cliquant sur [Voir dans GINCO] sur l’application métadonnées SINP. Cette action permet d’accéder directement à la plateforme de Dépôt légal et d’utiliser le jeu de données sélectionné pour l’importer dans la plateforme.

Dans la barre de menu située en haut de la page, l’onglet [Jeux de données] vous offre plusieurs possibilités. 

Sélectionner un jeu de données
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 

**1.** Pour sélectionner un jeu de données, cliquez sur [Importer des données].

.. image:: ../../images/DLDBB_creer_jdd.png

**2.** Indiquez le numéro de dossier de demarches-simplifiees.fr et le jeu de données dans lequel vous souhaitez insérer votre fichier de données brutes. 

Si vous souhaitez créer une nouvelle fiche de métadonnée de jeu de données, un lien vers l’application de métadonnées de l’INPN vous est proposé.

**3.** Validez le formulaire via le bouton [Importer des données].

.. image:: ../../images/DLDBB_jdd_tps.png


Choix du format du fichier à importer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Une fois le choix du jeu de données à importer est fait, vous devez choisir le format sous lequel vous souhaitez l’importer. Deux formats de fichier sont possibles : csv ou shapefile.

**1.** Choisissez le format en cliquant sur l’onglet correspondant. 

.. image:: ../../images/DLDBB_jdd_format.png

**2.a.** Si vous choisissez de transmettre votre ou vos fichiers en format csv, sélectionnez le fichier, renseignez le système de référence (SRID) de vos données (code EPSG des géométries des observations), puis cliquez sur [Valider].
Un encart d’informations succinctes situé plus bas présente les principaux systèmes de référence utilisés Les données seront automatiquement converties en WGS84 lors de l’import dans la plateforme

.. warning:: Les fichiers doivent peser moins de 150 Mo.

Vous pouvez télécharger un fichier d’exemple pour chaque fichier demandé, contenant :

* Une ligne d’en-tête avec les noms des champs définis dans la configuration du fichier d’import,
* Une ligne commentée indiquant leur caractère obligatoire (signalé par une étoile), et le format des dates.

**2.b.** Si vous choisissez de transmettre votre ou vos fichiers en format shapefile, sélectionnez le fichier, puis cliquez sur [Valider].

.. warning:: Les fichiers Shape doivent, pour être acceptés par l’application, comprendre un fichier .prj indiquant le système de coordonnées utilisé.


Ouverture d’une nouvelle page « Gérer mes jeux de données »


Transférer votre ou vos fichier(s)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Une fois le choix du format de fichier effectué, les informations nécessaires renseignées, et que vous avez validé ces éléments, le transfert du fichier se fait automatiquement. 

**1.** Le transfert du fichier peut prendre un certain temps en fonction de sa taille. Une barre de progression indique le pourcentage des traitements réalisés et de données importées. 

**2.** Le résultat de l’import est ensuite affiché :  OK ou X

**3.** Dans le cas où le statut affiché est Un “Rapport de conformité et cohérence” est disponible en téléchargement ; il liste les erreurs rencontrées lors des différentes phases de contrôles et d’import, pour vous aider à corriger le fichier versé. 

Après avoir chargé ce premier fichier, il est possible d’ajouter d’autres fichiers à ce jeu de données via la page de gestion de vos jeux de données ainsi que la page de gestion de tous les jeux de données.



II.2. Phases de contrôles et rapport d'erreur
"""""""""""""""""""""""""""""""""""""""""""""

Fonctionnement des phases de contrôles
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

En cas d’erreur lors de l’import, la nature et la localisation des erreurs sont indiquées dans le “Rapport de conformité et cohérence”, disponible pour chaque soumission sur la page listant les jeux de données. Le service d’import détecte les erreurs en 3 étapes :

**ÉTAPE 1**

Dans un premier temps, le service d’import s’assure que la ligne d’en-tête du fichier importé est correcte :

* pas de nom de colonne en doublon ;
* pas de nom de colonne inconnu dans le modèle d’import ;
* pas de colonne obligatoire manquante ;

Le nom des colonnes doit correspondre exactement aux noms indiqués dans le standard de fichier de données brutes de biodiversité publié au Bulletin officiel et fournis dans le modèle proposé en téléchargement.

Toute la ligne est évaluée pour ces 3 contrôles. Si une erreur est relevée, l’import est rejeté.

**ÉTAPE 2**

Contrôles de conformité et cohérence : les erreurs sont enregistrées au fur et à mesure. Elles ne sont pas bloquantes pour le reste de la ligne ou du fichier, dans la limite de 1 000 erreurs, auquel cas les contrôles s’arrêtent.

**Conformité** : ce sont les erreurs de format, et de valeurs non conformes aux nomenclatures et aux référentiels (pour les valeurs de type code) listés dans le standard de fichier de données brutes de biodiversité.

**Cohérence** : ce sont des erreurs spécifiques au standard de fichier de données brutes de biodiversité, qui concernent souvent la cohérence entre plusieurs champs ; par exemple, certains champs doivent être remplis (ou non) en fonction de la valeur prise par d’autres champs.

Le service d’import lance les contrôles de conformité et de cohérence vis à vis du standard de fichier de données brutes de biodiversité. Vous pouvez vous référer au détail du standard “Standard de fichier de données occurrences de taxons. Dépôt légal des données brutes de biodiversité” pour connaître l’ensemble des règles de cohérence.

**ÉTAPE 3**

Cette étape concerne les contrôles sur le champ géométrique ainsi que les erreurs identifiées lors de l’insertion des données en base (bloquantes pour le reste de la ligne).


Localisation des erreurs et étude de cas d’erreur
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Dans la partie “Détails des erreurs de conformité”, le nom du champ ainsi que la ligne dans le fichier où est localisée l’erreur, s’ils ont identifiables, sont indiqués.

Dans la partie “Détails des erreurs de cohérence”, la ligne où est localisée l’erreur est indiquée, ainsi qu’un message permettant d’identifier les champs en erreur.


Des **erreurs de conformité** ont lieu lorsque :


* Le **fichier importé** est **vide**


* Un des **champs obligatoires** n’est pas indiqué


* Une **colonne obligatoire** est manquante dans la ligne d’en-tête du fichier d’import


* Le **nombre de champs** est incorrect. Cette erreur peut arriver notamment : 

      * si le séparateur de champ dans le fichier csv n’est pas un point-virgule ; 
      * s’il existe des champs vides en fin de ligne, qui n’ont pas été comptés par le tableur ; 
   
.. tip:: Le fichier doit contenir le bon nombre de champs, séparés par des points-virgules. Cette erreur peut être résolue en insérant une ligne d’en-têtes en haut de fichier (commençant par //).

   
* Le **nom du champ** est incorrect 

Le nom de la colonne indiqué dans la ligne d’en-tête du fichier csv n’existe pas dans le modèle d’import. Vous devez modifier votre fichier.


* Une **ligne** est **dupliquée** 

Cette erreur survient lorsque l’on tente de livrer des données avec un identifiant producteur qui existe déjà dans des jeux de données déjà intégrés par le même producteur.

.. tip:: Il faut soit supprimer la donnée précédemment importée, voire le jeu de données entier, soit modifier les identifiants dans le jeu de données que l’on cherche à livrer.
   
* Des **noms de colonnes** sont en double 

* Le **format** et/ou le **type du champ** n’est pas respecté

.. tip:: Voir le :ref:`Format_des_dates`.

* La **chaîne de caractères** est trop longue ; 

Cette erreur survient si la valeur du champ comporte trop de caractères. 

.. tip:: La limite pour les chaînes de caractère est de 255 caractères.

* La **valeur** indiquée est incorrecte 

La valeur donnée n’est pas reconnue et empêche l’exécution du code (**remplissage automatique de champs**).

* La **géométrie** est invalide 

La valeur de la géométrie ne correspond pas au format WKT.

* Mauvais **SRID** pour la géométrie 

L’identifiant du système de coordonnées (SRID) indiqué ne correspond pas à celui des données. C’est-à-dire que l’identifiant du système de référence indiqué sur la page d’import du fichier ne peut pas correspondre aux coordonnées indiquées dans le champ géométrique du fichier importé.




Des **erreurs de cohérence** ont lieu lorsque :

* Des **champs obligatoires conditionnels** sont manquants 

Il existe des groupes de champs « obligatoires conditionnels », c’est à dire que certains champs doivent être fournis obligatoirement si d’autres champs le sont. 
Par exemple, si l’un des champs décrivant l’objet “Commune” est fourni, tous doivent être fournis.

* Des **tableaux** n’ont pas le même nombre d’éléments

Certains champs de type tableaux doivent avoir le même nombre d’éléments. Par exemple codeCommune et nomCommune (et les éléments doivent se correspondre).

* Version **Taxref** manquante 

Si un code de taxon est fourni (dans cdNom ou cdRef), alors la version du référentiel taxonomique utilisé doit être indiquée.

* Le **géoréférencement** est manquant 

Un géoréférencement doit être fourni, c’est à dire qu’il faut livrer : soit une géométrie, soit une ou plusieurs commune(s), ou département(s), ou maille(s), dont le champ “typeInfoGeo” est indiqué à 1.

* Plusieurs géoréférencements sont indiqués

Un seul géoréférencement doit être livré ; un seul champ “typeInfoGeo” peut valoir 1.

* La **période d’observation** est incorrecte

La valeur de jourdatedebut est ultérieure à celle de jourdatefin ou la valeur de jourdatefin est ultérieure à la date du jour.



II.3. Gérer et déposer les jeux de données
""""""""""""""""""""""""""""""""""""""""""

Accéder à la liste de vos jeux de données
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
Lorsque vous êtes authentifié sur la plateforme, cliquez dans la barre de menu sur [Jeux de données] > [Gérer mes jeux de données]. 

Cette page d’accueil de gestion des jeux de données liste l’ensemble de vos jeux de données ainsi que leurs actions associées.

Un tableau regroupe les jeux de données existants en indiquant leur titre et leur identifiant de métadonnée. Au sein d’un jeu de données, ce tableau liste les fichiers de données qui ont été soumis à l’application. Pour chaque soumission, on visualise :

* le nom du fichier
* le nombre de lignes (plus exactement le nombre de données) que comporte le fichier
* le statut de la soumission (en cours, ok, error)

Actions réalisables sur un jeu de données
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Visualiser la page de détail d’un jeu de données**

Il est possible de visualiser le détail d’un jeu de données en cliquant sur le titre du jeu de données.

La page détaillant un jeu de données est composée de deux parties.

**1.**	Des informations concernant la métadonnée associée au jeu de données. Il est notamment possible d’y télécharger la fiche de métadonnée.

**2.**	Des informations concernant les versements effectuées dans le jeu de données.

Un lien permet d’ajouter un nouveau fichier au jeu de données en cours de visualisation.

Il est possible de mettre à jour la fiche de métadonnée et les informations la concernant via le bouton “Mettre à jour les métadonnées depuis l’INPN”.

Enfin, si le jeu de données ne comporte aucun versement il est possible de le supprimer.

**Ajouter un fichier au jeu de données**

Pour chaque jeu de données importé il est possible de lui associer plusieurs fichiers. Pour cela cliquez sur **[+Ajouter un fichier]** dans la colonne **[Fichiers]** du tableau.
Vous serez alors redirigez vers la page ajout de fichier et de chargement des données.


**Supprimer un jeu de données**

La suppression n’est possible que si le jeu de données ne comporte aucun versement (matérialisé par croix rouge). Dans le cas contraire, la croix est grisée.

Pour supprimer un jeu de données il est nécessaire de supprimer toutes les données qui y ont été versées puis de supprimer le jeu de données ; la suppression d’un jeu de données peut être réalisée alors même que les données ont fait l’objet d’un Dépôt légal.

**Télécharger un rapport**
 
* **Le rapport de conformité et cohérence** est un fichier PDF listant les éventuelles erreurs rencontrées lors de l’intégration.
* **Le rapport de sensibilité** est un fichier CSV listant les données sensibles du jeu de données (le calcul de la sensibilité fait partie des traitements réalisés par l’application lors de l’import). Ce rapport est téléchargeable seulement si le statut de la soumission est OK.
* **Le rapport des identifiants SINP** (identifiant permanent) qui est un fichier CSV listant les identifiants SINP attribués aux données versés. L’attribution de l’identifiant SINP est réalisé par l’application lorsque le champ du fichier est vide à l’import. Ce rapport est téléchargeable seulement si le statut de la soumission est OK.


Procéder au Dépôt légal des jeux de données
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Lorsqu’un jeu de données a été créé dans la plateforme, et que tous les fichiers versés dans ce jeu ont un statut OK, le déposant peut procéder au dépôt légal du jeu de données. 

.. warning:: Le dépôt légal d’un jeu de données est définitif ! Une fois qu’un jeu de données a fait l’objet d’un dépôt légal, ce jeu est clos et le déposant ne peut pas annuler son action.

Pour procéder au dépôt légal d’un jeu de données, il faut cliquer sur le bouton “Dépôt légal” dans la colonne “Dépôt légal” (matérialisé par bouton dépôt). Dans le cas contraire, le bouton est grisée bouton grisé.

Une fenêtre de confirmation valide le processus de dépôt légal. 

Après validation du dépôt légal, une barre de progression, indique l’avancée du processus.

Quand le processus est terminé, plusieurs fichiers sont disponibles en téléchargement. 

