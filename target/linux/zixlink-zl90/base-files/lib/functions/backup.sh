#!/bin/sh

BACKUP_DIR=/tmp/backup/

mkdir -p $BACKUP_DIR

#Backup userdata
USERDATA_DIR=/data/userdata
mkdir -p $BACKUP_DIR/$USERDATA_DIR
cp -r $USERDATA_DIR/* $BACKUP_DIR/$USERDATA_DIR/

#Backup collector
/lib/functions/collector_db_data_clear.sh

COLLECTOR_MAIN_DB_DIR=/data/collector
COLLECTOR_MAIN_DB_FILE=database.sqlite3
mkdir -p $BACKUP_DIR/$COLLECTOR_MAIN_DB_DIR
cp -r $COLLECTOR_MAIN_DB_DIR/$COLLECTOR_MAIN_DB_FILE $BACKUP_DIR/$COLLECTOR_MAIN_DB_DIR/

#backup meshroot
MESHROOT_MAIN_DB_DIR=/data/meshroot
mkdir -p $BACKUP_DIR/$MESHROOT_MAIN_DB_DIR
cp -r $MESHROOT_MAIN_DB_DIR/* $BACKUP_DIR/$MESHROOT_MAIN_DB_DIR/

exit 0
