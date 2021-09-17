CREATE DATABASE Clinica_Oftalmologica
GO
USE [Clinica_Oftalmologica]
GO
/****** Object:  UserDefinedFunction [dbo].[getMedidaMarcoIdByMedidas_IdMarca_IdEstilo]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[getMedidaMarcoIdByMedidas_IdMarca_IdEstilo]
(
	@IdMarca int,
	@IdEstilo int,
	@MedPuente float,
	@MedLente float,
	@MedPatilla float
)
returns int
as
begin
declare @Id_MarcoMedida int
	select @Id_MarcoMedida=Id_Marco_Medida from tbl_Marco_Medida
							where Medida_Lente_Marco_Medida=@MedLente
							and Medida_Patilla_Marco_Medida=@MedPatilla
							and Medida_Puente_Marco_Medida=@MedPuente
							and Id_Estilo_Marco_Medida=@IdEstilo
							and Id_Marca_Marco_Medida=@IdMarca

	if(@Id_MarcoMedida is null)
	begin
		set @Id_MarcoMedida=0
	end

return @Id_MarcoMedida
end
GO
/****** Object:  UserDefinedFunction [dbo].[getMedidaOjoIdByMedidas_IdLente]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[getMedidaOjoIdByMedidas_IdLente]
( 
@Esf float,  
@Cyl float, 
@Eje float,
@Vp float ,
@Dip float  , 
@Prisma float, 
@id_Tipo_Lente int 
)
returns int
as
begin
declare @Id_Medida int

select @Id_Medida= Id_Medida_Ojo from tbl_Medida_Ojo 
where Esfera_Medida_Ojo=@Esf and Cilindro_Medida_Ojo=@Cyl 
and Eje_Medida_Ojo=@Eje and Vision_Proxima_Medida_Ojo=@Vp 
and Distancia_Interpupilar_Medida_Ojo=@Dip and Prisma_Medida_Ojo=@Prisma
and Id_Tipo_Lente_Medida_Ojo = @id_Tipo_Lente


if(
@Id_Medida is null
)
begin
set @Id_Medida=0
end

return @Id_Medida 
end
GO
/****** Object:  UserDefinedFunction [dbo].[getPrecioAnteojoById]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[getPrecioAnteojoById](@Id_Anteojo as int)
returns int
as
begin
declare @res int
select @res = Precio_Anteojo  from tbl_Anteojo 
where  Id_Anteojo=@Id_Anteojo

return @res
end

GO
/****** Object:  UserDefinedFunction [dbo].[getPrecioAnteojoByIdMedidasOjo_IdMedidasMarco]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  function [dbo].[getPrecioAnteojoByIdMedidasOjo_IdMedidasMarco]
(
@idMarco int,
@idMedidaOjoDer int,
@idMedidaOjoIzq int
)
returns float
as
begin
declare @res float

declare @precioMarco float
declare @precioMedidaOjoDer float
declare @precioMedidaOjoIzq float

select @precioMarco= dbo.getPrecioMedidasMarcoById(@idMarco)
select @precioMedidaOjoDer= dbo.getPrecioMedidaOjoById(@idMedidaOjoDer)
select @precioMedidaOjoIzq= dbo.getPrecioMedidaOjoById(@idMedidaOjoIzq)

set @res= @precioMarco+@precioMedidaOjoDer+@precioMedidaOjoIzq


return @res
end

GO
/****** Object:  UserDefinedFunction [dbo].[getPrecioEstiloMarcoById]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[getPrecioEstiloMarcoById](@Id as int)
	returns float
as
	begin

		declare @res float
		select @res=Precio_Estilos_Marco from tbl_Estilos_Marco
		where Id_Estilos_Marco=@Id

	return @res
end
GO
/****** Object:  UserDefinedFunction [dbo].[getPrecioExamenByIdExamen]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[getPrecioExamenByIdExamen](@Id_Examen int)
returns int
as
begin
declare @res int

select @res= Precio_Tipo_Examen  from tbl_Tipo_Examen 
inner join tbl_Examen on ID_TE_Examen=Id_Tipo_Examen
where (Id_Tipo_Examen = ID_TE_Examen) and ID_TE_Examen = @Id_Examen


return @res
end
GO
/****** Object:  UserDefinedFunction [dbo].[getPrecioMarcaById]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[getPrecioMarcaById](@Id as int)
	returns float
as
	begin

		declare @res float
		select @res=Precio_Marca from tbl_Marca
		where Id_Marca=@Id

	return @res
end
GO
/****** Object:  UserDefinedFunction [dbo].[getPrecioMedidaOjoById]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[getPrecioMedidaOjoById](@Id_Medida_Ojo int)
returns float
as
begin
declare @id_Tipo_Lente int
declare @valor float

declare 
@res float
declare @Esf float,
@Cyl float,
@Eje float,
@Vp float,
@Dip float,
@Prisma float

select @id_Tipo_Lente=Id_Tipo_Lente_Medida_Ojo from tbl_Medida_Ojo where Id_Medida_Ojo=@Id_Medida_Ojo
select @valor = dbo.getPrecioTipoLenteById(@id_Tipo_Lente)

select @Esf=ABS(Esfera_Medida_Ojo) from tbl_Medida_Ojo where Id_Medida_Ojo=@Id_Medida_Ojo
select @Cyl=ABS(Cilindro_Medida_Ojo) from tbl_Medida_Ojo where Id_Medida_Ojo=@Id_Medida_Ojo
select @Eje=ABS(Eje_Medida_Ojo) from tbl_Medida_Ojo where Id_Medida_Ojo=@Id_Medida_Ojo
select @Vp=ABS(Vision_Proxima_Medida_Ojo) from tbl_Medida_Ojo where Id_Medida_Ojo=@Id_Medida_Ojo
select @Dip=ABS(Distancia_Interpupilar_Medida_Ojo) from tbl_Medida_Ojo where Id_Medida_Ojo=@Id_Medida_Ojo
select @Prisma=ABS(Prisma_Medida_Ojo) from tbl_Medida_Ojo where Id_Medida_Ojo=@Id_Medida_Ojo

set @res=@valor+ (((@Esf+@Cyl+@Eje+@Vp+@Dip+@Prisma)*@valor)/10)
--al valor definido le sumamos la decima parte de suma de las medidas por el valor definido
--del lente 
return @res
end
GO
/****** Object:  UserDefinedFunction [dbo].[getPrecioMedidaOjoByMedida]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[getPrecioMedidaOjoByMedida]
(
	@Esf float,
	@Cyl float,
	@Eje float ,
	@Vp float ,
	@Dip float  ,
	@Prisma float,
	@id_Tipo_Lente int
)
returns float
as
begin
	declare @idMedidas int, @precioMedidas float

	select @idMedidas= dbo.getMedidaOjoIdByMedidas_IdLente(@Esf ,@Cyl ,@Eje  ,@Vp  ,@Dip ,@Prisma ,@id_Tipo_Lente)

	select @precioMedidas = [dbo].[getPrecioMedidaOjoById](@idMedidas)

	


	return @precioMedidas
end
GO
/****** Object:  UserDefinedFunction [dbo].[getPrecioMedidasMarcoById]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select getPrecioMedidasMarcoById(1)

create function [dbo].[getPrecioMedidasMarcoById]
(
	@IdMedidaMarco int
)
returns float
as
begin

declare @medLenteNuevo float, @medPatillaNuevo float, @medPuenteNuevo float,@Id_Marco int
declare @res float
declare @valorBasico int, @medLente int, @medPuente int , @medPatilla int, @IdMarca int, @IdEstilo int
declare @precioLente float
declare @precioPatilla float
declare @precioPuente float

set @medLente=130
set @medPatilla=140
set @medPuente=20

select @Id_Marco=Id_Marco_Medida from tbl_Marco_Medida where Id_Marco_Medida=@IdMedidaMarco
select @medLenteNuevo =Medida_Lente_Marco_Medida from tbl_Marco_Medida where Id_Marco_Medida=@IdMedidaMarco
select @medPatillaNuevo= Medida_Patilla_Marco_Medida from tbl_Marco_Medida where Id_Marco_Medida=@IdMedidaMarco
select @medPuenteNuevo=Medida_Puente_Marco_Medida from tbl_Marco_Medida where Id_Marco_Medida=@IdMedidaMarco
select @IdMarca=Id_Marca_Marco_Medida from tbl_Marco_Medida where Id_Marco_Medida=@IdMedidaMarco
select @IdEstilo=Id_Estilo_Marco_Medida from tbl_Marco_Medida where Id_Marco_Medida=@IdMedidaMarco

select @valorBasico=(dbo.getPrecioEstiloMarcoById(@IdEstilo)+dbo.getPrecioMarcaById(@IdMarca))

set @precioLente = (@medLenteNuevo * @valorBasico)/@medLente
set @precioPatilla = (@medPatillaNuevo * @valorBasico)/@medPatilla
set @precioPuente = (@medPuenteNuevo * @valorBasico)/@medPuente


select @res = @precioLente + @precioPatilla + @precioPuente
return @res/3
end
GO
/****** Object:  UserDefinedFunction [dbo].[getPrecioTipoExamenById]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[getPrecioTipoExamenById](@Id_Tipo as int)
returns int
as
begin
declare @res int
select @res = Precio_Tipo_Examen  from tbl_Tipo_Examen 
where  Id_Tipo_Examen=@Id_Tipo

return @res
end
GO
/****** Object:  UserDefinedFunction [dbo].[getPrecioTipoLenteById]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[getPrecioTipoLenteById](@Id_Tipo_Lente int)
returns float
as
begin
declare  @res float
select @res=Precio_lentes from tbl_Tipo_Lente
where Id_Lente=@Id_Tipo_Lente

return @res
end
GO
/****** Object:  UserDefinedFunction [dbo].[insertAnteojoFacturaFun]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[insertAnteojoFacturaFun]
(
@Esfd float,
@Cyld float,
@Ejed float,
@Vpd float,
@Dipd float,
@Prismad float,
@Id_Tipo_Lented float,

@Esfi float,
@Cyli float,
@Ejei float,
@Vpi float,
@Dipi float,
@Prismai float,
@Id_Tipo_Lentei float,

@IdMarca int,
@IdEstilo int,
@MedPuente float,
@MedLente float,
@MedPatilla float,

@idPaciente int

)
returns int
begin
declare @idOjoDer int, @idOjoIzq int,  @idMarco int
declare @precioAnteojo float
select @idOjoDer=[dbo].[getMedidaOjoIdByMedidas_IdLente](@Esfd,@Cyld ,@Ejed ,@Vpd ,@Dipd ,@Prismad ,@Id_Tipo_Lented )
select @idOjoIzq=[dbo].[getMedidaOjoIdByMedidas_IdLente](@Esfi,@Cyli ,@Ejei ,@Vpi ,@Dipi ,@Prismai ,@Id_Tipo_Lentei )
select @idMarco=[dbo].[getMedidaMarcoIdByMedidas_IdMarca_IdEstilo](@IdMarca,@IdEstilo,@MedPuente,@MedLente,@MedPatilla)

exec [dbo].[insertAnteojo] @idMarco,@idOjoDer,@idOjoIzq

declare @idAnteojo int
select @idAnteojo=max(Id_Anteojo) from tbl_Anteojo

exec [dbo].[insertFacturaAnteojo] @idAnteojo, @idPaciente

return 1
end

--exec [dbo].[insertAnteojoFactura] 10,10,10,10,10,10,1,20,20,20,20,20,20,2,2,3,10,10,10,1
GO
/****** Object:  Table [dbo].[tbl_Cita]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Cita](
	[Id_Cita] [int] IDENTITY(1,1) NOT NULL,
	[Id_O_Cita] [int] NULL,
	[Id_P_Cita] [int] NULL,
	[Fecha_Cita] [smalldatetime] NULL,
	[Descripcion_Cita] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Cita] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Factura_Cita]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Factura_Cita](
	[Id_Factura_Cita] [int] IDENTITY(1,1) NOT NULL,
	[Fecha_Factura_Cita] [datetime] NOT NULL,
	[Id_Paciente_Factura_Cita] [int] NULL,
	[Id_Cita_Factura_Cita] [int] NULL,
	[IVA_Factura_Cita] [smallint] NOT NULL,
	[Precio_Factura_Cita] [money] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Factura_Cita] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Oftalmologo]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Oftalmologo](
	[Id_Oftalmologo] [int] IDENTITY(1,1) NOT NULL,
	[Nombres_Oftalmologo] [nvarchar](50) NOT NULL,
	[Apellidos_Oftalmologo] [nvarchar](50) NOT NULL,
	[Edad_Oftalmologo] [int] NULL,
	[Telefono_Oftalmologo] [bigint] NULL,
	[Direccion_Oftalmologo] [nvarchar](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Oftalmologo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Paciente]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Paciente](
	[Id_Paciente] [int] IDENTITY(1,1) NOT NULL,
	[Nombres_Paciente] [nvarchar](50) NOT NULL,
	[Apellidos_Paciente] [nvarchar](50) NOT NULL,
	[Edad_Paciente] [int] NULL,
	[Telefono_Paciente] [bigint] NULL,
	[Direccion_Paciente] [nvarchar](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Paciente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vista prueba pacientes cita]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vista prueba pacientes cita]
AS
SELECT        dbo.tbl_Cita.Fecha_Cita, dbo.tbl_Cita.Descripcion_Cita, dbo.tbl_Factura_Cita.IVA_Factura_Cita, dbo.tbl_Factura_Cita.Precio_Factura_Cita, dbo.tbl_Oftalmologo.Nombres_Oftalmologo, dbo.tbl_Oftalmologo.Apellidos_Oftalmologo, 
                         dbo.tbl_Oftalmologo.Edad_Oftalmologo, dbo.tbl_Paciente.Nombres_Paciente, dbo.tbl_Paciente.Apellidos_Paciente, dbo.tbl_Paciente.Edad_Paciente, dbo.tbl_Paciente.Telefono_Paciente
FROM            dbo.tbl_Cita INNER JOIN
                         dbo.tbl_Factura_Cita ON dbo.tbl_Cita.Id_Cita = dbo.tbl_Factura_Cita.Id_Cita_Factura_Cita INNER JOIN
                         dbo.tbl_Oftalmologo ON dbo.tbl_Cita.Id_O_Cita = dbo.tbl_Oftalmologo.Id_Oftalmologo INNER JOIN
                         dbo.tbl_Paciente ON dbo.tbl_Cita.Id_P_Cita = dbo.tbl_Paciente.Id_Paciente
GO
/****** Object:  Table [dbo].[tbl_Anteojo]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Anteojo](
	[Id_Anteojo] [int] IDENTITY(1,1) NOT NULL,
	[Id_Marco_Medida_Anteojo] [int] NULL,
	[Id_Medida_Ojo_Izquierdo_Anteojo] [int] NULL,
	[Id_Medida_Ojo_Derecho_Anteojo] [int] NULL,
	[Precio_Anteojo] [money] NULL,
 CONSTRAINT [PK__tbl_Ante__33D69CF934CF4067] PRIMARY KEY CLUSTERED 
(
	[Id_Anteojo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Compra]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Compra](
	[Id_Compra] [int] IDENTITY(1,1) NOT NULL,
	[Id_Proveedor_Compra] [int] NULL,
	[Fecha_Compra] [datetime] NOT NULL,
	[Cantidad_Compra] [int] NOT NULL,
	[Precio_Lote] [money] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Compra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Detalle_Medida_Lente_Compra]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Detalle_Medida_Lente_Compra](
	[Id_Detalle_Medida_Lente_Compra] [int] IDENTITY(1,1) NOT NULL,
	[Id_Medida_Ojo_Detalle_Medida_Lente_Compra] [int] NULL,
	[Id_Compra_Detalle_Medida_Lente_Compra] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Detalle_Medida_Lente_Compra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Detalle_Medida_Lente_Inventario]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Detalle_Medida_Lente_Inventario](
	[Id_Detalle_Medida_Lente_Inventario] [int] IDENTITY(1,1) NOT NULL,
	[Id_Medida_Ojo_Detalle_Medida_Lente_Inventario] [int] NOT NULL,
	[Id_Inventario_Detalle_Medida_Lente_Inventario] [int] NOT NULL,
 CONSTRAINT [PK_tbl_Detalle_Medida_Lente_Inventario] PRIMARY KEY CLUSTERED 
(
	[Id_Detalle_Medida_Lente_Inventario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Detalle_Medida_Marco_Compra]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Detalle_Medida_Marco_Compra](
	[Id_Detalle_Medida_Marco_Compra] [int] IDENTITY(1,1) NOT NULL,
	[Id_Marco_Medida_Detalle_Medida_Marco_Compra] [int] NULL,
	[Id_Compra_Detalle_Medida_Marco_Compra] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Detalle_Medida_Marco_Compra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Detalle_Medida_Marco_Inventario]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Detalle_Medida_Marco_Inventario](
	[Id_Detalle_Medida_Marco_Inventario] [int] IDENTITY(1,1) NOT NULL,
	[Id_Marco_Medida_Detalle_Medida_Marco_Inventario] [int] NOT NULL,
	[Id_Inventario_Detalle_Medida_Marco_Inventario] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Estilos_Marco]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Estilos_Marco](
	[Id_Estilos_Marco] [int] IDENTITY(1,1) NOT NULL,
	[Precio_Estilos_Marco] [float] NOT NULL,
	[Descripcion_Estilos_Marco] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_tbl_Estilos_Marco] PRIMARY KEY CLUSTERED 
(
	[Id_Estilos_Marco] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Examen]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Examen](
	[Id_Examen] [int] IDENTITY(1,1) NOT NULL,
	[Id_C_Examen] [int] NULL,
	[ID_TE_Examen] [int] NULL,
	[Descripcion_Examen] [nvarchar](max) NOT NULL,
	[Resultado_Examen] [nvarchar](max) NOT NULL,
	[Requerimiento_Lente_Examen] [smallint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Examen] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Examen_Anteojo]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Examen_Anteojo](
	[Id_Examen_Anteojo] [int] NOT NULL,
	[Id_Ante_Examen_Anteojo] [int] NULL,
	[Id_Exam_Examen_Anteojo] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Examen_Anteojo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Factura_Anteojo]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Factura_Anteojo](
	[Id_Factura_Anteojo] [int] IDENTITY(1,1) NOT NULL,
	[Fecha_Factura_Anteojo] [datetime] NOT NULL,
	[Id_Paciente_Factura_Anteojo] [int] NULL,
	[Id_Anteojo_Factura_Anteojo] [int] NULL,
	[IVA_Factura_Anteojo] [smallint] NOT NULL,
	[Precio_Factura_Anteojo] [money] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Factura_Anteojo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Factura_Examen]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Factura_Examen](
	[Id_Factura_Examen] [int] IDENTITY(1,1) NOT NULL,
	[Fecha_Factura_Examen] [datetime] NOT NULL,
	[Id_Paciente_Factura_Examen] [int] NULL,
	[Id_Examen_Factura_Examen] [int] NULL,
	[IVA_Factura_Examen] [smallint] NOT NULL,
	[Precio_Factura_Examen] [money] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Factura_Examen] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Inventario]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Inventario](
	[Id_Inventario] [int] IDENTITY(1,1) NOT NULL,
	[Cantidad_Inventario] [int] NULL,
	[Precio_Lote_Inventario] [money] NULL,
 CONSTRAINT [PK__tbl_Inve__A9DB439C18D339D9] PRIMARY KEY CLUSTERED 
(
	[Id_Inventario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Marca]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Marca](
	[Id_Marca] [int] IDENTITY(1,1) NOT NULL,
	[Nombre_Marca] [nvarchar](50) NOT NULL,
	[Precio_Marca] [float] NOT NULL,
 CONSTRAINT [PK__tbl_Marc__28EFE28A2C068689] PRIMARY KEY CLUSTERED 
(
	[Id_Marca] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Marco_Medida]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Marco_Medida](
	[Id_Marco_Medida] [int] IDENTITY(1,1) NOT NULL,
	[Id_Marca_Marco_Medida] [int] NOT NULL,
	[Id_Estilo_Marco_Medida] [int] NOT NULL,
	[Medida_Puente_Marco_Medida] [float] NOT NULL,
	[Medida_Lente_Marco_Medida] [float] NOT NULL,
	[Medida_Patilla_Marco_Medida] [float] NOT NULL,
 CONSTRAINT [PK__tbl_Marc__47BB52F10C460043] PRIMARY KEY CLUSTERED 
(
	[Id_Marco_Medida] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Medida_Ojo]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Medida_Ojo](
	[Id_Medida_Ojo] [int] IDENTITY(1,1) NOT NULL,
	[Esfera_Medida_Ojo] [float] NULL,
	[Cilindro_Medida_Ojo] [float] NULL,
	[Eje_Medida_Ojo] [float] NULL,
	[Vision_Proxima_Medida_Ojo] [float] NULL,
	[Distancia_Interpupilar_Medida_Ojo] [float] NULL,
	[Prisma_Medida_Ojo] [float] NULL,
	[Id_Tipo_Lente_Medida_Ojo] [int] NULL,
 CONSTRAINT [PK_tbl_Medida_Ojo] PRIMARY KEY CLUSTERED 
(
	[Id_Medida_Ojo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Orden]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Orden](
	[Id_Orden] [int] IDENTITY(1,1) NOT NULL,
	[Fecha_Orden] [datetime] NOT NULL,
	[Id_Factura_Anteojo_Orden] [int] NOT NULL,
 CONSTRAINT [PK__tbl_Orde__370733B645D6CE43] PRIMARY KEY CLUSTERED 
(
	[Id_Orden] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Producto_Espera]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Producto_Espera](
	[Id_Producto_Espera] [int] IDENTITY(1,1) NOT NULL,
	[Fecha_Producto_Espera] [datetime] NOT NULL,
	[Id_Orden_Producto_Espera] [int] NULL,
	[Estado_Producto_Espera] [bit] NOT NULL,
 CONSTRAINT [PK__tbl_Prod__6A378FC5355DCB12] PRIMARY KEY CLUSTERED 
(
	[Id_Producto_Espera] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Producto_Terminado]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Producto_Terminado](
	[Id_Producto_Terminado] [int] IDENTITY(1,1) NOT NULL,
	[Fecha_Producto_Terminado] [datetime] NOT NULL,
	[Id_Orden__Producto_Terminado] [int] NULL,
 CONSTRAINT [PK__tbl_Prod__74D62E107AD02E4E] PRIMARY KEY CLUSTERED 
(
	[Id_Producto_Terminado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Proveedor]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Proveedor](
	[Id_Proveedor] [int] IDENTITY(1,1) NOT NULL,
	[Detalle_Proveedor] [nvarchar](100) NOT NULL,
	[Telefono_Proveedor] [nvarchar](20) NOT NULL,
	[Correo_Proveedor] [nvarchar](30) NOT NULL,
	[Direccion] [nvarchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Proveedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Retiro]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Retiro](
	[Id_Retiro] [int] IDENTITY(1,1) NOT NULL,
	[Id_Prod_Term_Retiro] [int] NOT NULL,
	[Fecha_Retiro] [datetime] NOT NULL,
	[Estado_Retiro] [smallint] NOT NULL,
 CONSTRAINT [PK__Retiro__2499A397E86AA3A3] PRIMARY KEY CLUSTERED 
(
	[Id_Retiro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Tipo_Estilo]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Tipo_Estilo](
	[Id_Tipo_Estilo] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion_Tipo_Estilo] [nchar](100) NOT NULL,
 CONSTRAINT [PK_tbl_Tipo_Estilo] PRIMARY KEY CLUSTERED 
(
	[Id_Tipo_Estilo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Tipo_Examen]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Tipo_Examen](
	[Id_Tipo_Examen] [int] IDENTITY(1,1) NOT NULL,
	[Precio_Tipo_Examen] [smallmoney] NOT NULL,
	[Descripcion_Tipo_Examen] [nvarchar](max) NOT NULL,
	[Nombre_Tipo_Examen] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Tipo_Examen] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Tipo_Lente]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Tipo_Lente](
	[Id_Lente] [int] IDENTITY(1,1) NOT NULL,
	[Tipo_Lente] [nvarchar](50) NOT NULL,
	[Precio_lentes] [smallmoney] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Lente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Anteojo]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Anteojo_tbl_Medida_OjoDerecho] FOREIGN KEY([Id_Medida_Ojo_Derecho_Anteojo])
REFERENCES [dbo].[tbl_Medida_Ojo] ([Id_Medida_Ojo])
GO
ALTER TABLE [dbo].[tbl_Anteojo] CHECK CONSTRAINT [FK_tbl_Anteojo_tbl_Medida_OjoDerecho]
GO
ALTER TABLE [dbo].[tbl_Anteojo]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Anteojo_tbl_Medida_OjoIzquierdo] FOREIGN KEY([Id_Medida_Ojo_Izquierdo_Anteojo])
REFERENCES [dbo].[tbl_Medida_Ojo] ([Id_Medida_Ojo])
GO
ALTER TABLE [dbo].[tbl_Anteojo] CHECK CONSTRAINT [FK_tbl_Anteojo_tbl_Medida_OjoIzquierdo]
GO
ALTER TABLE [dbo].[tbl_Cita]  WITH CHECK ADD FOREIGN KEY([Id_O_Cita])
REFERENCES [dbo].[tbl_Oftalmologo] ([Id_Oftalmologo])
GO
ALTER TABLE [dbo].[tbl_Cita]  WITH CHECK ADD FOREIGN KEY([Id_P_Cita])
REFERENCES [dbo].[tbl_Paciente] ([Id_Paciente])
GO
ALTER TABLE [dbo].[tbl_Compra]  WITH CHECK ADD FOREIGN KEY([Id_Proveedor_Compra])
REFERENCES [dbo].[tbl_Proveedor] ([Id_Proveedor])
GO
ALTER TABLE [dbo].[tbl_Detalle_Medida_Lente_Compra]  WITH CHECK ADD FOREIGN KEY([Id_Compra_Detalle_Medida_Lente_Compra])
REFERENCES [dbo].[tbl_Compra] ([Id_Compra])
GO
ALTER TABLE [dbo].[tbl_Detalle_Medida_Lente_Compra]  WITH CHECK ADD FOREIGN KEY([Id_Medida_Ojo_Detalle_Medida_Lente_Compra])
REFERENCES [dbo].[tbl_Tipo_Lente] ([Id_Lente])
GO
ALTER TABLE [dbo].[tbl_Detalle_Medida_Lente_Inventario]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Detalle_Medida_Lente_Inventario_tbl_Inventario] FOREIGN KEY([Id_Inventario_Detalle_Medida_Lente_Inventario])
REFERENCES [dbo].[tbl_Inventario] ([Id_Inventario])
GO
ALTER TABLE [dbo].[tbl_Detalle_Medida_Lente_Inventario] CHECK CONSTRAINT [FK_tbl_Detalle_Medida_Lente_Inventario_tbl_Inventario]
GO
ALTER TABLE [dbo].[tbl_Detalle_Medida_Lente_Inventario]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Detalle_Medida_Lente_Inventario_tbl_Medida_Ojo] FOREIGN KEY([Id_Medida_Ojo_Detalle_Medida_Lente_Inventario])
REFERENCES [dbo].[tbl_Medida_Ojo] ([Id_Medida_Ojo])
GO
ALTER TABLE [dbo].[tbl_Detalle_Medida_Lente_Inventario] CHECK CONSTRAINT [FK_tbl_Detalle_Medida_Lente_Inventario_tbl_Medida_Ojo]
GO
ALTER TABLE [dbo].[tbl_Detalle_Medida_Marco_Compra]  WITH CHECK ADD FOREIGN KEY([Id_Compra_Detalle_Medida_Marco_Compra])
REFERENCES [dbo].[tbl_Compra] ([Id_Compra])
GO
ALTER TABLE [dbo].[tbl_Detalle_Medida_Marco_Compra]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Detalle_Medida_Marco_Compra_tbl_Marco_Medida] FOREIGN KEY([Id_Marco_Medida_Detalle_Medida_Marco_Compra])
REFERENCES [dbo].[tbl_Marco_Medida] ([Id_Marco_Medida])
GO
ALTER TABLE [dbo].[tbl_Detalle_Medida_Marco_Compra] CHECK CONSTRAINT [FK_tbl_Detalle_Medida_Marco_Compra_tbl_Marco_Medida]
GO
ALTER TABLE [dbo].[tbl_Detalle_Medida_Marco_Inventario]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Detalle_Medida_Marco_Inventario_tbl_Inventario] FOREIGN KEY([Id_Inventario_Detalle_Medida_Marco_Inventario])
REFERENCES [dbo].[tbl_Inventario] ([Id_Inventario])
GO
ALTER TABLE [dbo].[tbl_Detalle_Medida_Marco_Inventario] CHECK CONSTRAINT [FK_tbl_Detalle_Medida_Marco_Inventario_tbl_Inventario]
GO
ALTER TABLE [dbo].[tbl_Detalle_Medida_Marco_Inventario]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Detalle_Medida_Marco_Inventario_tbl_Marco_Medida] FOREIGN KEY([Id_Marco_Medida_Detalle_Medida_Marco_Inventario])
REFERENCES [dbo].[tbl_Marco_Medida] ([Id_Marco_Medida])
GO
ALTER TABLE [dbo].[tbl_Detalle_Medida_Marco_Inventario] CHECK CONSTRAINT [FK_tbl_Detalle_Medida_Marco_Inventario_tbl_Marco_Medida]
GO
ALTER TABLE [dbo].[tbl_Examen]  WITH CHECK ADD FOREIGN KEY([Id_C_Examen])
REFERENCES [dbo].[tbl_Cita] ([Id_Cita])
GO
ALTER TABLE [dbo].[tbl_Examen]  WITH CHECK ADD FOREIGN KEY([ID_TE_Examen])
REFERENCES [dbo].[tbl_Tipo_Examen] ([Id_Tipo_Examen])
GO
ALTER TABLE [dbo].[tbl_Examen_Anteojo]  WITH CHECK ADD  CONSTRAINT [FK__tbl_Exame__Id_An__412EB0B6] FOREIGN KEY([Id_Ante_Examen_Anteojo])
REFERENCES [dbo].[tbl_Anteojo] ([Id_Anteojo])
GO
ALTER TABLE [dbo].[tbl_Examen_Anteojo] CHECK CONSTRAINT [FK__tbl_Exame__Id_An__412EB0B6]
GO
ALTER TABLE [dbo].[tbl_Examen_Anteojo]  WITH CHECK ADD FOREIGN KEY([Id_Exam_Examen_Anteojo])
REFERENCES [dbo].[tbl_Examen] ([Id_Examen])
GO
ALTER TABLE [dbo].[tbl_Factura_Anteojo]  WITH CHECK ADD  CONSTRAINT [FK__tbl_Factu__Id_An__6754599E] FOREIGN KEY([Id_Anteojo_Factura_Anteojo])
REFERENCES [dbo].[tbl_Anteojo] ([Id_Anteojo])
GO
ALTER TABLE [dbo].[tbl_Factura_Anteojo] CHECK CONSTRAINT [FK__tbl_Factu__Id_An__6754599E]
GO
ALTER TABLE [dbo].[tbl_Factura_Anteojo]  WITH CHECK ADD FOREIGN KEY([Id_Paciente_Factura_Anteojo])
REFERENCES [dbo].[tbl_Paciente] ([Id_Paciente])
GO
ALTER TABLE [dbo].[tbl_Factura_Cita]  WITH CHECK ADD FOREIGN KEY([Id_Cita_Factura_Cita])
REFERENCES [dbo].[tbl_Cita] ([Id_Cita])
GO
ALTER TABLE [dbo].[tbl_Factura_Cita]  WITH CHECK ADD FOREIGN KEY([Id_Paciente_Factura_Cita])
REFERENCES [dbo].[tbl_Paciente] ([Id_Paciente])
GO
ALTER TABLE [dbo].[tbl_Factura_Examen]  WITH CHECK ADD FOREIGN KEY([Id_Examen_Factura_Examen])
REFERENCES [dbo].[tbl_Examen] ([Id_Examen])
GO
ALTER TABLE [dbo].[tbl_Factura_Examen]  WITH CHECK ADD FOREIGN KEY([Id_Paciente_Factura_Examen])
REFERENCES [dbo].[tbl_Paciente] ([Id_Paciente])
GO
ALTER TABLE [dbo].[tbl_Marco_Medida]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Marco_Medida_tbl_Estilos_Marco] FOREIGN KEY([Id_Estilo_Marco_Medida])
REFERENCES [dbo].[tbl_Estilos_Marco] ([Id_Estilos_Marco])
GO
ALTER TABLE [dbo].[tbl_Marco_Medida] CHECK CONSTRAINT [FK_tbl_Marco_Medida_tbl_Estilos_Marco]
GO
ALTER TABLE [dbo].[tbl_Marco_Medida]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Marco_Medida_tbl_Marca] FOREIGN KEY([Id_Marca_Marco_Medida])
REFERENCES [dbo].[tbl_Marca] ([Id_Marca])
GO
ALTER TABLE [dbo].[tbl_Marco_Medida] CHECK CONSTRAINT [FK_tbl_Marco_Medida_tbl_Marca]
GO
ALTER TABLE [dbo].[tbl_Medida_Ojo]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Medida_Ojo_tbl_Tipo_Lente] FOREIGN KEY([Id_Tipo_Lente_Medida_Ojo])
REFERENCES [dbo].[tbl_Tipo_Lente] ([Id_Lente])
GO
ALTER TABLE [dbo].[tbl_Medida_Ojo] CHECK CONSTRAINT [FK_tbl_Medida_Ojo_tbl_Tipo_Lente]
GO
ALTER TABLE [dbo].[tbl_Orden]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Orden_tbl_Factura_Anteojo] FOREIGN KEY([Id_Factura_Anteojo_Orden])
REFERENCES [dbo].[tbl_Factura_Anteojo] ([Id_Factura_Anteojo])
GO
ALTER TABLE [dbo].[tbl_Orden] CHECK CONSTRAINT [FK_tbl_Orden_tbl_Factura_Anteojo]
GO
ALTER TABLE [dbo].[tbl_Producto_Espera]  WITH CHECK ADD  CONSTRAINT [FK__tbl_Produ__Id_Or__0F624AF8] FOREIGN KEY([Id_Orden_Producto_Espera])
REFERENCES [dbo].[tbl_Orden] ([Id_Orden])
GO
ALTER TABLE [dbo].[tbl_Producto_Espera] CHECK CONSTRAINT [FK__tbl_Produ__Id_Or__0F624AF8]
GO
ALTER TABLE [dbo].[tbl_Producto_Terminado]  WITH CHECK ADD  CONSTRAINT [FK__tbl_Produ__Id_Or__10566F31] FOREIGN KEY([Id_Orden__Producto_Terminado])
REFERENCES [dbo].[tbl_Orden] ([Id_Orden])
GO
ALTER TABLE [dbo].[tbl_Producto_Terminado] CHECK CONSTRAINT [FK__tbl_Produ__Id_Or__10566F31]
GO
ALTER TABLE [dbo].[tbl_Retiro]  WITH CHECK ADD  CONSTRAINT [FK__Retiro__Id_Prod___72C60C4A] FOREIGN KEY([Id_Prod_Term_Retiro])
REFERENCES [dbo].[tbl_Producto_Terminado] ([Id_Producto_Terminado])
GO
ALTER TABLE [dbo].[tbl_Retiro] CHECK CONSTRAINT [FK__Retiro__Id_Prod___72C60C4A]
GO
/****** Object:  StoredProcedure [dbo].[getInventarioMedidas]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  proc [dbo].[getInventarioMedidas]
as
begin
select Id_Medida_Ojo, Cantidad_Inventario, Precio_Lote_Inventario,dbo.getPrecioMedidaOjoById(Id_Medida_Ojo) as PrecioMedida,Id_Inventario,Esfera_Medida_Ojo, Cilindro_Medida_Ojo,Eje_Medida_Ojo, Vision_Proxima_Medida_Ojo, Distancia_Interpupilar_Medida_Ojo, Prisma_Medida_Ojo,Tipo_Lente,Precio_lentes from tbl_Medida_Ojo
inner join tbl_Detalle_Medida_Lente_Inventario on Id_Medida_Ojo=Id_Medida_Ojo_Detalle_Medida_Lente_Inventario
inner join tbl_Inventario on Id_Inventario_Detalle_Medida_Lente_Inventario=Id_Inventario
inner join tbl_Tipo_Lente on Id_Tipo_Lente_Medida_Ojo=Id_Lente
end
GO
/****** Object:  StoredProcedure [dbo].[getInventarioMedidasMarco]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  proc [dbo].[getInventarioMedidasMarco]
as
begin
select Id_Marco_Medida,Cantidad_Inventario,Precio_Lote_Inventario,ROUND([dbo].[getPrecioMedidasMarcoById](Id_Marco_Medida),4) as PrecioMedida, Id_Inventario,Medida_Puente_Marco_Medida,Medida_Patilla_Marco_Medida,Medida_Lente_Marco_Medida,Nombre_Marca,Precio_Marca,Descripcion_Estilos_Marco,Precio_Estilos_Marco
from tbl_Marco_Medida
inner join tbl_Detalle_Medida_Marco_Inventario on Id_Marco_Medida = Id_Marco_Medida_Detalle_Medida_Marco_Inventario
inner join tbl_Inventario on Id_Inventario_Detalle_Medida_Marco_Inventario = Id_Inventario
inner join tbl_Marca on Id_Marca_Marco_Medida = Id_Marca
inner join tbl_Estilos_Marco on Id_Estilo_Marco_Medida=Id_Estilos_Marco
end
GO
/****** Object:  StoredProcedure [dbo].[insertAnteojo]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[insertAnteojo]
(
@IdMedidaMarco int,
@IdMedidaOjoDer int,
@IdMedidaOjoIzq int
)
as
begin
declare @PrecioLente float
select @PrecioLente=dbo.getPrecioAnteojoByIdMedidasOjo_IdMedidasMarco(@IdMedidaMarco,@IdMedidaOjoDer,@IdMedidaOjoIzq)

insert into tbl_Anteojo values 
(
@IdMedidaMarco,
@IdMedidaOjoIzq,
@IdMedidaOjoDer,
@PrecioLente
)

end
GO
/****** Object:  StoredProcedure [dbo].[insertAnteojoFactura]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[insertAnteojoFactura]
(
@Esfd float,
@Cyld float,
@Ejed float,
@Vpd float,
@Dipd float,
@Prismad float,
@Id_Tipo_Lented float,

@Esfi float,
@Cyli float,
@Ejei float,
@Vpi float,
@Dipi float,
@Prismai float,
@Id_Tipo_Lentei float,

@IdMarca int,
@IdEstilo int,
@MedPuente float,
@MedLente float,
@MedPatilla float,

@idPaciente int,
@fecha smalldatetime

)
as
begin
declare @idOjoDer int, @idOjoIzq int,  @idMarco int
declare @precioAnteojo float

select @idOjoDer=[dbo].[getMedidaOjoIdByMedidas_IdLente](@Esfd,@Cyld ,@Ejed ,@Vpd ,@Dipd ,@Prismad ,@Id_Tipo_Lented )
if(@idOjoDer = 0)
begin
insert into tbl_Medida_Ojo values(@Esfd,@Cyld ,@Ejed ,@Vpd ,@Dipd ,@Prismad ,@Id_Tipo_Lented)
select @idOjoDer=max(Id_Medida_Ojo) from tbl_Medida_Ojo
end

select @idOjoIzq=[dbo].[getMedidaOjoIdByMedidas_IdLente](@Esfi,@Cyli ,@Ejei ,@Vpi ,@Dipi ,@Prismai ,@Id_Tipo_Lentei )
if(@idOjoIzq = 0)
begin
insert into tbl_Medida_Ojo values(@Esfi,@Cyli ,@Ejei ,@Vpi ,@Dipi ,@Prismai ,@Id_Tipo_Lentei)
select @idOjoIzq=max(Id_Medida_Ojo) from tbl_Medida_Ojo
end


select @idMarco=[dbo].[getMedidaMarcoIdByMedidas_IdMarca_IdEstilo](@IdMarca,@IdEstilo,@MedPuente,@MedLente,@MedPatilla)
if(@idMarco = 0)
begin
insert into tbl_Marco_Medida values(@IdMarca,@IdEstilo,@MedPuente,@MedLente,@MedPatilla)
select MAX(Id_Marco_Medida) from tbl_Marco_Medida
end

	declare @PrecioLente float
	select @PrecioLente=dbo.getPrecioAnteojoByIdMedidasOjo_IdMedidasMarco(@idMarco,@idOjoDer,@idOjoIzq)
	insert into tbl_Anteojo values 
		(
			@idMarco,
			@idOjoIzq,
			@idOjoDer,
			@PrecioLente
		)


	declare @idAnteojo int
	select @idAnteojo=max(Id_Anteojo) from tbl_Anteojo
	insert into tbl_Factura_Anteojo values(@fecha,@idPaciente,@idAnteojo, 15,dbo.getPrecioAnteojoById(@idAnteojo))

end
GO
/****** Object:  StoredProcedure [dbo].[insertFacturaAnteojo]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create  proc [dbo].[insertFacturaAnteojo](@Id_Anteojo int, @Id_Paciente int)
as
begin
insert into tbl_Factura_Anteojo values(GETDATE(),@Id_Paciente,@Id_Anteojo, 15,dbo.getPrecioAnteojoById(@Id_Anteojo))
end

GO
/****** Object:  StoredProcedure [dbo].[insertFacturaExamen]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create  proc [dbo].[insertFacturaExamen](@Id_Paciente int, @Id_Examen int)
as
begin
insert into tbl_Factura_Examen values(GETDATE(),@Id_Paciente,@Id_Examen, 15,dbo.getPrecioExamenByIdExamen(@Id_Examen))
end
GO
/****** Object:  StoredProcedure [dbo].[insertInventarioLente]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create  proc [dbo].[insertInventarioLente](
	@Esf float,
	@Cyl float,
	@Eje float ,
	@Vp float ,
	@Dip float  ,
	@Prisma float,
	@id_Tipo_Lente int, 
	@Cantidad int
) 
as
begin
	declare @idMedidas int, @precioMedidas float, @idDetallesMedidas int

		select @idMedidas= dbo.getMedidaOjoIdByMedidas_IdLente(@Esf ,@Cyl ,@Eje  ,@Vp  ,@Dip ,@Prisma ,@id_Tipo_Lente)

		select @precioMedidas = [dbo].[getPrecioMedidaOjoById](@idMedidas)

		select @idDetallesMedidas=Id_Detalle_Medida_Lente_Inventario from [tbl_Detalle_Medida_Lente_Inventario] 
		where Id_Medida_Ojo_Detalle_Medida_Lente_Inventario =@idMedidas

		declare @Inv int
if(@idDetallesMedidas is not null)
	begin
		select @Inv= Id_Inventario_Detalle_Medida_Lente_Inventario from tbl_Detalle_Medida_Lente_Inventario where Id_Detalle_Medida_Lente_Inventario = @idDetallesMedidas

		update tbl_Inventario
			set Cantidad_Inventario = Cantidad_Inventario+@Cantidad,
				Precio_Lote_Inventario=Precio_Lote_Inventario+(@precioMedidas*@Cantidad)
		where Id_Inventario=@Inv

	end
else
	begin

	insert into tbl_Inventario values(
			@Cantidad,
			(@precioMedidas*@Cantidad)
		)

	select @Inv = max(Id_Inventario) from tbl_Inventario

	insert into tbl_Detalle_Medida_Lente_Inventario values(
			@idMedidas,
			@Inv
		)

	end



end
GO
/****** Object:  StoredProcedure [dbo].[insertInventarioLenteByIdMedidas]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create  proc [dbo].[insertInventarioLenteByIdMedidas](
	@idMedidas int, 
	@Cantidad int
) 
as
begin
	declare  @precioMedidas float, @idDetallesMedidas int

		select @precioMedidas = [dbo].[getPrecioMedidaOjoById](@idMedidas)

		select @idDetallesMedidas=Id_Detalle_Medida_Lente_Inventario from [tbl_Detalle_Medida_Lente_Inventario] 
		where Id_Medida_Ojo_Detalle_Medida_Lente_Inventario =@idMedidas

		declare @Inv int
if(@idDetallesMedidas is not null)
	begin
		select @Inv= Id_Inventario_Detalle_Medida_Lente_Inventario from tbl_Detalle_Medida_Lente_Inventario where Id_Detalle_Medida_Lente_Inventario = @idDetallesMedidas

		update tbl_Inventario
			set Cantidad_Inventario = Cantidad_Inventario+@Cantidad,
				Precio_Lote_Inventario=Precio_Lote_Inventario+(@precioMedidas*@Cantidad)
		where Id_Inventario=@Inv

	end
else
	begin

	insert into tbl_Inventario values(
			@Cantidad,
			(@precioMedidas*@Cantidad)
		)

	select @Inv = max(Id_Inventario) from tbl_Inventario

	insert into tbl_Detalle_Medida_Lente_Inventario values(
			@idMedidas,
			@Inv
		)

	end



end
GO
/****** Object:  StoredProcedure [dbo].[insertInventarioMarco]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[insertInventarioMarco]
(
	@IdMarca int,
	@IdEstilo int,
	@MedPuente float,
	@MedLente float,
	@MedPatilla float,
	@Cant int
)
as
begin
	declare @idMedidas int, @precioMedidas float, @idDetallesMedidas int

	select @idMedidas=dbo.getMedidaMarcoIdByMedidas_IdMarca_IdEstilo(@IdMarca, @IdEstilo, @MedPuente, @MedLente, @MedPatilla)

	select @precioMedidas=dbo.getPrecioMedidasMarcoById(@idMedidas)

	select @idDetallesMedidas = Id_Detalle_Medida_Marco_Inventario from tbl_Detalle_Medida_Marco_Inventario
								where Id_Marco_Medida_Detalle_Medida_Marco_Inventario=@idMedidas

		declare @Inv int
	if(@idDetallesMedidas is not null)
	begin
		select @Inv=Id_Inventario_Detalle_Medida_Marco_Inventario from tbl_Detalle_Medida_Marco_Inventario
					where Id_Detalle_Medida_Marco_Inventario=@idDetallesMedidas


		update tbl_Inventario
			set Cantidad_Inventario = Cantidad_Inventario+@Cant,
				Precio_Lote_Inventario=Precio_Lote_Inventario+(@precioMedidas*@Cant)
		where Id_Inventario=@Inv

	end
	else
	begin
		insert into tbl_Inventario values
			(
				@Cant,
				(@precioMedidas*@Cant)
			)

		select @Inv= max(Id_Inventario) from tbl_Inventario

		insert into tbl_Detalle_Medida_Marco_Inventario values
			(
				@idMedidas,
				@Inv
			)


	end


end
GO
/****** Object:  StoredProcedure [dbo].[insertInventarioMarcoByIdMedidas]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[insertInventarioMarcoByIdMedidas]
(
	@idMedidas int,
	@Cant int
)
as
begin
	declare  @precioMedidas float, @idDetallesMedidas int

	select @precioMedidas=dbo.getPrecioMedidasMarcoById(@idMedidas)

	select @idDetallesMedidas = Id_Detalle_Medida_Marco_Inventario from tbl_Detalle_Medida_Marco_Inventario
								where Id_Marco_Medida_Detalle_Medida_Marco_Inventario=@idMedidas

		declare @Inv int
	if(@idDetallesMedidas is not null)
	begin
		select @Inv=Id_Inventario_Detalle_Medida_Marco_Inventario from tbl_Detalle_Medida_Marco_Inventario
					where Id_Detalle_Medida_Marco_Inventario=@idDetallesMedidas


		update tbl_Inventario
			set Cantidad_Inventario = Cantidad_Inventario+@Cant,
				Precio_Lote_Inventario=Precio_Lote_Inventario+(@precioMedidas*@Cant)
		where Id_Inventario=@Inv

	end
	else
	begin
		insert into tbl_Inventario values
			(
				@Cant,
				(@precioMedidas*@Cant)
			)

		select @Inv= max(Id_Inventario) from tbl_Inventario

		insert into tbl_Detalle_Medida_Marco_Inventario values
			(
				@idMedidas,
				@Inv
			)


	end


end
GO
/****** Object:  StoredProcedure [dbo].[insertMedidaMarco]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[insertMedidaMarco]
(
	@IdMarca int,
@IdEstilo int,
@MedPuente float,
@MedLente float,
@MedPatilla float,
@idMedida int = null output
)
as
begin

select @idMedida=[dbo].[getMedidaMarcoIdByMedidas_IdMarca_IdEstilo](@IdMarca,@IdEstilo,@MedPuente,@MedLente,@MedPatilla)
if(@idMedida != 0)
begin
return @idMedida
end
else
begin
insert into tbl_Marco_Medida values
(
@IdMarca ,
@IdEstilo ,
@MedPuente ,
@MedLente ,
@MedPatilla 
)
set @idMedida = 0
	return @idMedida
end
end
GO
/****** Object:  StoredProcedure [dbo].[insertMedidaOjo]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[insertMedidaOjo]
(
@Esf float,
@Cyl float,
@Eje float,
@Vp float,
@Dip float,
@Prisma float,
@Id_Tipo_Lente float,
@idMedida int = null output
)
as
begin

select @idMedida=dbo.[getMedidaOjoIdByMedidas_IdLente](@Esf,@Cyl,@Eje,@Vp,@Dip,@Prisma,@Id_Tipo_Lente)
if(@idMedida != 0)
begin
return @idMedida
end
else
begin
insert into tbl_Medida_Ojo values
(
@Esf ,
@Cyl ,
@Eje ,
@Vp ,
@Dip ,
@Prisma ,
@Id_Tipo_Lente
)
set @idMedida = 0
	return @idMedida
end
end
GO
/****** Object:  StoredProcedure [dbo].[insertOrden]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[insertOrden]
(
	@idFac int
)
as
begin
	insert into tbl_Orden values
	(
		GETDATE(),
		@idFac
	)
end
GO
/****** Object:  StoredProcedure [dbo].[insertProductoEspera]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[insertProductoEspera]
(
	@idOrden int
)
as
begin
	insert into tbl_Producto_Espera values
	(
		GETDATE(),
		@idOrden,
		0
	)
end
GO
/****** Object:  StoredProcedure [dbo].[insertProductTerminado]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[insertProductTerminado]
(
	@idOrden int
)
as
begin
	insert into tbl_Producto_Terminado values
	(
		GETDATE(),
		@idOrden
	)
end
GO
/****** Object:  StoredProcedure [dbo].[insertRetiro]    Script Date: 10/9/2021 12:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[insertRetiro]
(
	@idProTer int
)
as
begin
	insert into tbl_Retiro values
	(
		@idProTer,
		DATEADD(month, 1 , getdate()),		
		0
	)
end
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tbl_Cita"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 215
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "tbl_Factura_Cita"
            Begin Extent = 
               Top = 6
               Left = 253
               Bottom = 136
               Right = 472
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "tbl_Oftalmologo"
            Begin Extent = 
               Top = 6
               Left = 510
               Bottom = 136
               Right = 722
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "tbl_Paciente"
            Begin Extent = 
               Top = 6
               Left = 760
               Bottom = 136
               Right = 949
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vista prueba pacientes cita'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vista prueba pacientes cita'
GO
USE master
GO