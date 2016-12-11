# Single Host

- `docker network create -d bridge catnet`: Create a user-defined bridge network for our application
`docker run -d --net catnet --name cat-db redis`: Instantiate the backend DB (redis container) on the catnet network
`docker run -d --net catnet -p 8000:5000 -e 'DB=cat-db' -e 'ROLE=cat' chrch/web`: Instantiate the web frontend on the catnet network and configure it to connect to a container named `cat-db`; When an IP address is not specified, port mapping will be exposed on all interfaces of a host. In this case the container's application is exposed on 0.0.0.0:8000. We can specify a specific IP address to advertise on only a single IP interface with the flag `-p IP:host_port:container_port`
- The Docker Engine's built-in DNS will resolve a container's name to its location in any user-defined network. Thus, on a network, a container or service can always be referenced by its name.
- `docker network inspect catnet`: network info in json format

# Multi Host

- host A: `docker run -d -p 8000:5000 -e 'DB=host-B:8001' -e 'ROLE=cat' --name cat-web chrch/web`
- host B: `docker run -d -p 8001:6379 redis`: explicitly tell the web container the location of redis with the environment variable DB=hostB:8001; port map port 6379 inside the redis container to port 8001 on the second host; without the port mapping, redis would only be accessible on its connected networks
- We are doing manual service discovery here since we cannot use the built-in DNS

# Overlay Driver

- This model utilizes the built-in overlay driver to provide multi-host connectivity out of the box. The default settings of the overlay driver will provide external connectivity to the outside world as well as internal connectivity and service discovery within a container application.
- `docker node ls`: inspect your Swarm
- `docker network create -d overlay --subnet 10.1.0.0/24 --gateway 10.1.0.1 dognet`: create an overlay network
- `docker service create --network dognet --name dog-db redis`: provision some services on that overlay network
- `docker service create --network dognet -p 8000:5000 -e 'DB=dog-db' -e 'ROLE=dog' --name dog-web chrch/web`: provision some services on that overlay network
- Inside overlay and bridge networks, all TCP and UDP ports to containers are open and accessible to all other containers attached to the overlay network.
- `docker network create -d overlay --subnet 10.2.0.0/24 --gateway 10.2.0.1 catnet`: create a second overlay network catnet
- `docker service create --network catnet --name cat-db redis`: attach the new containers
- `docker service create --network catnet -p 9000:5000 -e 'DB=cat-db' -e 'ROLE=cat' --name cat-web chrch/web`: attach the new containers
- `docker service create --network dog-net --network cat-net -p 7000:5000 -e 'DB1=dog-db' -e 'DB2=cat-db' --name admin chrch/admin`: create the admin service and attach it to both networks

# MACVLAN Bridge Mode

- There may be cases where the application or network environment requires containers to have routable IP addresses that are a part of the underlay subnets. Each container receives a unique MAC address and an IP address of the physical network that the node is attached to.
- host-A `docker network create -d macvlan --subnet 192.168.0.0/24 --gateway 192.168.0.1 -o parent=eth0 macvlan`: Creation of local macvlan network on both hosts
- host-B `docker network create -d macvlan --subnet 192.168.0.0/24 --gateway 192.168.0.1 -o parent=eth0 macvlan`: Creation of local macvlan network on both hosts
- host-A `docker run -it --net macvlan --ip 192.168.0.4 -e 'DB=dog-db' -e 'ROLE=dog' --name dog-web chrch/web`: Creation of web container on host-A
- host-B `docker run -it --net macvlan --ip 192.168.0.5 --name dog-db redis`: Creation of db container on host-B
