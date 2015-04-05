#!/bin/bash

cd "$(dirname "$0")"

if [ ! $GOPATH ]; then
  echo "I'm missing a GOPATH environment variable. Do you have Go configured correctly?"
  exit
fi

source lib/download.sh

echo "Installing the service now. This will require root"
sudo -E lib/install-service.sh
