FROM docker:stable
WORKDIR /home
ENTRYPOINT ["docker", "build", "-t"]
CMD ["repo:tag", "."]
