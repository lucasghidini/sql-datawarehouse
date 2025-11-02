
/*
	Checagem dos dados da camada silver, esse script roda queires para chegar se as transformaçoes foram feitas corretamente como:
	- Chaves primarias nulas ou duplicadas
	- Espaços nas strings
	- Padronização dos dados
*/


-- -----------------------
--  Checando 'silver.crm_cust_info'
-- ---------------------------


-- Checagem de nulos e dados duplicados na chave primaria, expequitativa: 0 resultados
select
	cst_id,
	count(*)
from silver.crm_cust_info
group by cst_id
having count (*) > 1 or cst_id is null;

-- Checagem de espaços nas strings, expequitativa: 0 resultados
select 
	cst_key
from silver.crm_cust_info
where cst_key != trim(cst_key);

-- Padronizaçõa dos dados
select distinct 
	cst_marital_status
from silver.crm_cust_info;

select * from silver.crm_cust_info

-- -----------------------
--  Checando 'silver.crm_prd_info'
-- ---------------------------

-- Chegando as chaves primarias, se comtem dados duplicados ou nulos, expectativa de resultados: 0
select
prd_id,
count(*)
from silver.crm_prd_info
group by prd_id
having count(*) > 1 or prd_id is null

-- checando espaços indesejados, expectativa de resultados: 0
select
prd_nm
from silver.crm_prd_info
where prd_nm != trim(prd_nm)

-- Padronização de dados
select distinct
prd_line
from silver.crm_prd_info

-- Checagem de datas invalidas(começo e final das datas)
select * from silver.crm_prd_info
where prd_end_dt < prd_start_dt
