/*
	Esse script contem a criação das visualizações da gamada gold no data warehouse
	Cada visualização realiza trasnformações e combina dados da camada silver para
	produzir dados limpos e prontos para serem usados.
*/


-- Criação da visualição dim_clientes

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
go

-- Criação da visualização dim_produtos
create view gold.dim_produtos as
select
	ip.prd_id as id_produto,
	ip.prd_key as chave_produto,
	ip.prd_nm as nome_produto,
	ip.cat_id as id_categoria,
	pr.cat as categoria,
	pr.subcat as subcategoria,
	pr.maintenance manuntençao,
	ip.prd_cost as custo,
	ip.prd_line as linha,
	ip.prd_start_dt as data_inicial
from silver.crm_prd_info ip 
	left join silver.erp_px_cat_g1v2 pr
on ip.cat_id = pr.id
where ip.prd_end_dt is null
