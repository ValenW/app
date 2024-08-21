FROM soulteary/webhook:latest as bin

FROM alpine:latest
RUN apk add --update --no-cache git
COPY --from=bin /usr/bin/webhook /usr/bin/webhook
EXPOSE 9000/tcp
CMD ["/usr/bin/webhook"]
