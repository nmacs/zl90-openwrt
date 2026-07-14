#!/bin/sh

BACKUP_DIR=/tmp/backup/

if [ ! -d "$BACKUP_DIR" ]; then
	exit 1
fi

cp -r $BACKUP_DIR/* /
sync
rm -rf $BACKUP_DIR
sync

exit 0
