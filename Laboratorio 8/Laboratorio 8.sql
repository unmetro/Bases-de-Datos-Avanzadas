create table dim_cliente(
	id_cliente serial primary key,
	nombre_cliente varchar(50),
	edad integer,
	genero char(50),
	cuidad varchar(50)
);

create table dim_tiempo(
	id_tiempo serial primary key,
	anio integer,
	mes integer,
	dia integer,
	trimestre integer
);

create table dim_libro(
	id_libro serial primary key,
	titulo varchar(50),
	autor varchar(50),
	genero varchar(50),
	precio_unitario decimal(10,2)
);

create table dim_tienda(
	id_tienda serial primary key,
	nombre_tienda varchar(50),
	cuidad varchar(50),
	pais varchar(50)
);

--Tabla principal de llaves
create table hechos_ventas_libros(
	id_venta serial primary key,
	id_tiempo integer,
	id_libro integer,
	id_cliente integer,
	id_tienda integer,
	cantidad int,
	precio_total decimal(10,2),
	foreign key(id_tiempo) references dim_tiempo(id_tiempo),
	foreign key(id_libro) references dim_libro(id_libro),
	foreign key(id_cliente) references dim_cliente(id_cliente),
	foreign key(id_tienda) references dim_tienda(id_tienda)
);

--inserts
INSERT INTO dim_libro (titulo, autor, genero, precio_unitario) VALUES
('La sombra del viento', 'Carlos Ruiz Zafón', 'Ficción', 15.99),
('Cien años de soledad', 'Gabriel García Márquez', 'Realismo Mágico', 18.50),
('1984', 'George Orwell', 'Distopía', 12.99),
('El principito', 'Antoine de Saint-Exupéry', 'Fábula', 10.99),
('Harry Potter y la piedra filosofal', 'J.K. Rowling', 'Fantasía', 14.99);

INSERT INTO dim_cliente (nombre_cliente, edad, genero, cuidad) VALUES
('Ana Pérez', 28, 'Femenino', 'Madrid'),
('Luis Gómez', 35, 'Masculino', 'Barcelona'),
('María López', 22, 'Femenino', 'Valencia'),
('Carlos Sánchez', 40, 'Masculino', 'Sevilla'),
('Laura Torres', 30, 'Femenino', 'Bilbao');

INSERT INTO dim_tienda (nombre_tienda, cuidad, pais) VALUES
('Tienda Central', 'Madrid', 'España'),
('Librería Norte', 'Barcelona', 'España'),
('Lecturas del Sur', 'Sevilla', 'España');

INSERT INTO dim_tiempo (anio, mes, dia, trimestre) VALUES
(2024, 11, 12, 4),
(2024, 10, 25, 4),
(2024, 9, 15, 3);

INSERT INTO hechos_ventas_libros (id_tiempo, id_libro, id_cliente, id_tienda, cantidad, precio_total) VALUES
(1, 1, 1, 1, 2, 31.98), -- Ana compra 2 copias de "La sombra del viento" en Tienda Central
(1, 2, 2, 2, 1, 18.50), -- Luis compra "Cien años de soledad" en Librería Norte
(2, 3, 3, 1, 1, 12.99), -- María compra "1984" en Tienda Central
(2, 4, 4, 3, 1, 10.99), -- Carlos compra "El principito" en Lecturas del Sur
(2, 5, 5, 2, 3, 44.97), -- Laura compra 3 copias de "Harry Potter" en Librería Norte
(3, 1, 2, 3, 1, 15.99), -- Luis compra "La sombra del viento" en Lecturas del Sur
(3, 2, 1, 1, 1, 18.50), -- Ana compra "Cien años de soledad" en Tienda Central
(1, 3, 3, 2, 2, 25.98), -- María compra 2 copias de "1984" en Librería Norte
(2, 4, 4, 1, 1, 10.99), -- Carlos compra "El principito" en Tienda Central
(3, 5, 5, 3, 1, 14.99); -- Laura compra "Harry Potter" en Lecturas del Sur

--Consultas
--1
CREATE VIEW total_ventas_genero_mes AS
SELECT 
    l.genero,
    t.mes,
    SUM(h.precio_total) AS total_ventas
FROM 
    hechos_ventas_libros h
JOIN dim_libro l ON h.id_libro = l.id_libro
JOIN dim_tiempo t ON h.id_tiempo = t.id_tiempo
GROUP BY l.genero, t.mes;

select *from total_ventas_genero_mes order by mes;

--2
CREATE VIEW cantidad_libros_vendidos_tienda_autor AS
SELECT 
    ti.nombre_tienda,
    l.autor,
    SUM(h.cantidad) AS total_libros_vendidos
FROM 
    hechos_ventas_libros h
JOIN dim_libro l ON h.id_libro = l.id_libro
JOIN dim_tienda ti ON h.id_tienda = ti.id_tienda
GROUP BY ti.nombre_tienda, l.autor;

select *from cantidad_libros_vendidos_tienda_autor order by autor;

--3
CREATE VIEW ingresos_totales_ciudad_trimestre AS
SELECT 
    c.cuidad,
    t.trimestre,
    SUM(h.precio_total) AS ingresos_totales
FROM 
    hechos_ventas_libros h
JOIN dim_cliente c ON h.id_cliente = c.id_cliente
JOIN dim_tiempo t ON h.id_tiempo = t.id_tiempo
GROUP BY c.cuidad, t.trimestre;

select *from ingresos_totales_ciudad_trimestre order by trimestre;

--4
CREATE VIEW total_ventas_y_libros_por_cliente AS
SELECT 
    c.nombre_cliente,
    SUM(h.precio_total) AS total_ventas_cliente,
    SUM(h.cantidad) AS total_libros_comprados
FROM 
    hechos_ventas_libros h
JOIN dim_cliente c ON h.id_cliente = c.id_cliente
GROUP BY c.nombre_cliente;

select *from total_ventas_y_libros_por_cliente order by nombre_cliente;

