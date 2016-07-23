#!/bin/sh

[ ! -d /nssdb/etc ] && mkdir /nssdb/etc
[ ! -d /nssdb/db ] && mkdir /nssdb/db
[ ! -f /nssdb/Makefile ] && {

	cp /var/lib/misc/Makefile /nssdb/
}

## check also possibility to "merge" repositories
# getent -s db shadow
# because passwd(1) will not work if user exists only in db
# doing administrative tasks in ephemeral container with persistent volume obviously require to populate back /etc/passwd always before recreating DB from it
# or better resort to getent passwd | awk ....

for i in passwd group; do
	getent $i | sort | uniq | awk -F : '$1 !~ /^(guest|nobody)/ && $3 >= 1000 {print $0}' > /nssdb/etc/$i
done
USERS=$(cat /nssdb/etc/passwd | cut -d: -f 1 | xargs | tr ' ' '|')
getent shadow | sort | uniq | grep -E "($USERS)" > /nssdb/etc/shadow
	
make -f /nssdb/Makefile

