SET NAMES utf8mb4;
DROP PROCEDURE IF EXISTS sp_get_monthly_payment;

DELIMITER //

CREATE PROCEDURE sp_get_monthly_payment (
    IN p_user_id INT,
    IN p_month CHAR(7) -- 'YYYY-MM'
)
BEGIN
    SELECT
        u.id AS user_id,
        u.username,
        u.full_name,
        p_month AS target_month,

        IFNULL(SUM(s.base_salary + s.allowance + s.bonus), 0) AS total_salary,
        IFNULL(SUM(t.amount), 0) AS total_transport_cost,
        IFNULL(SUM(s.base_salary + s.allowance + s.bonus), 0)
        + IFNULL(SUM(t.amount), 0) AS grand_total

    FROM user u
    LEFT JOIN salary s
        ON s.user_id = u.id
       AND s.salary_month = p_month
    LEFT JOIN transportation_cost t
        ON t.user_id = u.id
       AND DATE_FORMAT(t.travel_date, '%Y-%m') = p_month
    WHERE u.id = p_user_id
    GROUP BY u.id;
END //

DELIMITER ;
