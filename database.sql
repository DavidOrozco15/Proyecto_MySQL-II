CREATE DATABASE IF NOT EXISTS gaseosasValle;

use gaseosasValle;

CREATE TABLE IF NOT EXISTS Clientes(
	id_cliente INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	nombre_completo VARCHAR(100) NOT NULL,
	identificacion VARCHAR(12) NOT NULL,
	direccion VARCHAR(200) NOT NULL,
	telefono VARCHAR(13) NOT NULL,
	correo_electronico VARCHAR(100) NOT NULL
);


CREATE TABLE IF NOT EXISTS Sedes(
	id_sede INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	nombre_sede VARCHAR(100) NOT NULL,
	ubicacion VARCHAR(150) NOT NULL,
	capacidad_almacenamiento INT NOT NULL,
	encargado VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Productos(
	id_producto INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	nombre VARCHAR(100) NOT NULL,
	categoria VARCHAR(100) NOT NULL,
	precio DECIMAL(10,2) NOT NULL,
	volumen_ml DECIMAL(10,2) NOT NULL,
	stock_actual INTEGER NOT NULL,
	stock_minimo INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS Pedidos(
	id_pedido INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	fecha_pedido DATE NOT NULL,
	id_cliente_FK INT NOT NULL,
	id_sede_FK INT NOT NULL,
	total_sin_iva DECIMAL(10,2) NOT NULL,
	total_con_iva DECIMAL(10,2) NOT NULL,
	FOREIGN KEY (id_cliente_FK) REFERENCES Clientes(id_cliente),
	FOREIGN KEY (id_sede_FK) REFERENCES Sedes(id_sede)
);


CREATE TABLE IF NOT EXISTS Detalle_Pedido(
    id_detalle INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    id_pedido_FK INT NOT NULL,
    id_producto_FK INT NOT NULL, 
    cantidad INT NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL, 
    FOREIGN KEY (id_pedido_FK) REFERENCES Pedidos(id_pedido),
    FOREIGN KEY (id_producto_FK) REFERENCES Productos(id_producto)
);

CREATE TABLE IF NOT EXISTS Cambio_Precios(
    id_cambio INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    id_producto_FK INT NOT NULL,
    precio_anterior DECIMAL(10,2) NOT NULL,
    precio_nuevo DECIMAL(10,2) NOT NULL,
    fecha_cambio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (id_producto_FK) REFERENCES Productos(id_producto)
);

INSERT INTO Sedes (nombre_sede, ubicacion, capacidad_almacenamiento, encargado) VALUES 
('Sede Girón - Principal', 'Calle 12 # 23-45 Industrial', 10000, 'Carlos Rodríguez'),
('Sede Bucaramanga - Norte', 'Av. Quebrada Seca # 15-09', 15000, 'Ana María López'),
('Sede Piedecuesta - Sur', 'Carrera 6 # 10-22 Barrio Centro', 8000, 'Julián Castro');

INSERT INTO Clientes (nombre_completo, identificacion, direccion, telefono, correo_electronico) VALUES 
('Tienda La Bendición', '900123456-1', 'Calle 45 # 12-01', '3156789012', 'labendicion@mail.com'),
('Supermercado El Vecino', '1098765432', 'Carrera 27 # 54-10', '3004567890', 'elvecino@atencion.com'),
('Restaurante Doña Flor', '63542189', 'Calle 10 # 8-15', '3109876543', 'flor_ventas@rest.com'),
('Licorería El Paso', '91234567-8', 'Anillo Vial Km 2', '3201234567', 'gerencia@elpaso.co'),
('Estación Central', '1095432100', 'Bulevar Santander', '3116543210', 'central_est@mail.com'),
('Panadería Gran Trigo', '13567890', 'Calle 105 - Provenza', '3187654321', 'pedidos@grantrigo.com'),
('Hamburguesas El Garaje', '800567123-4', 'Cabecera Etapa 4', '3174561234', 'admin@elgaraje.co'),
('Mini Mercado Girón', '1092345678', 'Cerca al Parque Principal', '3019876543', 'minigiron@gmail.com'),
('Club Campestre Bucaramanga', '890123456-0', 'Vía Cañaveral', '3123456789', 'compras@clubcampestre.com'),
('Frutería La Séptima', '37890123', 'Calle 7 # 14-20', '3151239876', 'frutas7@outlook.com'),
('Asadero El Pollo Loco', '1098123456', 'Autopista Floridablanca', '3225678901', 'polloloco@asadero.com'),
('Tienda Los Amigos', '63123456', 'Vereda Chocoita', '3146782345', 'amigos_tienda@mail.com');

INSERT INTO Productos (nombre, categoria, precio, volumen_ml, stock_actual, stock_minimo) VALUES 
('Gaseosa Cola Familiar', 'Gaseosas', 6500.00, 2500, 500, 100),
('Gaseosa Naranja Personal', 'Gaseosas', 2500.00, 350, 1200, 200),
('Agua Mineral Sin Gas', 'Aguas', 1800.00, 500, 50, 60), -- Bajo stock
('Soda Cristal 1L', 'Sodas', 3200.00, 1000, 180, 50),
('Jugo de Mango Caja', 'Jugos', 4500.00, 1000, 25, 30), -- Bajo stock
('Gaseosa Limón Litro', 'Gaseosas', 3800.00, 1000, 300, 100),
('Agua con Gas 600ml', 'Aguas', 2000.00, 600, 450, 100),
('Té Helado Durazno', 'Té', 3500.00, 500, 120, 40),
('Energizante Valle Power', 'Energizantes', 5500.00, 400, 85, 25),
('Gaseosa Uva 1.5L', 'Gaseosas', 4200.00, 1500, 210, 80),
('Soda de Jengibre', 'Sodas', 3900.00, 300, 45, 50), -- Bajo stock
('Jugo de Mora Botella', 'Jugos', 2800.00, 400, 600, 150),
('Gaseosa Manzana Familiar', 'Gaseosas', 6500.00, 2500, 480, 100),
('Limonada Natural Pack', 'Jugos', 12000.00, 2000, 15, 20), -- Bajo stock
('Agua Purificada Botellón', 'Aguas', 15000.00, 20000, 100, 20);