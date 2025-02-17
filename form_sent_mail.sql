DECLARE @fileName VARCHAR(200)
DECLARE @sql VARCHAR(8000)
DECLARE @Today date = GETDATE()
DECLARE @BFirstDate date = DATEADD(MONTH, -1, DATEADD(DAY, 1, EOMONTH(GETDATE(), -1)))
DECLARE @BLastDate date = EOMONTH(GETDATE(), -1)
DECLARE @FirstDate date = DATEADD(DAY, 1, EOMONTH(GETDATE(), -1))
DECLARE @LastDate date =  CONVERT (date,  GETDATE())

	SET @fileName = 'MyData_'+ CONVERT(VARCHAR, GETDATE(), 112)+'.csv'

	IF (@FirstDate = @Today)
	BEGIN
		SET @sql = 'SELECT * FROM demo.dbo.pd_num 
			WHERE datetime BETWEEN DATEADD(MONTH, -1, DATEADD(DAY, 1, EOMONTH(GETDATE(), -1))) AND EOMONTH(GETDATE(), -1)'
	END
	ELSE
	BEGIN
		SET @sql = 'SELECT * FROM demo.dbo.pd_num 
			WHERE datetime BETWEEN DATEADD(DAY, 1, EOMONTH(GETDATE(), -1)) AND CONVERT (date,  GETDATE())'
	END

	EXEC msdb.dbo.sp_send_dbmail  
	@profile_name = 'ABC',
	@recipients = 'Mail.com',
	@subject = 'รายงานข้อมูล',
	@body = 'โปรดดูข้อมูลในไฟล์แนบ',
	@query = @sql,
	@attach_query_result_as_file = 1,
	@query_attachment_filename = @fileName,
	@query_result_separator = ',',
	@query_result_no_padding = 1,
	@query_result_header = 1;