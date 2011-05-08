#!/usr/bin/env python

print "Content-Type: text/plain"
print

import cgi

form = cgi.FieldStorage()

data = form["ps"].file.read()

fichier = open("/var/spool/plot/" + form["ps"].filename, "a")
fichier.write(data)
fichier.close()

print "done"

