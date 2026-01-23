#!/bin/sh

# 環境変数を読み込む
if [ -f /batch/.env ]; then
    export $(cat /batch/.env | grep -v '^#' | xargs)
fi

# 共通変数
MONTH=`date +%m`
DATE=`date +%d`
HOUR=`date +%H`
MINUTE=`date +%M`
NOW=`date "+%Y-%m-%d %H:%M:%S"`
MONTH_FULL=`date "+%Y-%m"`
LOG_DIR="/batch/logs"
LOG_FILE="${LOG_DIR}/batch.log"

mysql_exec() {
    mysql -h mysql \
            -u"${MYSQL_BATCH_USER}" \
            -p"${MYSQL_BATCH_PASSWORD}" \
            "${MYSQL_DATABASE}" \
            -e "$1"
}

# CSVファイルへ結果を出力する共通関数
export_result_to_csv() {
    local output_file="$1"
    local input_sql="$2"
    
    # SQLを実行してCSVに出力
    mysql_exec "$input_sql" > "$output_file"
}