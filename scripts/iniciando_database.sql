/*
	Criando o Database e os Schemas

	Esse script cria um database com o nome 'DataWarehouse' e checa se já existe um.
	Se existir ele é apagado e recirado, ápois isso ele cria três schemas, 'bronze', 'silver', e 'gold'.

*/

use master;
go

-- Garantindo que nao existe outro database com esse nome
drop DATABASE if exists DataWarehouse;
go

-- Criando o banco de dados

create database DataWarehouse;
go

use DataWarehouse;
go

-- Criando os schemas
create schema bronze;
go

create schema silver;
go

create schema gold;
go
