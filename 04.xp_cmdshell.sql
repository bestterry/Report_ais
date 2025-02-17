DECLARE @fileName VARCHAR(MAX);
DECLARE @path VARCHAR(MAX);
DECLARE @SQL VARCHAR(8000);
DECLARE @command_string VARCHAR(8000);
DECLARE @query NVARCHAR(MAX);
DECLARE @FirstDate date = DATEADD(DAY, 1, EOMONTH(GETDATE(), -1))
DECLARE @Today date = GETDATE()

    -- Define Query (Ensure proper syntax for bcp)
    IF (@FirstDate = @Today)
	    BEGIN
            SET @query = 'SELECT ''Published Date/Time'' AS PublishedOnUTC, ''Local Published Date/Time'' AS PublishedOnUTC, ''.ID'' AS DisplayId, ''Agent'' AS Agent, ''Agent ID'' AS AgentID, ''Evaluation'' AS FirstName, ''Category'' AS TemplateCategoryName, ''Question'' AS TemplateQuestionContent, ''Answer'' AS EvaluatorsAnswer, ''Point Earned'' AS CurrentAnswerScoredPoints ' + 
				'UNION ALL SELECT CAST([a11].[PublishedOnUTC] AS VARCHAR),CAST(DATEADD(HOUR,7,[a11].[PublishedOnUTC]) AS VARCHAR),CAST([a11].[DisplayId] AS VARCHAR),[a12].[Agent],CAST([a11].[AgentID] AS VARCHAR),CONCAT([a16].[LastName], [a16].[FirstName]),REPLACE([a14].[TemplateCategoryName], '','', ''''),REPLACE([a15].[TemplateQuestionContent], '','', ''''),CAST([a11].[EvaluatorsAnswer] AS NVARCHAR),CAST([a11].[CurrentAnswerScoredPoints] AS VARCHAR) '+ 
				'FROM [NexidiaESIDW].[Dossier].[fctEvaluationQuestionCurrentAnswer] [a11] JOIN [NexidiaESIDW].[Evals].[EvaluationOrganization] [a12] ON [a11].[EvaluationKey] = [a12].[EvaluationKey] JOIN [NexidiaESIDW].[Evals].[dimTemplateCategory] [a14] ON [a11].[TemplateCategoryKey] = [a14].[TemplateCategoryKey] JOIN [NexidiaESIDW].[Evals].[dimTemplateQuestion] [a15] ON [a11].[TemplateQuestionKey] = [a15].[TemplateQuestionKey] JOIN [NexidiaESIDW].[Evals].[dimUser] [a16] ON [a11].[CreatedByUserID] = [a16].[UserID] ' +
				'WHERE (convert(date,[a11].[PublishedOnUTC]) BETWEEN DATEADD(MONTH, -1, DATEADD(DAY, 1, EOMONTH(GETDATE(), -1))) AND EOMONTH(GETDATE(), -1)) '+
                'AND [a11].[TemplateKey] in (124) ' + 
				'AND [a11].[IgnoredForAgentReporting] = 0 AND convert(date,[a11].[PublishedOnUTC]) is not null AND [a11].[RescoreIsActive] = 0 AND CASE WHEN ([a11].[AcknowledgedOnUTC] Is Null) then 0 else 1 end in (1, 0)  AND [a11].[IsPurgedInEvals] in (0) AND [a11].[EvaluationType] not in (N''C-'') AND [a11].[EvaluationType] in (N''S-'', N''E-'')'+
				'ORDER BY DisplayId ASC';
        END
    ELSE
        BEGIN
            SET @query = 'SELECT ''Published Date/Time'' AS PublishedOnUTC, ''Local Published Date/Time'' AS PublishedOnUTC, ''.ID'' AS DisplayId, ''Agent'' AS Agent, ''Agent ID'' AS AgentID, ''Evaluation'' AS FirstName, ''Category'' AS TemplateCategoryName, ''Question'' AS TemplateQuestionContent, ''Answer'' AS EvaluatorsAnswer, ''Point Earned'' AS CurrentAnswerScoredPoints ' + 
				'UNION ALL SELECT CAST([a11].[PublishedOnUTC] AS VARCHAR),CAST(DATEADD(HOUR,7,[a11].[PublishedOnUTC]) AS VARCHAR),CAST([a11].[DisplayId] AS VARCHAR),[a12].[Agent],CAST([a11].[AgentID] AS VARCHAR),CONCAT([a16].[LastName], [a16].[FirstName]),REPLACE([a14].[TemplateCategoryName], '','', ''''),REPLACE([a15].[TemplateQuestionContent], '','', ''''),CAST([a11].[EvaluatorsAnswer] AS NVARCHAR),CAST([a11].[CurrentAnswerScoredPoints] AS VARCHAR) '+ 
				'FROM [NexidiaESIDW].[Dossier].[fctEvaluationQuestionCurrentAnswer] [a11] JOIN [NexidiaESIDW].[Evals].[EvaluationOrganization] [a12] ON [a11].[EvaluationKey] = [a12].[EvaluationKey] JOIN [NexidiaESIDW].[Evals].[dimTemplateCategory] [a14] ON [a11].[TemplateCategoryKey] = [a14].[TemplateCategoryKey] JOIN [NexidiaESIDW].[Evals].[dimTemplateQuestion] [a15] ON [a11].[TemplateQuestionKey] = [a15].[TemplateQuestionKey] JOIN [NexidiaESIDW].[Evals].[dimUser] [a16] ON [a11].[CreatedByUserID] = [a16].[UserID] ' +
				'WHERE (convert(date,[a11].[PublishedOnUTC]) BETWEEN DATEADD(DAY, 1, EOMONTH(GETDATE(), -1)) AND DATEADD(DAY, -1, CAST(GETDATE() AS DATE))) ' + 
                'AND [a11].[TemplateKey] in (124) ' + 
				'AND [a11].[IgnoredForAgentReporting] = 0 AND convert(date,[a11].[PublishedOnUTC]) is not null AND [a11].[RescoreIsActive] = 0 AND CASE WHEN ([a11].[AcknowledgedOnUTC] Is Null) then 0 else 1 end in (1, 0)  AND [a11].[IsPurgedInEvals] in (0) AND [a11].[EvaluationType] not in (N''C-'') AND [a11].[EvaluationType] in (N''S-'', N''E-'')'+
				'ORDER BY DisplayId ASC';
        END


    -- Set the filename with today's date
    SET @fileName = '04.Evaluation_Detail_ByQuestion_Tele_Collection_Form_'+FORMAT(DATEADD(DAY, -1, GETDATE()), 'ddMMyyyy')+'.csv';

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