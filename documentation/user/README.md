# Documentation utilisateur du projet Dépôt Légal de données brutes de Biodiversité 

Ce répertoire contient un projet Sphinx autonome : la documentation utilisateur du projet GINCO-DLB. Elle se rapporte aux 
 projets suivants : 
 
* SINP-GINCO / ginco
* SINP-GINCO / DLB 
* L'application de métadonnées de l'INPN (partie DLB)

## SPHINX

### En bref

Sphinx est un générateur de documentation. Il compile des fichiers sources au format texte ou rst
(ReStructured Text), pour générer de la documentation dans différents formats de sortie : HTML, LaTeX 
 puis PDF à partir du LaTeX, et beaucoup d'autres formats... 
 
Le rst permet d'indiquer le formatage du texte : titres, listes, liens, etc... 
Et Sphinx ajoute des fonctionnalités, telles que la construction d'une table des matières (toctree), 
le marquage par version, les notes et warnings... 

### Documentation

* [Documentation Sphinx](http://www.sphinx-doc.org/en/stable/)
* [Syntaxe RST générale](http://www.sphinx-doc.org/en/stable/rest.html)
* [Syntaxe RST spécifique Sphinx](http://www.sphinx-doc.org/en/stable/markup/index.html)

## Installation de Sphinx

### Linux : 

```bash
apt-get install python-sphinx
```
Et installer l'outil latexpdf (pour compiler la doc en PDF) :

```bash
apt-get install texlive-latex-base
```
Et installer l'outil textlive-lang-french pour avoir les textes en français(pour la doc PDF en français) : 

```bash
apt-get install texlive-lang-french
```

### Windows : à compléter

## Organisation du projet

_Remarque préalable :_ L'organisation du projet de documentation est similaire à celle de la doc du projet Ginco, et elle DOIT 
 rester similaire ! 

`dlb/documentation/user/` contient le projet de documentation utilisateur.

Le sous-répertoire `source` contient : 

* les fichiers sources `*.rst`, organisés en sous-dossiers par grande partie de la documentation : 
  introduction, metadonnées, import, etc...
    
* un fichier `index.rst` qui contient la table des matières globale ; en fait cette table des matières 
  appelle les fichiers `index.rst` de chaque partie, qui contiennent chacun une table des matières 
  détaillée de la partie. 
  
* un répertoire `images`où sont rangées les images illustrant la doc (essentiellement des captures d'écran). 

* un répertoire `_themes` contenant le thème utilisé (thème "Read the docs" pour Sphinx). 

* les répertoires `_static` et  `_templates`, qui sont vides mais indiqués dans la conf. 

* le fichier de configuration `conf.py`. C'est là où est indiqué le thème utilisé, et diverses options 
  (à voir en particulier pour les versions). 
 
Lorsque l'on compile le projet, un répertoire `build` est créé et contient la documentation aux formats de sortie 
choisis.
  
Le fichier Makefile à la racine contient les options courantes pour la compilation du projet.

## Compiler le projet

Se placer dans `dlb/documentation/user/` et exécuter : 

```bash
make clean
make html
```
Les fichiers html sont générés dans `build/html`. Pour voir le résultat, ouvrir `build/html/index.html`
dans un navigateur. 

Pour générer un PDF : 

```bash
make latexpdf
```
Le fichier généré est `build/latex/Ginco.pdf`. 

Et pour les deux en même temps (le PDF est ainsi téléchargeable directement depuis le site de doc) :

```bash
make htmlandpdf
```

## Captures d'écran

Pour créer des captures d'écran annotées, utiliser le plugin Chrome 
[Awesome Screenshot](https://chrome.google.com/webstore/detail/awesome-screenshot-screen/nlipoenfbbikpbjkfpfillcgkoblgpmj?hl=fr&gl=FR). 

## Déployer la doc

**Todo: àdapter à DLB.**

Afin de builder les documentations indépendamment des instances, des nouveaux doc-<*>.properties ont été ajoutés: doc-ginco-dailybuild.properties, doc-ginco-test.properties, doc-ginco-prod.properties

Il contiennent la version de la documentation à déployer (qui correspond à une version Ginco).

Doc dailybuild :
Elle est déployée automatiquement par jenkins après le déploiement du dailybuild.

Doc test et prod :
Les commandes pour déployer les versions de test et de prod de la documentation sont commentées dans jenkins.

Pour mettre à jour une version (déployer), il faut :
 - mettre à jour le fichier de config de documentation correspondant et le pusher sur le serveur.
 - décommenter les commandes correspondantes dans Jenkins, et préciser dans la commande getPackage la version (branche) que l'on souhaite déployer. 

Par exemple, pour déployer la documentation de test en version 2.0.3, les commandes que doit réaliser jenkins sont :
```bash
./getPackage.sh -p ginco -v v2.0.3 -d ./build
./deploy_doc.sh -i doc-ginco-test
```
et le fichier doc-ginco-dailybuild.properties doit contenir :
```bash
doc.version=ginco-test
doc.basepath=v2.0.3
doc.branch=v2.0.3
```

remarque : Pour effectuer cette opération sans passer par Jenkins, il faut avoir buildé l'application auparavant (pour récupérer le code source de la doc dans la bonne version via le git clone Ginco).
