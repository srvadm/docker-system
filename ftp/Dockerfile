FROM alpine:3.7
MAINTAINER Tino Naumann <mail@ti-no.de>

RUN apk --update-cache --no-cache add bash vsftpd
COPY rootfs /
RUN ln -s ./ssl/fullchain.pem /etc/vsftpd/vsftpd.crt \
  && ln -s ./ssl/key.pem /etc/vsftpd/v$
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/vsftpd", "/etc/vsftpd/vsftpd.conf"]
