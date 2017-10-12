#!/usr/bin/env python

"""
MySQL external inventory script
=================================

External inventory using a MySQL backend.

Requires a MySQL database using any predefined tables.
Modify mysql.ini to match your login credentials.

Extended upon the original MySQL Inventory script.
"""

# As it is mostly based on the original MySQL Dynamic Inventory
# https://github.com/productsupcom/ansible-dyninv-mysql/blob/master/mysql.py
# the same license, the GPL-3 applies.

import argparse
import ConfigParser
import os
import re
from time import time
import pymysql.cursors

try:
    import json
except ImportError:
    import simplejson as json


class MySQLInventory(object):
    """ Creates a dynamic inventory from a MySQL DB"""

    def __init__(self):

        """ Main execution path """
        self.conn = None

        self.inventory = dict()  # A list of groups and the hosts in that group
        self.cache = dict()  # Details about hosts in the inventory

        # Read settings and parse CLI arguments
        self.read_settings()
        self.parse_cli_args()

        # Cache
        if self.args.refresh_cache:
            self.update_cache()
        elif not self.is_cache_valid():
            self.update_cache()
        else:
            self.load_inventory_from_cache()
            self.load_cache_from_cache()

        data_to_print = ""

        # Data to print
        if self.args.host:
            data_to_print += self.get_host_info()
        else:
            self.inventory['_meta'] = {'hostvars': {}}
            for hostname in self.cache:
                self.inventory['_meta']['hostvars'][hostname] = self.cache[hostname]
            data_to_print += self.json_format_dict(self.inventory, True)

        print data_to_print

    def _connect(self):
        if not self.conn:
            self.conn = pymysql.connect(**self.myconfig)

    def is_cache_valid(self):
        """ Determines if the cache files have expired, or if it is still valid """

        if os.path.isfile(self.cache_path_cache):
            mod_time = os.path.getmtime(self.cache_path_cache)
            current_time = time()
            if (mod_time + self.cache_max_age) > current_time:
                if os.path.isfile(self.cache_path_inventory):
                    return True

        return False

    def read_settings(self):
        """ Reads the settings from the mysql.ini file """

        config = ConfigParser.SafeConfigParser()
        config.read(os.path.dirname(os.path.realpath(__file__)) + '/mysql.ini')

        self.myconfig = dict(config.items('server'))
        if 'port' in self.myconfig:
            self.myconfig['port'] = config.getint('server', 'port')

        # Cache related
        cache_path = config.get('config', 'cache_path')
        self.cache_path_cache = cache_path + "/ansible-mysql.cache"
        self.cache_path_inventory = cache_path + "/ansible-mysql.index"
        self.cache_max_age = config.getint('config', 'cache_max_age')

        # Other config
        self.facts_hostname_var = config.get('config', 'facts_hostname_var')

    def parse_cli_args(self):
        """ Command line argument processing """

        parser = argparse.ArgumentParser(description='Produce an Ansible Inventory file based on MySQL')
        parser.add_argument('--list', action='store_true', default=True, help='List instances (default: True)')
        parser.add_argument('--host', action='store', help='Get all the variables about a specific instance')
        parser.add_argument('--refresh-cache', action='store_true', default=False,
                            help='Force refresh of cache by making API requests to MySQL (default: False - use cache files)')
        self.args = parser.parse_args()

    def process_group(self, group, host):
        """ Process inventory group """

        # Add group if it does not already exist with hosts, vars, and children
        if group not in self.inventory:
            self.inventory[group] = {'hosts': [host], 'vars': {}, 'children': []}
            # Code to determine groupvars and children from db info would be here
        # Add host to group if the group does exist
        else:
            self.inventory[group]['hosts'].append(host)

    def update_cache(self):
        """ Make calls to MySQL and save the output in a cache """

        # Connect to CMDB and etch the systems
        self._connect()
        cursor = self.conn.cursor(pymysql.cursors.DictCursor)

        # SQL query to grab host info from a CMDB
        sql = """select
              host_name as host,
              group_concat(distinct lifecycle order by lifecycle) as env,
              group_concat(distinct group_name order by group_name) as host_group from host h
              group by host_name
              order by host_name;"""

        # Grab info from CMDB and store in data
        cursor.execute(sql)
        data = cursor.fetchall()

        # Iterate through data pulled from a CMDB
        for host in data:
            # Remove host key from dict and retain
            hostname = host.pop('host', None)

            # Process group and host into inventory dict
            self.process_group(host['host_group'], hostname)
            self.cache[hostname] = host
            self.inventory = self.inventory

        # Write out inventory to cache file
        self.write_to_cache(self.cache, self.cache_path_cache)
        self.write_to_cache(self.inventory, self.cache_path_inventory)

    def get_host_info(self):
        """ Get variables about a specific host """

        if not self.cache or len(self.cache) == 0:
            # Need to load index from cache
            self.load_cache_from_cache()

        if self.args.host not in self.cache:
            # try updating the cache
            self.update_cache()

            if self.args.host not in self.cache:
                # host might not exist anymore
                return self.json_format_dict({}, True)

        return self.json_format_dict(self.cache[self.args.host], True)

    def push(self, my_dict, key, element):
        """ Pushed an element onto an array that may not have been defined in the dict """

        if key in my_dict:
            my_dict[key].append(element)
        else:
            my_dict[key] = [element]

    def load_inventory_from_cache(self):
        """ Reads the index from the cache file sets self.index """

        cache = open(self.cache_path_inventory, 'r')
        json_inventory = cache.read()
        self.inventory = json.loads(json_inventory)

    def load_cache_from_cache(self):
        """ Reads the cache from the cache file sets self.cache """

        cache = open(self.cache_path_cache, 'r')
        json_cache = cache.read()
        self.cache = json.loads(json_cache)

    def write_to_cache(self, data, filename):
        """ Writes data in JSON format to a file """
        json_data = self.json_format_dict(data, True)
        cache = open(filename, 'w')
        cache.write(json_data)
        cache.close()

    def to_safe(self, word):
        """ Converts 'bad' characters in a string to underscores so they can be used as Ansible groups """

        return re.sub("[^A-Za-z0-9\\-]", "_", word)

    def json_format_dict(self, data, pretty=False):
        """ Converts a dict to a JSON object and dumps it as a formatted string """

        if pretty:
            return json.dumps(data, sort_keys=True, indent=2)
        return json.dumps(data)


MySQLInventory()
