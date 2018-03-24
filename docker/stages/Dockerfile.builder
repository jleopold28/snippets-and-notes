FROM docker:stable
WORKDIR /home
ENTRYPOINT ["docker", "build", "-t", "repo:tag", "."]
