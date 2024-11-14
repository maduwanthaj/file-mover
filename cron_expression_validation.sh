#!/bin/sh

# function to validate the cron expression using regex patterns for each field
cron_expression_validation() {
    # regular expressions for cron field validation
    minute_regex='^(\*|([1-5]?[0-9](-[1-5]?[0-9])?)(/[1-9][0-9]*)?(,(\*|[1-5]?[0-9](-[1-5]?[0-9])?)(/[1-9][0-9]*)?)*)$'
    hour_regex='^(\*|((1?[0-9]|2[0-3])(-(1?[0-9]|2[0-3]))?)(/[1-9][0-9]*)?(,(\*|(1?[0-9]|2[0-3])(-(1?[0-9]|2[0-3]))?)(/[1-9][0-9]*)?)*)$'
    day_of_month_regex='^(\*|([1-9]|[1-2][0-9]|3[0-1])(-([1-9]|[1-2][0-9]|3[0-1]))?)(/[1-9][0-9]*)?(,(\*|([1-9]|[1-2][0-9]|3[0-1])(-([1-9]|[1-2][0-9]|3[0-1]))?)(/[1-9][0-9]*)?)*$'
    month_regex='^(\*|([1-9]|1[0-2])(-([1-9]|1[0-2]))?)(/[1-9][0-9]*)?(,(\*|([1-9]|1[0-2])(-([1-9]|1[0-2]))?)(/[1-9][0-9]*)?)*$'
    day_of_week_regex='^(\*|[0-6](-[0-6])?)(/[1-9][0-9]*)?(,(\*|[0-6](-[0-6])?)(/[1-9][0-9]*)?)*$'

    # read and split the cron expression fields, then validate each field
    while read -r minute hour day_of_month month day_of_week; do
        log_info "starting validation for cron entry: minute='$minute', hour='$hour', day of month='$day_of_month', month='$month', day of week='$day_of_week'"

        # validate each field using the defined regular expressions
        if echo "$minute" | grep -Eq "$minute_regex"; then
            log_info "minute field '$minute' is valid."
        else
            log_error "minute field '$minute' is invalid. must be '*', a number 0-59, or a valid range or list."
            return 1
        fi

        if echo "$hour" | grep -Eq "$hour_regex"; then
            log_info "hour field '$hour' is valid."
        else
            log_error "hour field '$hour' is invalid. must be '*', a number 0-23, or a valid range or list."
            return 1
        fi

        if echo "$day_of_month" | grep -Eq "$day_of_month_regex"; then
            log_info "day of month field '$day_of_month' is valid."
        else
            log_error "day of month field '$day_of_month' is invalid. must be '*', a number 1-31, or a valid range or list."
            return 1
        fi

        if echo "$month" | grep -Eq "$month_regex"; then
            log_info "month field '$month' is valid."
        else
            log_error "month field '$month' is invalid. must be '*', a number 1-12, or a valid range or list."
            return 1
        fi

        if echo "$day_of_week" | grep -Eq "$day_of_week_regex"; then
            log_info "day of week field '$day_of_week' is valid."
        else
            log_error "day of Week field '$day_of_week' is invalid. must be '*', a number 0-6, or a valid range or list."
            return 1
        fi

        log_info "all fields are valid for cron entry: '$minute $hour $day_of_month $month $day_of_week'"
    done < <(echo "$1")
}