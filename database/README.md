Databases updates for DLB
-------------------------

Databases updates for DLB are performed like Ginco updates. 

In the `database/update/v*` directories of this project, we must put only updates applying to DLB. 

You can play them locally with the commands: 

`
php /path/to/dlb/database/update/vx.x.x/update_dlb.php -f <configFile> [{-D<propertiesName>=<Value>}]
`

In the deployment scripts, update directories of Ginco and DLB are merged, then all `update_*.php` scripts are executed. 

So: don't give the same name to your php update scripts, or the sql scripts, unless tou really want to replace 
a Ginco update script by a DLB one! 

