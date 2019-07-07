#!/bin/sh
# Based on https://github.com/docker/compose/blob/master/docker-compose-entrypoint.sh

set -e

source /docker-lib.sh
start_docker

# "Temporary" fix for https://github.com/docker/for-linux/issues/219
mkdir /sys/fs/cgroup/systemd
mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- docker-compose "$@"
fi

# for a valid Docker subcommand, let's invoke it through Docker instead
# (this allows for "docker run docker ps", etc)
if docker-compose help "$1" > /dev/null 2>&1; then
	set -- docker-compose "$@"
fi

exec "$@"
