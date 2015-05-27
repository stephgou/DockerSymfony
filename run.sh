#!/bin/bash

chown -R www-data: /var/www/KitAzureDiscoveryPhp
chmod -R a+rX /var/www/KitAzureDiscoveryPhp
source /etc/apache2/envvars
exec apache2 -D FOREGROUND