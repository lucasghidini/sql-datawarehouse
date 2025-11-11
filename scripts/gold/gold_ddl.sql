-- camada gold
create view gold.dim_clientes as 
select
	row_number () over(order by cst_id) as cliente_chave,
	ci.cst_id as cliente_id,
	ci.cst_key as numero_cliente,
	ci.cst_fistname as primeiro_nome,
	ci.cst_lastname as segundo_nome,
	la.cntry as pais_de_origem,
	ca.bdate as data_de_nascimento,
	case
		when ci.cst_gndr != 'n/a' then ci.cst_gndr -- crm é nosso banco de dados mestre para os generos
		else coalesce(ca.gen, 'n/a')
	end as sexo,
	ci.cst_marital_status as estado_civil,
	ci.cst_create_date as data_de_criacao
from silver.crm_cust_info ci
	left join silver.erp_cust_az12 ca
on ci.cst_key = ca.cid
	left join silver.erp_loc_a101 la
on ci.cst_key = la.cid
