docker-mysql/
├─ docker-compose.yml                 # Docker Compose設定ファイル: MySQL コンテナと batch コンテナの構成を定義
├─ .env                               # 環境変数ファイル: MYSQL_ROOT_PASSWORD, MYSQL_DATABASE, ユーザー認証情報等を定義
├─ dockerfile                         # Dockerイメージ定義: MySQL ベースイメージに cron をインストール
├─ batch/
│  ├─ .env                            # バッチ用環境変数: MySQL 接続情報等を定義
│  ├─ run_get_monthly_payment.sh      # バッチスクリプト: 指定ユーザーの月次給与支払額を計算・CSV出力
│  ├─ run_get_salary_list_by_month.sh # バッチスクリプト: 全ユーザーの月次給与一覧を集計・DB保存
│  ├─ logs/
│  │  └─ batch.log                    # バッチ実行ログ: スケジュール実行結果を記録
│  └─ crontab/
│     ├─ cron                         # crontab 設定: 1分毎と5分毎のバッチ実行スケジュール
│     ├─ init.sh                      # crontab 初期化スクリプト: 共通関数・変数定義、MySQL接続機能提供
│     ├─ 01min.sh                     # 1分毎実行スクリプト
│     └─ 05min.sh                     # 5分毎実行スクリプト
└─ mysql/
   ├─ my.cnf                          # MySQL 設定ファイル: 文字セット (utf8mb4) とコレーションを設定
   └─ db/
      └─ init/
         ├─ 01_world.sql                        # DB初期化スクリプト
         ├─ 02_sp_add_transportation_cost.sql   # ストアドプロシージャ: 交通費記録を追加
         ├─ 03_sp_get_monthly_payment.sql       # ストアドプロシージャ: 指定ユーザーの月次給与情報を取得
         └─ 04_sp_get_salary_list_by_month.sql  # ストアドプロシージャ: 全ユーザーの月次給与を集計・税額計算
--------------------------------------------------------------------------
#パスまで移動
cd docker-mysql/

# コンテナの作成
$ docker composer build
$ docker compose up -d

# 起動したコンテナにログイン
$ docker exec -it mysql8 sh

# MySQLを起動
$ mysql -u root -p

# この後パスワードを入力して完了

# ストアドプロシージャ一覧を確認
SHOW PROCEDURE STATUS WHERE Db = 'world';

# プロシージャ詳細を確認
use world;
SHOW PROCEDURE STATUS LIKE 'sp_get_salary_list_by_month';

#cronファイルに時間設定
分 時 日 月 曜日
*  *  *  *  *

#シェルスクリプト（shell Script）を新規追加ファイルをやるべきこと（windowであればバッチ「.bat」ファイルと似ている）
chmod +x ファイル名.sh

crontab/cronファイルを修正後以下のコメントを実行
$ docker composer down
$ docker composer build
$ docker compose up -d
