import os

import docker
import compose
import compose.cli.docker_client as compose_client


# instantiate docker client
client = docker.DockerClient(base_url='unix:///var/run/docker.sock')

# instantiate container
print(client.containers.run('alpine:3.8', command='echo hi!', auto_remove=True))

# list images
print(client.images.list(all=True))

# list plugins
print(client.plugins.list())

# arch
# docker-compose cli <-- docker-compose module+docker-compose.yaml <-- docker module <-- docker server rest api <-- docker

# init docker client through docker compose; says not callable but it should be according to usage
docker_client = compose_client(os.environ)

# create and list secrets (requires swarm)
client.secrets.create(name='the_secret', data='secret_data')
print(client.secrets.list())
