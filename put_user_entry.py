#!/usr/bin/env python 

# templates
passwd="%s:x:%s:0::/home/%s:"
shadow="%s:%s:17004:0:99999:7:::\x00"

# proof of concept: create files suitable for libnss-db from scratch by given password and username

import bsddb3
from passlib.hash import sha512_crypt

def useradd(_n, uid, name):
	dbpwd = bsddb3.btopen("passwd.db")
	pwd_entry = passwd % (name, uid, name)

	dbpwd[".%s" % name] = pwd_entry
	dbpwd["=%s" % uid] = pwd_entry
	dbpwd["0%d" % _n] = pwd_entry

	dbpwd.sync()

def pwdset(_n, name, passw):
	pwhash = sha512_crypt.encrypt(passw)

	shadow_entry = shadow % (name, pwhash)

	dbsh = bsddb3.btopen("shadow.db")
	dbsh[".%s" % name] = shadow_entry
	dbsh["0%d" % _n] = shadow_entry; 

	dbsh.sync()

useradd(0, 300, 'usertest')
pwdset(0, 'usertest', '10101')
