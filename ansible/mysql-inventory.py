# also https://github.com/productsupcom/ansible-dyninv-mysql
#!/usr/bin/env python

import sys
import json
import mysql.connector

result = {}
result['_meta'] = {}
result['_meta']['hostvars'] = {'foo': {}}

try:
    cnx = mysql.connector.connect(user='scott',
                                  password='tiger',
                                  host='127.0.0.1',
                                  database='employees',
                                  raise_on_warnings=True)
except mysql.connector.Error as err:
    if err.errno == mysql.errorcode.ER_ACCESS_DENIED_ERROR:
        print 'Something is wrong with your user name or password'
    elif err.errno == mysql.errorcode.ER_BAD_DB_ERROR:
        print 'Database does not exist'
    else:
        print err
else:
    cursor = cnx.cursor()

    query = ("SELECT name, group FROM servers "
             "WHERE os EQUALS %s or %s")

    platform = 'linux'
    platform_other = 'windoze'

    cursor.execute(query, (platform, platform_other))

    for (name, group) in cursor:
        if group in result:
            result[group]['hosts'].extend(name)
        else:
            result[group] = {'hosts': [name], 'vars': {}, 'children': []}

    cursor.close()
    cnx.close()

var_dict = {}
var_dict['foo'] = {}

# output json of managed groups
if len(sys.argv) == 2 and sys.argv[1] == '--list':
    print json.dumps(result)
# output json of host variables
elif len(sys.argv) == 3 and sys.argv[1] == '--host':
    try:
        print json.dumps(var_dict[sys.argv[2]])
    except KeyError:
        print 'Host not found in dynamic inventory.'
else:
    print 'Requires an argument; please use --list or --host <host>.'
