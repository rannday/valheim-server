# Valheim Server Setup
## Ubuntu 20.04

## Install git
`sudo apt install git`

## Create server directory
`sudo mkdir /opt/valheim`

## Create an unprivileged user
`sudo adduser valheim`

## Set folder permissions
`sudo chown valheim:valheim /opt/valheim`

## Install steamcmd
````
sudo apt update && sudo apt upgrade -y
sudo add-apt-repository -y multiverse
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install steamcmd -y
````

## Switch to user
`su - valheim`

## Clone repo
`cd`  
`git clone git@github.com:rannday/valheim-server.git .`

## Run the install script. Requires root for systemd symlinks
`./install.sh`

## TO-DO
Install script isn't done. All it will do is symlink the files to the correct directories

server_files/ to /opt/valheim  
scripts/start.sh & update.sh to /opt/valheim
### This is what requires root
scripts/valheim.service, valheim-backup.service & valheim-backup.timer to /etc/systemd/system

### Also TO-DO
script all of this

## Start and enable the services
`sudo systemctl enable --now valheim.service`  
`sudo systemctl enable --now valheim-backup.timer`

# DONE!
