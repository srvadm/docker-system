FROM alpine:3.11
RUN apk add --no-cache pwgen

# always generate 'secure' passwords
ENTRYPOINT ["pwgen", "-s"]

# by default, generate 1 password, 16-characters long with at least one capital letter, one number.
CMD ["-c", "-n", "-1", "16"]
