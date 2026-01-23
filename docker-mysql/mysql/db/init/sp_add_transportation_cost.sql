DROP PROCEDURE IF EXISTS sp_add_transportation_cost;

DELIMITER //

CREATE PROCEDURE sp_add_transportation_cost (
    IN p_user_id INT,
    IN p_travel_date DATE,
    IN p_from_station VARCHAR(100),
    IN p_to_station VARCHAR(100),
    IN p_transport_type ENUM('train','bus','taxi'),
    IN p_amount INT,
    IN p_note VARCHAR(255)
)
BEGIN
    INSERT INTO transportation_cost
    (user_id, travel_date, from_station, to_station, transport_type, amount, note)
    VALUES
    (p_user_id, p_travel_date, p_from_station, p_to_station,
     p_transport_type, p_amount, p_note);
END //

DELIMITER ;
