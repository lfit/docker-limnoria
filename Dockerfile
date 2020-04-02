FROM python:3.8-alpine

LABEL maintainer Sumant Manne <sumant.manne@gmail.com>
LABEL description Docker image for the Limnoria IRC bot

ENV LIMNORIA_VERSION="master" \
    MEETBOT_VERSION="master"

RUN apk add --update git gcc musl-dev libffi-dev openssl-dev python3-dev && \
    pip3 install -r https://raw.githubusercontent.com/ProgVal/Limnoria/${LIMNORIA_VERSION}/requirements.txt && \
    pip3 install git+https://github.com/ProgVal/Limnoria.git@${LIMNORIA_VERSION} --upgrade && \
    pip3 install git+https://github.com/dwt2/meetbot.git@${MEETBOT_VERSION} --upgrade && \
    apk del git gcc musl-dev libffi-dev openssl-dev python3-dev && \
        rm -rf /var/cache/apk/*

ENV SUPYBOT_NICK="collabottest" \
    SUPYBOT_USER="collabottest" \
    SUPYBOT_NETWORKS="freenode" \
    SUPYBOT_FREENODE_PASSWORD="" \
    SUPYBOT_FREENODE_SERVERS="chat.freenode.net:6697" \
    SUPYBOT_FREENODE_CHANNELS="abaranov-test"

COPY ["start.sh", "/usr/local/bin/"]
RUN chmod 0755 /usr/local/bin/start.sh

RUN adduser -S limnoria && \
    mkdir -p /data && \
    mkdir -p /config/conf && \
    chown -R limnoria /data

COPY ["config.conf", "/config"]
RUN chown -R limnoria /config

USER limnoria

VOLUME ["/data"]
WORKDIR /data

CMD sed -i "s/SUPYBOT_NICK/${SUPYBOT_NICK}/; \
            s/SUPYBOT_USER/${SUPYBOT_USER}/; \
            s/SUPYBOT_NETWORKS/${SUPYBOT_NETWORKS}/; \
            s/SUPYBOT_FREENODE_PASSWORD/${SUPYBOT_FREENODE_PASSWORD}/; \
            s/SUPYBOT_FREENODE_SERVERS/${SUPYBOT_FREENODE_SERVERS}/; \
            s/SUPYBOT_FREENODE_CHANNELS/${SUPYBOT_FREENODE_CHANNELS}/;" /config/config.conf \
    && head /config/config.conf \
    && exec supybot /config/config.conf


# ONBUILD ARG CONFIG_FOLDER=config
# ONBUILD ADD [CONFIG_FOLDER] .
