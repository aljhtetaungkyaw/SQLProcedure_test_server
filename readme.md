
# MySQL バッチ処理システム構成 (Docker)

このプロジェクトは、Docker環境でMySQLサーバーを立ち上げ、cronを利用して定期的な集計バッチ処理（ストアドプロシージャの実行）を行う構成です。

## 📁 ディレクトリ構造

```text
docker-mysql/
├─ docker-compose.yml       # Docker Compose設定ファイル: MySQL/Batch構成を定義
├─ .env                     # 環境変数: MySQLパスワード、DB名、認証情報
├─ dockerfile               # MySQLベースイメージに cron をインストール
├─ batch/
│  ├─ .env                  # バッチ用環境変数: MySQL接続情報
│  ├─ run_get_monthly_payment.sh      # 月次給与計算・CSV出力スクリプト
│  ├─ run_get_salary_list_by_month.sh  # 全ユーザー給与集計・DB保存スクリプト
│  ├─ logs/
│  │  └─ batch.log          # バッチ実行ログ
│  └─ crontab/
│     ├─ cron               # crontab設定 (1分毎 / 5分毎のスケジュール)
│     ├─ init.sh            # 共通関数・変数定義、MySQL接続用初期化
│     ├─ 01min.sh           # 1分毎実行スクリプト
│     └─ 05min.sh           # 5分毎実行スクリプト
└─ mysql/
   ├─ my.cnf                # MySQL設定 (utf8mb4 等)
   └─ db/
      └─ init/              # 初期化SQL (テーブル作成、ストアドプロシージャ)
          ├─ 01_world.sql
          ├─ 02_sp_add_transportation_cost.sql
          ├─ 03_sp_get_monthly_payment.sql
          └─ 04_sp_get_salary_list_by_month.sql

```

---

## 🚀 セットアップ手順

### 1. コンテナのビルドと起動

プロジェクトのルートディレクトリに移動し、コンテナを起動します。

```bash
# プロジェクトディレクトリへ移動
cd docker-mysql/

# イメージのビルド
docker compose build

# コンテナをバックグラウンドで起動
docker compose up -d

```

### 2. コンテナへのログインとMySQL確認

起動したMySQLコンテナに入り、ストアドプロシージャの状態を確認します。

```bash
# コンテナへのログイン
docker exec -it mysql8 sh

# MySQLにログイン (パスワードは .env の値を入力)
mysql -u root -p

# ストアドプロシージャ一覧の確認
SHOW PROCEDURE STATUS WHERE Db = 'world';

# 特定のプロシージャ詳細を確認
USE world;
SHOW PROCEDURE STATUS LIKE 'sp_get_salary_list_by_month';

```

---

## 🛠 スケジュール（cron）の管理

### cron 設定の書き方

`batch/crontab/cron` ファイル内で時間を指定します。

```bash
# 分 時 日 月 曜日
* * * * * /path/to/script.sh

```

### スクリプトの追加・更新

新しいシェルスクリプト（`.sh`）を追加した際は、実行権限の付与が必要です。

```bash
chmod +x <ファイル名>.sh

```

### 設定反映の手順

`cron` ファイルや設定を修正した後は、変更を反映させるためにコンテナを再ビルドする必要があります。

```bash
# コンテナ停止と削除
docker compose down

# 再ビルドと起動
docker compose build
docker compose up -d

```

---

## 💡 補足事項

* **ログの確認:** バッチの実行結果は `batch/logs/batch.log` で確認できます。
* **環境変数:** データベースの接続情報などは `.env` ファイルで一元管理されています。
