FROM nginx:1.17-alpine
MAINTAINER Tino Naumann <mail@ti-no.de>

COPY rootfs /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]