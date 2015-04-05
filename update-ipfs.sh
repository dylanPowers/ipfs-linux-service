#!/bin/bash

cd "$(dirname "$0")"

source lib/download.sh

sudo service ipfs stop

if [ ! $GOPATH ]; then
  echo "I'm missing a GOPATH environment variable :("
  exit
else
  sudo cp $GOPATH/bin/ipfs /usr/local/bin/ipfs
fi

sudo service ipfs start
