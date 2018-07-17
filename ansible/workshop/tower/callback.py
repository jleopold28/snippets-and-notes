"""Ansible CLI Agent: Remotely executes jobs from Ansible Tower"""

import sys
from tower_cli import get_resource

KEY = sys.argv[1]
ID = sys.argv[2]

# prep API
res = get_resource('job_template')

# launch job with parameters
res.callback(pk=ID, host_config_key=KEY)
