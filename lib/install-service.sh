#!/bin/bash

IPFS_PATH=/var/lib/ipfs
IPFS_USER=ipfs-daemon

ipfs_running="
There's already an ipfs service installed and running. Are you sure you don't
want to run update-ipfs.sh?
"
if service ipfs status &>/dev/null; then
  printf "$ipfs_running"
  select yn in "Exit" "Continue anyways"; do
    case $yn in
      "Exit" ) exit;;
      "Continue anyways" ) service ipfs stop; break;;
    esac
  done
fi

## Note: Copying rather than linking avoids permissions problems
cp $GOPATH/bin/ipfs /usr/local/bin/ipfs
if [ ! -d $IPFS_PATH ]; then mkdir -p $IPFS_PATH; fi

echo "Initializing ipfs... This can take some time to generate the keys"
ipfs init >/dev/null

## Check if the daemon user exists
id -u $IPFS_USER &>/dev/null
if [ $? -ne 0 ]; then
  useradd --system $IPFS_USER --shell /bin/false
fi
chown -R $IPFS_USER:$IPFS_USER $IPFS_PATH

cp init.d/ipfs /etc/init.d/ipfs
chmod +x /etc/init.d/ipfs
update-rc.d ipfs defaults >/dev/null

msg="
****************************  Daemon Installed!  *******************************
The ipfs daemon has now been installed. You may now start it as a system
service. With most distros you can run the following to start the service:
                        \`sudo service ipfs start\`

The ipfs configuration can be found at $IPFS_PATH/

However, one last step!!!
The IPFS_PATH environment variable with the location of the ipfs
configuration must be loaded into your shell when running ipfs commands.
So add into your .bashrc:
                       export IPFS_PATH=$IPFS_PATH
"
printf "$msg"
