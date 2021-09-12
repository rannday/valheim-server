# Valheim Server Setup
## For Ubuntu / Debian

## Install prerequisites
```
sudo apt update && sudo apt upgrade -y
sudo add-apt-repository -y multiverse
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install git tmux steamcmd -y
```

## Create an unprivileged user
`sudo adduser valheim`

## Switch to user
`su - valheim`

## Clone repo
`cd`  
`git clone https://github.com/rannday/valheim-server.git`