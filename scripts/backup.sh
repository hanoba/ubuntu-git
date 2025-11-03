#!/bin/bash
# Daily backup mit tar
TARFILE=/tmp/ubuntu4-backup.tar
BACKUPDIR=/home/harald/backup
ARCHIVE=/root/Dropbox/1-Data.7z
LOGFILE=/home/harald/logfile.txt
ARCHIVEDIR=/media/DriveX/hba/1-Data   
MAILDIR=/media/DriveX/hba/Mail

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

# Create archive of 1-Data directory in Dropbox folder 
# (Dropbox folder is used for historic reasons. Dropbox is no longer used)
rm -f $ARCHIVE
7z a -mhe=on -xr!.sync -xr!.git -p2bYFGvE28m0NcUkTK8SW $ARCHIVE $ARCHIVEDIR $MAILDIR $TARFILE >>$LOGFILE
date >>$LOGFILE

# copy to harald-bauer.com
sshpass -f /root/pw.txt sftp  harald@192.168.20.27 >>$LOGFILE  <<END_SCRIPT
cd hdd/backups
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
# 2025-09-21 HB Outlook pst file is no longer part of the backup. It has been converted
#               to mbox format for Thunderbird. It is stored in hba/Mail/Local Folders.
#               hba/Mail is included in the backup.
