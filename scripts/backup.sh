#!/bin/bash
# Daily backup mit tar
#TARFILE=/tmp/ubuntu4-backup.tar.7z
TARFILE=/tmp/ubuntu4-backup.tar
BACKUPDIR=/home/harald/backup
ARCHIVE=/root/Dropbox/1-Data.7z
LOGFILE=/home/harald/logfile.txt
#ARCHIVEDIR=/home/harald/1-Data
#OUTLOOK=/home/harald/1-Data/.sync/Archive/0-Outlook
ARCHIVEDIR=/media/DriveX/hba/1-Data   
OUTLOOKDIR=/media/DriveX/hba/Mail/0-Outlook

# new logfile
date >$LOGFILE

# dump hanoba wiki
mysqldump -u root -pferena --default-character-set=binary hanoba_wiki >$BACKUPDIR/hanoba_wiki.sql

# copy FHEM files
cp -f /opt/fhem/*cfg $BACKUPDIR
cp -f /opt/fhem/FHEM/99_myUtils.pm $BACKUPDIR

# list installed packages
dpkg -l >$BACKUPDIR/packages.txt

# Backup of the following directory trees:
#    /etc 
#    /var/www 
#    /home
#    /opt/fhem
#    /media/DriveX/hba/www
# Note: Dropbox directories are excluded
rm -rf $TARFILE
tar -cf $TARFILE  --exclude=/root/Dropbox \
   --exclude=".*" \
   --exclude=$ARCHIVEDIR \
   --exclude=/home/harald/artwork \
   --exclude=/home/harald/Downloads \
   --exclude=/home/harald/rompr \
   /etc /var/www /home /opt/fhem /media/DriveX/hba/www   >>$LOGFILE
#tar -cf -  --exclude=/root/Dropbox \
#   --exclude=".*" \
#   --exclude=$ARCHIVEDIR \
#   --exclude=/home/harald/artwork \
#   --exclude=/home/harald/Downloads \
#   --exclude=/home/harald/rompr \
#   /etc /var/www /home /opt/fhem /media/DriveX/hba/www | 7z a -mhe=on -p2bYFGvE28m0NcUkTK8SW -si $TARFILE  >>$LOGFILE
#mv $TARFILE /root/Dropbox

# Create archive of 1-Data directory in Dropbox folder
rm -f $ARCHIVE
#if [ -d $OUTLOOK ]; then rm -rf $OUTLOOK; fi
7z a -mhe=on -xr!.sync -xr!.git -p2bYFGvE28m0NcUkTK8SW $ARCHIVE $ARCHIVEDIR $OUTLOOKDIR $TARFILE >>$LOGFILE
date >>$LOGFILE
# #
# # Start Dropbox and wait until synchronization is complete
# date >>$LOGFILE
# #echo -e "$(date): Starting dropbox\n" >>$LOGFILE
# dropbox start >>$LOGFILE
# while [[ $(dropbox status) != Aktualisiert ]]; do sleep 20; done
# #echo -e "$(date): Dropbox update completed\n" >>$LOGFILE
# dropbox status >>$LOGFILE
# #echo -e "$(date): Stopping dropbox\n" >>$LOGFILE
# dropbox stop >>$LOGFILE

# copy to harald-bauer.com
sshpass -p 'HOny3gAdPcVOdm1JuK6p.' sftp  harald-bauer.com@ssh.harald-bauer.com >>$LOGFILE  <<END_SCRIPT
cd backups
put $ARCHIVE
rm     1-Data-7.7z
rename 1-Data-6.7z 1-Data-7.7z
rename 1-Data-5.7z 1-Data-6.7z
rename 1-Data-4.7z 1-Data-5.7z
rename 1-Data-3.7z 1-Data-4.7z
rename 1-Data-2.7z 1-Data-3.7z
rename 1-Data-1.7z 1-Data-2.7z
rename 1-Data.7z 1-Data-1.7z
quit
END_SCRIPT

# put $TARFILE

date >>$LOGFILE
mail -s 'Ubuntu4 backup completed!' harald.n.bauer@web.de <$LOGFILE
exit 0

# History
# 2024-04-29 HB The folder 1-Data has been moved from ~ to hba/1-Data. 
#               Outlook pst file is now in hba/Mail/0-Outlook (included in $ARCHIVE)
#               $TARFILE is now part of $ARCHIVE