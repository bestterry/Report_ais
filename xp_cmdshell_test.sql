DECLARE @fileName VARCHAR(MAX);
DECLARE @path VARCHAR(MAX);
DECLARE @SQL VARCHAR(8000);
DECLARE @command_string VARCHAR(8000);
DECLARE @query NVARCHAR(MAX);
DECLARE @FirstDate date = DATEADD(DAY, 1, EOMONTH(GETDATE(), -1));
DECLARE @Today date = GETDATE();

	IF (@FirstDate = @Today)
		BEGIN
		   SET @query = 'SELECT pd_num.id, pd_num.st_id, pd_num.pd_id, pd_num.num, pd_num.datetime, stock.st_name FROM demo.dbo.pd_num ' + 
						'JOIN demo.dbo.stock ON pd_num.st_id = stock.st_id';
		END
	ELSE
		BEGIN
		   SET @query = 'SELECT pd_num.id, pd_num.st_id, pd_num.pd_id, pd_num.num, pd_num.datetime, stock.st_name FROM demo.dbo.pd_num ' + 
						'JOIN demo.dbo.stock ON pd_num.st_id = stock.st_id';
		END

		-- Set the filename with today's date
        SET @fileName = '01.ScoreByAgent_'+FORMAT(DATEADD(DAY, -1, GETDATE()), 'ddMMyyyy')+'.csv';

        -- Set the file path
        SET @path = 'D:\test\' + @fileName;

        -- Construct the BCP command
        SET @SQL = 'bcp "'
                + @query
                + '" queryout "'
                + @path
                + '" -c -t, -C 65001 -T -S BEST\SQLDEV';

        -- Execute the command
        SET @command_string = CAST(@SQL AS VARCHAR(MAX));
        EXEC xp_cmdshell @command_string;

		SET @SQL = 'powershell -Command "[System.IO.File]::WriteAllBytes(''' + @path + ''', [System.Text.Encoding]::UTF8.GetPreamble() + [System.IO.File]::ReadAllBytes(''' + @path + '''))"';
		EXEC xp_cmdshell @SQL;