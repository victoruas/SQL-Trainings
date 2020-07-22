-- BASIC COURSE

CREATE DATABASE mytestdb

use mytestdb

CREATE TABLE mytesttable
(
rowno int,
firstname varchar(50),
lastname varchar(50)
)

INSERT INTO mytesttable(rowno, firstname, lastname)
VALUES(7, 'VICTOR', 'RUAS')

SELECT * FROM mytesttable

USE [AdventureWorks2012]

SELECT * FROM [HumanResources].[Department]

SELECT Name FROM [HumanResources].[Department]

SELECT GroupName FROM [HumanResources].[Department]

SELECT DISTINCT GroupName FROM [HumanResources].[Department]

SELECT Name, GroupName FROM [HumanResources].[Department]
WHERE GroupName LIKE 'Manufacturing'

SELECT * FROM [HumanResources].[Employee]
WHERE OrganizationLevel = 2

SELECT * FROM [HumanResources].[Employee]
WHERE OrganizationLevel IN (2,4)

SELECT * FROM [HumanResources].[Employee]
WHERE JobTitle LIKE 'FACILITIES%'

SELECT * FROM [HumanResources].[Employee]
WHERE BirthDate > '11/1/1980'

SELECT * FROM [HumanResources].[Employee]
WHERE BirthDate BETWEEN '11/1/1980' AND '11/30/1980'

SELECT Name, ListPrice 
FROM [Production].[Product]

SELECT Name, ListPrice, ListPrice + 10 AS ADJUSTED_LISTPRICE
FROM [Production].[Product]

SELECT Name, ListPrice, ListPrice + 10 AS ADJUSTED_LISTPRICE INTO [Production].[Product2]
FROM [Production].[Product]

SELECT *
FROM [Production].[Product2]

SELECT Name, ListPrice, ListPrice + 10 AS ADJUSTED_LISTPRICE INTO #tmptable
FROM [Production].[Product]

	SELECT * FROM #tmptable

DELETE FROM [Production].[Product2]
WHERE Name LIKE 'Bearing Ball'

UPDATE [Production].[Product2]
SET NAME = 'BLADE_NEW'
WHERE NAME LIKE 'BLADE'

SELECT *
FROM [Production].[Product2]

CREATE TABLE MYEMPLOYEE (EMPLOYEEID INT, FIRSTNAME VARCHAR(20), LASTNAME VARCHAR(20))

INSERT INTO MYEMPLOYEE VALUES (1, 'Victor', 'Ruas')
INSERT INTO MYEMPLOYEE VALUES (2, 'Pedro', 'Celino')
INSERT INTO MYEMPLOYEE VALUES (3, 'Bru', 'Alvarez')

SELECT * FROM MYEMPLOYEE

CREATE TABLE MYSALARY (EMPLOYEEID INT, SALARY FLOAT)

INSERT INTO MYSALARY VALUES (1, 11000)
INSERT INTO MYSALARY VALUES (2, 5000)
INSERT INTO MYSALARY VALUES (3, 7500)

SELECT * FROM MYEMPLOYEE
SELECT * FROM MYSALARY

SELECT A.FIRSTNAME, A.LASTNAME, B.SALARY
FROM MYEMPLOYEE A INNER JOIN MYSALARY B ON A.EMPLOYEEID = B.EMPLOYEEID

CREATE TABLE MYPHONE (EMPLOYEEID INT, PHONENUMBER INT)

SELECT * FROM MYPHONE

DELETE FROM MYPHONE WHERE EMPLOYEEID = 1
INSERT INTO MYPHONE VALUES (1, 1323223)
INSERT INTO MYPHONE VALUES (2, 5463943)

SELECT ME.FIRSTNAME, ME.LASTNAME, MP.PHONENUMBER
FROM MYEMPLOYEE ME LEFT JOIN MYPHONE MP ON ME.EMPLOYEEID = MP.EMPLOYEEID

CREATE TABLE MYPARKING (EMPLOYEEID INT, PARKINGSPOT VARCHAR(20))

INSERT INTO MYPARKING VALUES (1, 'A1')
INSERT INTO MYPARKING VALUES (2, 'A2')
INSERT INTO MYPARKING VALUES (3, 'A3')
INSERT INTO MYPARKING VALUES (4, 'A4')

SELECT A.FIRSTNAME, A.LASTNAME, B.PARKINGSPOT 
FROM MYPARKING B LEFT JOIN MYEMPLOYEE A
ON A.EMPLOYEEID = B.EMPLOYEEID

SELECT * FROM MYEMPLOYEE CROSS JOIN MYPHONE
SELECT * FROM MYEMPLOYEE
SELECT * FROM MYEMPLOYEE, MYPHONE

SELECT GETDATE()
SELECT GETDATE() - 2
SELECT DATEPART (yyyy, GETDATE()) AS YEAR
SELECT DATEPART (mm, GETDATE()) AS MONTH
SELECT DATEPART (dd, GETDATE()) AS DAY

SELECT DATEADD (yyyy,-10, GETDATE()) AS YEAR
SELECT DATEADD (mm,4, GETDATE()) AS MONTH
SELECT DATEADD (dd,10, GETDATE()) AS DAY
SELECT DATEADD (dd,10, '09/03/1986') AS DAYBIRTH

-- ADVANCED COURSE ----------------------------------------

-- VIEWS 
SELECT TOP 1000 [TerritoryID]
      ,[Name]
      ,[CountryRegionCode]
      ,[Group]
      ,[SalesYTD]
      ,[SalesLastYear]
      ,[CostYTD]
      ,[CostLastYear]
      ,[rowguid]
      ,[ModifiedDate]
  FROM [AdventureWorks2012].[Sales].[SalesTerritory]

CREATE VIEW MyCustomUSView
AS
SELECT * FROM [AdventureWorks2012].[Sales].[SalesTerritory]
WHERE CountryRegionCode LIKE 'US'

SELECT * FROM MyCustomUSView

CREATE VIEW NASalesQuota
AS
SELECT [Name], [Group], [SalesQuota], [Bonus]
FROM [Sales].[SalesTerritory] a INNER JOIN [Sales].[SalesPerson] b
ON a.[TerritoryID] = b.[TerritoryID]

SELECT * FROM NASalesQuota

-- TRIGGERS

SELECT * FROM [HumanResources].[Shift]
INSERT INTO [HumanResources].[Shift]
VALUES ('MADRUGADA','07:00:00.0000000','23:00:00.0000000',GETDATE());

CREATE TRIGGER Demo_trigger
ON [HumanResources].[Shift]
AFTER INSERT -- PODE SER AFTER OU BEFORE / INSERT_UPDATE_DELETE
AS
BEGIN
PRINT 'NOT ALLOWED TO INSERT DATA. NEED APPROVAL'
ROLLBACK TRANSACTION
END
GO

INSERT INTO [HumanResources].[Shift]
VALUES ('TARDEZINHA','09:00:00.0000000','20:00:00.0000000',GETDATE());

SELECT * FROM [HumanResources].[Shift]

-- TRIGGERS DB LEVEL

CREATE TRIGGER Demo_triggerDBlevel
ON DATABASE
AFTER CREATE_TABLE
AS
BEGIN
PRINT 'NOT ALLOWED TO CREATE A TABLE. NEED APPROVAL'
ROLLBACK TRANSACTION
END
GO

-- COMPUTED COLUMNS (CALCULATED COLUMNS)

CREATE TABLE Tabletesttrigger (col1 varchar(50))

CREATE TABLE Myemployeetest2
(
firstname varchar(50),
lastname varchar(50),
fullname AS CONCAT(firstname,' ',lastname),
Salary int,
Hoursworked int,
SalaryPerHour AS Salary/Hoursworked
)

INSERT INTO Myemployeetest2 VALUES ('VICTOR','RUAS', 100000, 50)
INSERT INTO Myemployeetest2 VALUES ('BOO','CELINO', 5000, 40)
INSERT INTO Myemployeetest2 VALUES ('PEDRO','WHITEHEAD', 3700, 35)

SELECT * FROM Myemployeetest2

DROP TABLE Myemployeetest2

-- STORED PROCEDURES

CREATE PROCEDURE MytestProc
AS
SET NOCOUNT ON -- ON OR OFF TO SHOW OR NOT MESSAGE OF ROWS AFFECTED
SELECT * FROM [HumanResources].[Shift]

EXECUTE MytestProc -- COULD BE EXEC

DROP PROC MytestProc

CREATE PROC MytesteParamProc
@Param_name VARCHAR(50)
AS
SET NOCOUNT ON
SELECT * FROM [HumanResources].[Shift]
WHERE Name = @Param_name

EXEC MytesteParamProc @Param_name = 'Day'
EXEC MytesteParamProc 'Day'

DROP PROC MytesteParamProc

CREATE PROC MytesteParamProc
@Param_name VARCHAR(50) = 'Evening' -- PUT A DEFAULT VALUE
AS
SET NOCOUNT ON
SELECT * FROM [HumanResources].[Shift]
WHERE Name = @Param_name

EXEC MytesteParamProc 'Day'
EXEC MytesteParamProc -- RUNS WITH THE DEFAULT VALUE

-------- USER DEFINED FUNCTIONS -------------------

SELECT * FROM [Sales].[SalesTerritory]

CREATE FUNCTION YTDSALES()
RETURNS MONEY
AS
BEGIN
DECLARE @YTDSALES AS MONEY
SELECT @YTDSALES = SUM(SALESYTD) FROM [Sales].[SalesTerritory]
RETURN @YTDSALES
END

DECLARE @YTDRESULTS AS MONEY
SELECT @YTDRESULTS = dbo.YTDSALES()
PRINT @YTDRESULTS

----- PARAMETERIZED FUNCTIONS

SELECT * FROM [Sales].[SalesTerritory]

CREATE FUNCTION YTD_GROUP(@GROUP VARCHAR(50))
RETURNS MONEY
AS
BEGIN
DECLARE @YTDSALES AS MONEY
SELECT @YTDSALES = SUM(SALESYTD) FROM [Sales].[SalesTerritory]
WHERE [Group] = @GROUP
RETURN @YTDSALES
END

DECLARE @RESULTS AS MONEY
SELECT @RESULTS = DBO.YTD_GROUP('NORTH AMERICA')
PRINT @RESULTS

--------------- FUNCTION RETURNING TABLE

CREATE FUNCTION ST_TABVALUED(@TERRITORYID INT)
RETURNS TABLE
AS RETURN
SELECT NAME, COUNTRYREGIONCODE, [GROUP], SALESYTD FROM [Sales].[SalesTerritory]
WHERE TerritoryID = @TERRITORYID

SELECT *FROM DBO.ST_TABVALUED(4)

-------------- TRANSACTIONS

SELECT * FROM [Sales].[SalesTerritory]

BEGIN TRANSACTION
	UPDATE [Sales].[SalesTerritory]
	SET CostYTD = 1.00
	WHERE TerritoryID = 1
COMMIT TRANSACTION

--@@error 0 - SUCCESS, > 0 MEANS ERROR

DECLARE @ERRORRESULTS VARCHAR(50)
BEGIN TRANSACTION
INSERT INTO [Sales].[SalesTerritory]
			([Name]
			,[CountryRegionCode]
			,[Group]
			,[SalesYTD]
			,[SalesLastYear]
			,[CostYTD]
			,[CostLastYear]
			,[rowguid]
			,[ModifiedDate])
		VALUES
			('ABC',
			'US',
			'NA',
			1.00,
			1.00,
			1.00,
			1.00,
			'43689A10-E30B-497F-B0DE-11DX20267FF3',
			GETDATE())

SET @ERRORRESULTS = @@ERROR
IF @ERRORRESULTS = 0
BEGIN
	PRINT 'SUCCESS!!!'
	COMMIT TRANSACTION
END
ELSE
BEGIN
	PRINT 'STATEMENT FAILED!'
	ROLLBACK TRANSACTION
END

--- TRY AND CATCH

BEGIN TRY
BEGIN TRANSACTION
INSERT INTO [Sales].[SalesTerritory]
			([Name]
			,[CountryRegionCode]
			,[Group]
			,[SalesYTD]
			,[SalesLastYear]
			,[CostYTD]
			,[CostLastYear]
			,[rowguid]
			,[ModifiedDate])
		VALUES
			('ABC',
			'US',
			'NA',
			1.00,
			1.00,
			1.00,
			1.00,
			'43689A10-E30B-497F-B0DE-11DX20267FF3',
			GETDATE())

			COMMIT TRANSACTION

END TRY

BEGIN CATCH
	PRINT 'ERROR - CATCH STATEMENT'
	ROLLBACK TRANSACTION
END CATCH

--- CTE

SELECT * FROM [Sales].[SalesTerritory]

WITH CTE_SALESTERR
AS
(
SELECT NAME, COUNTRYREGIONCODE
FROM [Sales].[SalesTerritory]
)

SELECT * FROM CTE_SALESTERR
WHERE NAME LIKE 'NORTH%'

----GROUP

SELECT NAME, NULL, NULL, SUM(SalesYTD)
FROM [Sales].[SalesTerritory]
GROUP BY Name

UNION ALL

SELECT NAME, CountryRegionCode, NULL, SUM(SalesYTD)
FROM [Sales].[SalesTerritory]
GROUP BY Name, CountryRegionCode

UNION ALL

SELECT NAME, CountryRegionCode, [GROUP], SUM(SalesYTD)
FROM [Sales].[SalesTerritory]
GROUP BY Name, CountryRegionCode, [GROUP]

--GROUP SETS

SELECT NAME, CountryRegionCode, [GROUP], SUM(SalesYTD)
FROM [Sales].[SalesTerritory]
GROUP BY GROUPING SETS
(
	(NAME),
	(NAME, CountryRegionCode),
	(NAME, CountryRegionCode,[GROUP])
)

--ROLL UP
SELECT NAME, CountryRegionCode, [GROUP], SUM(SalesYTD)
FROM [Sales].[SalesTerritory]
GROUP BY ROLLUP
(
	(NAME, CountryRegionCode,[GROUP])
)

-- CUBE
SELECT NAME, CountryRegionCode, [GROUP], SUM(SalesYTD)
FROM [Sales].[SalesTerritory]
GROUP BY CUBE
(
	(NAME, CountryRegionCode,[GROUP])
)

--- RANK FUNCTIONS

SELECT * FROM [Person].[Address]
WHERE PostalCode IN ('98052','98027','98055','97205')

SELECT POSTALCODE
,ROW_NUMBER() OVER (ORDER BY POSTALCODE) AS 'ROW NUMBER'
,RANK() OVER (ORDER BY POSTALCODE) AS 'RANK'
,DENSE_RANK() OVER (ORDER BY POSTALCODE) AS 'DENSE RANK'
,NTILE(10) OVER (ORDER BY POSTALCODE) AS 'NTILE'
FROM [Person].[Address]
WHERE PostalCode IN ('98052','98027','98055','97205')

--- XML DATATYPE

SELECT * FROM [dbo].[samplexmltable]

INSERT INTO [dbo].[samplexmltable] VALUES
('<note>
<to>Tove</to>
<from>Jani</from>
<heading>Reminder</heading>
<body>Dont forget me this weekend!</body>
</note>')

SELECT * FROM [Sales].[SalesTerritory]
FOR XML AUTO, ELEMENTS, ROOT ('SALESTERRITORY')

SELECT * FROM [Sales].[SalesTerritory]
FOR XML RAW, ELEMENTS, ROOT ('SALESTERRITORY')

-- XML QUERY TO TAKE SPECIFIC VALUES

SELECT [XMLDATA].query ('/note/to') AS [to]
FROM [dbo].[samplexmltable]

SELECT [XMLDATA].value ('(/note/to)[1]','varchar(10)') AS [to]
FROM [dbo].[samplexmltable]

SELECT TOP 10 TerritoryID FROM [Sales].[SalesTerritory]
FOR XML AUTO, ELEMENTS, ROOT ('SALESTERRITORY')

DECLARE @xmlhandle INT
DECLARE @xmldocument XML

SET @xmldocument = (SELECT * FROM [Sales].[SalesTerritory]
FOR XML AUTO, ELEMENTS, ROOT ('SALESTERRITORY'))

EXEC sp_xml_preparedocument @xmlhandle output , @xmldocument

SELECT * FROM OPENXML(@xmlhandle, '/SALESTERRITORY/Sales.SalesTerritory',2)
WITH (TERRITORYID INT, SALESYTD MONEY)

EXEC sp_xml_removedocument @xmlhandle

-- PARTITION

CREATE PARTITION FUNCTION cust_part_func(int)
AS RANGE RIGHT
FOR VALUES (1000, 2000, 3000, 4000, 5000)

CREATE PARTITION SCHEME cust_part_scheme
AS PARTITION cust_part_func
TO (fgp1, fgp2, fgp3, fgp4, fgp5, fgp6)

CREATE TABLE PARTITION
(EMPID INT IDENTITY (1, 1) NOT NULL
EMPDATE DATETIME NULL
)
ON cust_part_scheme (empid)

DECLARE @i INT
SET @i = 0
WHILE @i<10000
BEGIN
INSERT INTO [PARTITION](empdate) VALUES (GETDATE())
SET @i = @i + 1
END

-- DYNAMIC QUERIES

-- PIVOT


-- GEOMETRY & GEOGRAPHY DATA

SELECT TOP 1000 
ID,
SPATIALDATA,
SpatialData.ToString() AS 'SPATIALDATA STRING',
SpatialData.AsGml() AS 'SPATIALDATA TEXT'
FROM [Spatialdb].[dbo].[Spatial]

INSERT INTO [Spatialdb].[dbo].[Spatial] (ID, SpatialData)
VALUES
(5, 'Point(7 12)'),
(3,'Linestring(0 0, 7 8)'),
(4, 'Polygon((0 0, 8 5, 9 6, 10 0, 0 0))')

