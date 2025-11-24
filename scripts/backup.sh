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
   --exclude=/home/harald/fhem-docker \
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
rm     1-Data-31.7z
rename 1-Data-30.7z 1-Data-31.7z
rename 1-Data-29.7z 1-Data-30.7z
rename 1-Data-28.7z 1-Data-29.7z
rename 1-Data-27.7z 1-Data-28.7z
rename 1-Data-26.7z 1-Data-27.7z
rename 1-Data-25.7z 1-Data-26.7z
rename 1-Data-24.7z 1-Data-25.7z
rename 1-Data-23.7z 1-Data-24.7z
rename 1-Data-22.7z 1-Data-23.7z
rename 1-Data-21.7z 1-Data-22.7z
rename 1-Data-20.7z 1-Data-21.7z
rename 1-Data-19.7z 1-Data-20.7z
rename 1-Data-18.7z 1-Data-19.7z
rename 1-Data-17.7z 1-Data-18.7z
rename 1-Data-16.7z 1-Data-17.7z
rename 1-Data-15.7z 1-Data-16.7z
rename 1-Data-14.7z 1-Data-15.7z
rename 1-Data-13.7z 1-Data-14.7z
rename 1-Data-12.7z 1-Data-13.7z
rename 1-Data-11.7z 1-Data-12.7z
rename 1-Data-10.7z 1-Data-11.7z
rename 1-Data-09.7z 1-Data-10.7z
rename 1-Data-08.7z 1-Data-09.7z
rename 1-Data-07.7z 1-Data-08.7z
rename 1-Data-06.7z 1-Data-07.7z
rename 1-Data-05.7z 1-Data-06.7z
rename 1-Data-04.7z 1-Data-05.7z
rename 1-Data-03.7z 1-Data-04.7z
rename 1-Data-02.7z 1-Data-03.7z
rename 1-Data-01.7z 1-Data-02.7z
rename 1-Data.7z    1-Data-01.7z
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
