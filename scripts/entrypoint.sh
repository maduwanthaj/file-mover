#!/bin/sh

# source the common library
source /app/lib.sh

# source the cron validation script
source /app/cron_expression_validation.sh

# function to display usage instructions
show_usage() {
    printf "${C_BOLD}Usage:${C_RESET}  entrypoint.sh [OPTIONS] [ARG...]\n\n"
    printf "${C_BOLD}Options:${C_RESET}\n"
    printf "${C_BLUE}%-20s${C_RESET} %-50s\n" "--schedule [TIME]" "schedule the container to run repeatedly at a specified time."
    printf "${C_BLUE}%-20s${C_RESET} %-50s\n" "--run-once [TIME]" "run the container once at a specified time or immediately."
    printf "${C_BLUE}%-20s${C_RESET} %-50s\n" "--help" "display this help message."
    printf "${C_BLUE}%-20s${C_RESET} %-50s\n" "--version" "display the script version."
    printf "\n"
    exit 0
}

# function to add cron job based on input type
set_cron_job() {
    echo "${1} /app/app.sh" > /etc/crontabs/root
    log_info "${2} file-moving task has been created."
}

# function to print the script version
show_version() {
    printf "${C_BOLD}Version:${C_RESET} ${VERSION}\n\n"
    exit 0
}

# function to execute the main application script directly
execute_app() {
    sh /app/app.sh
}

# function to create a one-time task or schedule it at a specified time
create_one_time_task() {
    if [ -n "${1}" ]; then
        touch "${SENTINEL}"
        set_cron_job "${1}" "one-time"
    else
        log_info "immediate file-moving task has been created."
        execute_app
        exit 0
    fi
}

# function to create a recurring task based on a specified time
create_schedule_task() {
    if [ -n "${1}" ]; then
        set_cron_job "${1}" "scheduled"
    else
        show_usage
        exit 0
    fi
}

# parse command-line arguments and execute appropriate functions
case "${1}" in
    "--help")
        show_usage ;;
    "--version")
        show_version ;;
    "--run-once")
        cron_expression_validation "${2}"
        create_one_time_task "${2}" ;;
    "--schedule")
        cron_expression_validation "${2}"
        create_schedule_task "${2}" ;;
    *)
        show_usage ;;
esac

# start cron in the foreground
crond -f 2> /dev/null