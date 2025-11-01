create or alter procedure silver.load_data as
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
	
	end try
	begin catch
		print 'Erro ao carregar os dados da camada Bronze';
		print 'Mensagem de erro' + error_message();
		print 'Mensagem de erro' + cast (error_number() as nvarchar);
		print 'Mensagem de erro' + cast (error_state() as nvarchar);
	end catch
end
