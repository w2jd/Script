#!/bin/bash

# Title       : Backup - webhome directory
# Description : Backup - webhome directory
# How to Use  : ./backup_webhome.sh
# Maker       : LT
# Date        : 2018.11.14.
# OS          : Linux



### Set variable
TODAY=`date +'%Y%m%d'`
REMOVEDAY=`date +'%Y%m%d' -d '5 days ago'`
LOGFILE="/var/log/backup-webhome.log"
BAKDIR="/backup"
BAKTARGET="[Backup Target Directory ex> var/www/html]"

### Write log
function wrlog(){
	NOWTIME=`date +'[%F %T]'`
	MSG="${NOWTIME} $1"
	echo $MSG
	echo $MSG >> $LOGFILE
}

wrlog "Backup - webhome"

### Remove Past file
if [ -f "${BAKDIR}/${BAKTARGET}_${REMOVEDAY}.tar.gz" ] ; then
	wrlog "Delete past file : ${BAKDIR}/${BAKTARGET}_${REMOVEDAY}.tar.gz"
	wrlog "`ls -al ${BAKDIR}/${BAKTARGET}_${REMOVEDAY}.tar.gz`"

	/bin/rm -f ${BAKDIR}/${BAKTARGET}_${REMOVEDAY}.tar.gz
	wrlog "Remove Complete!"
fi

### Backup Today file
if [ ! -f "${BAKDIR}/${BAKTARGET}_${TODAY}.tar.gz" ] ; then
	wrlog "Backup Start : /${BAKTARGET}"
	/bin/tar zcfP ${BAKDIR}/${BAKTARGET}_${TODAY}.tar.gz /${BAKTARGET}/
	wrlog "Backup End : /${BAKTARGET}"
fi

wrlog "=============================="

/bin/ls -aRl ${BAKDIR}
