FROM alpine:3.7

ADD entrypoint.sh  /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]