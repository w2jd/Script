#!/bin/bash

# Title       : Backup - /home directory
# Description : Backup - /home directory
# How to Use  : ./backup_home.sh
# Maker       : LT
# Date        : 2017.12.12.
# OS          : Linux



### Set variable
TODAY=`date +'%Y%m%d'`
REMOVEDAY=`date +'%Y%m%d' -d '3 days ago'`

### Check log
LOGFILE="/var/log/backup_home.log"
if [ ! -f $LOGFILE ]; then
	sudo touch $LOGFILE
	sudo chown [UID.GID] $LOGFILE
fi

function wrlog(){
	NOWTIME=`date +'[%F %T]'`
	MSG="${NOWTIME} $1"
	echo $MSG
	echo $MSG >> $LOGFILE
}

wrlog "Backup home directory"

### Get home directory
for BAKDIR in $(ls -l /home | grep drwx | awk '{print $9}')
do

	### Remove Past file
	if [ -f "/backup/${BAKDIR}_${REMOVEDAY}.tar.gz" ] ; then
		wrlog "Delete past file : /backup/${BAKDIR}_${REMOVEDAY}.tar.gz"
		wrlog "`ls -al /backup/${BAKDIR}_${REMOVEDAY}.tar.gz`"

		sudo /bin/rm -f /backup/${BAKDIR}_${REMOVEDAY}.tar.gz
		wrlog "Remove Complete!"
	fi

	### Backup Today file
	if [ ! -f "/backup/${BAKDIR}_${TODAY}.tar.gz" ] ; then
		wrlog "Backup Start : ${BAKDIR}"
		cd /home
		sudo /bin/tar zcf /backup/${BAKDIR}_${TODAY}.tar.gz ${BAKDIR}
		wrlog "Backup End : ${BAKDIR}"
	fi

done

wrlog "=============================="

/bin/ls -al /backup
