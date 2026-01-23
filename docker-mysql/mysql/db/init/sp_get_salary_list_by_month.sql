DROP PROCEDURE IF EXISTS sp_get_salary_list_by_month;

-- プロシージャ内の複数のセミコロンを含めるため、ステートメント終端を // に変更
DELIMITER //

CREATE PROCEDURE sp_get_salary_list_by_month (
    IN p_month CHAR(7) -- 'YYYY-MM'
)
BEGIN
    DECLARE tax_rate DECIMAL(5,2) DEFAULT 0.10;

    /* ① 同じ月のデータを削除 */
    DELETE FROM salary_summary
    WHERE salary_month = p_month;

    /* ② 月次集計結果を INSERT */
    INSERT INTO salary_summary
    (
        salary_month,
        user_id,
        total_salary,
        transport_cost,
        gross_amount,
        tax_amount,
        net_amount
    )
    SELECT
        p_month AS salary_month,
        u.id AS user_id,

        IFNULL(s.base_salary + s.allowance + s.bonus, 0) AS total_salary,
        IFNULL(SUM(t.amount), 0) AS transport_cost,

        IFNULL(s.base_salary + s.allowance + s.bonus, 0)
        + IFNULL(SUM(t.amount), 0) AS gross_amount,

        ROUND(
            (
                IFNULL(s.base_salary + s.allowance + s.bonus, 0)
                + IFNULL(SUM(t.amount), 0)
            ) * tax_rate
        ) AS tax_amount,

        (
            IFNULL(s.base_salary + s.allowance + s.bonus, 0)
            + IFNULL(SUM(t.amount), 0)
        )
        - ROUND(
            (
                IFNULL(s.base_salary + s.allowance + s.bonus, 0)
                + IFNULL(SUM(t.amount), 0)
            ) * tax_rate
        ) AS net_amount

    FROM user u
    LEFT JOIN salary s
        ON s.user_id = u.id
       AND s.salary_month = p_month
    LEFT JOIN transportation_cost t
        ON t.user_id = u.id
       AND DATE_FORMAT(t.travel_date, '%Y-%m') = p_month
    GROUP BY
        u.id,
        s.base_salary,
        s.allowance,
        s.bonus;
END // -- プロシージャの終了（// で終端）

-- ステートメント終端を ; に戻す（その後の SQL が正常に実行されるため）
DELIMITER ;