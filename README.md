# Dépôt Légal de Biodiversité

## Installation

* Create or select a folder on your local machine where you will install the project:
```bash
# Clone OGAM repo (public repo currently unavailable)
git clone git@github.com:SINP-GINCO/ginco.git
git clone git@github.com:SINP-GINCO/ogam-configurator.git
git clone git@github.com:SINP-GINCO/dlb.git
```
* Copy the properties template and edit it to suit your needs
```bash
cp dlb/configs/localhost.properties.dist dlb/configs/localhost.properties
vi dlb/configs/localhost.properties
```
* Build the Ginco Postgres database and apply patches for dlb
```bash
php ginco/database/init/create_db.php -f dlb/configs/localhost.properties
php dlb/database/apply_db_patch.php -f dlb/configs/localhost.properties
```

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


* Add the following lines to your hosts file:

 127.0.0.1 local-dlb  
 127.0.0.1 local-dlb.ign.fr  
 127.0.0.1 local-dlb-1.ign.fr  
 127.0.0.1 local-dlb-2.ign.fr  
 127.0.0.1 local-dlb-3.ign.fr  
 127.0.0.1 local-dlb-4.ign.fr  
 127.0.0.1 local-dlb-5.ign.fr  
 127.0.0.1 local-dlb-6.ign.fr  
 127.0.0.1 local-dlb-7.ign.fr  
 127.0.0.1 local-dlb-8.ign.fr  
 127.0.0.1 local-dlb-9.ign.fr  
 ```bash
 sudo vi /etc/hosts
 ```

* Build the project and follow the instructions left at the end of the script:
```bash
php dlb/build_dlb.php -f dlb/configs/localhost.properties --mode=dev
```

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
