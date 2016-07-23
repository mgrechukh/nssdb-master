#!/bin/sh
# this script is to be added into incron as
# /path/to/db IN_MOVED_TO push.sh $#

fname=$1
echo "$(date) $fname" >> /tmp/sync-log
case $fname in
	group.db)
		db=group
		mode=644
		;;
	passwd.db)
		db=passwd
		mode=644
		;;
	shadow.db)
		db=shadow
		mode=600
		;;
	*)
		echo 'skipping' >> /tmp/sync.log
		exit
		;;
esac

BTSYNC_DIR=/path/to
FNAME=/var/lib/misc/${db}.db
BTSYNC_NAME=$BTSYNC_DIR/db/${db}.db
[ ! -e $FNAME ] && touch -d 1970-01-01 $FNAME

chown root $FNAME
chmod $mode $FNAME

# @TODO gpg --decrypt --verify --output $FNAME $BTSYNC_NAME

cat $BTSYNC_NAME > $FNAME

