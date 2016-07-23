content must be also encrypted and signed:

gpg --sign --encrypt --output /home/mykola/passwd.db.gpg --recipient dell1 --recipient dell2 --recipient lenovo-lviv passwd.db

On receiver side:

gpg --decrypt --output /home/mykola/test/passwd.db passwd.db.gpg

THis also verifies attached signature and refuses to decrypt if it is not valid
