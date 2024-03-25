use [Art Gallery]


DROP TABLE IF EXISTS CollectorsContestRegistration;
DROP TABLE IF EXISTS Collector;
DROP TABLE IF EXISTS CollectorsContest;


-- Ta(aid, a2, …) => aid = collectorID, a2 = rank
CREATE TABLE Collector(
	collectorID INT NOT NULL PRIMARY KEY,
	rank INT UNIQUE NOT NULL,
	name VARCHAR(50) NOT NULL
);


--Tb(bid, b2, …) => bid = collectorContestID, b2 = points
CREATE TABLE CollectorsContest(
	collectorContestID INT NOT NULL PRIMARY KEY,
	points INT NOT NULL,
	name VARCHAR(50) NOT NULL
);

-- Tc(cid, aid, bid, …) => cid = ccrID, aid = collectorID, bid = collectorContestID
CREATE TABLE CollectorsContestRegistration(
	ccrID INT NOT NULL PRIMARY KEY,
	collectorID INT NOT NULL REFERENCES Collector(collectorID) ON DELETE CASCADE ON UPDATE CASCADE,
	collectorContestID INT NOT NULL REFERENCES CollectorsContest(collectorContestID) ON DELETE CASCADE ON UPDATE CASCADE
);


-- insert random data in Ta

DROP PROCEDURE IF EXISTS insertIntoCollector;
GO

CREATE PROCEDURE insertIntoCollector (@rows INT) AS
BEGIN
	DECLARE @collector INT = 1;
	DECLARE @rank INT = 1;
	DECLARE @name VARCHAR(50) = 'Default Name';

	WHILE @rows > 0
	BEGIN
		INSERT INTO Collector (collectorID, rank, name)
		VALUES (@collector, @rank, @name);

		SET @collector = @collector + 1;
		SET @rank = @rank + 1;
		SET @rows = @rows - 1;
	END
	
END
GO


-- insert random data in Tb

DROP PROCEDURE IF EXISTS insertIntoCollectorsContest;
GO

CREATE PROCEDURE insertIntoCollectorsContest (@rows INT) AS
BEGIN
	DECLARE @contest INT = 1;
	DECLARE @points INT = 1000;
	DECLARE @name VARCHAR(50) = 'Default Contest';

	WHILE @rows > 0
	BEGIN
		INSERT INTO CollectorsContest (collectorContestID, points, name)
		VALUES (@contest, @points, @name);

		SET @contest = @contest + 1;
		SET @points = @points + 100;
		IF @points > 1500
			SET @points = 1000;
		SET @rows = @rows - 1;
	END

END
GO


-- insert random data in Tc

DROP PROCEDURE IF EXISTS insertIntoCollectorContestsRegistration;
GO

CREATE PROCEDURE insertIntoCollectorsContestRegistration (@rows INT) AS
BEGIN
	DECLARE @registration INT = 1;
	DECLARE @collector INT = 1;
	DECLARE @contest INT = 1;

	WHILE @rows > 0
	BEGIN
		INSERT INTO CollectorsContestRegistration (ccrID, collectorID, collectorContestID)
		VALUES (@registration, @collector, @contest);

		SET @registration = @registration + 1;
		SET @collector = @collector + 1;
		SET @contest = @contest + 1;
		SET @rows = @rows - 1;
	END

END
GO


-- populate the tables

DELETE FROM CollectorsContestRegistration ;
DELETE FROM Collector ;
DELETE FROM CollectorsContest;

EXEC insertIntoCollector 10000;
EXEC insertIntoCollectorsContest 10000;
EXEC insertIntoCollectorsContestRegistration 10000;


-----------------------------------------------------------------------------------------------
/*
a. Write queries on Ta such that their execution plans contain the following operators:

	- clustered index scan;
	- clustered index seek;
	- nonclustered index scan;
	- nonclustered index seek;
	- key lookup.
*/

EXEC sp_helpindex Collector;

-- PK: collectorID => automatically created clustered index
-- unique: rank => automatically created unclustered index

-- clustered index scan => touch every row in the table

SELECT * FROM Collector;

-- clustered index seek => returns a specific subset from the clustered index

SELECT * FROM Collector
WHERE collectorID < 1000;

-- nonclustered index scan => scan the entire nonclustered index

SELECT rank FROM Collector;

-- nonclustered index seek => returns a specific subset from the nonclustered index

SELECT rank FROM Collector
WHERE rank < 100;

-- key lookup => nonclustered index seek + additional data needed

SELECT name, rank FROM Collector
WHERE rank = 1234;


-----------------------------------------------------------------------------------------------
/*
b. Write a query on table Tb with a WHERE clause of the form WHERE b2 = value and analyze its execution plan. 
Create a nonclustered index that can speed up the query. Examine the execution plan again.
*/
-- first it's a clustered index scan
SELECT points FROM CollectorsContest
WHERE points = 1400;

DROP INDEX IF EXISTS CollectorsContestNonclustered ON CollectorsContest

CREATE NONCLUSTERED INDEX CollectorsContestNonclustered ON CollectorsContest(points)

-- now we have a nonclustered index seek, which is more efficient
SELECT points FROM CollectorsContest
WHERE points = 1400;


-----------------------------------------------------------------------------------------------
/*
c. Create a view that joins at least 2 tables. Check whether existing indexes are helpful; 
if not, reassess existing indexes / examine the cardinality of the tables.
*/

DROP VIEW IF EXISTS view1;
GO

CREATE VIEW view1 AS
	SELECT C.ccrID, C.collectorContestID, B.points, B.name FROM CollectorsContestRegistration C
	INNER JOIN CollectorsContest B ON C.collectorContestID = B.collectorContestID
	WHERE B.points > 1100;
GO

DECLARE @start1 DATETIME = GETDATE();
SELECT * FROM view1
DECLARE @end1 DATETIME = GETDATE();

PRINT 'WITHOUT INDEXES: start: ' + CONVERT(NVARCHAR(MAX), @start1) + ', end: ' + CONVERT(NVARCHAR(MAX), @end1) 
		+ ', total time: ' + CONVERT(NVARCHAR(MAX), DATEDIFF(millisecond, @start1, @end1)) + ' milliseconds';


DROP INDEX IF EXISTS Nonclustered1 ON CollectorsContest

CREATE NONCLUSTERED INDEX Nonclustered1 ON CollectorsContest(points)

DROP INDEX IF EXISTS Nonclustered2 ON CollectorsContest

CREATE NONCLUSTERED INDEX Nonclustered2 ON CollectorsContest(name)


DROP VIEW IF EXISTS view2;
GO

CREATE VIEW view2 AS
	SELECT C.ccrID, C.collectorContestID, B.points, B.name FROM CollectorsContestRegistration C
	INNER JOIN CollectorsContest B ON C.collectorContestID = B.collectorContestID
	WHERE B.points < 1100;
GO

DECLARE @start2 DATETIME = GETDATE();
SELECT * FROM view2
DECLARE @end2 DATETIME = GETDATE();

PRINT 'WITH INDEXES: start: ' + CONVERT(NVARCHAR(MAX), @start2) + ', end: ' + CONVERT(NVARCHAR(MAX), @end2) 
		+ ', total time: ' + CONVERT(NVARCHAR(MAX), DATEDIFF(millisecond, @start2, @end2)) + ' milliseconds';

DROP INDEX IF EXISTS Nonclustered1 ON CollectorsContest

CREATE NONCLUSTERED INDEX Nonclustered1 ON CollectorsContest(points)

DROP INDEX IF EXISTS Nonclustered2 ON CollectorsContest

CREATE NONCLUSTERED INDEX Nonclustered2 ON CollectorsContest(name)

