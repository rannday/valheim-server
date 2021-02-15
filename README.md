# Valheim Server Setup
## Ubuntu 20.04

## Install prerequisites
`sudo apt install git tmux`

## Create server directory
`sudo mkdir /opt/valheim`

## Create an unprivileged user
`sudo adduser valheim`

## Set folder permissions
`sudo chown valheim:valheim /opt/valheim`

## Install steamcmd
```
sudo apt update && sudo apt upgrade -y
sudo add-apt-repository -y multiverse
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install steamcmd -y
```

## Switch to user
`su - valheim`

## Clone repo
`cd`  
`git clone https://github.com/rannday/valheim-server.git`

## Edit start.sh, change server start parameters
`nano valheim-server/scripts/start.sh`

## Create a backup directory
`mkdir backups`

## Pre-install the game
`/usr/games/steamcmd +login anonymous +force_install_dir /opt/valheim +app_update 896660 validate +exit`

## Symlink stuff
```
ln -s /home/valheim/valheim-server/scripts/start.sh /opt/valheim/start.sh  
ln -s /home/valheim/valheim-server/scripts/update.sh /opt/valheim/update.sh  
ln -s /home/valheim/valheim-server/server_files/adminlist.txt /opt/valheim/adminlist.txt  
ln -s /home/valheim/valheim-server/server_files/bannedlist.txt /opt/valheim/bannedlist.txt  
ln -s /home/valheim/valheim-server/server_files/permittedlist.txt /opt/valheim/permittedlist.txt  
```

## Requires root
```
sudo ln -s /home/valheim/valheim-server/scripts/valheim.service /etc/systemd/system/valheim.service  
sudo ln -s /home/valheim/valheim-server/scripts/valheim-backup.service /etc/systemd/system/valheim-backup.service  
sudo ln -s /home/valheim/valheim-server/scripts/valheim-backup.timer /etc/systemd/system/valheim-backup.timer  
```

## Start and enable the services
```
sudo systemctl daemon-reload
sudo systemctl enable --now valheim.service 
sudo systemctl enable --now valheim-backup.timer
```

## Firewall setup example
```
sudo ufw allow in on eno1 to any port 6456 proto udp
sudo ufw allow in on eno1 to any port 6457 proto udp
sudo ufw allow in on eno1 to any port 6458 proto udp 
```

# DONE!

## TO-DO
Script all of this into install.sh

Setup a proper world backup script. Right now, it's just rsync, so if it gets corrupted, the backups will, too.
