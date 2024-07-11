Create Database ExamenIntegrador20241C
Go
Use ExamenIntegrador20241C
Go
CREATE TABLE Concursos (
	ID bigint IDENTITY(1,1) NOT NULL,
	Titulo varchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Inicio date NOT NULL,
	Fin date NOT NULL,
	RankingMinimo decimal(5,2) NOT NULL,
	CONSTRAINT PK__Concurso__3214EC27C10C899D PRIMARY KEY (ID)
)
Go
CREATE TABLE Participantes (
	ID bigint IDENTITY(1,1) NOT NULL,
	Apellidos varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Nombres varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT PK__Particip__3214EC2749CC62C4 PRIMARY KEY (ID)
)
Go
CREATE TABLE Fotografias (
	ID bigint IDENTITY(1,1) NOT NULL,
	IDParticipante bigint NOT NULL,
	IDConcurso bigint NOT NULL,
	Titulo varchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Descalificada bit DEFAULT 0 NOT NULL,
	Publicacion date NOT NULL,
	CONSTRAINT PK__Fotograf__3214EC27A48B8043 PRIMARY KEY (ID),
	CONSTRAINT FK__Fotografi__IDCon__29572725 FOREIGN KEY (IDConcurso) REFERENCES Concursos(ID),
	CONSTRAINT FK__Fotografi__IDPar__286302EC FOREIGN KEY (IDParticipante) REFERENCES Participantes(ID)
)
Go
CREATE TABLE Votaciones (
	ID bigint IDENTITY(1,1) NOT NULL,
	IDVotante bigint NOT NULL,
	IDFotografia bigint NOT NULL,
	Fecha date NOT NULL,
	Puntaje decimal(5,2) NOT NULL,
	CONSTRAINT PK__Votacion__3214EC2794203779 PRIMARY KEY (ID),
	CONSTRAINT FK__Votacione__IDFot__2E1BDC42 FOREIGN KEY (IDFotografia) REFERENCES Fotografias(ID),
	CONSTRAINT FK__Votacione__IDVot__2D27B809 FOREIGN KEY (IDVotante) REFERENCES Participantes(ID)
);
ALTER TABLE Votaciones ADD CONSTRAINT CK__Votacione__Punta__2F10007B CHECK (([Puntaje]>=(0) AND [Puntaje]<=(10)));

SET DATEFORMAT 'YMD'