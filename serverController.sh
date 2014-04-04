#!/bin/bash

# ARGS = { $1=command, $2=map/mode, $3=mode }

SRCDS_PATH=/home/dedicated/steamcmd/gmod/srcds_run
SESSION_NAME=GModServer
GAME=garrysmod

DEFAULTMAP=gm_construct
DEFAULTGAMEMODE=sandbox

case "$1" in
  start ) 
          if [ `ps u | grep srcds | grep -v grep | awk -F ' ' '{print $2}' | head -n1` ]
          then
            echo 'Server is already started'
          else
            if [[ -z "$2" ]]
            then
              screen -S $SESSION_NAME -d -m $SRCDS_PATH -game $GAME +host_workshop_collection `cat workshop` -authkey `cat authkey` +map $DEFAULTMAP +gamemode $DEFAULTGAMEMODE # Screen creates session, sends command there and detatches. When command finished, session will finish too.
            else
              screen -S $SESSION_NAME -d -m $SRCDS_PATH -game $GAME +host_workshop_collection `cat workshop` -authkey `cat authkey` +map $2 +gamemode $3
            fi
            echo $2 $3 | cat > status
            echo "Server started"
          fi;;
  changemap )
          if [ `ps u | grep srcds | grep -v grep | awk -F ' ' '{print $2}' | head -n1` ];
          then
            screen -S $SESSION_NAME -p 0 -X stuff "map $2 $(printf \\r)"
            echo $2 `awk -F ' ' '{print $2}' status`  | cat >status 
          else
            echo "Server is Halted"
          fi;;
  changemode)
          if [ `ps u | grep srcds | grep -v grep | awk -F ' ' '{print $2}' | head -n1` ];
          then
            screen -S $SESSION_NAME -p 0 -X stuff "gamemode $2 $(printf \\r)"
            echo `awk -F ' ' '{print $1}' status` $2  | cat >status 
          else
            echo "Server is Halted"
          fi;;
  kill )  
          for PIDAL in `ps u | grep srcds | grep -v grep | awk -F ' ' '{print $2}'| head -n 2` # screen session will also stop
          do 
            kill $PIDAL
          done
          rm status
          echo "All processes killed"
          ;;
  status )
          if [ `ps u | grep srcds | grep -v grep | wc -l | awk -F ' ' '{print $1}'` -eq 0 ];
          then
            echo "Halted"
          else
            echo "Running $(cat status)"
          fi;;
  pids )  
          echo "Server pids:"
          for PIDAL in `ps u | grep srcds | grep -v grep | awk -F ' ' '{print $2}'` # screen session will also stop
          do 
            echo $PIDAL
          done;;
  * ) 
          echo; echo "Usage:"; echo; echo "  start <MAP> <MODE> - start server with MAP and MODE."; echo "  changemap <MAP> - changes current map"; echo "  changemode <MODE> - changes current gamemode"; echo "  kill - kills server processes."; echo "  status - get status of server."; echo "  pids - get pids of server and screen"; echo;;
esac

