ARG registry
FROM ${registry}/docker:stable
ENTRYPOINT ["docker", "build", "-t"]
CMD ["repo:tag", "."]
