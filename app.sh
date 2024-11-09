#!/bin/sh

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

# log initial status of file check
log_info "checking for new files."

# check if the source directory exists and count the files and directories in it
[ -d "${SOURCE}" ] && file_num=$(find "${SOURCE}" -mindepth 1 -maxdepth 1 \( -type f -o -type d \) | wc -l) || log_error "source directory not found."

# if files or directories are found, proceed to move them
if [ "${file_num}" -gt 0 ]; then
    log_info "${file_num} file(s) found."
    for file in "${SOURCE}"/*; do
        # check if the item is a file or directory before moving
        if [ -f "${file}" ] || [ -d "${file}" ]; then
            mv "${file}" "${TARGET}" && log_info "$(basename "${file}") has been moved." || log_error "failed to move ${file}"
        fi
    done
else
    log_info "no files were found."
fi