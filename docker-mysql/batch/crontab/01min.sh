#!/bin/sh

. /batch/crontab/init.sh

SCRIPT_NAME=$(basename "$0")

sh /batch/run_get_salary_list_by_month.sh "$SCRIPT_NAME"
sh /batch/run_get_monthly_payment.sh "$SCRIPT_NAME" 2

# if [ "$HOUR" = "15" ] && [ "$MINUTE" = "25" ]; then
#######
# fi
