/*
	Esse script contem a criação das visualizações da gamada gold no data warehouse
	Cada visualização realiza trasnformações e combina dados da camada silver para
	produzir dados limpos e prontos para serem usados.
*/


-- Criação da visualição dim_clientes
if object_id('gold.dim_clientes', 'V') is not null
	drop view gold.dim_clientes;
go


create view gold.dim_clientes as 
select
	row_number () over(order by cst_id) as chave_cliente,
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


-- Criação da visaulização dim_produtos]
if object_id('gold.dim_produtos', 'V') is not null
	drop view gold.dim_produtos;
go


create view gold.dim_produtos as
select
	row_number () over(order by ip.prd_start_dt, ip.prd_id) as chave_produto,
	ip.prd_id as id_produto,
	ip.prd_key as numero_produto,
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
go


-- criando a visualização gold.fato_vendas
if object_id('gold.fato_vendas', 'V') is not null
	drop view gold.fato_vendas;
go


create view gold.fato_vendas as
select 
	sd.sls_ord_num as numero_pedido,
	pr.chave_produto,
	cl.chave_cliente,
    sd.sls_order_dt as data_pedido,
    sd.sls_ship_dt as data_envio,
    sd.sls_due_dt as data_vencimento,
    sd.sls_sales as valor_vendas,
    sd.sls_quantity as quantidade,
    sd.sls_price as preco
from silver.crm_sales_details sd
left join gold.dim_produtos pr
on sd.sls_prd_key = pr.numero_produto
left join gold.dim_clientes cl
on sd.sls_cust_id = cl.cliente_id

go
