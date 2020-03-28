FROM anapsix/alpine-java:latest

COPY entrypoint.sh  /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]