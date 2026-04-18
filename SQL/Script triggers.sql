DELIMITER $$
CREATE TRIGGER tr_auditar_cambio_precio
AFTER UPDATE ON Productos
FOR EACH ROW 
BEGIN 
	IF OLD.precio <> NEW.precio THEN 
		INSERT INTO Cambio_Precios(id_producto_FK,precio_anterior,precio_nuevo) VALUES (OLD.id_producto, OLD.precio, NEW.precio);
	END IF;
END $$

DELIMITER ;

DELIMITER $$
CREATE TRIGGER tr_actualizar_stock
AFTER INSERT ON Detalle_Pedido
FOR EACH ROW
BEGIN 
	UPDATE Productos SET stock_actual = stock_actual - NEW.cantidad WHERE id_producto = NEW.id_producto_FK;
END $$

DELIMITER ;