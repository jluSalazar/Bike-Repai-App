/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2012                    */
/* Created on:     6/12/2024 21:18:31                           */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('BICICLETA') and o.name = 'FK_BICICLET_PERTENECE_CLIENTE')
alter table BICICLETA
   drop constraint FK_BICICLET_PERTENECE_CLIENTE
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('BICICLETA') and o.name = 'FK_BICICLET_REPARA_MECANICO')
alter table BICICLETA
   drop constraint FK_BICICLET_REPARA_MECANICO
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PIEZA') and o.name = 'FK_PIEZA_USA_REPARACI')
alter table PIEZA
   drop constraint FK_PIEZA_USA_REPARACI
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('REPARACION') and o.name = 'FK_REPARACI_TIENE_BICICLET')
alter table REPARACION
   drop constraint FK_REPARACI_TIENE_BICICLET
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('BICICLETA')
            and   name  = 'PERTENECE_FK'
            and   indid > 0
            and   indid < 255)
   drop index BICICLETA.PERTENECE_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('BICICLETA')
            and   name  = 'REPARA_FK'
            and   indid > 0
            and   indid < 255)
   drop index BICICLETA.REPARA_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('BICICLETA')
            and   type = 'U')
   drop table BICICLETA
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CLIENTE')
            and   type = 'U')
   drop table CLIENTE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('MECANICO')
            and   type = 'U')
   drop table MECANICO
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('PIEZA')
            and   name  = 'USA_FK'
            and   indid > 0
            and   indid < 255)
   drop index PIEZA.USA_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('PIEZA')
            and   type = 'U')
   drop table PIEZA
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('REPARACION')
            and   name  = 'TIENE_FK'
            and   indid > 0
            and   indid < 255)
   drop index REPARACION.TIENE_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('REPARACION')
            and   type = 'U')
   drop table REPARACION
go

/*==============================================================*/
/* Table: BICICLETA                                             */
/*==============================================================*/
create table BICICLETA (
   NUMERO_SERIE         char(10)             not null,
   CI_MECANICO          char(10)             not null,
   CI_CLIENTE           char(10)             not null,
   MARCA                char(10)             not null,
   MODELO               char(10)             not null,
   TIPO                 char(10)             not null,
   COLOR                char(10)             not null,
   constraint PK_BICICLETA primary key nonclustered (NUMERO_SERIE)
)
go

/*==============================================================*/
/* Index: REPARA_FK                                             */
/*==============================================================*/
create index REPARA_FK on BICICLETA (
CI_MECANICO ASC
)
go

/*==============================================================*/
/* Index: PERTENECE_FK                                          */
/*==============================================================*/
create index PERTENECE_FK on BICICLETA (
CI_CLIENTE ASC
)
go

/*==============================================================*/
/* Table: CLIENTE                                               */
/*==============================================================*/
create table CLIENTE (
   CI_CLIENTE           char(10)             not null,
   NOMBRE_CLIENTE       char(10)             not null,
   APELLIDO_CLIENTE     char(10)             not null,
   CORREO_ELECTRONICO   char(10)             not null,
   DIRECCION            char(10)             not null,
   constraint PK_CLIENTE primary key nonclustered (CI_CLIENTE)
)
go

/*==============================================================*/
/* Table: MECANICO                                              */
/*==============================================================*/
create table MECANICO (
   CI_MECANICO          char(10)             not null,
   NOMBRE_MECANICO      char(20)             not null,
   APELLIDO_MECANICO    char(20)             not null,
   TELEFONO_MECANICO    char(10)             not null,
   FECHA_CONTRATACION   datetime             not null,
   SUELDO               money                not null,
   constraint PK_MECANICO primary key nonclustered (CI_MECANICO)
)
go

/*==============================================================*/
/* Table: PIEZA                                                 */
/*==============================================================*/
create table PIEZA (
   ID_PIEZA             char(10)             not null,
   ID_REPARACION        int                  not null,
   NOMBRE_PIEZA         char(10)             not null,
   MARCA_PIEZA          char(10)             not null,
   PRECIO_PIEZA         char(10)             not null,
   STOCK                int                  null,
   constraint PK_PIEZA primary key nonclustered (ID_PIEZA)
)
go

/*==============================================================*/
/* Index: USA_FK                                                */
/*==============================================================*/
create index USA_FK on PIEZA (
ID_REPARACION ASC
)
go

/*==============================================================*/
/* Table: REPARACION                                            */
/*==============================================================*/
create table REPARACION (
   ID_REPARACION        int                  not null,
   NUMERO_SERIE         char(10)             not null,
   FECHA_REPARACION     datetime             not null,
   TIPO_REPARACION      char(10)             not null,
   TOTAL                money                not null,
   OBSERVACIONES        text                 not null,
   constraint PK_REPARACION primary key nonclustered (ID_REPARACION)
)
go

/*==============================================================*/
/* Index: TIENE_FK                                              */
/*==============================================================*/
create index TIENE_FK on REPARACION (
NUMERO_SERIE ASC
)
go

alter table BICICLETA
   add constraint FK_BICICLET_PERTENECE_CLIENTE foreign key (CI_CLIENTE)
      references CLIENTE (CI_CLIENTE)
go

alter table BICICLETA
   add constraint FK_BICICLET_REPARA_MECANICO foreign key (CI_MECANICO)
      references MECANICO (CI_MECANICO)
go

alter table PIEZA
   add constraint FK_PIEZA_USA_REPARACI foreign key (ID_REPARACION)
      references REPARACION (ID_REPARACION)
go

alter table REPARACION
   add constraint FK_REPARACI_TIENE_BICICLET foreign key (NUMERO_SERIE)
      references BICICLETA (NUMERO_SERIE)
go

