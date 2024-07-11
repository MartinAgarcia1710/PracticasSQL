use ExamenIntegrador20241C
go

INSERT INTO Concursos (Titulo,Inicio,Fin,RankingMinimo) VALUES
	 (N'Yada Yada Yada','2024-06-01','2024-06-10',0.00),
	 (N'Spare a Square','2024-06-15','2024-06-28',0.00),
	 (N'Serenity Now','2024-05-10','2024-06-15',3.00),
	 (N'No soup for you','2024-06-03','2024-06-20',8.00);

INSERT INTO Participantes (Apellidos,Nombres) VALUES
	 (N'Seinfeld',N'Jerry'),
	 (N'Benes',N'Elaine'),
	 (N'Costanza',N'George'),
	 (N'Kramer',N'Cosmo'),
	 (N'Ross',N'Susan'),
	 (N'Costanza',N'Frank'),
	 (N'Costanza',N'Estelle'),
	 (N'Seinfeld',N'Helen'),
	 (N'Seinfeld',N'Morty')

INSERT INTO Fotografias (IDParticipante,IDConcurso,Titulo,Descalificada,Publicacion) VALUES
	 (1,1,N'The Stake Out',0,'2024-06-02'),
	 (1,3,N'The Stock Tip',1,'2024-06-06'),
	 (2,1,N'The Pony Remark',0,'2024-06-03'),
	 (2,3,N'The Jacket',0,'2024-06-05'),
	 (2,4,N'The Phone Message',0,'2024-06-06'),
	 (3,1,N'The Apartment',0,'2024-06-02'),
	 (3,3,N'The Statue',0,'2024-05-20'),
	 (4,1,N'The Revenge',0,'2024-06-03'),
	 (5,1,N'The Chinese Restaurant',0,'2024-06-04'),
	 (6,1,N'The Library',0,'2024-06-01'),
	 (6,3,N'The Parking Garage',0,'2024-05-31'),
	 (7,1,N'The Red Dot',0,'2024-06-05')



INSERT INTO Votaciones (IDVotante,IDFotografia,Fecha,Puntaje) VALUES
	 (2,1,'2024-06-03',9.00),
	 (3,1,'2024-06-03',7.00),
	 (4,1,'2024-06-03',8.00),
	 (5,1,'2024-06-03',6.00),
	 (6,1,'2024-06-03',5.00),
	 (4,3,'2024-06-03',4.00),
	 (5,3,'2024-06-04',8.00),
	 (6,4,'2024-06-05',10.00),
	 (7,4,'2024-06-05',5.00),
	 (8,5,'2024-06-06',7.00),
	 (9,5,'2024-06-06',9.00),
	 (1,6,'2024-06-02',7.00),
	 (2,6,'2024-06-03',9.00),
	 (8,7,'2024-05-21',9.00),
	 (9,8,'2024-06-03',7.00),
	 (8,10,'2024-06-02',8.00)