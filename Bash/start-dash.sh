#!/bin/bash 
APP_DIR="/home/dubz/east-side-server" 
LOG_FILE="$APP_DIR/server.log" 
cd "$APP_DIR" || exit 1 
# Activate virtual environment 
source "$APP_DIR/vEast/bin/activate" 
# Kill existing process 
pkill -f "python3 server.py" 2>/dev/null 
echo "Starting East Side Server..." 
echo "Logging to $LOG_FILE" 
# Start app 
nohup python3 server.py >"$LOG_FILE" 2>&1 &
# `chmod + x` `crontab -e` `@reboot /pwd/start-dash.sh` 
# `ps aux | grep server.py
# Tail me a story of the last..
# `tail -f ~/east-side-server/server.log`
