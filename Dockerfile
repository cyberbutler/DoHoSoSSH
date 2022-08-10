FROM alpine:latest
ENV TERM=xterm-256color

RUN apk update
RUN apk --no-cache add curl autossh dumb-init

COPY --from=cloudflare/cloudflared:latest /usr/local/bin/cloudflared /usr/local/bin/cloudflared
COPY ./entrypoint.sh /entrypoint.sh

WORKDIR /tunnel

EXPOSE 53/udp 8080/tcp
VOLUME [ "/tunnel" ]

ENTRYPOINT [ "/entrypoint.sh" ]