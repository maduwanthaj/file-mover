#!/bin/sh

# script version
VERSION="0.1"

# color codes for formatting output
C_BOLD="\033[1m"
C_BLUE="\033[0;34m"
C_RESET="\033[0m"

# define log file and directories
LOG_FILE="/app/log/file-mover.log"
SOURCE="/app/source"
TARGET="/app/target"
SENTINEL="/tmp/cron_task_in_progress"

# function to log informational messages
log_info() {
    echo "$(date "+%Y-%m-%d %T") level=info msg=$1" | tee -a "$LOG_FILE"
}

# function to log error messages and exit
log_error() {
    echo "$(date "+%Y-%m-%d %T") level=error msg=$1" | tee -a "$LOG_FILE"
    exit 1
}