#!/bin/bash
DIR=$(dirname $0)
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 2>&1
    echo "Please try:" 2>&1
    echo "sudo $DIR/deploy.sh" 2>&1
    exit 1
fi


folder="/var/www/amr.rfcom-tech.com"

# create folder if not exists
[ -d "$folder" ] || mkdir -p "$folder"

systemctl stop rfcom-amr.service

sudo -u www-data rsync -qavr --exclude="media" --exclude=".git" --exclude="*.pyc" --delete $DIR/ $folder/

sudo -u www-data sed -i 's/^DEBUG = .*/DEBUG = False/g' $folder/gateway_server/settings.py
sudo -u www-data $folder/manage.py collectstatic --noinput --link >/dev/null


systemctl start rfcom-amr.service
