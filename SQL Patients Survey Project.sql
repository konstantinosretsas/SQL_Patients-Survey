--/ SQL Data Cleaning

SELECT Release_Period, State, Facility_ID, Completed_Surveys,
	CASE WHEN Response_Rate = 'Not Available' THEN 0 ELSE Response_Rate 
	END AS Response_Rates
INTO reponses_2
FROM responses
DROP TABLE responses
exec sp_rename 'dbo.reponses_2', 'dbo.responses'

UPDATE responses
SET Response_Rate = 0
WHERE Response_rate is null;

UPDATE questions
SET Middle_box_answer = 'N/A'
WHERE Middle_box_answer is null;

--/ SQL 1: Find the total number of questions in the dataset

SELECT COUNT(distinct Question) as Number_of_Questions FROM questions

--/ SQL 2: Find the Start and End Dates for the '07_2018' report (release period)

SELECT Start_date, End_date FROM reports
WHERE Release_Period = '07_2018'

--/ SQL 3: Find the hospitals in Alabama (AL) with a response rate greater than 30%

SELECT Facility_ID, Response_Rates FROM responses
WHERE Response_Rates >30 AND State = 'AL'

--/ SQL 4: Get the average Top-box Percentage for all Measures in '07_2015'

SELECT Measure_ID, AVG(Top_box_Percentage) AS Average_Top_Box_Percentage
FROM state_results
WHERE Release_Period = '07_2015'
GROUP BY Measure_ID

--/ SQL 5: Find the states along with the highest and lowest response rates in '07_2015' 
--/ when response rate is different that Not Available

SELECT State, MIN(Response_Rates) AS MIN_RATE, MAX(Response_Rates) AS MAX_RATE 
FROM responses
WHERE Release_Period = '07_2015' and Response_Rates<>0
GROUP BY State

--/ SQL 5A: Find the states with the highest response rates in '07_2015' 
--/ when response rate is different that Not Available

WITH STATE_MAX  AS (SELECT State, MAX(Response_Rates) AS MAX_RATE 
FROM responses
WHERE Release_Period = '07_2015' and Response_Rates<>0
GROUP BY State),
SINGLE_MAX AS (SELECT MAX(MAX_RATE) AS MAX_1 FROM STATE_MAX)

SELECT State, MAX_RATE FROM STATE_MAX, SINGLE_MAX
WHERE MAX_RATE = MAX_1

--/SQL 5A: *with JOIN

WITH STATE_MAX  AS (SELECT State, MAX(Response_Rates) AS MAX_RATE 
FROM responses
WHERE Release_Period = '07_2015' and Response_Rates<>0
GROUP BY State),
SINGLE_MAX AS (SELECT MAX(MAX_RATE) AS MAX_1 FROM STATE_MAX)

SELECT State, MAX_RATE FROM STATE_MAX
JOIN SINGLE_MAX ON MAX_RATE = MAX_1

--/ SQL 5B: Find the states along with the lowest response rates in '07_2015' 
--/ when response rate is different that Not Available

WITH STATE_MIN AS (SELECT State, MIN(Response_Rates) AS MIN_RATE 
FROM responses
WHERE Release_Period = '07_2015' and Response_Rates<>0
GROUP BY State),
SINGLE_MIN AS (SELECT MIN(MIN_RATE) AS MIN_1 FROM STATE_MIN)

SELECT State, MIN_RATE FROM STATE_MIN
JOIN SINGLE_MIN ON MIN_RATE = MIN_1

--/ SQL 6: What is the average response rate when response rate is different from Not Available? 
--/ What is the average response rate when response rate is with values of Not Available

SELECT AVG(Response_Rates) FROM [SQL_Patients Survey].dbo.responses
WHERE Response_Rates <>0

SELECT AVG(Response_Rates) FROM [SQL_Patients Survey].dbo.responses

--/ SQL 7: List the States along with their regions and facility id, 
--/ which have a response rate greater than the average response rate in '07_2015'

SELECT a.State,a.Facility_ID,b.Region FROM [SQL_Patients Survey].dbo.responses a
LEFT JOIN [SQL_Patients Survey].dbo.states b ON b.State = a.State
WHERE Response_Rates>(SELECT AVG(Response_Rates) FROM [SQL_Patients Survey].dbo.responses a1 WHERE Release_Period = '07_2015')

--/ SQL 7: 2nd VERSION

WITH AVG_RESPONSES AS (SELECT AVG(Response_Rates) AS AVG_RE FROM [SQL_Patients Survey].dbo.responses a1 WHERE Release_Period = '07_2015')

SELECT a.State,a.Facility_ID,b.Region FROM [SQL_Patients Survey].dbo.responses a 
LEFT JOIN [SQL_Patients Survey].dbo.states b ON b.State = a.State, 
AVG_RESPONSES
WHERE Response_Rates>AVG_RE

--/ SQL 8: Measure Description & lowest bottom-box in 07_2015:

SELECT a.Measure_ID,b.Measure, MIN(a.Bottom_box_Percentage) AS MIN_Bottom FROM [SQL_Patients Survey].dbo.state_results a
LEFT JOIN [SQL_Patients Survey].dbo.measures b ON a.Measure_ID = b.Measure_ID
WHERE a.Release_Period = '07_2015'
GROUP BY a.Measure_ID,b.Measure
ORDER BY MIN_Bottom ASC

--/ SQL 9: List the measures that have at least 2 question related to them

SELECT Distinct questions.Measure_ID, COUNT(questions.Question) AS Number_Questions FROM [SQL_Patients Survey].dbo.questions questions
GROUP BY questions.Measure_ID
HAVING COUNT(questions.Question)>=2 --/ HAVING COUNT(*)>=2 

--/SQL 10: Get the states with the highest Bottom-box Percentage
--/ for 'Communication with Nurses' in '07_2015'

SELECT b.Measure,MAX(a.Bottom_box_Percentage) AS MAX_BottomBox,a.State FROM [SQL_Patients Survey].dbo.state_results a
LEFT JOIN [SQL_Patients Survey].dbo.measures b ON a.Measure_ID = b.Measure_ID
WHERE a.Release_Period = '07_2015' and b.Measure = 'Communication with Nurses'
GROUP BY a.State, b.Measure
ORDER BY MAX_BottomBox DESC

--/ SQL 11: Get the State Names with the top 3 highest Top-box Percentages 
--/ for 'Cleanliness of Hospital Environment' in '07_2015'

SELECT TOP 3 a.Top_box_Percentage,a.State, b.State_Name FROM [SQL_Patients Survey].dbo.state_results a
LEFT JOIN [SQL_Patients Survey].dbo.states b ON a.State = b.State
WHERE a.Release_Period = '07_2015' and a.Measure_ID = 'H_CLEAN_HSP'
ORDER BY Top_box_Percentage DESC

--/ SQL 12: Get the Top 3 Measures based on the frequency of their Middle-box Answer being 'Usually'

SELECT top 3 Measure, COUNT(*) AS UsuallyCount
FROM Questions a
join measures b on a.Measure_ID = b.Measure_ID
WHERE Middle_box_Answer = 'Usually'
GROUP BY Measure
ORDER BY UsuallyCount DESC

--/ SQL 13: Get the states along with their average Bottom-box, Middle-box, 
--/ and Top-box Percentages for 'Communication with Nurses' measure

SELECT AVG(a.Bottom_box_Percentage) AS AVG_BottomBox,
AVG(a.Middle_box_Percentage) AS AVG_MiddleBox,
AVG(a.Top_box_Percentage) AS AVG_TopBox, a.State 
FROM [SQL_Patients Survey].dbo.state_results a
LEFT JOIN [SQL_Patients Survey].dbo.measures b ON a.Measure_ID = b.Measure_ID
WHERE b.Measure = 'Communication with Nurses'
GROUP BY a.State
ORDER BY a.State

--/ SQL 14: List the questions along with their Bottom-box, Middle-box, and Top-box answers, 
--/ and the corresponding percentages for '07_2015'

SELECT a.Measure_ID, b.Question, a.Bottom_box_Percentage AS BottomBox,
a.Middle_box_Percentage AS MiddleBox,
a.Top_box_Percentage AS TopBox, b.Bottom_box_Answer, b.Middle_box_Answer, b.Top_box_Answer
FROM [SQL_Patients Survey].dbo.state_results a
LEFT JOIN [SQL_Patients Survey].dbo.questions b ON a.Measure_ID = b.Measure_ID
WHERE a.Release_Period = '07_2015'


--/ SQL 15: Find the states with more than 20 Hospitals in the 'Responses' table

SELECT State, COUNT(Distinct Facility_ID) AS Hospitals 
FROM responses
GROUP BY State
HAVING COUNT(Distinct Facility_ID)>20
ORDER BY COUNT(Distinct Facility_ID) DESC

--/ SQL 16: Get the average Bottom-box Percentage for each Measure, only for measures 
--/ that have at least 3 questions related to them

WITH COUNT_QUESTIONS AS (SELECT Measure_ID, COUNT( Distinct QUESTION) AS Questions_count
FROM questions
GROUP BY Measure_ID)

SELECT a.Measure_ID,AVG(Bottom_box_Percentage) AS Bottom_Average, Questions_count FROM national_results a
LEFT JOIN COUNT_QUESTIONS b ON a.Measure_ID = b.Measure_ID
WHERE Questions_count>=3
GROUP BY a.Measure_ID, Questions_count

--/ SQL 16: 2nd Version

WITH COUNT_QUESTIONS AS (SELECT Measure_ID, COUNT( Distinct QUESTION) AS Questions_count
FROM questions
GROUP BY Measure_ID
HAVING COUNT( Distinct QUESTION)>=3)

SELECT a.Measure_ID,AVG(Bottom_box_Percentage) AS Bottom_Average, Questions_count FROM national_results a
JOIN COUNT_QUESTIONS b ON a.Measure_ID = b.Measure_ID
GROUP BY a.Measure_ID, Questions_count

--/ SQL 17: For each release period, rank the measures based on their Bottom-box Percentage in descending order 
--/ (if more than 1 value is in the same rank, then skip this number). 
--/ Do the same but the opposite 
--/(if more than 1 value is in the ….do not skip this number).

--/ Skip this number
SELECT Release_Period, Measure_ID, Bottom_box_Percentage,
RANK() OVER (ORDER BY Bottom_box_Percentage DESC) AS RANK
FROM national_results
ORDER BY RANK

--/ DO NOT Skip this number
SELECT Release_Period, Measure_ID, Bottom_box_Percentage,
DENSE_RANK() OVER (ORDER BY Bottom_box_Percentage DESC) AS RANK
FROM national_results
ORDER BY RANK

--/ Note: If I had used "Partition by", this would be on "Release Period" and it will calculate the rank for each one. 

