#!/bin/bash

# ARGS = { $1=command, $2=map, $3=mode }

SRCDS_PATH=/home/dedicated/steamcmd/gmod/srcds_run
SESSION_NAME=GModServer
GAME=garrysmod

case "$1" in
  start ) 
          screen -S $SESSION_NAME -d -m $SRCDS_PATH -game $GAME +map $2 +gamemode $3 # Screen creates session, sends command there and detatches. When command finished, session will finish too.
          echo "Server started";;
  stop )  
          screen -S $SESSION_NAME -X stuff 'quit' # Screen sends command. 'stuff' with X - choosing buffer for command you send. ^M can be gathered in Vim by pressing ctrl-v,ctrl-m -> Enter press
          echo "Server stopped" ;;
  kill )  
          for PIDEL in `ps u | grep srcds | awk -F ' ' '{print $2}'| head -n 2` # screen session will also stop
          do 
            kill $PIDEL
          done
          echo "All processes killed"
          ;;
  status )
          if [ `ps u | grep srcds | wc -l | awk -F ' ' '{print $1}'` -eq 1 ];
          then
            echo "Shutted down"
            echo "0"
          else
            echo "Working"
            echo "1"
          fi;;
  pids )  
          echo "Server pids:"
          for PIDEL in `ps u | grep srcds | awk -F ' ' '{print $2}'| head -n 2` # screen session will also stop
          do 
            echo $PIDEL
          done;;
  * ) 
          echo; echo "Usage:"; echo; echo "  start <MAP> <MODE> - start server with MAP and MODE."; echo "  stop - stops server."; echo "  kill - kills server processes."; echo "  status - get status of server."; echo "  pids - get pids of server and screen"; echo;;
esac

