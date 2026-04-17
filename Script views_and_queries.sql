CREATE VIEW vista_resumen_pedidos_por_sede AS
	SELECT
		s.nombre_sede,
		COUNT(p.id_pedido) AS 'Total Pedidos',
		SUM(p.total_con_iva) AS 'Total Ventas'  	
	FROM Sedes s 
	JOIN Pedidos p ON p.id_sede_FK = s.id_sede
	GROUP BY s.id_sede, s.nombre_sede;

CREATE VIEW vista_productos_bajo_stock AS
	SELECT p.nombre, p.categoria, p.stock_actual, p.stock_minimo
	FROM Productos p 
	WHERE p.stock_actual <= p.stock_minimo;


CREATE VIEW vista_clientes_activos AS
	SELECT c.nombre_completo AS 'Cliente Activo', COUNT(id_pedido) AS 'Total Pedidos'
	FROM Clientes c 
	JOIN Pedidos p ON c.id_cliente = p.id_cliente_FK
	WHERE p.id_pedido > 0
	GROUP BY c.id_cliente, c.nombre_completo;

-- Consultar los productos con stock por debajo del mínimo.
SELECT p.nombre AS 'Nombre del Producto', p.stock_actual AS 'Stock Actual', p.stock_minimo AS 'Stock Minimo'  
FROM Productos p
WHERE p.stock_actual < p.stock_minimo;
  
-- Consultar los pedidos realizados entre dos fechas (BETWEEN).
SELECT p.fecha_pedido, c.nombre_completo , s.nombre_sede  
FROM Pedidos p
JOIN Clientes c ON p.id_cliente_FK = c.id_cliente
JOIN Sedes s ON p.id_sede_FK = s.id_sede 
WHERE p.fecha_pedido BETWEEN '2026-02-25' AND '2026-04-01';

-- Listar los productos más vendidos (con JOIN y GROUP BY).
SELECT 
FROM 
WHERE 

-- Mostrar clientes y la cantidad de pedidos realizados.
SELECT c.nombre_completo AS Cliente, COUNT(p.id_pedido) AS 'Cantidad Pedidos Realizador' 
FROM Clientes c 
LEFT JOIN Pedidos p ON p.id_cliente_FK = c.id_cliente 
GROUP BY c.id_cliente, c.nombre_completo;  

-- Buscar clientes por nombre parcial usando LIKE.
SELECT c.nombre_completo AS 'Cliente'
FROM Clientes c 
WHERE c.nombre_completo LIKE '%EL%';

-- Consultar productos de ciertas categorías usando IN.
SELECT 
FROM 
WHERE 

-- Mostrar el cliente con mayor número de pedidos (subconsulta).
SELECT 
FROM 
WHERE 

-- Consultar pedidos y sus totales agrupados por sede.
SELECT 
FROM 
WHERE