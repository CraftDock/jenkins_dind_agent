#
# Jenkins docker in docker agent for craftdock/jenkins
#
FROM docker:18.03-dind

LABEL maintainer="Hexosse <hexosse@gmail.com>" \
      description="Minimal Alpine image used as a base image."

RUN \
	# Print executed commands
	set -x \
    # Update repository indexes
    && apk update \
    # Download the install-base script and run it
    && apk add curl \
    && curl -s -o /tmp/install-base.sh https://raw.githubusercontent.com/craftdock/Install-Scripts/master/alpine-base/install-base.sh \
    && sh /tmp/install-base.sh \
    # Add tools commonly used
    && apk-install --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --repository http://dl-cdn.alpinelinux.org/alpine/main/community/ \
        bash \
        bzip2 \
        ca-certificates \
        docker-bash-completion>=18.03.1 \
        git \
        make \
        openjdk8 \
        openssh-client \
        openssl \
        sudo \
        tar \
        unzip \
        zip \
        wget \
    # Add docker-compose
    && apk-install --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --repository http://dl-cdn.alpinelinux.org/alpine/main/community/ \
        py2-pip \
    && pip install --upgrade pip \
    && pip install docker-compose \
	# Clear apk's cache
	&& apk-cleanup