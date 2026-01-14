#!/bin/bash

BACKUP_FILE=$1
DB_NAME="labdb_restore"
DB_USER="dba"
DB_HOST="localhost"
DB_PORT="5432"

createdb -h $DB_HOST -p $DB_PORT -U $DB_USER $DB_NAME

pg_restore -h $DB_HOST -p $DB_PORT -U $DB_USER \
  -d $DB_NAME \
  $BACKUP_FILE
