#!/bin/sh

# script version
VERSION="0.1"

# color codes for formatting output
C_BOLD="\033[1m"
C_BLUE="\033[0;34m"
C_RESET="\033[0m"

# define source and target directories for file operations
SOURCE="/app/source"
TARGET="/app/target"

# define the log file location
LOG_FILE="/app/log/file-mover.log"

# function to log informational messages
log_info() {
    local msg="${1}"
    echo "time=$(date "+%Y-%m-%d %T") level=info msg=${msg}" | tee -a "${LOG_FILE}"
}

# function to log error messages and exit
log_error() {
    local msg="${1}"
    echo "time=$(date "+%Y-%m-%d %T") level=error msg=${msg}" | tee -a "${LOG_FILE}"
    exit 1
}

# function to display usage instructions
usage() {
    printf "${C_BOLD}Usage:${C_RESET}  entrypoint.sh [OPTIONS] [ARG...]\n\n"
    printf "${C_BOLD}Options:${C_RESET}\n"
    printf "${C_BLUE}%-20s${C_RESET} %-50s\n" "--schedule [TIME]" "schedule the container to run repeatedly at a specified time."
    printf "${C_BLUE}%-20s${C_RESET} %-50s\n" "--run-once [TIME]" "run the container once at a specified time or immediately."
    printf "${C_BLUE}%-20s${C_RESET} %-50s\n" "--help" "display this help message."
    printf "${C_BLUE}%-20s${C_RESET} %-50s\n" "--version" "display the script version."
    printf "\n"
}

# function to schedule a one-time task using at
once() {
    local time="${1}"
    echo "${time} /app/app.sh ; sed -i '/app.sh/d' /etc/crontabs/root" ; > /etc/crontabs/root
    log_info "one-time file-moving task has been created." && crond -f
}

# function to schedule a recurring task using cron
schedule() {
    local time="${1}"
    echo "${time} /app/app.sh" > /etc/crontabs/root
    log_info "scheduled file-moving task has been created." && crond -f
}

# function to execute the main application script directly
app() {
    sh /app/app.sh
}

# parse command-line arguments and execute appropriate functions
case "${1}" in
    "--run-once")
        [ -n "${2}" ] && once "${2}" || app ;;
    "--schedule")
        [ -n "${2}" ] && schedule "${2}" || usage ;;
    "--help")
        usage ;;
    "--version")
        echo "Version: ${VERSION}" ;;
    *)
        usage ;;
esac