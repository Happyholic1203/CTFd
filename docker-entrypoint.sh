#!/bin/sh

if [ -n "$DATABASE_URL" ]
    then
    # https://stackoverflow.com/a/29793382
    echo "Waiting on MySQL"
    while ! mysqladmin ping -h db --silent; do
        # Show some progress
        echo -n '.';
        sleep 1;
    done
    echo "Ready"
    # Give it another second.
    sleep 1;
fi

echo "Starting CTFd"
gunicorn --bind 0.0.0.0:8000 -w ${WORKERS:-1} 'CTFd:create_app()' --access-logfile ${ACCESS_LOG:-/var/log/CTFd/access.log} --error-logfile ${ERROR_LOG:-/var/log/CTFd/error.log}
