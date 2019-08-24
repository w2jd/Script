#!/bin/sh

# Title       : Backup mariadb on synology
# Description : Backup mariadb on synology
# How to Use  : sudo ./backup_db.sh
# Maker       : LT
# Date        : 2019.08.24.
# OS          : Synology



### Set variable
DIR=[Backup Path ex> /volume1/Backup_mysql/]
DATESTAMP=$(date +%Y%m%d_%H%M%S)
DAYS_KEEP=30
DB_USER=[Backup user id]
DB_PASS=[Backup user password]

### show Databases
/usr/local/mariadb10/bin/mysqlshow --user=$DB_USER --password=$DB_PASS

### remove backups older than $DAYS_KEEP
find ${DIR}* -mtime +$DAYS_KEEP -exec rm -f {} \; > /dev/null

### Backup full database
FULLDB=${DIR}FULL-${DATESTAMP}.sql
/usr/local/mariadb10/bin/mysqldump --user=$DB_USER --password=$DB_PASS --opt --all-databases --flush-logs > ${FULLDB}

### Backup database - individual
DBNAME=[DB Name]
/usr/local/mariadb10/bin/mysqldump --user=$DB_USER --password=$DB_PASS --opt ${DBNAME} > ${DIR}${DBNAME}-${DATESTAMP}.sql
