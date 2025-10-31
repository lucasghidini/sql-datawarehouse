/*
	Carregamento dos dados da fonte para a camada Bronze
	-----------------------------------------
	Esse script cria o procedimento na camada bronze chamado:
	bronze.load_data
	-----------------------------------------
	As tabelas são truncadas, antes de serem carregadas, para evitar duplicidade.
	Foi usado o metodo 'bulk insert' para o carregamento

	-----------------------------------------
	Para execultar:
		exec bronze.load_data;
*/

create or alter procedure bronze.load_data as


begin
	declare @start_time datetime, @end_time datetime, @comeco_time datetime, @final_time datetime;
	set @comeco_time = getdate();
	begin try
		
		print '===================';
		print 'Carregando a camada Bronze';
		print '===================';

		print '------------------';
		print 'Carregando as tabelas CRM';
		print '------------------';

		set @start_time = GETDATE();
		print '>>Truncate bronze.crm_cust_info';
		truncate table bronze.crm_cust_info;
		print '>>Carregando a tabela cust_info.csv';
		bulk insert bronze.crm_cust_info
		from 'C:\Users\GhidiniLucas\Desktop\source_crm\cust_info.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = getdate();
		print '>>Duração do carregamento: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'segundos';
		print '-----------'
	

		-------------
		set @start_time = GETDATE();
		print '>>Truncate bronze.crm_prd_info';
		truncate table bronze.crm_prd_info;
		print '>>Carregando a tabela crm_prd_info.csv';
		bulk insert bronze.crm_prd_info
		from 'C:\Users\GhidiniLucas\Desktop\source_crm\prd_info.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = getdate();
		print '>>Duração do carregamento: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'segundos';
		print '-----------';

		-------------
		set @start_time = GETDATE();
		print '>>Truncate bronze.crm_sales_details';
		truncate table bronze.crm_sales_details;
		print '>>Carregando a tabela sales_details.csv';
		bulk insert bronze.crm_sales_details
		from 'C:\Users\GhidiniLucas\Desktop\source_crm\sales_details.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = getdate();
		print '>>Duração do carregamento: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'segundos';
		print '-----------';

		print '--------------------'
		print 'Carregando as tabelas ERP'
		print '--------------------'

		-------------
		set @start_time = GETDATE();
		print '>>Truncate bronze.erp_cust_az12'
		truncate table bronze.erp_cust_az12;
		print '>>Carregando a tabela cust_az12.csv'
		bulk insert bronze.erp_cust_az12
		from 'C:\Users\GhidiniLucas\Desktop\source_erp\CUST_AZ12.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = getdate();
		print '>>Duração do carregamento: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'segundos';
		print '-----------';

		-------------
		set @start_time = GETDATE();
		print '>>Truncate bronze.erp_loc_a101'
		truncate table bronze.erp_loc_a101;
		print '>>Carregando a tabela loc_a101.csv'
		bulk insert bronze.erp_loc_a101
		from 'C:\Users\GhidiniLucas\Desktop\source_erp\LOC_A101.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = getdate();
		print '>>Duração do carregamento: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'segundos';
		print '-----------';

		-------------
		set @start_time = GETDATE();
		print '>>Truncate bronze.erp_px_cat_g1v2'
		truncate table bronze.erp_px_cat_g1v2;
		print '>>Carregando a tabela px_cat_g1v2.csv'
		bulk insert bronze.erp_px_cat_g1v2
		from 'C:\Users\GhidiniLucas\Desktop\source_erp\PX_CAT_G1V2.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = getdate();
		print '>>Duração do carregamento: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'segundos';
		print '-----------';
		
		set @final_time = getdate();
		print 'Duração total do carregamento de dados da camada Bronze: ' + cast(datediff(second, @comeco_time, @final_time) as nvarchar) + 'segundos'
	end try
	
	begin catch
		print '=========================='
		print 'ERRO AO CARREGAR OS DADOS'
		print 'Mensagem de erro' + error_message();
		print 'Mensagem de erro' + cast(error_number() as nvarchar);
		print 'Mensagem de erro' + cast(error_state() as nvarchar);
		print '=========================='
	end catch
end
