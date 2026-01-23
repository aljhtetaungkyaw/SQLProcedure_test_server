#!/bin/sh

. /batch/crontab/init.sh

CALLER="$1"

{
    echo "----------------------------------------"
    echo "[$NOW] START"
    echo "Caller    : $CALLER"
    echo "Procedure : sp_get_salary_list_by_month"

    mysql_exec "CALL sp_get_salary_list_by_month('$MONTH_FULL');" 2>&1
    RESULT=$?

    if [ $RESULT -eq 0 ]; then
        echo "Result    : SUCCESS"
    else
        echo "Result    : FAILED (code=$RESULT)"
    fi

    echo "[$NOW] END"
} >> "$LOG_FILE" 2>&1