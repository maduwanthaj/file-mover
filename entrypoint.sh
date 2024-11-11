#!/bin/sh

# source the common library
source /app/lib.sh

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

# function to schedule a one-time task using cron
once() {
    echo "${1} touch ${SENTINEL} && /app/app.sh" > /etc/crontabs/root
    log_info "one-time file-moving task has been created."
}

# function to schedule a recurring task using cron
schedule() {
    echo "${1} /app/app.sh" > /etc/crontabs/root
    log_info "scheduled file-moving task has been created."
}

# function to execute the main application script directly
app() {
    sh /app/app.sh
}

# parse command-line arguments and execute appropriate functions
case "${1}" in
    "--run-once")
        [ -n "${2}" ] && once "${2}" || app
        # start cron in the foreground
        crond -f 2> /dev/null ;;
    "--schedule")
        [ -n "${2}" ] && schedule "${2}" || usage
        # start cron in the foreground
        crond -f 2> /dev/null ;;
    "--help")
        usage ;;
    "--version")
        echo "Version: ${VERSION}" ;;
    *)
        usage ;;
esac