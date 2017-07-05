# generate subnet fact
import socket
import re
SUBNET = re.match(r'\d+\.\d+\.\d+', socket.gethostbyname(socket.gethostname()))
print "%s=%s" % ('subnet', SUBNET.group())
