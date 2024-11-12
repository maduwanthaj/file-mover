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

# function to add cron job based on input type
set_cron_job() {
    echo "${1} /app/app.sh" > /etc/crontabs/root
    log_info "${2} file-moving task has been created."
}

# function to execute the main application script directly
app() {
    sh /app/app.sh
}

# parse command-line arguments and execute appropriate functions
case "${1}" in
    "--help")
        usage
        exit 0 ;;
    "--version")
        echo "Version: ${VERSION}"
        exit 0 ;;
    "--run-once")
        if [ -n "${2}" ]; then
            touch "${SENTINEL}"
            set_cron_job "${2}" "one-time"
        else
            app
            exit 0
        fi ;;
    "--schedule")
        if [ -n "${2}" ]; then
            set_cron_job "${2}" "scheduled"
        else
            usage
            exit 0
        fi ;;
    *)
        usage
        exit 0 ;;
esac

# start cron in the foreground
crond -f 2> /dev/null