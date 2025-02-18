SELECT 
    [a11].[PublishedOnUTC] AS 'Published Date/Time',
    DATEADD(HOUR, 7, [a11].[PublishedOnUTC]) AS 'Local Published Date/Time',
    [a11].[DisplayId] AS 'ID',
    [a12].[Agent] AS 'Agent',
    [a11].[AgentID] AS 'Agent ID',
    CONCAT([a16].[LastName], ', ', [a16].[FirstName]) AS "Evaluation",
    [a14].[TemplateCategoryName] AS 'Category',
    [a15].[TemplateQuestionContent] AS 'Question',
    [a11].[EvaluatorsAnswer] AS 'Answer',
    [a11].[CurrentAnswerScoredPoints] AS 'Point Earned'
FROM [Dossier].[fctEvaluationQuestionCurrentAnswer] [a11]
JOIN [Evals].[EvaluationOrganization] [a12]
    ON [a11].[EvaluationKey] = [a12].[EvaluationKey]
JOIN [Evals].[dimTemplateCategory] [a14]
    ON [a11].[TemplateCategoryKey] = [a14].[TemplateCategoryKey]
JOIN [Evals].[dimTemplateQuestion] [a15]
    ON [a11].[TemplateQuestionKey] = [a15].[TemplateQuestionKey]
JOIN [Evals].[dimUser] [a16]
    ON [a11].[CreatedByUserID] = [a16].[UserID]
WHERE 
    CONVERT(DATE, [a11].[PublishedOnUTC]) = '2025-01-01'  -- Ensuring date format
    AND [a11].[IgnoredForAgentReporting] = 0
    AND [a11].[PublishedOnUTC] IS NOT NULL
    AND [a11].[TemplateKey] IN (218)
    AND [a11].[RescoreIsActive] = 0
    AND (CASE WHEN ([a11].[AcknowledgedOnUTC] IS NULL) THEN 0 ELSE 1 END) IN (1, 0)
    AND [a11].[IsPurgedInEvals] = 0
    AND [a11].[EvaluationType] NOT IN (N'C-')
    AND [a11].[EvaluationType] IN (N'S-', N'E-')
ORDER BY 
    [a11].[DisplayId] ASC, 
    [a14].[TemplateCategoryName] ASC, 
    CASE 
        WHEN CHARINDEX('.', [a15].[TemplateQuestionContent]) > 0 
        THEN TRY_CAST(LEFT([a15].[TemplateQuestionContent], CHARINDEX('.', [a15].[TemplateQuestionContent]) - 1) AS INT) 
        ELSE NULL 
    END ASC;
