#!/bin/bash

function check_config {
  if [ ! -f "$PWD/conf.env" ]; then
    echo "ERROR: Missing configuration file"
    exit 1
  fi
  source $PWD/conf.env
}

function debug_config {
  echo "$NAME"
  echo "$PORT"
  echo "$WORLD"
  echo "$PASS"
  echo "$PUB"
  echo "$APP_ID"
  echo "$SESSION"
  echo "$GAME_DIR"
  echo "$SAVE_DIR"
  echo "$UNIT_DIR"
}

function create_dirs {
  if [ ! -d "$GAME_DIR" ]; then
    mkdir $GAME_DIR
  fi
  if [ ! -d "$SAVE_DIR" ]; then
    mkdir $SAVE_DIR
  fi
  if [ ! -d "$UNIT_DIR" ]; then
    mkdir -p $UNIT_DIR
  fi
}

function build_start {
  # build startup script
  start_s="$GAME_DIR/start.sh"
  echo "#!/bin/sh" > $start_s
  echo "" >> $start_s
  echo "export TERM=roxterm" >> $start_s
  echo "export templdpath=\$LD_LIBRARY_PATH" >> $start_s
  echo "export LD_LIBRARY_PATH=./linux64:\$LD_LIBRARY_PATH" >> $start_s
  echo "export SteamAppId=$APP_ID" >> $start_s
  echo "" >> $start_s
  echo "echo \"Starting server PRESS CTRL-C to exit\"" >> $start_s
  echo "" >> $start_s
  echo "./valheim_server.x86_64 -name \"$NAME\" -port $PORT -world \"$WORLD\" -password \"$PASS\" -savedir $SAVE_DIR -public $PUB" -crossplay >> $start_s
  #echo "./valheim_server.x86_64 -name \"$NAME\" -port $PORT -world \"$WORLD\" -password \"$PASS\" -public $PUB" >> $start_s
  echo "" >> $start_s
  echo "export LD_LIBRARY_PATH=\$templdpath" >> $start_s
  echo "" >> $start_s

  chmod +x $start_s
}

function build_update {
  # build update script
  update_s="$GAME_DIR/update.sh"
  echo "#!/bin/sh" > $update_s
  echo "" >> $update_s
  echo "/usr/games/steamcmd +login anonymous +force_install_dir $GAME_DIR +app_update $APP_ID_SRV validate +exit" >> $update_s
  echo "" >> $update_s

  chmod +x $update_s
}

function build_service {
  # build service
  service_s="$HOME/.config/systemd/user/valheim.service"
  echo "[Unit]" > $service_s
  echo "Description=Valheim service" >> $service_s
  echo "After=network-online.target" >> $service_s
  echo "Wants=network-online.target" >> $service_s
  echo "" >> $service_s
  echo "[Service]" >> $service_s
  echo "Type=forking" >> $service_s
  echo "Restart=on-failure" >> $service_s
  echo "RestartSec=5" >> $service_s
  echo "StartLimitInterval=60s" >> $service_s
  echo "StartLimitBurst=3" >> $service_s
  echo "RemainAfterExit=yes" >> $service_s
  echo "WorkingDirectory=$GAME_DIR" >> $service_s
  echo "ExecStart=/usr/bin/tmux new-session -s $SESSION -d '/usr/bin/sh $GAME_DIR/start.sh; exec \$SHELL'" >> $service_s  #echo "ExecStartPre=/usr/bin/sh $GAME_DIR/update.sh" >> $service_s
  echo "ExecStop=/usr/bin/tmux kill-session -t $SESSION" >> $service_s
  echo "ExecReload=/bin/kill -s HUP" >> $service_s
  echo "KillSignal=SIGINT" >> $service_s
  echo "LimitNOFILE=100000" >> $service_s
  echo "" >> $service_s
  echo "[Install]" >> $service_s
  echo "WantedBy=multi-user.target" >> $service_s
  echo "" >> $service_s
  systemctl --user daemon-reload
  sleep .1
}

function install_game {
  if [ ! -f "$GAME_DIR/server_start.sh" ]; then
    /usr/games/steamcmd +login anonymous +force_install_dir $GAME_DIR +app_update $APP_ID_SRV validate +exit
  fi
}

function start_service {
  systemctl --user start valheim.service
  sleep .1
  systemctl --user enable valheim.service
  systemctl --user status valheim.service
}

check_config
#debug_config
create_dirs
build_start
build_update
build_service
install_game
#start_service

echo "Done! exiting"
exit 0
