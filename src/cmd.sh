#!/usr/bin/env bash


# Override cron.d configuration
if [ -e /home/sindria/config/cron.d/app ]; then
    cp /home/sindria/config/cron.d/app /etc/cron.d/
fi

# Fix permission
chown root:root /etc/cron.d/*
chmod 644 /etc/cron.d/*
chmod 644 /etc/supervisor/*.conf
chmod 644 /etc/supervisor/conf.d/*.conf
chown -R sindria:sindria /var/www/app

# Override timezone by env
if [ "$TZ" != "" ] || [ "$TZ" != "Europe/Rome" ]; then
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
fi


#/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

/usr/sbin/crond -f -l 8
