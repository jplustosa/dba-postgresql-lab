#!/bin/bash

DATA=$(date +"%Y%m%d_%H%M")
BACKUP_DIR="../backups"
DB_NAME="labdb"
DB_USER="dba"
DB_HOST="localhost"
DB_PORT="5432"

mkdir -p $BACKUP_DIR

pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER \
  -F c \
  -f $BACKUP_DIR/${DB_NAME}_${DATA}.backup \
  $DB_NAME
