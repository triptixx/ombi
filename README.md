[hub]: https://hub.docker.com/r/loxoo/ombi
[mbdg]: https://microbadger.com/images/loxoo/ombi
[git]: https://github.com/triptixx/ombi
[actions]: https://github.com/triptixx/ombi/actions

# [loxoo/ombi][hub]
[![Layers](https://images.microbadger.com/badges/image/loxoo/ombi.svg)][mbdg]
[![Latest Version](https://images.microbadger.com/badges/version/loxoo/ombi.svg)][hub]
[![Git Commit](https://images.microbadger.com/badges/commit/loxoo/ombi.svg)][git]
[![Docker Stars](https://img.shields.io/docker/stars/loxoo/ombi.svg)][hub]
[![Docker Pulls](https://img.shields.io/docker/pulls/loxoo/ombi.svg)][hub]
[![Build Status](https://github.com/triptixx/ombi/workflows/docker%20build/badge.svg)][actions]

## Usage

```shell
docker run -d \
    --name=srvombi \
    --restart=unless-stopped \
    --hostname=srvombi \
    -p 5000:5000 \
    -v $PWD/config:/config \
    loxoo/ombi
```

## Environment

- `$SUID`         - User ID to run as. _default: `952`_
- `$SGID`         - Group ID to run as. _default: `952`_
- `$TZ`           - Timezone. _optional_

## Volume

- `/config`       - Server configuration file location.

## Network

- `5000/tcp`      - WebUI.
