#!/bin/sh

#
VERSION="0.1"

#
C_BOLD="\033[1m"
C_BLUE="\033[0;34m"
C_RESET="\033[0m"

#
SOURCE=/app/source
TARGET=/app/target

#
LOG_FILE=/app/log/file-mover.log

# 
usage() {
    printf "${C_BOLD}Usage:${C_RESET}  [OPTIONS] [ARG...]\n"
    printf "\n"
    printf "${C_BOLD}Options:${C_RESET}\n"
    printf "${C_BLUE}%-15s${C_RESET} %-50s\n" "--schedule" "Run the container at a scheduled time repeatedly."
    printf "${C_BLUE}%-15s${C_RESET} %-50s\n" "--run-once" "Run the container only once or at a scheduled time only once."
    printf "${C_BLUE}%-15s${C_RESET} %-50s\n" "--help" "Display this help message."
    printf "${C_BLUE}%-15s${C_RESET} %-50s\n" "--version" "Show the script version."
    printf "\n"
}

# 
log_info () {
	local msg="$1"
	echo "time=$(date "+%Y-%m-%d %T") level=info msg=${msg}" | tee -a "${LOG_FILE}"
}

# 
log_error () {
	local msg="$1"
	echo "time=$(date "+%Y-%m-%d %T") level=error msg=${msg}" | tee -a "${log_file}"
	exit 1
}

# 
if [[ -d "$source_path" ]]; then
	file_num="$(ls -1A "$source_path" | wc -l)"
fi


# 
move () {
	log_info "Checking for new files."
	if [[ "$file_num" -gt 0  ]]; then
		log_info "$file_num file(s) found."
		for file in "$source_path"/*; do
			if [[ -f "$file" || -d "$file" ]]; then
				mv "$file" "$target_path" && log_info "$(basename "$file") has been moved." || log_error "Failed to move $file"
			fi
		done
	else
		log_info "No files were found."
	fi
}

# function to kill if atd service is running
atd_kill () {
	if pgrep -x "atd" >> /dev/null; then
		pkill atd
	fi
}



case "${1}" in
	"--run-once")
		echo "run-once" ;;
	"--schedule")
		echo "schedule" ;;
	"--help")
		usage ;;
	"--version")
		echo "${VERSION}" ;;
	*)
		usage ;;
esac