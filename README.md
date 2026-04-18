# 🥤 Gaseosas del Valle S.A. - Sistema de Gestión de Inventario y Ventas

¡Hola! 👋 Bienvenido al repositorio de **Gaseosas del Valle S.A.** Este proyecto es una base de datos relacional diseñada para automatizar la operación comercial de una distribuidora de bebidas. El objetivo principal fue eliminar los procesos manuales, asegurar que el inventario se actualice solo y mantener un registro auditable de los precios. Todo esto estructurado directamente desde el motor de base de datos usando SQL puro.

---

## 🗺️ Modelo Entidad-Relación

Para arrancar, diseñamos la arquitectura de los datos. La lógica fue centralizar la operación en las ventas (Pedidos), conectando a los clientes, las sucursales y el catálogo de productos, asegurando que ninguna tabla quede "flotando" sin relación.

![Modelo Entidad-Relación](./IMG/Modelo%20Entidad-Relacion.png)

---

## 🗄️ Estructura de Tablas (El Core del Negocio)

Diseñamos 6 tablas clave. La idea fue separar las entidades maestras de las tablas transaccionales para evitar redundancia de datos.

* **`Clientes`**: La tabla maestra de compradores. Se configuró con llaves primarias autoincrementables y campos obligatorios (NOT NULL) para nombre, identificación y contacto.
* **`Sedes`**: Representa nuestras sucursales. Además de la ubicación, le agregamos capacidad de almacenamiento y un encargado para futuros módulos de logística.
* **`Productos`**: Nuestro catálogo maestro. El truco aquí fue no solo poner el precio, sino integrar dos columnas clave: `stock_actual` y `stock_minimo`, las cuales son la base para nuestras alertas de inventario.
* **`Pedidos`**: Funciona como la "cabecera" de la factura. Une el `id_cliente` con el `id_sede` mediante llaves foráneas. Aquí guardamos la fecha y los totales financieros.
* **`Detalle_Pedido`**: La tabla transaccional más importante. Rompe la relación muchos a muchos entre Pedidos y Productos. Almacena qué se vendió y en qué cantidad. **Es la tabla que activa los triggers de inventario.**
* **`Cambio_Precios`**: Una tabla 100% de auditoría. No se toca manualmente. Se diseñó para recibir datos automáticos de un trigger cada vez que el precio de un producto cambia.

---

## ⚙️ Lógica de Negocio (Funciones y Triggers)

Para que la base de datos sea "inteligente" y no dependa de un software externo para hacer cálculos, programamos la lógica directamente en el motor:

### Funciones de Cálculo y Validación
* **Función: Cálculo de Total con IVA**
    * *Cómo se hizo:* Creamos una función determinística que recibe el ID de un pedido, hace un `SELECT SUM` de todos los subtotales en la tabla de detalles para ese pedido, y multiplica el resultado por 1.19. Esto garantiza que el impuesto siempre se calcule igual y sin errores.
* **Función: Validación de Stock**
    * *Cómo se hizo:* Se programó un bloque condicional (`IF/ELSE`) que recibe el ID del producto y la cantidad pedida. Compara esto con el `stock_actual` y devuelve un simple "DISPONIBLE" o "AGOTADO". Es un escudo preventivo.

### Triggers (Disparadores Automáticos)
* **Trigger: Actualización de Stock en Tiempo Real**
    * *Cómo se hizo:* Se configuró un evento `AFTER INSERT` sobre la tabla `Detalle_Pedido`. Por cada nueva línea de venta, el trigger hace un `UPDATE` en la tabla `Productos`, restando la cantidad (`NEW.cantidad`) del stock actual. El bodeguero virtual perfecto.
* **Trigger: Auditoría de Precios**
    * *Cómo se hizo:* Se usó un evento `AFTER UPDATE` en la tabla `Productos`. Incluimos un condicional que verifica si el precio viejo (`OLD.precio`) es diferente al nuevo (`NEW.precio`). Si es así, hace un `INSERT` en la tabla de `Cambio_Precios` guardando ambos valores y la estampa de tiempo (`CURRENT_TIMESTAMP`).

---

## 🔭 Vistas (Views) - Acceso rápido a datos críticos

Las vistas se crearon para que la gerencia pueda consultar métricas clave sin necesidad de escribir sentencias JOIN complejas repetidamente.

**1. Vista: Resumen de Pedidos por Sede**
* *Cómo se hizo:* Unimos Sedes y Pedidos agrupando por el ID de la sede. Aplicamos `COUNT` para el volumen de ventas y `SUM` para el flujo de dinero.
![Vista Resumen Pedidos](./IMG/Vista%20Resumen%20Pedidos%20Por%20Sede.png)

**2. Vista: Productos con Bajo Stock**
* *Cómo se hizo:* Una consulta sencilla sobre la tabla Productos aplicando un filtro en el `WHERE` para mostrar únicamente aquellos donde el `stock_actual` sea menor o igual al `stock_minimo`.
![Vista Stock Bajo](./IMG/Vista%20Productos%20Bajo%20Stock.png)

**3. Vista: Clientes Activos**
* *Cómo se hizo:* Un `JOIN` entre Clientes y Pedidos. Agrupamos por cliente y usamos `COUNT` para enlistar cuántas compras ha realizado cada uno.
![Vista Clientes Activos](./IMG/View%20Clientes%20Activos.png)

---

## 📊 Análisis de Datos (Consultas Estratégicas)

El sistema responde a 8 requerimientos analíticos fundamentales. Aquí detallamos cómo se construyeron lógicamente:

**1. Consultar los productos con stock por debajo del mínimo.**
* *Cómo se hizo:* Se compararon dos columnas de la misma tabla usando un condicional `<=` en la cláusula `WHERE`, proyectando solo el nombre y los datos de stock.
![Consulta 1](./IMG/Consulta%201.png)

**2. Consultar los pedidos realizados entre dos fechas.**
* *Cómo se hizo:* Se utilizaron múltiples `JOIN` para traer el nombre del cliente y la sede, y se filtró el rango temporal usando el operador `BETWEEN` sobre la columna `fecha_pedido`.
![Consulta 2](./IMG/Consulta%202.png)

**3. Listar los productos más vendidos.**
* *Cómo se hizo:* Se cruzó el catálogo con el detalle de ventas. En lugar de contar facturas, usamos `SUM(cantidad)` bajo un `GROUP BY` por producto, y ordenamos los resultados de forma descendente (`ORDER BY DESC`).
![Consulta 3](./IMG/Consulta%203.png)

**4. Mostrar clientes y la cantidad de pedidos realizados.**
* *Cómo se hizo:* Para garantizar que aparecieran incluso los clientes que no han comprado, se utilizó un `LEFT JOIN` desde la tabla Clientes hacia Pedidos, agrupando por el nombre.
![Consulta 4](./IMG/Consulta%204.png)

**5. Buscar clientes por nombre parcial.**
* *Cómo se hizo:* Se implementó un motor de búsqueda básico en el `WHERE` utilizando el operador `LIKE` y el comodín `%` para encontrar coincidencias en cualquier parte de la cadena.
![Consulta 5](./IMG/Consulta%205.png)

**6. Consultar productos de ciertas categorías.**
* *Cómo se hizo:* Para evitar usar múltiples sentencias `OR`, agrupamos las categorías solicitadas ('Sodas', 'Aguas') dentro de un operador `IN()`, dándole un orden alfabético.
![Consulta 6](./IMG/Consulta%206.png)

**7. Mostrar el cliente con mayor número de pedidos.**
* *Cómo se hizo:* Se implementó una subconsulta como tabla derivada. La subconsulta agrupa, cuenta y limita a 1 (`LIMIT 1`) al ganador, y luego la consulta externa trae el nombre.
![Consulta 7](./IMG/Consulta%207.png)

**8. Consultar pedidos y sus totales agrupados por sede.**
* *Cómo se hizo:* Se relacionaron Sedes y Pedidos. Usamos dos funciones de agregación simultáneas: un `COUNT` para transacciones y un `SUM` para el gran total recaudado con IVA.
![Consulta 8](./IMG/Consulta%208.png)

---

## 🚀 Próximos Pasos (Expansión)

1.  **Módulo de Proveedores:** Conectar la alerta de bajo stock con una tabla de órdenes de compra automáticas.
2.  **Módulo de Logística:** Tablas de Rutas, Vehículos y Conductores para cada sede.
3.  **Fidelización:** Reglas de negocio para aplicar descuentos automáticos a los clientes top.