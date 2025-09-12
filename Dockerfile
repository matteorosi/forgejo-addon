ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache \
    git \
    openssh \
    sqlite

ENV FORGEJO_VERSION=12.0.3

RUN case "$(uname -m)" in \
        x86_64) ARCH=amd64 ;; \
        aarch64) ARCH=arm64 ;; \
        *) echo "Unsupported architecture"; exit 1 ;; \
    esac \
    && curl -fsSL -o /usr/local/bin/forgejo \
        "https://codeberg.org/forgejo/forgejo/releases/download/v${FORGEJO_VERSION}/forgejo-${FORGEJO_VERSION}-linux-${ARCH}" \
    && chmod +x /usr/local/bin/forgejo

RUN adduser -D -u 1000 -g git -s /bin/bash git \
    && mkdir -p /data \
    && chown git:git /data

COPY run.sh /
RUN chmod a+x /run.sh

EXPOSE 3000 22

CMD [ "/run.sh" ]
