ARG TAG_SUFFIX
FROM python:${TAG_SUFFIX}-alpine

ARG TAG_VERSION
ARG HOST_USER_UID
ARG TIMEZONE

LABEL \
	name="python" \
	image="sindriainc/python" \
	tag="${TAG_VERSION}-${TAG_SUFFIX}" \
	vendor="sindria"

ENV TZ=${TIMEZONE}
ENV SINDRIA_USER="sindria"
ENV SINDRIA_USER_HOME="/home/sindria"

RUN apk update

# Install packages and setting
RUN apk add \
    bash \
    dcron \
    supervisor \
    curl \
    wget \
    rsync \
    ca-certificates \
    tzdata && \
    rm -rf /var/cache/apk/*

# Setup cron and supervisor
RUN mkdir -p /var/log/cron && \
    mkdir -m 0644 -p /var/spool/cron/crontabs && \
    touch /var/log/cron/cron.log && \
    mkdir -m 0644 -p /etc/cron.d && \
    mkdir -m 0755 -p /etc/supervisor && \
    mkdir -m 0755 -p /etc/supervisor/conf.d

# Setting app user, timezone and permissions
RUN addgroup -S ${SINDRIA_USER} -g ${HOST_USER_UID} && adduser -s /bin/bash -S ${SINDRIA_USER} -u ${HOST_USER_UID} -G ${SINDRIA_USER} -h ${SINDRIA_USER_HOME} && \
    mkdir -p /var/www && \
    mkdir -p /var/www/app && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    chmod -R 770 /var/www/app && \
    chown -R ${SINDRIA_USER}:${SINDRIA_USER} /var/www/app

# Supervisor configuration
COPY resources/supervisor/supervisord.conf /etc/supervisor/supervisord.conf
COPY resources/supervisor/conf.d/*.conf /etc/supervisor/conf.d/

# Cron configuration
COPY resources/cron/app /etc/cron.d/app

WORKDIR /var/www/app

# Add and execute startup command
COPY cmd.sh /cmd.sh
CMD ["/bin/bash", "/cmd.sh"]
