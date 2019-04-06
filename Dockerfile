#
# Jenkins docker in docker agent for craftdock/jenkins
#
FROM docker:18-dind

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
	# Clear apk's cache
	&& apk-cleanup

RUN \    
    # Add tools commonly used
    apk-install --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --repository http://dl-cdn.alpinelinux.org/alpine/main/community/ \
        bash \
        bzip2 \
        ca-certificates \
        docker-bash-completion>=18.03.1 \
        g++ \
        gcc \
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
        nss \
	# Clear apk's cache
	&& apk-cleanup

RUN \    
    # Add docker-compose
    apk-install --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --repository http://dl-cdn.alpinelinux.org/alpine/main/community/ \
        py-pip python-dev libffi-dev openssl-dev libc-dev \
    && pip install --upgrade pip \
    && pip install docker-compose \
	# Clear apk's cache
	&& apk-cleanup