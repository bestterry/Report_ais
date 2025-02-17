	DECLARE @query NVARCHAR(MAX);

	SET @sql = 'SELECT ''.ID'' AS DisplayId, ''Published Date/Time'' AS PublishedOnUTC, ''Local Published Date Time'' AS LocalPublishedOnUTC,' + 
		'''Primary Media File'' AS FileName, ''ACCS_Group'' AS GroupName, ''ACCS_TEAM'' AS UDFVarchar30, ''Agent'' AS Agent, ''Agent ID'' AS AgentID, ' + 
		'''Evaluator'' AS FirstName, ''Template'' AS TemplateName,''AGENT_PINCODE'' AS UDFVarchar92, ''CBP_GROUP'' AS UDFVarchar31, ' + 
		'''CBP_POSITION'' AS UDFVarchar33 ,''CBP_TEAM'' AS UDFVarchar32, ''Participant PhoneNumber'' AS UDFVarchar15, ''User Department'' AS UDFvarchar25,' + 
		'''Participant Agent Name'' AS UDFvarchar27,''SUPERVISOR_NAME_ENG'' AS SupervisorName, ''User LoginName'' AS UDFVarchar21,CAST(''User Hire Date'' AS VARCHAR(50)) AS UDFdate1,' + 
		'''Interaction Date'' AS RecordedDate, ''Edited'' AS ModifiedDateUTC, ''Time'' AS timevalue, ''Score'' AS InitialScoredPoints ' + 
	'UNION ALL SELECT CAST([a11].[DisplayId] AS VARCHAR),CAST([a11].[PublishedOnUTC] AS VARCHAR),CAST(DATEADD(HOUR,7,[a11].[PublishedOnUTC]) AS VARCHAR), ' + 
		'ISNULL([a19].[FileName], ''''), ISNULL([a12].[GroupName], ''''), ISNULL([a18].[UDFVarchar30], ''''),[a12].[Agent],[a11].[AgentID], ' + 
		'CONCAT(REPLACE([a14].[LastName], '','', ''''), ''. '', REPLACE([a14].[FirstName], '','', '''')), CONCAT([a17].[TemplateName],'' v'',[a17].[TemplateVersion]),' + 
		'ISNULL([a18].[UDFVarchar92], ''''),' + 
		'ISNULL([a18].[UDFVarchar31], ''''),ISNULL([a18].[UDFVarchar33], ''''), ' + 
		'ISNULL([a18].[UDFVarchar32], ''''),ISNULL([a18].[UDFVarchar15], ''''),ISNULL([a18].[UDFvarchar25], ''''), ISNULL([a18].[UDFvarchar27], ''''), ' + 
		'[a11].[SupervisorName], ISNULL([a18].[UDFVarchar21], ''''), CONVERT(VARCHAR(10), TRY_CONVERT(DATE, CAST([a18].[UDFdate1] AS VARCHAR(8)), 112), 120), ' + 
		'CAST(FORMAT([a19].[RecordedDate], ''MM/dd/yyyy'') AS VARCHAR),' + 
		'CASE WHEN [a11].[CreationDateUTC]=[a11].[ModifiedDateUTC] THEN ''No'' ELSE ''Yes'' END AS ''Edited'', ' + 
		'''1'' AS timevalue, CAST([a11].[InitialScoredPoints] AS VARCHAR) ' + 
	'FROM [NexidiaESIDW].[Dossier].[vfctEvaluation] [a11] ' + 
	'JOIN [NexidiaESIDW].[Evals].[EvaluationOrganization] [a12] ON ([a11].[EvaluationKey] = [a12].[EvaluationKey]) ' + 
	'JOIN [NexidiaESIDW].[Evals].[dimUser] [a14] ON ([a11].[CreatedByUserID] = [a14].[UserID])' + 
	'JOIN [NexidiaESIDW].[Evals].[dimTemplate] [a17] ON ([a11].[TemplateKey] = [a17].[TemplateKey]) ' + 
	'JOIN [NexidiaESIDW].[dim].[dimMediaUDF] [a18] ON ([a11].[PrimaryMediaKey] = [a18].[MediaUDFKey]) ' + 
	'JOIN [Dossier].[vMediaFileName]	[a19] ON ([a11].[PrimaryMediaKey] = [a19].[PrimaryMediaKey]) ' + 
	'where ([a11].[TemplateKey] in (123, 120, 124, 218, 197, 229, 230)' + 
	'and convert(date,[a11].[PublishedOnUTC]) is not null' + 
	'and convert(date,[a11].[PublishedOnUTC]) between ''20250101'' and ''20250101''' + 
	'and [a11].[RescoreIsActive] = 0' + 
	'and Case when ([a11].[AcknowledgedOnUTC] Is Null) then 0 else 1 end in (1, 0)' + 
	'and [a11].[IsPurgedInEvals] in (0)' + 
	'and [a11].[EvaluationType] not in (N''C-'')' + 
	'and [a11].[EvaluationType] in (N''S-'', N''E-''))' + 
	'ORDER BY DisplayId ASC'

	EXEC sp_executesql @query;