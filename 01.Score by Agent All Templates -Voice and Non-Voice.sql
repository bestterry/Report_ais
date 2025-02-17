DECLARE @fileName VARCHAR(MAX);
DECLARE @path VARCHAR(MAX);
DECLARE @SQL VARCHAR(8000);
DECLARE @command_string VARCHAR(8000);
DECLARE @query NVARCHAR(MAX);
DECLARE @FirstDate date = DATEADD(DAY, 1, EOMONTH(GETDATE(), -1))
DECLARE @Today date = GETDATE()

	IF (@FirstDate = @Today)
	    BEGIN
			SET @query = 'SELECT ''ID'' AS DisplayId, ''Published Date/Time'' AS PublishedOnUTC, ''Local Published Date Time'' AS LocalPublishedOnUTC, ' +
						'''ACCS_Group'' AS GroupName, ''ACCS_TEAM'' AS UDFVarchar30, ''Agent'' AS Agent, ''Agent ID'' AS AgentID, ''AGENT_PINCODE'' AS UDFVarchar92, '+ 
						'''Evaluator'' AS FirstName, ''CBP_GROUP'' AS UDFVarchar31, ''CBP_POSITION'' AS UDFVarchar33 ,' +
						'''CBP_TEAM'' AS UDFVarchar32, ''SUPERVISOR_NAME_ENG'' AS SupervisorName, ''Participant PhoneNumber'' AS UDFVarchar15, '+ 
						'''MANAGER_PINCODE'' AS UDFVarchar8, ''MANAGER_NAME_ENG'' AS UDFVarchar29, ''User LoginName'' AS UDFVarchar21, CAST(''User Hire Date'' AS VARCHAR(50)) AS UDFdate1, '+ 
						'''Edited'' AS ModifiedDateUTC, ''Template'' AS TemplateName, ''Time'' AS Time, ''Score'' AS InitialScoredPoints ' + 
						'UNION ALL SELECT CAST([a11].[DisplayId] AS VARCHAR),CAST([a11].[PublishedOnUTC] AS VARCHAR),CAST(DATEADD(HOUR,7,[a11].[PublishedOnUTC]) AS VARCHAR), ' + 
							'[a12].[GroupName], ISNULL([a18].[UDFVarchar30], ''''),[a12].[Agent],[a11].[AgentID],CONCAT(CHAR(39),[a18].[UDFVarchar92]), ' + 
							'CONCAT(REPLACE([a14].[LastName], '','', ''''), ''_ '', REPLACE([a14].[FirstName], '','', '''')), ISNULL([a18].[UDFVarchar31], ''''),ISNULL([a18].[UDFVarchar33], ''''), ' + 
							'ISNULL([a18].[UDFVarchar32], ''''),[a11].[SupervisorName],ISNULL([a18].[UDFVarchar15], ''''), ' +  
							'CONCAT(CHAR(39),[a18].[UDFVarchar8]),ISNULL([a18].[UDFVarchar29], ''''),ISNULL([a18].[UDFVarchar21], ''''), CONVERT(VARCHAR(10), TRY_CONVERT(DATE, CAST([a18].[UDFdate1] AS VARCHAR(8)), 112), 120), ' + 
							'CASE WHEN [a11].[CreationDateUTC]=[a11].[ModifiedDateUTC] THEN ''No'' ELSE ''Yes'' END AS ''Edited'', ' + 
							'[a17].[TemplateName], ''1'' AS Time, CAST([a11].[InitialScoredPoints] AS VARCHAR) ' + 
						'FROM [NexidiaESIDW].[Dossier].[vfctEvaluation] [a11] ' + 
						'JOIN [NexidiaESIDW].[Evals].[EvaluationOrganization] [a12] ON ([a11].[EvaluationKey] = [a12].[EvaluationKey]) ' + 
						'JOIN [NexidiaESIDW].[Dossier].[vAgent] [a13] ON ([a11].[AgentKey] = [a13].[LegacyCCAgentKey]) ' + 
						'JOIN [NexidiaESIDW].[Evals].[dimUser] [a14] ON ([a11].[CreatedByUserID] = [a14].[UserID]) ' + 
						'JOIN [NexidiaESIDW].[Evals].[dimUser] [a16] ON ([a11].[CreatedByUserID] = [a16].[UserID]) ' + 
						'JOIN [NexidiaESIDW].[Evals].[dimTemplate] [a17] ON ([a11].[TemplateKey] = [a17].[TemplateKey]) ' + 
						'JOIN [NexidiaESIDW].[dim].[dimMediaUDF] [a18] ON ([a11].[PrimaryMediaKey] = [a18].[MediaUDFKey]) ' + 
						'WHERE ([a11].[TemplateKey] IN (123, 120, 124, 218, 197, 229, 230) ' + 
						'AND CONVERT(DATE, [a11].[PublishedOnUTC]) IS NOT NULL ' + 
						'AND (CONVERT(DATE, [a11].[PublishedOnUTC]) BETWEEN DATEADD(MONTH, -1, DATEADD(DAY, 1, EOMONTH(GETDATE(), -1))) AND EOMONTH(GETDATE(), -1)) ' + 
						'AND [a11].[RescoreIsActive] = 0 AND [a11].[IsPurgedInEvals] IN (0) AND [a11].[EvaluationType] IN (''S-'', ''E-'')) ' + 
						'ORDER BY DisplayId DESC'
		END
    ELSE
        BEGIN
			SET @query = 'SELECT ''ID'' AS DisplayId, ''Published Date/Time'' AS PublishedOnUTC, ''Local Published Date Time'' AS LocalPublishedOnUTC, ' +
						'''ACCS_Group'' AS GroupName, ''ACCS_TEAM'' AS UDFVarchar30, ''Agent'' AS Agent, ''Agent ID'' AS AgentID, ''AGENT_PINCODE'' AS UDFVarchar92, '+ 
						'''Evaluator'' AS FirstName, ''CBP_GROUP'' AS UDFVarchar31, ''CBP_POSITION'' AS UDFVarchar33 ,' +
						'''CBP_TEAM'' AS UDFVarchar32, ''SUPERVISOR_NAME_ENG'' AS SupervisorName, ''Participant PhoneNumber'' AS UDFVarchar15, '+ 
						'''MANAGER_PINCODE'' AS UDFVarchar8, ''MANAGER_NAME_ENG'' AS UDFVarchar29, ''User LoginName'' AS UDFVarchar21, CAST(''User Hire Date'' AS VARCHAR(50)) AS UDFdate1, '+ 
						'''Edited'' AS ModifiedDateUTC, ''Template'' AS TemplateName, ''Time'' AS Time, ''Score'' AS InitialScoredPoints ' + 
						'UNION ALL SELECT CAST([a11].[DisplayId] AS VARCHAR),CAST([a11].[PublishedOnUTC] AS VARCHAR),CAST(DATEADD(HOUR,7,[a11].[PublishedOnUTC]) AS VARCHAR), ' + 
							'[a12].[GroupName], ISNULL([a18].[UDFVarchar30], ''''),[a12].[Agent],[a11].[AgentID],CONCAT(CHAR(39),[a18].[UDFVarchar92]), ' + 
							'CONCAT([a14].[LastName], ''_ '', [a14].[FirstName]), ISNULL([a18].[UDFVarchar31], ''''),ISNULL([a18].[UDFVarchar33], ''''), ' + 
							'ISNULL([a18].[UDFVarchar32], ''''),[a11].[SupervisorName],ISNULL([a18].[UDFVarchar15], ''''), ' +  
							'CONCAT(CHAR(39),[a18].[UDFVarchar8]),ISNULL([a18].[UDFVarchar29], ''''),ISNULL([a18].[UDFVarchar21], ''''), CONVERT(VARCHAR(10), TRY_CONVERT(DATE, CAST([a18].[UDFdate1] AS VARCHAR(8)), 112), 120), ' + 
							'CASE WHEN [a11].[CreationDateUTC]=[a11].[ModifiedDateUTC] THEN ''No'' ELSE ''Yes'' END AS ''Edited'', ' + 
							'[a17].[TemplateName], ''1'' AS Time, CAST([a11].[InitialScoredPoints] AS VARCHAR) ' + 
						'FROM [NexidiaESIDW].[Dossier].[vfctEvaluation] [a11] ' + 
						'JOIN [NexidiaESIDW].[Evals].[EvaluationOrganization] [a12] ON ([a11].[EvaluationKey] = [a12].[EvaluationKey]) ' + 
						'JOIN [NexidiaESIDW].[Dossier].[vAgent] [a13] ON ([a11].[AgentKey] = [a13].[LegacyCCAgentKey]) ' + 
						'JOIN [NexidiaESIDW].[Evals].[dimUser] [a14] ON ([a11].[CreatedByUserID] = [a14].[UserID]) ' + 
						'JOIN [NexidiaESIDW].[Evals].[dimUser] [a16] ON ([a11].[CreatedByUserID] = [a16].[UserID]) ' + 
						'JOIN [NexidiaESIDW].[Evals].[dimTemplate] [a17] ON ([a11].[TemplateKey] = [a17].[TemplateKey]) ' + 
						'JOIN [NexidiaESIDW].[dim].[dimMediaUDF] [a18] ON ([a11].[PrimaryMediaKey] = [a18].[MediaUDFKey]) ' + 
						'WHERE ([a11].[TemplateKey] IN (123, 120, 124, 218, 197, 229, 230) ' + 
						'AND CONVERT(DATE, [a11].[PublishedOnUTC]) IS NOT NULL ' + 
						'AND (convert(date,[a11].[PublishedOnUTC]) BETWEEN DATEADD(DAY, 1, EOMONTH(GETDATE(), -1)) AND DATEADD(DAY, -1, CAST(GETDATE() AS DATE))) ' + 
						'AND [a11].[RescoreIsActive] = 0 AND [a11].[IsPurgedInEvals] IN (0) AND [a11].[EvaluationType] IN (''S-'', ''E-'')) ' + 
						'ORDER BY DisplayId DESC'
		END

		EXEC sp_executesql @query;

	-- Set the filename with today's date
		SET @fileName = '01.ScoreByAgent_All_Templates_Voice&NonVoice_'+FORMAT(DATEADD(DAY, -1, GETDATE()), 'ddMMyyyy')+'.CSV';

		-- Set the file path
		SET @path = 'E:\Question_Report\' + @fileName;

		-- Construct the BCP command
		SET @SQL = 'bcp "'
				+ @query
				+ '" queryout "'
				+ @path
				+ '" -c -t, -C 65001 -T -S PNXDIAD901G\NIAIADB';

		-- Execute the command
		SET @command_string = CAST(@SQL AS VARCHAR(MAX));
		EXEC xp_cmdshell @command_string;

		SET @SQL = 'powershell -Command "[System.IO.File]::WriteAllBytes(''' + @path + ''', [System.Text.Encoding]::UTF8.GetPreamble() + [System.IO.File]::ReadAllBytes(''' + @path + '''))"';
		EXEC xp_cmdshell @SQL;

