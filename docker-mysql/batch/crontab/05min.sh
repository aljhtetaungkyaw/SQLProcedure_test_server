#!/bin/sh

. /batch/crontab/init.sh

SCRIPT_NAME=$(basename "$0")

sh /batch/run_procedure.sh "$SCRIPT_NAME"
