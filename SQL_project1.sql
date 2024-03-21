use[vehicle];
select *from [dbo].[accident];
select *from [dbo].[vehicle];

/* Q1- How many accidents have occured in urban areas versus rural areas? */
select 
[Area],
 count ([AccidentIndex]) as 'Total Accidents'
from [dbo].[accident]
group by 
[Area];

/* Q2- Which day of the week has the highest numbers of accidents? */
SELECT
[Day],
COUNT ([AccidentIndex]) AS 'Total'
FROM
[dbo].[accident]
GROUP BY
[Day]
ORDER BY 
'Total' DESC ;

/* Q3- What is the average age of vehicles involves in the accidents based on their type? */
SELECT
	[VehicleType],
	COUNT([AccidentIndex]) AS 'Total accidents',
	AVG([AgeVehicle]) AS 'Averge age'
FROM [dbo].[vehicle]
WHERE [AgeVehicle] IS NOT NULL
GROUP BY [VehicleType]
ORDER BY 'Total accidents' DESC


/* Q4- Can we identify any trends in accidents based on the age of vehicles involved? */
SELECT 
	AGEGROUP,
	COUNT([AccidentIndex]) AS 'Total accidents',
	AVG([AgeVehicle]) AS 'Averge age'
FROM(
  SELECT
	[AccidentIndex],
	[AgeVehicle],
	CASE 
		WHEN [AgeVehicle] BETWEEN 0 AND 5 THEN 'New'
		WHEN [AgeVehicle] BETWEEN 6 AND 10 THEN 'Regular'
		ELSE 'Old'
	END AS 'AGEGROUP'
  FROM [dbo].[vehicle]
) AS SUBQUERY
GROUP BY AGEGROUP

/* Q5- Are there any specific weather conditions that contribute to severe accidents? */
DECLARE @Severity VARCHAR(100)
SET @Severity ='Fatal'

SELECT
	[WeatherConditions],
	COUNT([Severity]) AS 'Total Accidents'
FROM 
	[dbo].[accident]
WHERE
	[Severity] = @Severity
GROUP BY 
	[WeatherConditions]
ORDER BY
	'Total Accidents' DESC

/* Q6- Do accidents often involve impacts on the left hand side of vehicles ? */
SELECT 
	[LeftHand],
	COUNT([AccidentIndex]) AS 'Total Accidents'
FROM 
	[dbo].[vehicle]
WHERE 
	[LeftHand] IS NOT NULL 
GROUP BY 
	[LeftHand]

/* Q7- Are there any relationship between journey purposes and the severity of accidents? */
SELECT 
	V.[JourneyPurpose],
	COUNT (A.[Severity]) AS 'Total Accidents',
	CASE
		WHEN COUNT (A.[Severity]) BETWEEN 0 AND 1000 THEN 'Low'
		WHEN COUNT (A.[Severity]) BETWEEN 1000 AND 5000 THEN 'Moderate'
		ELSE 'High'
	END AS 'Level'
FROM
	[dbo].[accident] A
JOIN 
	[dbo].[vehicle] V ON V.[AccidentIndex]= A.[AccidentIndex]
GROUP BY 
	V.[JourneyPurpose]
ORDER BY 
	'Total Accidents' DESC
	

/* Q8- Calculate the average age of vehicles involved in accidents, considering day light and point of impact: */
DECLARE @IMPACT VARCHAR(100)
DECLARE @LIGHT VARCHAR(100)
SET @IMPACT = 'Back'
SET @LIGHT = 'Daylight'

SELECT
	A.[LightConditions],
	V.[PointImpact],
	AVG([AgeVehicle]) AS 'Average Age'
FROM
	[dbo].[accident] A
JOIN 
	[dbo].[vehicle]V ON V.[AccidentIndex]=A.[AccidentIndex]
GROUP BY 
	A.LightConditions, V.PointImpact
HAVING 
	[LightConditions]=@Light AND [PointImpact]=@IMPACT