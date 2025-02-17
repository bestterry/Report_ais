	SELECT 'ID' AS DisplayId, 'Published Date/Time' AS PublishedOnUTC, 'Local Published Date Time' AS LocalPublishedOnUTC,
		'ACCS_Group' AS GroupName, 'ACCS_TEAM' AS UDFVarchar30, 'Agent' AS Agent, 'Agent ID' AS AgentID, 'AGENT_PINCODE' AS UDFVarchar92, 
		'Evaluator' AS FirstName, 'CBP_GROUP' AS UDFVarchar31, 'CBP_POSITION' AS UDFVarchar33 ,
		'CBP_TEAM' AS UDFVarchar32, 'SUPERVISOR' AS SupervisorName, 'Participant PhoneNumber' AS UDFVarchar15, 
		'MANAGER_PINCODE' AS UDFVarchar8, 'MANAGER_NAME_ENG' AS UDFVarchar29, 'User LoginName' AS UDFVarchar21, CAST('User Hire Date' AS VARCHAR(50)) AS UDFdate1, 
		'Edited' AS ModifiedDateUTC, 'Template' AS TemplateName, 'Time' AS timevalue, 'Score' AS InitialScoredPoints 
	UNION ALL SELECT CAST([a11].[DisplayId] AS VARCHAR),CAST([a11].[PublishedOnUTC] AS VARCHAR),CAST(DATEADD(HOUR,7,[a11].[PublishedOnUTC]) AS VARCHAR), 
		[a12].[GroupName], ISNULL([a18].[UDFVarchar30], '') ,[a12].[Agent],[a11].[AgentID],ISNULL([a18].[UDFVarchar92], ''), 
		CONCAT(ISNULL([a14].[LastName], ''),', ',ISNULL([a14].[FirstName], '')), ISNULL([a18].[UDFVarchar31], ''), ISNULL([a18].[UDFVarchar33], ''), 
		ISNULL([a18].[UDFVarchar32], ''),[a11].[SupervisorName], ISNULL([a18].[UDFVarchar15], ''),  
		ISNULL([a18].[UDFVarchar8], ''),ISNULL([a18].[UDFVarchar29], ''),ISNULL([a18].[UDFVarchar21], ''), CONVERT(VARCHAR(10), TRY_CONVERT(DATE, CAST([a18].[UDFdate1] AS VARCHAR(8)), 112), 120), 
		CASE WHEN [a11].[CreationDateUTC]=[a11].[ModifiedDateUTC] THEN 'No' ELSE 'Yes' END AS 'Edited', 
		CONCAT([a17].[TemplateName],' v',[a17].[TemplateVersion]), '1' AS timevalue, CAST([a11].[InitialScoredPoints] AS VARCHAR) 
	FROM [NexidiaESIDW].[Dossier].[vfctEvaluation] [a11] 
	JOIN [NexidiaESIDW].[Evals].[EvaluationOrganization] [a12] ON ([a11].[EvaluationKey] = [a12].[EvaluationKey]) 
	JOIN [NexidiaESIDW].[Evals].[dimUser] [a14] ON ([a11].[CreatedByUserID] = [a14].[UserID])
	JOIN [NexidiaESIDW].[Evals].[dimTemplate] [a17] ON ([a11].[TemplateKey] = [a17].[TemplateKey]) 
	JOIN [NexidiaESIDW].[dim].[dimMediaUDF] [a18] ON ([a11].[PrimaryMediaKey] = [a18].[MediaUDFKey]) 
	where ([a11].[TemplateKey] in (123, 120, 124, 218, 197, 229, 230)
	and convert(date,[a11].[PublishedOnUTC]) is not null
	and convert(date,[a11].[PublishedOnUTC]) between '20250101' and '20250101'
	and [a11].[RescoreIsActive] = 0
	and Case when ([a11].[AcknowledgedOnUTC] Is Null) then 0 else 1 end in (1, 0)
	and [a11].[IsPurgedInEvals] in (0)
	and [a11].[EvaluationType] not in (N'C-')
	and [a11].[EvaluationType] in (N'S-', N'E-'))
	ORDER BY DisplayId DESC