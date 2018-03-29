#ARG registry
#FROM ${registry}/docker:stable
FROM docker:stable
ENTRYPOINT ["docker", "build", "-t"]
CMD ["repo:tag", "."]
