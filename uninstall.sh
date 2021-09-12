#!/bin/bash

source $PWD/conf.env

systemctl --user stop valheim.service
tmux kill-session -t $SESSION
rm -rf $GAME_DIR $HOME/.config $HOME/.steam
systemctl --user daemon-reload