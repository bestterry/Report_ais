SELECT [a11].[PublishedOnUTC] AS 'Published Date/Time',
        DATEADD(HOUR,7,[a11].[PublishedOnUTC]) AS 'Local Published Date/Time',
        [a11].[DisplayId] AS 'ID',[a12].[Agent] AS 'Agent',[a11].[AgentID] AS 'Agent ID',
        CONCAT([a16].[LastName],', ', [a16].[FirstName]) AS "Evaluation",
        [a14].[TemplateCategoryName] AS 'Category',[a15].[TemplateQuestionContent] AS 'Question',
        [a11].[EvaluatorsAnswer] AS 'Answer',[a11].[CurrentAnswerScoredPoints] AS 'Point Earned'
    FROM [Dossier].[fctEvaluationQuestionCurrentAnswer] [a11]
    JOIN [Evals].[EvaluationOrganization] [a12] 
        ON ([a11].[EvaluationKey] = [a12].[EvaluationKey])
    JOIN [Evals].[dimTemplateCategory] [a14]
        ON    ([a11].[TemplateCategoryKey] = [a14].[TemplateCategoryKey])
    JOIN [Evals].[dimTemplateQuestion] [a15]
        ON    ([a11].[TemplateQuestionKey] = [a15].[TemplateQuestionKey])
    JOIN	[Evals].[dimUser] [a16]
        ON 	([a11].[CreatedByUserID] = [a16].[UserID])
    WHERE (convert(date,[a11].[PublishedOnUTC]) between '20250101' and '20250101'
        AND [a11].[IgnoredForAgentReporting] = 0
        AND convert(date,[a11].[PublishedOnUTC]) is not null
        AND [a11].[TemplateKey] in (120)
        AND [a11].[RescoreIsActive] = 0
        AND CASE WHEN ([a11].[AcknowledgedOnUTC] Is Null) then 0 else 1 end in (1, 0)
        AND [a11].[IsPurgedInEvals] in (0)
        AND [a11].[EvaluationType] not in (N'C-')
        AND [a11].[EvaluationType] in (N'S-', N'E-'))
    ORDER BY [a11].[fctEvaluationQuestionKey] ASC