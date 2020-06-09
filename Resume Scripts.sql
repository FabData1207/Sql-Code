--SQL


-- Creating a table with Category Type and category code from 2 differents tables.

SELECT
  DISTINCT job_cost_categories.JCC_TYPE AS Project_Category_Type_Code,
  job_cost_category_type_desc3.jcctd_type || ' - ' || TRIM(job_cost_category_type_desc3.description) AS Project_Category_Type_Combo
FROM
  pronto.JOB_COST_CATEGORIES job_cost_categories
  INNER JOIN pronto.JOB_COST_CATEGORY_TYPE_DESC job_cost_category_type_desc3 
  ON job_cost_category_type_desc3.jcctd_type = job_cost_categories.JCC_TYPE
WHERE
  job_cost_category_type_desc3.jcctd_language = ' '
ORDER BY
  2 ASC;

-- Building a fact table using key metrics from different source tables.

SELECT
  job_cost_transactions.job_code,
  job_cost_transactions.jc_trans_date AS transaction_date,
  CASE
    WHEN job_cost_categories.JCC_TYPE = 'I' THEN 0 - job_cost_transactions.jc_AMOUNT
    ELSE 0
  END AS invoiced_amount,
  CASE
    WHEN job_cost_categories.JCC_TYPE NOT IN ('I', 'A') THEN job_cost_transactions.jc_AMOUNT
    ELSE 0
  END AS actual_cost
FROM
  pronto.job_cost_transactions job_cost_transactions
  INNER JOIN pronto.job_cost_categories job_cost_categories ON job_cost_categories.JCC_CODE = job_cost_transactions.JOB_COST_CENTRE
WHERE
  1 = 1


TRUNCATE TABLE	[Database1].dbo.Example

INSERT INTO Scorecard.[dbo].Example
SELECT  DISTINCT  Masterkey
FROM	[AggregateDatabase1].dbo.[Example_Table]
WHERE	IDOrganization = 279
AND Masterkey LIKE '292%'


-- Getting patients first, last, and DOB


UPDATE Example
SET	[Patient's First Name]	= Pers..PsnFirst,	[Patient's Late Name]	=  Pers.PsnLaSt,	[Patient's Date of Birth]	=  Pers.Psnous,	[Client Name]	= Pers.PcPPracticeName
FROM [AggregateDatabase1].dbo.[Example_Table] Pers
JOIN  Scorecard.Example  samp
ON  Pers.MasterKey	=   samp.MRN
WHERE Pers.IDOrganization = Pers.IDMasterOrganization
AND  Pers.Idstatus = 1


--  getting most recent phone number

UPDATE  Example
SET	[Patient's  Phone  Number]	=  replace(replace(replace(replace(replace(replace(replace(replace(LTRIM(RTRIM(A.Phone)),'-',''),'(',''),')',''), ' ' ,''), '/' ,''),'x',''),'*',''),'calls','')
FROM (
 
SELECT  Phone [MasterKey],Phone.Phone,Phone.DateUpdated, ROW_NUMBER()  OVER (PARTITION BY Phone.MasterKey ORDER BY Phone.DateUpdated DESC) RN
FROM  [AggregateDatabase1].dbo.[Phone_Table]   Phone 
	INNER  JOIN  Scorecard.Example samp
ON Phone.Masterkey = samp.MRN
WHERE  PhoneType  in ('CELL','HOME') 
and  ISNULL ([Phone],'')  <> ''
and phone not  like  '%[a-z]%'
and  replace(replace(replace(replace(replace(replace(replace(replace(LTRIM(RTRIM(Phone.Phone)),'-',''),'(',''),')',''), ' ' ,''), '/' ,''),'x',''),'*',''),'calls','') NOT LIKE 'e%'
and lenreplace(replace(replace(replace(replace(replace(replace(replace(LTRIM(RTRIM(Phone.Phone)),'-',''),'(',''),')',''), ' ' ,''), '/' ,''),'x',''),'*',''),'calls','') = 10
) A

join [AggregateDatabase1].dbo.[Person_Table] j 	on a.MasterKey = j.MasterKey
join [AggregateDatabase1].dbo.[Master_Patient_Index_Table]  d  on  j.IDOrganization =  d.IDOrganization  END J.IDPerson = d.IDPerson 
INNER JOIN Scorecard.dbo.example Outp
ON A.MasterKey = OutP.MRN
WHERE  RN = 1


--  formats  phone  number

UPDATE  Example 
SET [Patient's   Phone  Number] =  SUBSTRING([Patient's  Phone  Number], 	1, 	3) +  '-' +
							SUBSTRING{[Patient's  Phone  Number],  4,	3) + '-' +
							SUBSTRING([Patient's  Phone  Number],  7,	4)

SELECT r.ProtCode
						,SUM(CASE  WHEN  R.Recommendation  LIKE	'%current'  THEN 1
								ELSE  0
							END)	[Met]	--Numerator
						,SUM(CASE  WHEN  R.Recommendation  LIKE	'%invalid' THEN 1
								ELSE  0
							END)	[Not Met]
						,SUM(CASE  WHEN  R.Recommendation  LIKE	'%incl'  THEN 1
								ELSE  0
							END)	[Denominator]
						,SUM(CASE  WHEN  R.Recommendation  LIKE	'%excl'  THEN 1
								ELSE  0
							END)	[Exclusion]
						,SUM(CASE  WHEN  R.Recommendation  LIKE	'%exception'  THEN 1
								ELSE  0
							END)	[Exception]
						,
					CONVERT(Decimal(20,1),
				  (CONVERT{Decimal(20,1), SUM(CASE WHEN R.Recommendation LIKE '%current' THEN 1  ELSE	0  END)*100)  )
						/
(SUM(CASE  WHEN  (R.Recommendation  LIKE   '%incl' THEN	1  ELSE	0  END)-SUM(CASE  WHEN  R.Recommendation  LIKE  '%exception'  THEN 1  ELSE	0  END) )
)	[Performance  Rate  %]


FROM 	[Example],[dbo].(Recommendations)  r WITH(NOLOCK)

				WHERE 	(R.Recommendation  LIKE  '%current'
						OR  R.Recommendation  LIKE  '%Excl' 
						OR  R.Recommendation  LIKE  '%Incl'
						OR  R.Recommendation  LIKE  '%Invalid'
						OR  R.Recommendation  LIKE  '%Exception')
GROUP BY r.ProtCode
ORDER BY 1


--DAX 

--Creating virtual relationship
-- This tecnique is used when we need to work with several dates (ex: Start date and Finish Date) then we create a virtual relationship to filter more than one field using condition "OR"

Invoiced Revenue test = CALCULATE(SUM(fact_jcm[Actual invoiced Revenue]), USERELATIONSHIP(fact_jcm[finish_date], 'Calendar'[Date]))
Revised CV = Revised CV = CALCULATE(SUM(Fact_job_cost_master[Revised Contract Value ]), USERELATIONSHIP(Dim_Calendar[Date],Fact_job_cost_master[finish_date]))

-- Using one key metric to filter another two differfent dates by Field.

_measure FILTER tabela = CALCULATE(COUNT(Principal[id]),
FILTER(Principal,
max(Principal[start_date]) <= MAX(DateDim[Date]) && max(Principal[start_date]) >= MIN(DateDim[Date]) ||
max(Principal[finish_date]) <= MAX(DateDim[Date]) && max(Principal[finish_date]) >= MIN(DateDim[Date])))
												
												----------- USING MORE THAN 2 DATES -----------------------

old_Forecast - Outstanding PO's = CALCULATE(SUM(Fact_job_cost_master[Forecast - Outstanding PO's]),
FILTER(Fact_job_cost_master,
Fact_job_cost_master[jcm_start_date] <= MAX(Dim_Calendar[Date]) && Fact_job_cost_master[jcm_start_date] >= MIN(Dim_Calendar[Date]) || Fact_job_cost_master[finish_date] <= MAX(Dim_Calendar[Date]) && Fact_job_cost_master[finish_date] >= MIN(Dim_Calendar[Date])))



MaxMonth = CALCULATE(MAX'Calendar'[MonthNumb]), (ALL('Calendar'), 'Calendar'[CurMonthOffset] = 0)

Sales Across Prior Years, = VAR MaxMonth = [MaxMonth]
RETURN CALCULATE ([sales], 'Calendar'[MonthNum]) <= MaxMonth)



--TREATAS-- (cross join, filter, creating virtual relationship and aggretation)
Measure = 
CALCULATE(SUM('Tax Values'[standard_tax]),
 TREATAS( SUMMARIZE( 'Pay Values', 'Pay Values'[Employee no],'Pay Values'[Pay Date]),
'Tax Values'[employee_no_],
'Tax Values'[pay_date]))
								
												
