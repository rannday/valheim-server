export TERM=roxterm
export templdpath=$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH
export SteamAppId=892970

./valheim_server.x86_64 -name "SERVER NAME" -port 2456 -world "WorldName" -password "ServerPass" -public 1

export LD_LIBRARY_PATH=$templdpath
