ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:15.0.8
FROM $BUILD_FROM

# Install requisiti
RUN apk add --no-cache \
    git \
    openssh \
    sqlite \
    curl \
    bash

# Set Forgejo version
ENV FORGEJO_VERSION=12.0.3

# Scarica e installa Forgejo (solo amd64)
RUN curl -fsSL -o /usr/local/bin/forgejo \
        "https://codeberg.org/forgejo/forgejo/releases/download/v${FORGEJO_VERSION}/forgejo-${FORGEJO_VERSION}-linux-amd64" \
    && chmod +x /usr/local/bin/forgejo

# Crea utente git e directory dati
RUN adduser -D -u 1000 -g git -s /bin/bash git \
    && mkdir -p /data \
    && chown git:git /data

# Copia run.sh
COPY run.sh /
RUN chmod a+x /run.sh

EXPOSE 3000 22

CMD [ "/run.sh" ]
