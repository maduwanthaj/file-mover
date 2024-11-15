#!/bin/sh

# source the common library
source /app/lib.sh

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

# if the sentinel file exists, remove the sentinel and kill the cron process 
[ -f "$SENTINEL" ] && rm -f "${SENTINEL}" && pkill crond > /dev/null 2>&1