#!/bin/sh

# check for composer file and install (if any)
if [ -e /app/composer.json ]; then
    echo "composer file found."
    echo "installing bundles..."
    echo "--------"

    composer install
    
    echo "--------"
    echo "done"
else
    echo "composer file not found."
fi

# start apache
echo "Starting httpd"
exec /usr/sbin/httpd -D FOREGROUND -f /etc/apache2/httpd.conf
echo "Done httpd"
