FROM ghcr.io/forgejo/forgejo:12.0.3

# Installa eventuali tool aggiuntivi
RUN apk add --no-cache \
    git \
    openssh \
    sqlite

# Crea utente git e directory dati
RUN adduser -D -u 1000 -g git -s /bin/bash git \
    && mkdir -p /data \
    && chown git:git /data

# Copia run.sh
COPY run.sh /
RUN chmod a+x /run.sh

EXPOSE 3000 22

CMD [ "/run.sh" ]
