# ldap-powershell
A very basic ldap parser for powershell
Expects LDAP Data Interchange Format.
See https://linux.die.net/man/5/ldif and https://linux.die.net/man/1/ldapsearch

## assumptions

* will warn if file doesnt end in newline (in case file was truncated) it will still return a result - including the last object
* assumes all base64 encoded properties are utf8 strings
* ignores all url properties, will just add the url as string property

## not implemented

* include statements
* change records
