# Dépôt Légal de Biodiversité

**This project is no longer maintained.**

This code creates a variant of the [Ginco](https://github.com/SINP-GINCO/ginco) platforms, dedicated to 
the legal uploading of biodiversity data collected during impact studies. 

## Installation

* Create or select a folder on your local machine where you will install the project:
```bash
git clone git@github.com:SINP-GINCO/ginco.git
git clone git@github.com:SINP-GINCO/ogam-configurator.git
git clone git@github.com:SINP-GINCO/dlb.git
```
* Copy the properties template and edit it to suit your needs
```bash
cp dlb/configs/localhost.properties.dist dlb/configs/localhost.properties
vi dlb/configs/localhost.properties
```
* Build the Ginco Postgres database
```bash
php ginco/database/init/create_db.php -f dlb/configs/localhost.properties
```
* And apply patches for dlb
`https://github.com/SINP-GINCO/dlb/tree/develop/database`

* Manually populate *metadata.mode_taxref* table by executing the following script block by block in your Postgres client:
```bash
vi ginco/database/init/populate_mode_taxref_table.sql
```

* Check that the following values are correct in *website.application_parameters* table:
    * contactEmail
    * contactEmailPrefix
    * contactEmailSufix
    * toMail
    * deeNotificationMail
    * https_proxy (url and port of your local proxy if needed)

* Add the following line to your hosts file:
 ```bash
 127.0.0.1 local-dlb.ign.fr
 ```
  (replace with the requested url for you local website).  
    
    
 ```bash
 sudo vi /etc/hosts
 ```

* Build the project and follow the instructions left at the end of the script:
```bash
php dlb/build_dlb.php -f dlb/configs/localhost.properties --mode=dev
```

* You should now access to the application by visiting  `http://local-dlb.ign.fr` (or 
  `http://local-dlb.ign.fr/app_dev.php` in dev environment) .

* Before uploading data and using the application, unpublish the standard model, publish it again and publish its import model.

## Troubleshooting

#### Geoportail layers are not displayed.
* Check that *mapping.layer_service* URLs are correct and have a correct Geoportail key.

#### Administrative limits and results are not displayed
* Check that your *mapping.layer_service* mapProxy values are correct.
* Check that the value for *mapserver_private_url* in *website.application_parameters* is working (it should be the same as in Apache configuration file) and should result
in a textual MapServer output.

#### Downloading the metadata file wghen creating a jdd fails
* Check that the http_proxy value in *website.application_parameters* is correct. If not put it in the properties file.
