SET NAMES utf8mb4;
CREATE DATABASE IF NOT EXISTS world;
USE world;

/* ここにテーブル定義・INSERT を書く */
DROP TABLE IF EXISTS user;

CREATE TABLE user (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    status TINYINT NOT NULL DEFAULT 1 COMMENT '1=active, 0=inactive',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO user (username, email, password, full_name, status) VALUES
('admin', 'admin@example.com', 'password123', '管理者 太郎', 1),
('yamada', 'yamada@example.com', 'password123', '山田 花子', 1),
('tanaka', 'tanaka@example.com', 'password123', '田中 一郎', 0),
('john', 'john@example.com', 'password123', 'John Smith', 1),
('testuser', 'test@example.com', 'password123', 'テストユーザー', 1);

DROP TABLE IF EXISTS salary;

CREATE TABLE salary (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL COMMENT 'user.id',
    base_salary INT NOT NULL COMMENT '基本給',
    allowance INT NOT NULL DEFAULT 0 COMMENT '手当',
    bonus INT NOT NULL DEFAULT 0 COMMENT '賞与',
    salary_month CHAR(7) NOT NULL COMMENT '支給月 (YYYY-MM)',
    note VARCHAR(255) COMMENT '備考',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_salary_user
        FOREIGN KEY (user_id)
        REFERENCES user(id)
        ON DELETE CASCADE
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO salary
(user_id, base_salary, allowance, bonus, salary_month, note)
VALUES
(1, 300000, 50000, 100000, '2026-02', '管理職手当あり'),
(2, 250000, 30000, 50000,  '2026-02', '通常支給'),
(3, 220000, 20000, 0,      '2026-02', '試用期間中'),
(4, 280000, 40000, 70000,  '2026-02', '海外プロジェクト'),
(5, 200000, 10000, 0,      '2026-02', '新人社員'),

(1, 300000, 50000, 120000, '2026-03', '業績ボーナス'),
(2, 250000, 30000, 60000,  '2026-03', '通常支給'),
(4, 280000, 40000, 80000,  '2026-03', '特別手当');

DROP TABLE IF EXISTS transportation_cost;

CREATE TABLE transportation_cost (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL COMMENT 'user.id',
    travel_date DATE NOT NULL COMMENT '利用日',
    from_station VARCHAR(100) NOT NULL COMMENT '出発駅',
    to_station VARCHAR(100) NOT NULL COMMENT '到着駅',
    transport_type ENUM('train', 'bus', 'taxi') NOT NULL COMMENT '交通手段',
    amount INT NOT NULL COMMENT '金額（円）',
    note VARCHAR(255) COMMENT '備考',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_transport_user
        FOREIGN KEY (user_id)
        REFERENCES user(id)
        ON DELETE CASCADE
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO transportation_cost
(user_id, travel_date, from_station, to_station, transport_type, amount, note)
VALUES
(1, '2026-02-10', '東京駅', '新宿駅', 'train', 200, '会議出席'),
(2, '2026-02-11', '横浜駅', '品川駅', 'train', 300, '客先訪問'),
(3, '2026-02-12', '大宮駅', '池袋駅', 'train', 320, '研修'),
(4, '2026-02-15', '羽田空港', '東京駅', 'bus',   1000, '出張移動'),
(5, '2026-02-18', '渋谷駅', '六本木駅', 'taxi',  1500, '深夜対応'),

(1, '2026-03-05', '新宿駅', '東京駅', 'train', 200, '定例会議'),
(2, '2026-03-07', '品川駅', '横浜駅', 'train', 300, '客先訪問'),
(4, '2026-03-20', '大阪駅', '新大阪駅', 'taxi', 1200, '緊急対応');

DROP TABLE IF EXISTS salary_summary;

CREATE TABLE salary_summary (
    salary_month CHAR(7) NOT NULL COMMENT '対象月 YYYY-MM',
    user_id INT UNSIGNED NOT NULL COMMENT 'user.id',

    total_salary INT NOT NULL COMMENT '給与合計',
    transport_cost INT NOT NULL COMMENT '交通費合計',
    gross_amount INT NOT NULL COMMENT '支給総額（税引前）',
    tax_amount INT NOT NULL COMMENT '税額',
    net_amount INT NOT NULL COMMENT '手取り額',

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (salary_month, user_id),
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_0900_ai_ci;
