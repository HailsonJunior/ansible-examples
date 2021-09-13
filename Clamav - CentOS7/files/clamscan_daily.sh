#!/bin/bash

#LOGFILE="/var/log/clamav/clamav-$(date +'%Y-%m-%d').log";
LOGDATE=`date +%Y-%m-%d`
DIRTOSCAN="/";


for S in $DIRTOSCAN;
 do DIRSIZE=$(du -sh "$S" 2>/dev/null | cut -f1);

 echo "Starting a daily scan of "$S" directory.
 Amount of data to be scanned is "$DIRSIZE".";

  clamdscan --config-file=/etc/clamd.d/scan.conf "$S" >> /var/log/clamav/clamavlog_$LOGDATE

 # get the value of "Infected lines"
 MALWARE=$(tail /var/log/clamav/clamavlog_$LOGDATE |grep Infected|cut -d" " -f3);


mutt -F /root/.muttrc -s "Clamav Scan Weekly - Not Infected" serviceit@hst.com.br < /var/log/clamav/clamavlog_$LOGDATE
echo "Clamav Scan daily "

 # if the value is not equal to zero, send an email with the log file attached
 if [ "$MALWARE" != "0" ]; then
 # using heirloom-mailx below

mutt -F /root/.muttrc -s "Clamav Scan Weekly - Infected" serviceit@hst.com.br < /var/log/clamav/clamavlog_$LOGDATE
echo "Clamav Scan with Virus "

fi
done
exit 0
