--Task 1: Financial Performance 
-- Write a query to list all films with the following information:
--• Exclude films with missing or zero budgets
 --• Sort results by ROI in descending order
 SELECT 
	 PF.film ,
	 YEAR(PF.release_date) AS 'Release year',
	 CONCAT(BO.budget / 1000000.0 , 'M') AS [Budget],
	 CONCAT(BO.box_office_worldwide / 1000000.0, 'M') AS [Worldwide gross],
	 CAST(((BO.box_office_worldwide - BO.budget) * 100.0) / BO.budget AS DECIMAL(5,1)) AS [ROI percentage]
 FROM
		['pixar_films $'] PF
 JOIN
		['box_office $'] BO
 ON 
	PF.film = BO.film
 WHERE 
	 BO.budget  IS NOT NULL AND BO.budget <> 0
ORDER BY [ROI percentage] DESC;
	
-------------------------------------------------------------
 --Task 2: Award Analysis (1.5 Marks)
 SELECT 
	WN.film,
	SUM(CASE WHEN status ='WON' THEN 1 ELSE 0 END) AS 'AWARDS WIN',
	COUNT (*) AS 'Total nominations' ,
	(SUM(CASE WHEN status ='WON' THEN 1 ELSE 0 END)*100/ COUNT(*)) AS [WIN PRECENT]
 FROM 
	( SELECT *
		 FROM
			Movies_Rewards$ 
		 WHERE
			 status = 'WON' OR  
			 status = 'Nominated') WN
 GROUP BY
	WN.film
 HAVING 
	SUM(CASE WHEN status ='WON' THEN 1 ELSE 0 END) > 0
ORDER BY [WIN PRECENT] DESC
  
--********************************************
--Task 3: Genre Profitability (2.0 Marks)

SELECT TOP 5
	MT.value,
	CAST(AVG(BO.box_office_worldwide)/1000000.0 AS DECIMAL(10,1)) AS [Average Worldwide Gross (M)],
	COUNT(*) AS 'Number of films'
FROM Movie_Type$ MT 
JOIN 
['box_office $'] BO
ON
MT.film = BO.film
GROUP BY MT.value
HAVING COUNT(*)  >3
ORDER BY  [Average Worldwide Gross (M)] DESC

-- Task 4: Director Impact Study (1.5 Marks)
-- For directors who have worked on two or more films, provide:

-- • Average Rotten Tomatoes score
-- • Average worldwide gross (in millions)
-- • Average IMDb score Sort the results by average worldwide gross in de
--scending order.


SELECT 
	PP.name , 
	COUNT(PP.film) AS 'MOVIE COUNT',
	CAST(AVG(PR.rotten_tomatoes_score) AS DECIMAL(5,1)) AS [Average Rotten Tomatoes Score],
	CAST(AVG(BO.box_office_worldwide) / 1000000.0 AS DECIMAL(10,1)) AS [Average Worldwide Gross (M)],
	CAST(AVG(PR.imdb_score) AS DECIMAL(5,1)) AS [Average IMDb score Sort the results ]
FROM
	pixar_people$ PP 
JOIN
	['public_response $'] PR
ON 
	PR.film  = PP.film
JOIN
	['box_office $'] BO
ON	
	BO.film = PP.film
WHERE 
	PP.role_type = 'Director' 
GROUP 
	BY PP.name 
HAVING 
    COUNT(DISTINCT PP.film) >= 2
ORDER BY 
	AVG(BO.box_office_worldwide) DESC



SELECT 
    PP.name AS [Director Name],
    CAST(AVG(PR.rotten_tomatoes_score) AS DECIMAL(5,1)) AS [Average Rotten Tomatoes Score],
    CAST(AVG(BO.box_office_worldwide) / 1000000.0 AS DECIMAL(10,1)) AS [Average Worldwide Gross (M)],
    CAST(AVG(PR.imdb_score) AS DECIMAL(5,1)) AS [Average IMDb Score]
FROM 
    [pixar_people$] PP
JOIN 
    ['public_response $'] PR ON PP.film = PR.film
JOIN 
    ['box_office $'] BO ON PP.film = BO.film
WHERE 
    PP.role_type = 'Director'
GROUP BY 
    PP.name
HAVING 
    COUNT(DISTINCT PP.film) >= 2
ORDER BY 
    [Average Worldwide Gross (M)] DESC;

 --Task 5: Franchise Comparison 
SELECT 
	CASE
		WHEN MOVIES.film  LIKE 'Toy%' THEN  'Toy Story' 
		WHEN MOVIES.film  LIKE 'Car%' THEN  'Car'
		WHEN MOVIES.film  LIKE 'Finding Dory%' THEN 'Finding Dory'
		WHEN MOVIES.film  LIKE 'Finding Nemo%' THEN 'Finding Nemo'
	END  AS  'Franchise name' ,
		ROUND(SUM(BO.box_office_worldwide) /1000000 ,2)AS 'Total worldwide gross (in millions)',
		COUNT(*) AS total_films,
		AVG(PF.run_time) AS 'Average runtime (in minutes)'
FROM
	(
	SELECT 
		BO.film
	FROM 
		['box_office $'] BO
	WHERE
		BO.film LIKE 'Toy%' OR
		BO.film LIKE 'Car%' OR
		BO.film LIKE 'Finding Dory%' OR
		BO.film LIKE 'Finding Nemo%'	
	) 
		AS MOVIES 
	JOIN 
			['box_office $'] BO
	ON 
			MOVIES.film = BO.film
	JOIN 
			['pixar_films $'] PF
	ON		PF.film = MOVIES.film
	GROUP BY
		CASE
			WHEN MOVIES.film  LIKE 'Toy%' THEN  'Toy Story' 
			WHEN MOVIES.film  LIKE 'Car%' THEN  'Car'
			WHEN MOVIES.film  LIKE 'Finding Dory%' THEN 'Finding Dory'
			WHEN MOVIES.film  LIKE 'Finding Nemo%' THEN 'Finding Nemo'
		END 
	ORDER BY [Total worldwide gross (in millions)] DESC
			
		




 --Task 6: Budget Category Analysis 
 SELECT 
	COUNT(*) AS film_count		,
	ROUND(AVG(PR.Metacritic_Score) *100,2) AS ' Average Metacritic score' ,
	ROUND(AVG(BO.box_office_worldwide/1000000),2) AS 'Average worldwide gross (in millions)',

	CASE 
		WHEN BO.budget < 100000000 THEN 'LOW'
		WHEN BO.budget >=100000000 AND BO.budget <= 150000000 THEN 'MEDIUM'
		WHEN BO.budget > 150000000 THEN 'HIGH'
	END AS budget_categories
 FROM 
		['box_office $'] BO 
	JOIN	
		['public_response $'] PR
	ON
		BO.film = PR.film
 
 GROUP BY 
	CASE 
		WHEN BO.budget <  100000000  THEN 'LOW'
		WHEN BO.budget >= 100000000 AND BO.budget <=150000000 THEN 'MEDIUM'
		WHEN BO.budget >  150000000  THEN 'HIGH'
	END

