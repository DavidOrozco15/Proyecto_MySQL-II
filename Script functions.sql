DELIMITER $$
CREATE FUNCTION fn_calcular_total_con_iva(id_pedido INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	DECLARE valor DECIMAL(10,2);
	SELECT SUM(subtotal) INTO valor FROM Detalle_Pedido
	WHERE id_pedido_fk = id_pedido;
	
	RETURN IFNULL(valor, 0) * 1.19;
END $$

DELIMITER ;

DELIMITER $$
CREATE FUNCTION fn_validar_stock(p_id_producto INT, cantidad_pedida INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
	DECLARE valor_stock INT;
	SELECT stock_actual INTO valor_stock FROM Productos
	WHERE id_producto = p_id_producto;

	IF valor_stock >= cantidad_pedida THEN
		RETURN 'STOCK DISPONIBLE';
	ELSE
		RETURN 'STOCK AGOTADO';
	END IF;
END $$

DELIMITER ;