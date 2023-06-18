FROM node:bullseye
MAINTAINER R. Hessing

# Set default timezone to UTC
ENV TZ=Etc/UTC
ENV TINI_VERSION v0.19.0

WORKDIR /usr/app

# Install requirements for Tini and PHP extension builds
RUN apt-get update && apt-get install --no-install-recommends -y \
        build-essential \
        default-mysql-client \
        git \
        npm \
        openssh-server \
        unzip \
        zip

# Install ulixee hero
RUN npm i --save @ulixee/hero

# Install tiny
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
COPY docker-entrypoint.sh /usr/local/bin/

# Create default user 'python'
# Fix issue with k8s authorized_keys and configmaps
# Keep SSH connection open
RUN echo "" >> /etc/ssh/sshd_config \
    && echo "ClientAliveInterval 3" >> /etc/ssh/sshd_config \
    && chmod 755 /bin/tini \
    && chmod 755 /usr/local/bin/docker-entrypoint.sh \
    && mkdir -p /usr/app \
    && addgroup -gid 9876 node \
    && adduser -uid 9876 -gid 9876 --shell /bin/bash --disabled-password --gecos '' node \
    && passwd -u node \
    && mkdir -p /home/node/.ssh \
    && mkdir -p /home/node/.vscode-server \
    && chown node:node /home/node/.ssh \
    && chown node:node /home/node/.vscode-server \
    && chmod 0700 /home/node/.ssh

# Cleanup
RUN rm -rf /tmp/* \
    && rm -rf /var/cache/apt/* \
    && rm -rf /var/lib/apt/lists/* \
    # Always refresh keys
    && rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key

EXPOSE 22
ENTRYPOINT ["/bin/tini", "--"]

CMD ["/usr/local/bin/docker-entrypoint.sh"]
