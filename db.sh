#!/bin/bash

if [ "$1" == '-b' ] || [ "$1" == '--backup' ]
then
  date=$(date +'%Y%m%d%H%M')
  echo "Backing up database to $date"
  source /vagrant/.env
  mysqldump -u $FACTER_DB_USER -p$FACTER_DB_PASSWORD --add-drop-database $FACTER_DB_NAME > /vagrant/database/$date.sql
fi

if [ "$1" == '-r' ] || [ "$1" == '--restore' ]
then
  echo "Restoring database from $2"
  source /vagrant/.env
  mysql -u $FACTER_DB_USER -p$FACTER_DB_PASSWORD $FACTER_DB_NAME < $2
fi
