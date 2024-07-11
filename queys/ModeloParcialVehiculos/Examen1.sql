Create Database ExamenIntegrador20232C
Go
Create Table TiposCuentas(
    IDTipoCuenta bigint not null primary key identity (1, 1),
    Nombre varchar(50) not null,
    CapacidadEnMB int not null
)
Go
Create Table Usuarios(
    IDUsuario bigint not null primary key identity (1, 1),
    IDTipoCuenta bigint not null foreign key references TiposCuentas(IDTipoCuenta),
    NombreUsuario varchar(50) not null unique
)
Go
Create Table Archivos(
    IDArchivo bigint not null primary key identity (1, 1),
    IDUsuario bigint not null foreign key references Usuarios(IDUsuario),
    NombreArchivo varchar(50) not null,
    Descripcion varchar(250) null,
    Extension varchar(5) not null,
    TamañoEnMB int not null,
    FechaPublicacion date not null
)
Go
Create Table CambiosDeCuenta(
    IDUsuario bigint not null foreign key references Usuarios(IDUsuario),
    IDTipoCuentaAnterior bigint not null foreign key references TiposCuentas(IDTipoCuenta),
    IDTipoCuentaActual bigint not null foreign key references TiposCuentas(IDTipoCuenta),
    Fecha date not null
)
Go
-- Datos
INSERT INTO TiposCuentas (Nombre, CapacidadEnMB) VALUES ('Lite', 1024);
INSERT INTO TiposCuentas (Nombre, CapacidadEnMB) VALUES ('Regular', 2048);
INSERT INTO TiposCuentas (Nombre, CapacidadEnMB) VALUES ('Premium', 5000);
INSERT INTO TiposCuentas (Nombre, CapacidadEnMB) VALUES ('Ultra', 8000);
INSERT INTO TiposCuentas (Nombre, CapacidadEnMB) VALUES ('Ilimitada', 9999999);

INSERT INTO Usuarios (IDTipoCuenta, NombreUsuario)
VALUES (1, 'UsuarioLite01');

INSERT INTO Usuarios (IDTipoCuenta, NombreUsuario)
VALUES (2, 'UsuarioRegular02');

INSERT INTO Usuarios (IDTipoCuenta, NombreUsuario)
VALUES (2, 'UsuarioRegular03');

INSERT INTO Usuarios (IDTipoCuenta, NombreUsuario)
VALUES (3, 'UsuarioPremium04');

INSERT INTO Usuarios (IDTipoCuenta, NombreUsuario)
VALUES (3, 'UsuarioPremium05');

INSERT INTO Usuarios (IDTipoCuenta, NombreUsuario)
VALUES (4, 'UsuarioUltra06');

INSERT INTO Usuarios (IDTipoCuenta, NombreUsuario)
VALUES (4, 'UsuarioUltra07');

INSERT INTO Usuarios (IDTipoCuenta, NombreUsuario)
VALUES (5, 'UsuarioIlimitado08');

INSERT INTO Usuarios (IDTipoCuenta, NombreUsuario)
VALUES (5, 'UsuarioIlimitado09');

INSERT INTO Usuarios (IDTipoCuenta, NombreUsuario)
VALUES (1, 'UsuarioLite10');

INSERT INTO Archivos (IDUsuario, NombreArchivo, Descripcion, Extension, TamañoEnMB, FechaPublicacion)
VALUES (1, 'Informe_Trimestral.pdf', 'Informe trimestral de ventas', 'pdf', 6, '2023-11-11');

INSERT INTO Archivos (IDUsuario, NombreArchivo, Descripcion, Extension, TamañoEnMB, FechaPublicacion)
VALUES (2, 'Foto_Viaje.jpg', 'Foto de un viaje a la montaña', 'jpg', 1.8, '2023-11-12');

INSERT INTO Archivos (IDUsuario, NombreArchivo, Descripcion, Extension, TamañoEnMB, FechaPublicacion)
VALUES (3, 'Contrato_Alquiler.docx', 'Contrato de alquiler de vivienda', 'docx', 2.5, '2023-11-13');

INSERT INTO Archivos (IDUsuario, NombreArchivo, Descripcion, Extension, TamañoEnMB, FechaPublicacion)
VALUES (4, 'Informe_Marketing.pptx', 'Informe de estrategia de marketing', 'pptx', 5, '2023-11-14');

INSERT INTO Archivos (IDUsuario, NombreArchivo, Descripcion, Extension, TamañoEnMB, FechaPublicacion)
VALUES (5, 'Facturas_Abril.xlsx', 'Facturas del mes de abril', 'xlsx', 3.2, '2023-11-15');

INSERT INTO Archivos (IDUsuario, NombreArchivo, Descripcion, Extension, TamañoEnMB, FechaPublicacion)
VALUES (1, 'Presentacion_Ejecutiva.pptx', 'Presentación ejecutiva de la empresa', 'pptx', 7, '2023-11-16');

INSERT INTO Archivos (IDUsuario, NombreArchivo, Descripcion, Extension, TamañoEnMB, FechaPublicacion)
VALUES (2, 'Video_Tutorial.mp4', 'Tutorial en video de software', 'mp4', 1200, '2023-11-17');

INSERT INTO Archivos (IDUsuario, NombreArchivo, Descripcion, Extension, TamañoEnMB, FechaPublicacion)
VALUES (3, 'Informe_Finanzas.pdf', 'Informe de finanzas trimestral', 'pdf', 8, '2023-11-18');

INSERT INTO Archivos (IDUsuario, NombreArchivo, Descripcion, Extension, TamañoEnMB, FechaPublicacion)
VALUES (4, 'Contrato_Cliente2.docx', 'Segundo contrato con ClienteX', 'docx', 4, '2023-11-19');

INSERT INTO Archivos (IDUsuario, NombreArchivo, Descripcion, Extension, TamañoEnMB, FechaPublicacion)
VALUES (5, 'Foto_Aniversario.jpg', 'Foto del aniversario de la empresa', 'jpg', 2.1, '2023-11-20');

INSERT INTO Archivos (IDUsuario, NombreArchivo, Descripcion, Extension, TamañoEnMB, FechaPublicacion)
VALUES (1, 'Instalador.exe', 'Instalador de software', 'exe', 1000, '2023-11-20');
