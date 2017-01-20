#!/usr/bin/env bash

set -eu pipefail

VERSION=1.0
PORTS=("11010" "11011")

for p in "${PORTS[@]}"
do
  docker build --build-arg KALTURA_CONTAINER_PORT=$p -t "yleisradio/kaltura-dev:port-$p-v$VERSION" .
  docker tag "yleisradio/kaltura-dev:port-$p-v$VERSION" "yleisradio/kaltura-dev:port-$p"
done

read -p "Images built. Publish? [yN] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  for p in "${PORTS[@]}"
  do
    docker push "yleisradio/kaltura-dev:port-$p-v$VERSION"
    docker push "yleisradio/kaltura-dev:port-$p"
  done
fi

echo "Done"
