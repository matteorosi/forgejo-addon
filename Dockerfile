ARG BUILD_FROM=ghcr.io/hassio-addons/base:15.0.8
FROM $BUILD_FROM

# Install requirements
RUN apk add --no-cache \
    git \
    openssh \
    sqlite

# Set Forgejo version
ENV FORGEJO_VERSION=12.0.3

# Download and install Forgejo
RUN case "$(uname -m)" in \
        x86_64) ARCH=amd64 ;; \
        aarch64) ARCH=arm64 ;; \
        armv7l) ARCH=arm-7 ;; \
        armv6l) ARCH=arm-6 ;; \
        i386) ARCH=386 ;; \
        *) echo "Unsupported architecture"; exit 1 ;; \
    esac \
    && curl -fsSL -o /usr/local/bin/forgejo \
        "https://codeberg.org/forgejo/forgejo/releases/download/v${FORGEJO_VERSION}/forgejo-${FORGEJO_VERSION}-linux-${ARCH}" \
    && chmod +x /usr/local/bin/forgejo

# Create git user and directories
RUN adduser -D -u 1000 -g git -s /bin/bash git \
    && mkdir -p /data \
    && chown git:git /data

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

EXPOSE 3000 22

CMD [ "/run.sh" ]
