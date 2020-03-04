FROM python:3.8-alpine

LABEL maintainer Sumant Manne <sumant.manne@gmail.com>
LABEL description Docker image for the Limnoria IRC bot

ENV LIMNORIA_VERSION master

RUN apk add --update git gcc musl-dev libffi-dev openssl-dev python3-dev && \
    pip3 install -r https://raw.githubusercontent.com/ProgVal/Limnoria/${LIMNORIA_VERSION}/requirements.txt && \
    pip3 install git+https://github.com/ProgVal/Limnoria.git@${LIMNORIA_VERSION} --upgrade && \
    apk del git gcc musl-dev libffi-dev openssl-dev python3-dev && \
    rm -rf /var/cache/apk/*

COPY ["start.sh", "/usr/local/bin/"]
RUN chmod 0755 /usr/local/bin/start.sh

RUN adduser -S limnoria && \
    mkdir -p /data && \
    chown limnoria /data

USER limnoria

VOLUME ["/data"]
WORKDIR /data

CMD ["/usr/local/bin/start.sh"]

# ONBUILD ARG CONFIG_FOLDER=config
# ONBUILD ADD [CONFIG_FOLDER] .
