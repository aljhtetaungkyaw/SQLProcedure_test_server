#!/bin/sh

. /batch/crontab/init.sh

CALLER="$1"
USER_ID="$2"
FILE_NAME=$(basename "$0")
OUTPUT_FILE="${LOG_DIR}/_${FILE_NAME}_$(date '+%Y%m%d_%H%M%S').csv"

{
    echo "----------------------------------------"
    echo "[$NOW] START"
    echo "Caller    : $CALLER"
    echo "Procedure : sp_get_monthly_payment"
    echo "User ID   : $USER_ID"

    export_result_to_csv "$OUTPUT_FILE" "CALL sp_get_monthly_payment($USER_ID, '$MONTH_FULL');"
    RESULT=$?

    if [ $RESULT -eq 0 ]; then
        echo "Result    : SUCCESS"
        echo "Output    : $OUTPUT_FILE"
    else
        echo "Result    : FAILED (code=$RESULT)"
    fi

    echo "[$NOW] END"
} >> "$LOG_FILE" 2>&1