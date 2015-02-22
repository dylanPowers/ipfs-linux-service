#!/bin/bash

if [ $EUID -ne 0 ]; then
  echo "I can't do much without root. Run me again with root privileges"
  exit
fi

if [ ! $GOPATH ]; then
  echo "I'm missing a GOPATH environment variable. Try again with sudo -E"
  exit
fi

export IPFS_PATH=/var/lib/ipfs
IPFS_USER=ipfs-daemon

ln -sf $GOPATH/bin/ipfs /usr/local/bin/ipfs
if [ ! -d $IPFS_PATH ]; then mkdir -p $IPFS_PATH; fi
ipfs init >/dev/null
  
## Check if the daemon user exists
id -u $IPFS_USER &>/dev/null
if [ $? -ne 0 ]; then
  useradd --system $IPFS_USER --shell /bin/false
fi
chown -R $IPFS_USER:$IPFS_USER $IPFS_PATH

cp init.d/ipfs /etc/init.d/ipfs
chmod +x /etc/init.d/ipfs

msg="
*********************************  Success!  ***********************************
The ipfs daemon has now been installed. You may now start it as a system
service. With most distros you can run the following to start the service:
                        \`sudo service ipfs start\`

The ipfs configuration can be found at $IPFS_PATH/

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  One last step  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
The IPFS_PATH environment variable with the location of the ipfs 
configuration must be loaded into your shell when running ipfs commands. 
So add into your .bashrc:
                       export IPFS_PATH=$IPFS_PATH
"
printf "$msg"
