FROM ubuntu

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libnss-db

RUN ln -s /nssdb/db/passwd.db /nssdb/db/shadow.db /nssdb/db/group.db /var/lib/misc
RUN sed -ri '/^(passwd|group|shadow)/ s,(: +),\1db ,' /etc/nsswitch.conf 

ADD nssdb.conf /etc/default/libnss-db
ADD updatedb.sh /

VOLUME /nssdb
