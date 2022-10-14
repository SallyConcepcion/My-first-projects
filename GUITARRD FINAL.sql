------------------------------------------------------------- DATABASE-----------------------------------------------------------
--GUITARRD
--Vendemos todo tipo de guitarras a buen precio
--Tienda no.1 en RD

--RESTRICCIONES PROPIAS DEL NEGOCIO
--No se aceptan Telefonos en blanco.
--En Sales.Territory en Country tiene que salir RD siempre.(DEF)
--Fecha actual donde sea requerida para ingresar algun dato.
--Store y Territory tienen que machear.
--en Orders EmployeeID tiene que machear con su respectivo Storeid y Territoryid (un empleado de LV no pudo haber vendido en SD)
--Total no puede ser ni mas ni menos que la cantidad exacta ordenada por su precio
--unique index en CardNumber



CREATE DATABASE GUITARRD

USE GUITARRD

--CREANDO LOS ESQUEMAS

CREATE SCHEMA Person
CREATE SCHEMA Products
CREATE SCHEMA HR
CREATE SCHEMA Sales



--CREANDO LAS TABLAS

--CLIENTES

CREATE TABLE Person.Clientes(
ClienteID INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
Nombres VARCHAR (20)NOT NULL,
Apellidos VARCHAR(20) NOT NULL,
Telefono VARCHAR(20)NOT NULL, CONSTRAINT No_tel_vacio CHECK(Telefono <> ''),    
TerritorioID INT NOT NULL,
CreditCardID INT NOT NULL,
);



ALTER TABLE Person.Clientes ADD FOREIGN KEY (TerritorioID) REFERENCES Sales.Territorio(TerritorioID)

ALTER TABLE Person.Clientes ADD FOREIGN KEY (CreditCardID) REFERENCES Person.CreditCard(CreditCardID)

--CREDITCARD

CREATE TABLE Person.CreditCard(
CreditCardID INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
CardType VARCHAR (20)NOT NULL,
CardNumber VARCHAR (20) NOT NULL, 
ExpMonth INT NOT NULL,
ExpYear INT NOT NULL,
ModifiedDate DATETIME NOT NULL,
);
ALTER TABLE Person.CreditCard ADD DEFAULT (GETDATE()) FOR [ModifiedDate]

CREATE UNIQUE INDEX ui_tarjeta on Person.CreditCard(CardNumber)


--PRODUCTOS

CREATE TABLE Products.Productos(
ProductoID INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
NombreProducto VARCHAR (30)NOT NULL,
CategoriaID INT NOT NULL,
PrecioUnitario DECIMAL NOT NULL,
UnidadesAlmacen INT NULL,
);


ALTER TABLE Products.Productos ADD FOREIGN KEY (CategoriaID) REFERENCES Products.Categorias(CategoriaID)


--STORE

CREATE TABLE Sales.Tienda(
TiendaID INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
NombreTienda VARCHAR (20) NOT NULL,
TerritorioID INT NOT NULL,
);

ALTER TABLE Sales.Tienda ADD FOREIGN KEY (TerritorioID) REFERENCES Sales.Territorio(TerritorioID)


--CATEGORIA

CREATE TABLE Products.Categorias(
CategoriaID INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
NombreCategoria VARCHAR (30)NOT NULL,
DescripcionCategoria VARCHAR (50) NUll,
);


--EMPLEADOS
CREATE TABLE HR.Empleados(
EmpleadoID INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
Nombres VARCHAR (20)NOT NULL,
Apellidos VARCHAR(20) NOT NULL,
Titulo VARCHAR(20) NOT NULL,
FechaNacimiento VARCHAR(20) NOT NULL,
FechaContrato VARCHAR(20) NOT NULL,
Telefono VARCHAR(20)NOT NULL CONSTRAINT No_tel_vacio1 CHECK(Telefono <> ''),  
DepartamentoID INT NOT NULL,
JornadaID INT NOT NULL,
TerritorioID INT NOT NULL,
TiendaID INT NOT NULL,
);

ALTER TABLE HR.Empleados ADD FOREIGN KEY (DepartamentoID) REFERENCES HR.Departamento(DepartamentoID)
ALTER TABLE HR.Empleados ADD FOREIGN KEY (JornadaID) REFERENCES HR.Jornada(JornadaID)
ALTER TABLE HR.Empleados ADD FOREIGN KEY (TerritorioID) REFERENCES Sales.Territorio(TerritorioID)
ALTER TABLE HR.Empleados ADD FOREIGN KEY (TiendaID) REFERENCES Sales.Tienda(TiendaID)

--DEPARTAMENTO

CREATE TABLE HR.Departamento(
DepartamentoID INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
NombreDepart VARCHAR (20)NOT NULL
);

select * from person.Clientes
--JORNADA

CREATE TABLE HR.Jornada(
JornadaID INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
Nombre VARCHAR (20)NOT NULL,
HoraInicio VARCHAR (20) NOT NULL,
Horafinal VARCHAR (20) NOT NULL,
);


--ORDENES

CREATE TABLE Sales.Ordenes(
OrdenID INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
ClienteID INT NOT NULL,
EmpleadoID INT NOT NULL,
ProductoID INT NOT NULL,
CreditCardID INT NOT NULL,
OrdenCantidades INT NOT NULL,
Total DECIMAL NOT NULL, 
OrderDate DATETIME NOT NULL,
TerritorioID INT NOT NULL,
TiendaID INT NOT NULL,
);
ALTER TABLE Sales.Ordenes ADD DEFAULT (GETDATE()) FOR [OrderDate]

ALTER TABLE Sales.Ordenes ADD FOREIGN KEY (ClienteID) REFERENCES Person.Clientes(ClienteID)
ALTER TABLE Sales.Ordenes ADD FOREIGN KEY (EmpleadoID) REFERENCES HR.Empleados(EmpleadoID)

ALTER TABLE Sales.Ordenes ADD FOREIGN KEY (ProductoID) REFERENCES Products.Productos(ProductoID)
ALTER TABLE Sales.Ordenes ADD FOREIGN KEY (CreditCardID) REFERENCES Person.CreditCard(CreditCardID)
ALTER TABLE Sales.Ordenes ADD FOREIGN KEY (TerritorioID) REFERENCES Sales.Territorio(TerritorioID)
ALTER TABLE Sales.Ordenes ADD FOREIGN KEY (TiendaID) REFERENCES Sales.Tienda(TiendaID)



--TERRITORIO

CREATE TABLE Sales.Territorio(
TerritorioID INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
Provincia VARCHAR (15) NOT NULL,
Pais VARCHAR (15) NOT NULL,
);
ALTER TABLE Sales.Territorio ADD CONSTRAINT Siempre_RD CHECK (Pais = 'RD')

-------------------------------------Creando Data--------------------------------------------------------
USE GUITARRD

---Tabla de Products.Categorias
BEGIN TRANSACTION
INSERT INTO Products.Categorias (NombreCategoria, DescripcionCategoria)
VALUES ('Guitarras Acústicas', 'Tienen cuerdas de nylon, se pinchan con los dedos')

INSERT INTO Products.Categorias (NombreCategoria, DescripcionCategoria)
VALUES ('Guitarra Eléctrica', 'Las cuerdas son mas delgadas, Más popular en Rock')

INSERT INTO Products.Categorias (NombreCategoria, DescripcionCategoria)
VALUES ('Guitarra Semiacustica', 'La caja de resonancia es de metal')

commit

SELECT * FROM Products.Categorias


---Tabla products.Productos
BEGIN TRANSACTION
INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Gibson', 2, 29999.99, 200)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Gretsch', 2, 30000.00, 150)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('BC Rich', 2, 50000.00, 110)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Charvel', 2, 60000.00, 250)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Daisy Rock', 2, 25000.00, 150)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Rickenbacker', 2, 30000.00, 30)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Fender', 2, 40000.00, 250)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Ibanes', 2, 25000.00, 45)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Paul Reed Smith', 2, 45000.00, 150)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Squier', 2, 30000.00, 123)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Epiphone', 2, 45000.00, 250)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Yamaha', 2, 30000.00, 125)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('G&L', 2, 25000.00, 65)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Jackson', 2, 35000.00, 100)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('ESP/LTD', 2, 60000.00, 150)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('John Lennon', 2, 70000.00, 80)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Charcoal', 1, 30000.00, 300)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Satin Black-Top', 1, 25000.00, 126)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Vintage Mahogany', 1, 40000.00, 152)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Cort', 1, 35000.00, 245)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Hummingbird Vintage', 1, 35000.00, 156)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Glenn Frey Dreadnought', 1, 45000.00, 145)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Martin gpcrsgt', 1, 25000.00, 152)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('DREADNOUGHT 16 RGT', 1, 30000.00, 158)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('BlueridgeGuitars BR-160-12', 1, 45000.00, 259)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Martin & Co. DRS1 W', 1, 40000.00, 278)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Ovation S', 1, 50000.00, 288)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('ORQUESTRA OMC 000 HPL', 1, 45000.00, 165)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Gibson Acoustic J-29', 1, 55000.00, 256)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Yamaha F310-PP', 1, 48000.00, 158)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Gibson Acoustic J-45 Standard', 1, 55000.00, 289)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Gibson LG2 American Eagle', 1, 60000.00, 5)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Gretsch G5420T Fairlane Blue', 3, 50000.00, 152)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Godin 5th Avenue CW', 3, 55000.00, 58)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Epiphone Semi-Akustik Deals', 3, 45000.00, 68)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('J&D SA70 Bigsby DGR Dark Green', 3, 45000.00, 59)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Ibanez AS53-TF Tobacco Flat', 3, 48000.00, 89)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Swingster Black Aged Gloss', 3, 48000.00, 59)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Casino Coupe Vintage Sunburst', 3, 45000.00, 87)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Artcore AS53-TKF', 3, 45000.00,46)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Ibanez Artcore AS73-OLM', 3, 48000.00, 58)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Ibanez AS73 TBC', 3, 55000.00, 100)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Ibanez EKM100-WRD', 3, 35000.00, 150)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Gretsch G5622T', 3, 30000.00, 152)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Gretsch G5655TG', 3, 35000.00, 52)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Reissue Vintage Burst', 3, 45000.00,25)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Gibson ES-335 Satin Cherry', 3, 55000.00, 5)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Gibson ES-339 Trans Ebony', 3, 50000.00, 6)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Gibson ES-345 Vintage Burst', 3, 45000.00, 25)

INSERT INTO Products.Productos (NombreProducto, CategoriaID, PrecioUnitario, UnidadesAlmacen)
VALUES ('Gibson Reissue Stopbar', 3, 45000.00, 5)

commit

SELECT * FROM Products.Productos


--- Tabla Sales.Territorio
BEGIN TRANSACTION
INSERT INTO Sales.Territorio (Provincia, Pais)
VALUES ('Santo Domingo', 'RD')

INSERT INTO Sales.Territorio (Provincia, Pais)
VALUES ('Santiago', 'RD')

INSERT INTO Sales.Territorio (Provincia, Pais)
VALUES ('La Vega', 'RD')
commit

SELECT * FROM Sales.Territorio




---Tabla HR.Departamento
begin transaction
INSERT INTO HR.Departamento (NombreDepart)
VALUES ('Ventas')

INSERT INTO HR.Departamento (NombreDepart)
VALUES ('Marketing')

INSERT INTO HR.Departamento (NombreDepart)
VALUES ('Recursos Humanos')

INSERT INTO HR.Departamento (NombreDepart)
VALUES ('Compras')

commit

SELECT * FROM HR.Departamento



---Tabla Sales.Tienda
begin tran
INSERT INTO Sales.Tienda (NombreTienda, TerritorioID)
VALUES ('GUITAR SD', 1)

INSERT INTO Sales.Tienda (NombreTienda, TerritorioID)
VALUES ('GUITAR STG', 2)

INSERT INTO Sales.Tienda (NombreTienda, TerritorioID)
VALUES ('GUITAR LV', 3)

commit

SELECT * FROM Sales.Tienda




---Tabla HR.Jornada
Begin tran
INSERT INTO HR.Jornada (Nombre, HoraInicio, Horafinal)
VALUES ('MAÑANA', '7:00 AM', '3:00 PM')

INSERT INTO HR.Jornada (Nombre, HoraInicio, Horafinal)
VALUES ('TARDE', '3:00 PM', '11:00 PM')

commit

SELECT * FROM HR.Jornada



---Tabla HR.Empleados

begin tran
INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Antoni', 'Martinez', 'Vendedor', '04/05/1992', '12/06/2019', '809-555-5448', 1, 2, 3, 3)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Robert', 'Montero', 'Repr de ventas', '04/04/1986', '19/12/2018', '829-985-2145', 1, 1, 1, 1)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Maria', 'Ogando', 'Dir Recursos Humanos', '26/07/1998', '14/02/2020', '849-123-4163', 3, 1, 2, 2)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Leonela', 'Peguero', 'Repre de Marketing', '30/11/2002', '12/02/2019', '809-524-4785', 2, 1, 1, 1)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Leonardo', 'Franco', 'Vendedor', '11/01/2001', '23/02/2020', '849-458-8556', 1, 2, 1, 1)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Lisbeth', 'Sanchez', 'Asis Recursos H', '14/02/2000', '07/07/2017', '809-754-5223', 3, 2, 2, 2)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Monica', 'Rodriguez', 'Dir Recursos Humanos', '26/12/1998', '05/05/2016', '849-156-4582', 3, 1, 1, 1)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Francisco', 'Solano', 'Director de Ventas', '13/11/1996', '10/01/2020', '829-456-7592', 1, 1, 1, 1)

INSERT INTO HR.Empleados(Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Nestor', 'Castillo', 'Director de ventas','20/06/2002', '12/05/2019', '849-465-6527', 1, 1, 2, 2)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Nicole', 'Bello', 'Asis Recursos H', '15/05/1998', '18/02/2020', '829-475-4582', 3, 2, 3, 3)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Sally', 'Concepcion', 'Dir de Ventas', '24/10/2001', '17/2/2018', '829-475-1254', 1, 1, 3, 3)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Pedro', 'Pimentel', 'Dir de Compras', '14/02/1974', '18/04/2015', '809-539-1548', 4, 1, 3, 3)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Veronica', 'Santos', 'Asis de Marketing', '04/05/1998', '20/12/2014', '829-125-4785', 2, 1, 1, 1)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Mateo', 'Valenciano', 'Dir de Marketing','25/03/2002', '14/07/2013', '829-475-1935', 2, 1, 1, 1)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Junior', 'Guerrero', 'Vendedor','30/01/2003', '21/10/2019', '829-200-1572', 1, 2, 2, 2)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('David', 'Guerrero', 'Vendedor','11/01/2002',' 14/06/2018', '809-418-7596', 1, 1, 3, 3)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Pablo', 'Rincon', 'Vendedor','20/02/2000',' 25/10/2016', '849-147-3698', 1, 2, 3, 3)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Jose', 'Aquino', 'Repre Recursos H','17/12/1987','24/08/2010', '809-145-1236', 3, 1, 3, 3)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Edwanny', 'Castellanos', 'Repre de compras','12/09/2002', '14/05/2016', '809-125-7859', 4, 1, 1, 1)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Joe', 'Guldberg', 'Dir de compras','15/06/1991', '18/07/2018', '82-456-1237', 4, 1, 1, 1)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Julio', 'Magnon', 'Vendedor','14/09/1975', '20/12/2013', '809-429-7594', 1, 1, 3, 3)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Wendys', 'Sanchez', 'Asis Recursos H','30/05/1975', '06/09/2017', '849-173-0694', 3, 2, 2, 2)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Lwendy', 'Terrero', 'Asis de Marketing','12/02/2003', '15/06/2018', '809-746-7896', 2, 1, 1, 1)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Frandy', 'Sanchez', 'Asis de Compras','26/12/1998', '14/08/2016', '829-759-2346', 4, 1, 2, 2)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Julia', 'Santos', 'Asis de Ventas','19/12/1990', '11/03/2019', '849-0369', 1, 2, 3, 3)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Raul', 'Hilario', 'Vendedor','29/11/2000', '17/10/2017', '809-129-8523', 1, 1, 3, 3)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Victo', 'Ramos', 'Repre de Ventas','14/04/2003', '06/11/2016', '829-479-2365', 1, 2, 2, 2)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Kevin', 'Rodriguez', 'Repre Recursos H','27/12/2002', '19/09/2017', '829-156-4526', 3, 2, 1, 1)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Rafael', 'Mella', 'Vendedor','27/02/1965', '13/05/2009', '829-743-4404', 1, 1, 1, 1)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Raphil', 'Mella', 'Repre de Compras','10/01/2001', '20/05/2018', '829-145-9050', 4, 2, 3, 3)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Rocio', 'Jimenez', 'Vendedor','29/10/2000', '16/07/2019', '829-186-1235', 1, 2, 2, 2)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Roberta', 'Martinez', 'Repre de Ventas','16/04/1990', '20/06/2012', '849-196-0368', 1, 2, 3, 3)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Ranny', 'Mella', 'Dir de Marketing','25/03/2003', '26/01/2019', '829-365-9055', 2, 1, 2, 2)

INSERT INTO HR.Empleados (Nombres, Apellidos, Titulo, FechaNacimiento, FechaContrato, Telefono, DepartamentoID, JornadaID, TerritorioID, TiendaID)
VALUES ('Edward', 'Ozuna', 'Repre de Ventas','29/07/1974', '26/01/2020', '829-693-1529', 1, 1, 3, 3)
commit

SELECT * FROM HR.Empleados

BEGIN TRANSACTION

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '19-999-111', 12, 2022)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '19-199-121', 1, 2023)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '19-186-432', 2, 2022) 

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear)
VALUES ('Credito', '23-554-123', 4, 2022)     

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '23-112-455', 5, 2023)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '11-333-456', 4, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '22-376-445', 2, 2025)     

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '23-447-1290', 7, 2022)    

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '18-332-154', 10, 2023)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '12-223-198', 12, 2022)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '11-223-123', 9, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '21-853-237', 5, 2026)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '23-443-227', 5, 2022)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '21-443-567', 1, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '25-653-187', 5, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '21-373-187', 2, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '25-123-156', 7, 2024)
INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '18-563-126', 5, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '11-903-126', 4, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '15-093-506', 4, 2022)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '15-087-306', 4, 2022)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '23-187-056', 4, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '23-016-676', 9, 2023)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '23-186-436', 3, 2023)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '19-246-656', 6, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '29-766-156', 6, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '25-656-436', 5, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '21-986-136', 4, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '25-953-109', 3, 2026)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '15-653-179', 6, 2022)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '20-765-089', 3, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '26-895-189', 7, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '27-765-141', 5, 2023)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '24-165-781', 9, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '22-765-181', 4, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '24-091-187', 4, 2022)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '11-265-067', 1, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '27-645-917', 3, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '23-208-967', 1, 2023)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '26-175-917', 1, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '13-408-667', 7, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '21-985-117', 5, 2023)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '11-168-667', 7, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '12-865-117', 2, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '17-567-167', 7, 2023)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '62-345-877', 1, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '32-167-160', 7, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '16-984-127', 4, 2026)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '91-657-187', 2, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '11-424-877', 12, 2026)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '20-457-091', 7, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '12-821-077', 11, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '71-657-491', 7, 2022)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '89-321-117', 9, 2026)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '19-157-231', 1, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '42-181-907', 7, 2022)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '29-120-431', 5, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '82-431-207', 7, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '29-494-117', 1, 2023)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '35-101-576', 4, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '29-430-711', 9, 2028)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '65-091-119', 2, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '39-110-711', 9, 2028)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '78-432-099', 5, 2022)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '39-546-191', 11, 2023)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '78-432-659', 4, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '32-564-928', 1, 2028)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '67-222-099', 7, 2022)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '22-094-768', 1, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '32-245-909', 5, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '44-674-128', 9, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '32-455-599', 8, 2029)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '23-985-234', 1, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '45-125-099', 8, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '45-175-094', 1, 2023)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '34-076-279', 4, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '12-345-874', 7, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '56-236-547', 2, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '86-755-019', 7, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '57-346-999', 7, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '35-297-719', 6, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '34-096-129', 4, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '27-457-659', 9, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '91-456-529', 8, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '67-551-609', 12, 2024)
INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '45-849-155', 3, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '76-561-119', 2, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '19-069-325', 5, 2022)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '28-541-619', 2, 2023)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear)
VALUES ('Debito', '39-234-109', 4, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '46-145-917', 8, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '82-019-786', 7, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '76-015-267', 3, 2023)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '20-549-896', 6, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '56-185-465', 9, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '76-787-740', 10, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '32-055-465', 10, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '36-981-450', 10, 2022)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '98-376-095', 10, 2022)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '98-381-409', 10, 2022)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '78-286-0435', 10, 2022)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '87-711-299', 6, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '31-764-095', 9, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '65-861-310', 4, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '87-437-865', 10, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '32-001-315', 6, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '92-631-329', 8, 2023)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '76-291-015', 7, 2022)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '94-101-549', 6, 2023)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '36-981-545', 7, 2022)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '65-231-209', 3, 2023)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '98-929-195', 5, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '55-051-309', 10, 2022)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '67-089-895', 4, 2024)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '94-256-867', 10, 2023)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '37-079-815', 6, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '54-226-917', 1, 2025)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '11-079-871', 2, 2023)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Debito', '26-946-754', 10, 2026)

INSERT Person.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) 
VALUES ('Credito', '78-756-111', 12, 2025)
Commit



---Tabla de Person.Clientes
BEGIN TRANSACTION
INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID)
VALUES ('Francis', 'Hernandez', '849-207-0091', 3, 1)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Perla', 'Fernandez', '829-087-1981', 3, 2)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Eva', 'Castillo', '809-182-9681', 2, 3)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES  ('Julio', 'Smith', '849-852-0985', 2, 4)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Juan', 'Asencio', '809-152-1835', 2, 5)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Hilary', N'Duran', N'849-089-9835', 2, 6)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Francisco', 'Pichardo', '809-567-2630', 2, 7)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Jorge', 'Castillo', '829-197-5631', 3, 8)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Alan', 'Corcino', '809-123-9645', 1, 9)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Antonio', 'Rodriguez', '829-089-1765', 1, 10)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Ranny', 'Mella', '809-193-0918', 1, 11)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Sally', 'Perez', '849-967-2984', 2, 12)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Angel', 'Rodriguez', '809-176-8544', 2, 13)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Nestor', 'Castillo', '849-675-0144', 2, 14)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Pedro', 'Santana', '829-175-9854', 1, 15)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Jose', 'Asencio', '829-785-1054', 1, 16)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Jose', 'Torres', '809-111-5584', 1, 17)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Abril', 'Quiñonez', '849-115-0874', 1, 18)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Joel', 'Johnson', '809-455-7174', 1, 19)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Paris', 'Hilton', '849-875-1084', 3, 20)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Juan', 'Soto', '809-110-9884', 3, 21)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Fernando', 'Tatis', '829-097-1198', 3, 22)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('David', 'Ortiz', '809-197-1118', 1, 23)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Nestor', 'Cruz', '809-197-1118', 1, 24)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Daniel', 'Alvarado', '829-997-7818', 1, 25)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Milagros', 'De los santos', '809-117-0518', 3, 26)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Laura', 'Gonzales', '849-078-1198', 2, 27)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Waldy', 'Peralta', '809-106-7248', 2, 28)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Luis', 'Almonte', '849-776-1098', 2, 29)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Maria', 'Dolores', '829-276-2875', 1, 30)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Luis', 'Alcantara', '829-656-7675', 1, 31)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Susana', 'Acosta', '809-110-5675', 3, 32)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Rafael', 'Abreu', '809-775-3422', 1, 33)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Alvaro', 'Torres', '829-985-1192', 1, 34)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Sara', 'Navarro', '809-156-1110', 2, 35)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Erick', 'Gomez', '829-566-9850', 2, 36)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Paloma', 'Valera', '809-076-7612', 2, 37)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Mario', 'Alonso', '829-776-1872', 2, 38)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Carlos', 'Palmeiro', '829-754-8574', 1, 39)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Cecilia', 'Gomez', '809-184-3474', 1, 40)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Rosa', 'Garcia', '849-872-9571', 1, 41)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Arturo', 'Maldonado', '829-962-1171', 2, 42)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Sofia', 'Cordero', '849-162-9971', 2, 43)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Oscar', 'Sanchez', '829-992-4571', 3, 44)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Ana', 'Arrieta', '829-992-4571', 3, 45)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Jaime', 'Diaz', '849-232-1871', 3, 46)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Norma', 'Sandoval', '829-562-1961', 2, 47)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Francisco', 'Parra', '829-672-9861', 1, 48)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Carlos', 'Cisnero', '849-162-4561', 1, 49)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Manuel', 'Acevedo', '829-972-5698', 3, 50)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID)
VALUES ('Anabelle', 'Smith', '849-765-7963', 3, 51)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Victor', 'Castillo', '829-456-1985', 2, 52)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Cesar', 'Fernandez', '829-567-9145', 3, 53)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Wendy', 'Sandoval', '849-661-6143', 1, 54)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Jaime', 'Lopez', '849-321-1267', 2, 55)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Juan', 'Cruz', '829-951-9143', 1, 56)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Juan', 'Cruz', '829-951-9143', 1, 57)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Rocio', 'Cuello', '849-321-1943', 1, 58)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Patricia', 'Quintana', '829-991-5543', 2, 59)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Aurora', 'Cedeño', '829-771-2299', 3, 60)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Ramon', 'Corcino', '809-991-1139', 3, 61)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Margarita', 'Duran', '829-011-8769', 2, 62)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Julio', 'Duran', '829-221-2739', 1, 63)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Elvis', 'Presley', '809-531-2754', 1, 64)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Cesar', 'Balboa', '849-125-7654', 3, 65)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Blanca', 'Silvestre', '809-545-5654', 3, 66)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Clara', 'Quintanilla', '849-115-3254', 3, 67)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Hilary', 'Cruz', '829-564-2254', 1, 68)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES  ('Mario', 'Gomez', '849-114-6754', 1, 69)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Miguel', 'Salazar', '829-539-3498', 3, 70)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Alejandro', 'Cuevas', '849-543-4598', 3, 71)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Gilberto', 'Dominguez', '849-129-4718', 1, 72)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('German', 'Estrada', '829-672-0918', 1, 73)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Alberto', 'Gutierrez', '849-162-3211', 1, 74)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Sergio', 'Garcia', '829-552-3232', 2, 75)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Guadalupe', 'Lopez', '829-122-7652', 2, 76)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Carmen', 'Parra', '849-652-7644', 2, 77)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Bruno', 'Peña', '849-442-1044', 2, 78)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Maria', 'Flores', '829-775-1024', 1, 79)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Jorge', 'Campos', '809-598-1024', 2, 80)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Maria', 'Mora', '849-129-5434', 2, 81)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Martha', 'Campos', '829-179-9934', 2, 82)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Melanie', 'Ortiz', '809-349-5564', 3, 83)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Jesus', 'Martinez', '849-432-5145', 3, 84)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID)
VALUES ('David', 'Perez', '829-112-7845', 3, 85)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Ivan', 'Carrasco', '849-453-1245', 3, 86)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Silvia', 'Contreras', '829-763-1245', 2, 87)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Gabriela', 'Molina', '849-174-2375', 2, 88)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Mauricio', 'Reyes', '829-572-4509', 1, 89)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Rogelio', 'Reynoso', '829-216-5419', 1, 90)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Samuel', 'Angomas', '849-111-4859', 1, 91)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Christian', 'Valdez', '809-521-1269', 3, 92)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Angel', 'Fiallo', '849-432-1115', 2, 93)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Wally', 'Arroyo', '829-552-1325', 2, 94)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Pablo', 'Asencio', '829-782-4325', 2, 95)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Pedro', 'Concepcion', '849-112-4150', 2, 96)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Martha', 'Morales', '829-902-9015', 1, 97)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Gregorio', 'Luperon', '849-122-0945', 1, 98)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Yolanda', 'Muñoz', '829-145-3245', 1, 99)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Juan', 'Nicasio', '849-564-0445', 1, 100)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Nicole', 'Carrillo', N'849-094-1092', 3, 101)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Roberto', 'Martinez', '849-194-0491', 3, 102)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Roberto', 'Estrada', '829-295-4561', 2, 103)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Ana', 'Arcon', '809-194-4544', 2, 104)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Alejandro', 'Marin', '849-324-3444', 2, 105)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Adolfo', 'Suarez', '849-434-9944', 1, 106)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID)
VALUES ('Nayelis', 'Ramirez', '849-424-1144', 1, 107)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Lisbeth', 'Rios', '809-124-7044', 1, 108)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID)
VALUES ('Abelardo', 'Mercado', '849-874-1254', 3, 109)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Fernando', 'Molina', '809-173-1353', 3, 110)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Eduardo', 'Ochoa', '809-173-0976', 3, 111)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Raul', 'Quiñonez', '849-274-1676', 1, 112)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Hugo', 'Tejeda', '809-564-0976', 1, 113)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Enrique', 'Aguilar', '849-120-8776', 1, 114)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Carlos', 'Guerrero', '809-521-8436', 2, 115)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Alfonso', 'Terrero', '829-751-7431', 2, 116)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Jimmy', 'Castro', '809-761-6411', 1, 117)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Nicolas', 'Sanchez', '829-411-7641', 1, 118)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Starling', 'Perez', '849-499-7291', 3, 119)

INSERT Person.Clientes (Nombres, Apellidos, Telefono, TerritorioID, CreditCardID) 
VALUES ('Armando', 'Peña', '809-199-8301', 3, 120)
commit 

---Tabla Sales.Ordenes
BEGIN TRANSACTION
INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (1, 1, 2, 1, 3, 90000.00, 1, 1)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (2, 1, 1, 2, 3, 90000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (3, 5, 20, 3, 2, 120000.00, 1, 1)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (4, 7, 20, 4, 5, 175000.00 , 1, 1)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (5, 11, 5, 5, 2, 50000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (6, 32, 20, 6, 3, 105000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (7, 34, 19, 7, 3, 120000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (8, 30, 23, 8, 3, 75000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (9, 17, 15, 9, 3, 180000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (10, 19, 25, 10, 2, 90000.00, 1, 1)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (11, 32, 41, 11, 3, 144000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (12, 31, 50, 12, 3, 135000.00, 2, 2)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (13, 34, 49, 13, 3, 135000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (14, 30, 39, 14, 2, 90000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (15, 30, 40, 15, 3, 135000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (16, 17, 1, 16, 4, 120000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (17, 20, 49, 17, 2, 90000.00, 1, 1)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (18, 31, 49, 18, 2, 90000.00, 2, 2)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (19, 17, 32, 19, 1, 60000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (20, 14, 45, 20, 2, 70000.00, 1, 1)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (21, 9, 16, 21, 2, 140000.00, 2, 2)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (22, 7, 12, 22, 2, 60000.00, 1, 1)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (23, 29, 24, 23, 1, 30000.00, 1, 1)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID,  OrdenCantidades, Total, TerritorioID, TiendaID)
VALUES (24, 19, 27, 24, 5, 250000.00, 1, 1)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID, TiendaID)
VALUES (25, 3, 8, 25, 4, 100000.00, 2, 2)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (26, 5, 22, 26, 1, 45000.00, 1, 1)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (27, 2, 16, 27, 3, 210000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (28, 12, 26, 28, 2, 80000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (29, 5, 15, 29, 2, 120000.00, 1, 1)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (30, 7, 20, 30, 5, 175000.00, 1, 1)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (31, 11, 5, 31, 2, 50000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (32, 32, 20, 32, 3, 105000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (33, 34, 19, 33, 3, 120000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (34, 30, 23, 34, 3, 75000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (35, 17, 15, 35, 3, 180000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (36, 19, 25, 36, 2, 90000.00, 1, 1)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (37,  32, 41, 37, 3, 144000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (38,  31, 50, 38, 3, 135000.00, 2, 2)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (39,  34, 49, 39,  3, 135000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (40,  30, 39, 40, 2, 90000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (41, 30, 40, 41, 3, 135000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (42, 17, 1, 42, 4, 120000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (43, 20, 49, 43, 2, 90000.00, 1, 1)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (44, 31, 49, 44, 2, 90000.00, 2, 2)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (45, 17, 32, 45, 1, 60000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (46, 14, 45, 46, 2, 70000.00, 1, 1)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (47, 9, 16, 47, 2, 140000.00, 2, 2)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (48, 7, 12, 48, 2, 60000.00, 1, 1)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (49, 29, 24, 49, 1, 30000.00, 1, 1)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (50,  19, 27, 50, 5, 250000.00, 1, 1)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (51, 3, 8, 51, 4, 100000.00, 2, 2)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (52, 5, 22, 52, 1, 45000.00, 1, 1)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (53, 2, 16, 53, 3, 210000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (54, 12, 26, 54, 2, 80000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID , TiendaID)
VALUES (55, 32, 20, 55, 3, 105000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID, TiendaID)
VALUES (56, 34, 19, 56, 3, 120000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID, TiendaID)
VALUES (57, 19, 25, 57, 2, 90000.00, 1, 1)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID, TiendaID)
VALUES (58, 30, 40, 58, 2, 135000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID, TiendaID)
VALUES (59, 5, 15, 59, 2, 120000.00, 1, 1)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID, TiendaID)
VALUES (60, 2, 40, 60, 2, 90000.00, 3, 3)

INSERT INTO Sales.Ordenes (ClienteID, EmpleadoID, ProductoID, CreditCardID, OrdenCantidades, Total, TerritorioID, TiendaID)
VALUES (61,5,33,61,3,150000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (62,9,22,62,1,45000.00,2,2)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (63,18,23,63,4,100000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (64,16,20,64,5,175000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (65,10,14,65,2,70000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (66,25,8,66,5,125000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (67,5,2,67,3,90000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (68,26,45,68,4,140000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (69,24,37,69,2,96000.00,2,2)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (70,5,10,70,5,150000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (71,10,9,71,2,90000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (72,5,23,72,1,25000.00,1,1)
 
INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (73,30,1,73,3,90000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (74,1,17,74,4,120000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (75,2,11,75,2,90000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (76,4,16,76,4,280000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (77,5,15,77,2,120000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (78,7,20,78,5,175000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (79,11,5,79,2,50000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (80,32,20,80,3,105000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (81,34,19,81,3,120000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (82,30,23,82,3,75000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (83,17,15,83,3,180000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (84,19,25,84,2,90000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (85,32,41,85,3,144000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (86,31,50,86,3,135000.00,2,2)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (87,34,49,87,3,135000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (88,30,39,88,2,90000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (89,30,40,89,3,135000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (90,23,23,90,5,125000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (91,20,10,91,3,90000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (92,10,43,92,3,105000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (93,10,23,93,3,75000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (94,2,5,94,3,75000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (95,21,45,95,2,70000.00,2,2)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (96,15,12,96,3,90000.00,2,2)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (97,23,17,97,2,60000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (98,21,45,98,2,70000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (99,14,34,99,2,110000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (100,12,22,100,1,45000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (101,14,4,101,2,120000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (102,31,3,102,4,200000.00,2,2)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (103,11,34,103,1,55000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (104,16,11,104,2,90000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (105,23,19,105,3,120000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (106,17,1,106,4,120000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (107,20,49,107,2,90000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (108,31,49,108,2,90000.00,2,2)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (109,17,32,109,1,60000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (110,14,45,110,2,70000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (111,9,16,111,2,140000.00,2,2)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (112,7,12,112,2,30000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (113,29,24,113,1,30000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (114,19,27,114,5,250000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (115,3,8,115,4,100000.00,2,2)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (116,5,22,116,1,45000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (117,2,16,117,3,210000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (118,12,26,118,2,80000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (119,4,34,119,1,55000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (120,20,16,120,2,140000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (50,15,15,50,2,120000.00,2,2)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (51,3,27,51,1,50000.00,2,2)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (52,1,6,52,4,120000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (53,5,35,53,1,45000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (54,26,48,54,4,200000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (55,16,50,55,1,45000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (56,34,36,56,1,45000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (57,29,3,57,1,50000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (58,27,24,58,3,90000.00,2,2)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (59,9,16,59,2,140000.00,2,2)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (60,28,1,60,1,30000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (61,9,3,61,2,100000.00,2,2)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (62,19,7,62,2,80000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (63,34,20,63,2,70000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (64,33,30,64,1,48000.00,2,2)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (65,8,21,65,5,175000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (66,10,22,66,2,90000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (67,4,40,67,1,45000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (68,12,29,68,4,220000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (69,20,1,69,5,150000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (70,7,11,70,2,90000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (71,8,21,71,5,175000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (72,18,42,72,1,55000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (73,13,48,73,2,100000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (74,23,23,74,3,75000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (75,15,12,75,3,90000.00,2,2)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (76,33,11,76,1,45000.00,2,2)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (77,5,41,77,2,96000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (78,16,46,78,2,90000.00,3,3) 

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (79,18,45,79,3,105000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (80,23,34,80,1,55000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (81,6,21,82,2,70000.00,2,2)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (90,17,49,90,1,45000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (91,29,46,91,1,45000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (92,26,11,92,2,90000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (93,12,38,93,5,144000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (94,7,8,94,3,75000.00,1,1)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (95,30,18,95,3,75000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (96,34,31,96,2,110000.00,3,3)

INSERT INTO Sales.Ordenes (ClienteID,EmpleadoID,ProductoID,CreditCardID,OrdenCantidades,Total,TerritorioID,TiendaID)
VALUES (97,32,43,97,2,70000.00,3,3)


Commit
rollback
SELECT * FROM sales.ordenes