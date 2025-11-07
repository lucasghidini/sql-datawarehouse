/*
	Checagem dos dados da camada silver, esse script roda queires para chegar se as transformaçoes foram feitas corretamente como:
	- Chaves primarias nulas ou duplicadas
	- Espaços nas strings
	- Padronização dos dados
*/


-- ---------------------------
--  Checando 'silver.crm_cust_info'
-- ---------------------------
use DataWarehouse

-- Checagem de nulos e dados duplicados na chave primaria
select
	cst_id,
	count(*)
from silver.crm_cust_info
group by cst_id
having count (*) > 1 or cst_id is null;

-- Checagem de espaços nas strings
select 
	cst_key
from silver.crm_cust_info
where cst_key != trim(cst_key);

-- Padronizaçõa dos dados
select distinct 
	cst_marital_status
from silver.crm_cust_info;

select * from silver.crm_cust_info

-- ---------------------------
--  Checando 'silver.crm_prd_info'
-- ---------------------------

-- Chegando as chaves primarias, se comtem dados duplicados ou nulos
select
prd_id,
count(*)
from silver.crm_prd_info
group by prd_id
having count(*) > 1 or prd_id is null

-- checando espaços indesejados
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

-- --------------------------
--  Checando 'silver.crm_sales_details'
-- ---------------------------

-- checagem de datas invalidas
select 
	nullif(sls_due_dt, 0) as sls_due_dt
from bronze.crm_sales_details
where sls_due_dt <= 0
	or len(sls_due_dt) != 8;

-- chegagem da orden das datas
select * from silver.crm_sales_details
where sls_order_dt > sls_ship_dt
	or sls_order_dt > sls_due_dt

--checagem regra de negocio:
-- sales = quantity * price
select distinct
	sls_sales,
	sls_quantity,
	sls_price
from silver.crm_sales_details
where sls_sales != sls_quantity * sls_price
	or sls_sales is null
	or sls_quantity is null
	or sls_price is null
	or sls_sales <= 0
	or sls_quantity <=0
	or sls_price <=0
order by sls_sales, sls_quantity, sls_price;

-- --------------------------
--  Checando 'silver.erp_cust_az12'
-- ---------------------------

-- Checagem de datas invalidas
select
	bdate
from silver.erp_cust_az12
where bdate > getdate();

-- chegagem dos genereos
select distinct 
gen
from silver.erp_cust_az12

-- --------------------------
--  Checando 'silver.erp_loc_a101'
-- ---------------------------

-- checagem dos nomes dos paises de origem da tabela
select distinct
cntry
from silver.erp_loc_a101
order by cntry

-- --------------------------
--  Checando 'silver.erp_px_cat_g1v2'
-- ---------------------------

-- chegando espaços
select
*
from silver.erp_px_cat_g1v2
where cat != trim(cat)
	or subcat != trim(subcat)
	or maintenance != trim(maintenance)

-- Padronização dos dados
select distinct  
    maintenance 
from silver.erp_px_cat_g1v2;
