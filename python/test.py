#!/usr/bin/python
import re

names = ['abcdfoo', 'efghijfoo', 'klbar', 'nmbaz', 'fooabcdbar', 'bazefghijbaz', 'fooklfoo', 'barnmbaz']

for name in names:
    if re.search('^abcd.*|^efghij.*|^kl.*|^nm.*', name):
        print name
    else:
        print 'NOPE'
