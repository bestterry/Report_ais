        DECLARE @query NVARCHAR(MAX);
        SET @query = 'WITH ResultSet AS ( ' + 
                    'SELECT ' + 
                    '''Published Date/Time'' AS PublishedOnUTC, ''Local Published Date/Time'' AS PublishedOnLocal, ''.ID'' AS DisplayId,' + 
                    '''Agent'' AS Agent, ''Agent ID'' AS AgentID, ''Evaluation'' AS FirstName, ''Category'' AS TemplateCategoryName, ''Question'' AS TemplateQuestionContent,' + 
                    '''Answer'' AS EvaluatorsAnswer, ''Point Earned'' AS CurrentAnswerScoredPoints ' + 
                    'UNION ALL ' + 
                    'SELECT ' + 
                    'CAST([a11].[PublishedOnUTC] AS VARCHAR) AS PublishedOnUTC, CAST(DATEADD(HOUR,7,[a11].[PublishedOnUTC]) AS VARCHAR) AS PublishedOnLocal,' + 
                    'CAST([a11].[DisplayId] AS VARCHAR), [a12].[Agent], CAST([a11].[AgentID] AS VARCHAR), CONCAT([a16].[LastName], [a16].[FirstName]),' + 
                    'REPLACE([a14].[TemplateCategoryName], '','', ''''), REPLACE([a15].[TemplateQuestionContent], '','', ''''), [a11].[EvaluatorsAnswer], CAST([a11].[CurrentAnswerScoredPoints] AS VARCHAR) ' + 
                    'FROM [NexidiaESIDW].[Dossier].[fctEvaluationQuestionCurrentAnswer] [a11] JOIN [NexidiaESIDW].[Evals].[EvaluationOrganization] [a12] ON [a11].[EvaluationKey] = [a12].[EvaluationKey] ' + 
                    'JOIN [NexidiaESIDW].[Evals].[dimTemplateCategory] [a14] ON [a11].[TemplateCategoryKey] = [a14].[TemplateCategoryKey] ' + 
                    'JOIN [NexidiaESIDW].[Evals].[dimTemplateQuestion] [a15] ON [a11].[TemplateQuestionKey] = [a15].[TemplateQuestionKey] ' + 
                    'JOIN [NexidiaESIDW].[Evals].[dimUser] [a16] ON [a11].[CreatedByUserID] = [a16].[UserID] ' + 
                    'WHERE ' + 
                    '(CONVERT(DATE,[a11].[PublishedOnUTC]) BETWEEN DATEADD(MONTH, -1, DATEADD(DAY, 1, EOMONTH(GETDATE(), -1))) AND EOMONTH(GETDATE(), -1)) ' + 
                    'AND [a11].[TemplateKey] IN (218) ' + 
                    'AND [a11].[IgnoredForAgentReporting] = 0  ' + 
                    'AND CONVERT(DATE,[a11].[PublishedOnUTC]) IS NOT NULL ' + 
                    'AND [a11].[RescoreIsActive] = 0 ' + 
                    'AND CASE WHEN ([a11].[AcknowledgedOnUTC] IS NULL) THEN 0 ELSE 1 END IN (1, 0) ' + 
                    'AND [a11].[IsPurgedInEvals] IN (0) ' + 
                    'AND [a11].[EvaluationType] NOT IN (N''C-'') ' + 
                    'AND [a11].[EvaluationType] IN (N''S-'', N''E-'') ' + 
                    ') ' + 
                    'SELECT * FROM ResultSet ' + 
                    'ORDER BY DisplayId ASC, TemplateCategoryName ASC,  ' + 
                    'CASE  ' + 
                    'WHEN TemplateQuestionContent = ''Question'' THEN 0 ' + 
                    'ELSE CAST(SUBSTRING(TemplateQuestionContent, 1, PATINDEX(''%[^0-9]%'', TemplateQuestionContent + ''a'') - 1) AS INT) ' + 
                    'END ASC ';

        EXEC sp_executesql @query;
    