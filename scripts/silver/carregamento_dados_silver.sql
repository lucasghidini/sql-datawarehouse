CREATE OR ALTER PROCEDURE silver.load_silver AS

begin
	declare @start_time datetime, @end_time datetime, @comeco_time datetime, @final_time datetime;
	begin try
	set @comeco_time = getdate();
	print'======================';
	print'Carregando a camada Silver';
	print'======================';

	print'----------------------';
	print'Carregando as tabelas crm';
	print'----------------------';


	-- carregando a tabela crm_cust_info
	set @start_time = getdate()
	print 'Truncate a tabela silver.crm_cust_info';
	truncate table silver.crm_cust_info;
	print 'Inserindo dados na: silver.crm_cust_info';
	insert into silver.crm_cust_info(
		cst_id,
		cst_key,
		cst_fistname,
		cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_create_date
	)
	select 
	cst_id,
	cst_key,
	trim(cst_fistname) as cst_firstname,
	trim(cst_lastname) as cst_lastname,
	case
		when upper (trim(cst_marital_status)) = 'S' then 'Solteiro'
		when upper (trim(cst_marital_status)) = 'M' then 'Casado'
		else 'n/a'
	end as cst_marital_status,
	case
		when upper (trim(cst_gndr)) = 'M' then 'Homem'
		when upper (trim(cst_gndr)) = 'F' then 'Mulher'
		else 'n/a'
	end as cst_gndr,
	cst_create_date
	from(
		select
		*,
		row_number () over (partition by cst_id order by cst_create_date desc) as flag_last
		from bronze.crm_cust_info
		where cst_id is not null
	)t where flag_last = 1;
	set @end_time = getdate();
	print '>>Tempo de carregamento: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'segundos';
	print '>>-------------------';
	
	-- carregando a tabela crm_prd_info
	set @start_time = getdate()
	print 'Truncate a tabela silver.crm_prd_info'
	truncate table silver.crm_prd_info;
	print 'Inserindo dados na: silver.crm_prd_info'
	insert into silver.crm_prd_info(
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
	)
	select
		prd_id,
		replace(substring(prd_key, 1, 5), '-', '_') as cat_id, -- extraindo a categoria id
		substring(prd_key, 7, len(prd_key)) as prd_key,
		prd_nm,
		isnull(prd_cost, 0) as prd_cost,
		case
			when upper(trim(prd_line)) = 'M' then 'Montanha'
			when upper(trim(prd_line)) = 'R' then 'Rodovia'
			when upper(trim(prd_line)) = 'S' then 'Outros vendedores'
			when upper(trim(prd_line)) = 'T' then 'Passeio'
			else 'n/a'
		end as prd_line,
		cast(prd_start_dt as date) as prd_start_dt,
		cast(
			dateadd(day, -1, lead(prd_start_dt) over (partition by prd_key order by prd_start_dt))
			as date
			) as prd_end_dt
	from bronze.crm_prd_info;
	set @end_time = getdate()
	print '>>Tempo de carregamento: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'segundos';
	print '>>-------------------';

	-- carregando a tabela crm_sales_details
	set @start_time = getdate();
	print 'Truncate a tabela silver.crm_sales_details';
	truncate table silver.crm_sales_details;
	print 'Inserindo dados na: silver.crm_sales_details';
	insert into silver.crm_sales_details (
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
	)
	select
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	case
		when sls_order_dt = 0 or len(sls_order_dt) != 8 then null
		else cast(cast(sls_order_dt as varchar)as date)
		end as sls_order_dt,
	case
		when sls_ship_dt = 0 or len(sls_ship_dt) != 8 then null
		else cast(cast(sls_ship_dt as varchar)as date)
		end as sls_ship_dt,
	case
		when sls_due_dt = 0 or len(sls_due_dt) != 8 then null
		else cast(cast(sls_due_dt as varchar) as date)
	end as sls_due_dt,
	case
		when sls_sales is null or sls_sales <=0 or sls_sales != sls_quantity * abs(sls_price)
		then sls_quantity * abs(sls_price)
		else sls_sales
	end as sls_sales,
	sls_quantity,
	case
		when sls_price is null or sls_price <= 0
		then sls_sales / nullif(sls_quantity, 0)
		else sls_price
	end as sls_price
	from bronze.crm_sales_details;
	set @end_time = getdate();
	print '>>Tempo de carregamento: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'segundos';
	print '>>-------------------';

	
	print'Carregando as tabelas erp';
	print'----------------------';


	-- carregando a tabela erp_cust_az12
	set @start_time = getdate();
	print 'Truncate a tabela silver.erp_cust_az12';
	truncate table silver.erp_cust_az12;
	print 'Inserindo dados na: silver.erp_cust_az12';
	insert into silver.erp_cust_az12(
	cid,
	bdate,
	gen
	)
	select
	case
		when cid like 'NAS%' then substring(cid, 4, len(cid))
		else cid
	end as cid,
	case
		when bdate > getdate() then null
		else bdate
	end as bdate,
	case
		when upper(trim(gen)) in ('F', 'FEMALE') then 'Mulher'
		when upper(trim(gen)) in ('M', 'MALE') then 'Homen'
		else 'N/A'
	end as gen
	from bronze.erp_cust_az12;
	set @end_time = getdate();
	print '>>Tempo de carregamento: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'segundos';
	print '>>-------------------';
	
	
	end try
	begin catch
		print 'Erro ao carregar os dados da camada Bronze';
		print 'Mensagem de erro' + error_message();
		print 'Mensagem de erro' + cast (error_number() as nvarchar);
		print 'Mensagem de erro' + cast (error_state() as nvarchar);
	end catch
end
