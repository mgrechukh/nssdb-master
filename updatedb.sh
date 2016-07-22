#!/bin/sh

[ ! -d /nssdb/etc ] && mkdir /nssdb/etc
[ ! -d /nssdb/db ] && mkdir /nssdb/db
[ ! -f /nssdb/Makefile ] && {

	cp /var/lib/misc/Makefile /nssdb/
}

for i in passwd group; do
	awk -F : '$1 !~ /^(guest|nobody)/ && $3 >= 1000 {print $0}' /etc/$i > /nssdb/etc/$i
done
USERS=$(cat /nssdb/etc/passwd | cut -d: -f 1 | xargs | tr ' ' '|')
grep -E "($USERS)" /etc/shadow > /nssdb/etc/shadow
	
make -f /nssdb/Makefile

