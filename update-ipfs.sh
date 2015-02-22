#!/bin/sh
go get -u github.com/jbenet/go-ipfs/cmd/ipfs
sudo service ipfs stop

if [ ! $GOPATH ]; then
  echo "I'm missing a GOPATH environment variable :("
  exit
else
  sudo cp $GOPATH/bin/ipfs /usr/local/bin/ipfs
fi

sudo service ipfs start