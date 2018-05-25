drop database  if exists `DBCaseifici`;
create database  `DBCaseifici`;
USE `DBCaseifici`;
drop table if exists `tblImages`;
drop table if exists `tblDettaglioOrdini`;
drop table if exists `tblOrdini`;
drop table if exists `tblForme`;
drop table if exists `tblAcquirenti`;
drop table if exists `tblProduzioneGiornaliera`;
drop table if exists `tblCaseifici`;
drop table if exists `tblUsers`;

CREATE TABLE tblUsers
(
	id			int auto_increment NULL,
	username	varchar(100) NOT NULL,
	pwd			char(128) NOT NULL, /*sha 3 https://github.com/emn178/js-sha3*/
	homepage	varchar(255) NULL default 'homeUser',
	constraint Pk_tblUsers primary key(id),
    constraint tblUsers_idx unique(username)
);
/*alter table tblusers add constraint tblUsers_idx unique(username);*/

create table tblCaseifici
(
	Id					char	(4)		not null,
	RagioneSociale		varchar	(200)	not null,
	Indirizzo			varchar (200)	not null,
	NominativoTitolare	varchar (200)	not null,
	Latitude			float,
	Longitude			float,
	constraint PK_tblCaseifici primary key (Id)
);

Create table tblImages
(
	Id				int not null,
	IdCaseificio	char(4) not null,
	Description		varchar(255) not null,
	Latitude		float,
	Longitude		float,
	ImageUrl		varchar(255),
	constraint PK_tblImages primary key(Id),
	constraint FK_tblImages foreign key (IdCaseificio) references tblCaseifici(id)
);

create table tblAcquirenti
(
	Id	int not null AUTO_INCREMENT,
	Nominativo	varchar(200),
	Indirizzo	varchar(200),
	Tipo		varchar(20) default 'grande distribuzione',
	constraint PK_tblAcquirenti primary key(Id)
);

create table tblOrdini
(
	Id				int not null,
	NumeroOrdine	int not null default 1,
	DataOrdine		datetime not null,
	IdAcquirente	int not null,
	constraint PK_tblOrdini primary key(Id),
	constraint FK_tblOrdini foreign key(IdAcquirente) references tblAcquirenti(Id)
);
drop trigger if exists `tblOrdini_INSERT`;
delimiter $$
CREATE TRIGGER `tblOrdini_INSERT` BEFORE INSERT ON `tblOrdini`
FOR EACH ROW BEGIN
    SET new.DataOrdine = current_date();

END$$
delimiter ;

create table tblForme
(
	Id				int not null,
	IdCaseificio	char(4) not null,
	DataProduzione  datetime not null ,
	Mese			int not null default 1,
	Anno			int not null ,
	NumProgressivo  int not null default 1,
	Stagionatura	int check (Stagionatura=12 or Stagionatura=24 or Stagionatura=36  ),
	Scelta			int  default 1,
	idOrdine		int null,
    Constraint chk_scelta check (Scelta =1 or Scelta = 2),
	Constraint PK_tblForme primary key(Id),
	constraint FK_tblForme foreign key(IdCaseificio) references tblCaseifici(id),
    constraint FK_tblFormeTblOrdini foreign key(IdOrdine) references tblOrdini(id)
);

drop trigger if exists `tblForme_INSERT`;
delimiter $$
CREATE TRIGGER `tblForme_INSERT` BEFORE INSERT ON `tblForme`
FOR EACH ROW BEGIN
    SET new.Anno = year(current_date());
    SET new.DataProduzione = current_date();
END$$
delimiter ;

create table tblProduzioneGiornaliera
(
	Id						int not null,
	IdCaseificio			char(4) not null,
	DataProduzione			datetime not null ,
	QuantitaLatteLavorata	float default 0,
	QuantitaLatteFormaggio	float default 0,
	constraint PK_tblProduzioneGiornaliera primary key(id),
	constraint FK_tblCaseifici2 foreign key(IdCaseificio) references tblCaseifici(Id)

);
drop trigger if exists `tblProduzioneGiornaliera_INSERT`;
delimiter $$
CREATE TRIGGER `tblProduzioneGiornaliera_INSERT` BEFORE INSERT ON `tblProduzioneGiornaliera`
FOR EACH ROW BEGIN
    SET new.DataProduzione = current_date();

END$$
delimiter ;

insert into tblCaseifici(id,RagioneSociale,Indirizzo,NominativoTitolare,Latitude,Longitude)
	values ('0001','Caseificio di Isera','via san vincenzo 2, 38060 Isera, TN', 'Mario Rossi', 45.8960411,11.0145501);
insert into tblCaseifici(id,RagioneSociale,Indirizzo,NominativoTitolare,Latitude,Longitude)
	values ('0002','Caseificio di S. Ilario','via p. monti 1, 38068 Rovereto, TN', 'Mario Rossi', 45.9006629,11.0444406);
	
insert into tblImages(id,IdCaseificio,Description,Latitude,Longitude,ImageUrl)
	values(1, '0001', 'Vista della sede del Caseificio di Isera',45.8960411,11.0145501,'d9992aca-d485-4d2a-a26b-00412efc8dda.jpg');

insert into tblImages(id,IdCaseificio,Description,Latitude,Longitude,ImageUrl)
	values(2, '0001', 'Magazzino del Caseificio di Isera',45.8960411,11.0145501,'cb9fc006-7e5d-4217-8ff4-fb788d46ffb2.jpg');
	
ALTER TABLE `dbcaseifici`.`tblimages` CHANGE COLUMN `Id` `Id` INT(11) NOT NULL AUTO_INCREMENT ;	


insert into tblImages(id,IdCaseificio,Description,Latitude,Longitude,ImageUrl)
	values(3, '0002', 'Vista della sede del Caseificio di Sant Ilario',45.9006629,11.0444406,'57bd9525-bb35-46fc-8a30-f9140aa68f0b.jpg');
insert into tblImages(id,IdCaseificio,Description,Latitude,Longitude,ImageUrl)
	values(4, '0002', 'Magazzino del Caseificio di Sant Ilario',45.9006629,11.0444406,'b874d9eb-7623-47f0-bb59-12bddc5c6fd3.jpg');

insert into tblForme(Id,IdCaseificio,DataProduzione,Mese,Anno,NumProgressivo,Stagionatura,scelta)
	values(1,'0001','20150518',5,2015,1,12,1);
insert into tblForme(Id,IdCaseificio,DataProduzione,Mese,Anno,NumProgressivo,Stagionatura,scelta)
	values(2,'0001','20150519',5,2015,2,12,1);

insert into tblForme(Id,IdCaseificio,DataProduzione,Mese,Anno,NumProgressivo,Stagionatura,scelta)
	values(3,'0002','20150314',3,2015,1,12,1);
insert into tblForme(Id,IdCaseificio,DataProduzione,Mese,Anno,NumProgressivo,Stagionatura,scelta)
	values(4,'0002','20150314',3,2015,2,24,2);
insert into tblForme(Id,IdCaseificio,DataProduzione,Mese,Anno,NumProgressivo,Stagionatura,scelta)
	values(5,'0002','20150415',4,2015,1,12,1);
insert into tblForme(Id,IdCaseificio,DataProduzione,Mese,Anno,NumProgressivo,Stagionatura,scelta)
	values(6,'0002','20150412',4,2015,2,36,1);
insert into tblForme(Id,IdCaseificio,DataProduzione,Mese,Anno,NumProgressivo,Stagionatura,scelta)
	values(7,'0002','20150417',4,2015,3,24,1);


insert into tblAcquirenti(Id,Nominativo,Indirizzo,Tipo)
	values(1,'Supermercati Poli', 'via crafonara 1, 38068 Rovereto', 'grande distribuzione');

insert into tblAcquirenti(Id,Nominativo,Indirizzo,Tipo)
	values(2,'Conad', 'via Trento 1, 38068 Rovereto', 'grande distribuzione');
insert into tblAcquirenti(Id,Nominativo,Indirizzo,Tipo)
	values(3,'XYZ snc', 'via Roma 1, 38068 Rovereto', 'Grossista');

insert into tblOrdini(Id,NumeroOrdine,	DataOrdine,	IdAcquirente)
	values(1,1,'20150301',1);
insert into tblOrdini(Id,NumeroOrdine,	DataOrdine,	IdAcquirente)
	values(2,2,'20150302',2);

update tblForme set idOrdine=1 where id=1;
update tblForme set idOrdine=1 where id=2;

insert into tblProduzioneGiornaliera(Id,IdCaseificio,DataProduzione,QuantitaLatteLavorata,QuantitaLatteFormaggio)
	values (1,'0001','20150115',1000,500);
insert into tblProduzioneGiornaliera(Id,IdCaseificio,DataProduzione,QuantitaLatteLavorata,QuantitaLatteFormaggio)
	values (2,'0002','20150115',2000,1000);


SET autocommit=0;

DROP PROCEDURE if exists `spUserInsert`; 
delimiter $$
Create Procedure `spUserInsert`
(
	IN UserName	varchar(100),
	in pwd		varchar(100),
	in homepage	varchar(255)
)
BEGIN 
    DECLARE _rollback BOOL DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
    START TRANSACTION;
    	INSERT INTO tblUsers(
			UserName,
			pwd,
			homepage)
		VALUES	(username, pwd, homepage);
    IF _rollback THEN begin
        ROLLBACK;
        select -1 as id;
        end;
    ELSE begin
        COMMIT;
        select LAST_INSERT_ID() as id;
        end;
    END IF;
END$$

DELIMITER ;
use dbcaseifici;
insert into tblUsers(UserName,pwd,homepage)
	values('admin','0a74cd16f336b3164dd8ee505561c257898b113089e3725dc171dba65f35000cda6447183448f2f09058b01c3dbceee3090ab75b587b517c9580aa517f7538af','homeAdmin');
insert into tblUsers(UserName,pwd,homepage)
	values('user1','0a74cd16f336b3164dd8ee505561c257898b113089e3725dc171dba65f35000cda6447183448f2f09058b01c3dbceee3090ab75b587b517c9580aa517f7538af','homeUser');

/* da sistemare
DROP PROCEDURE if exist `spCaseificioInsert`;
Create Procedure spCaseificioInsert
(
	in RagioneSociale		varchar(200),
	in Indirizzo			varchar(200),
	in NominativoTitolare	varchar(200),
	in Latitude			float,
	in Longitude			float,
	in UserName			nvarchar(256)
)
BEGIN 
	
		declare @massimo int;
		declare @IDstring char(4);
		select @massimo= (max(cast (tblCaseifici.Id as int)) )  from tblCaseifici;
		select @massimo=@massimo+1;
		select @IDstring=REPLICATE('0', 4 - LEN(@massimo)) + CAST(@massimo AS varchar) ;
		INSERT INTO tblCaseifici(ID,
								 RagioneSociale,		
								 Indirizzo,			
								 NominativoTitolare,	
								 Latitude,			
								 Longitude,			
								 UserName)			

		VALUES	(@IDstring,
				 @RagioneSociale,		
				 @Indirizzo	,		
				 @NominativoTitolare,	
				 @Latitude,			
				 @Longitude,			
				 @UserName)

	end try
	begin catch

		ROLLBACK TRAN
		select '-1'
   END catch

COMMIT TRAN
--return @massimo -- le stored procedure restituiscono sempre valori numerici
select @IDstring -- con select restituisce la chiave primaria di tipo string 
-- questo è un vincolo di entity framework nell'uso delle stored procedure.
-- in entity framework l'esito di una chiamata ad una stored procedure indica SOLO il 
-- nunero di righe coinvolte 
*/