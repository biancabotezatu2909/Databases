USE [Art Gallery];
SET NOCOUNT ON;


IF EXISTS (SELECT [name] FROM sys.objects 
            WHERE object_id = OBJECT_ID('RandIntBetween'))
BEGIN
   DROP FUNCTION RandIntBetween;
END
GO

CREATE FUNCTION RandIntBetween(@lower INT, @upper INT, @rand FLOAT)
RETURNS INT
AS
BEGIN
  DECLARE @result INT;
  DECLARE @range INT = @upper - @lower + 1;
  SET @result = FLOOR(@rand * @range + @lower);
  RETURN @result;
END
GO

 
--Delete data from a table

GO
CREATE OR ALTER PROC deleteData
@table_id INT
AS
BEGIN
	
	-- we get the table name
	DECLARE @table_name NVARCHAR(50) = (
		SELECT [Name] FROM [Tables] WHERE TableID = @table_id
	)

	-- we declare the function we are about to execute
	DECLARE @function NVARCHAR(MAX)
	-- we set the function
	SET @function = N'DELETE FROM ' + @table_name
	PRINT @function
	-- we execute the function
	EXEC sp_executesql @function
END
GO
exec deleteData @table_id = 6
--Delete data from all tables

CREATE OR ALTER PROC deleteDataFromAllTables
@test_id INT
AS
BEGIN

	DECLARE @tableID INT
	DECLARE cursorForDelete cursor local for
		SELECT TT.TableID
		FROM TestTables TT
			INNER JOIN Tests T ON TT.TestID = T.TestID
		WHERE T.TestID = @test_id
		ORDER BY TT.Position DESC

	OPEN cursorForDelete
	FETCH cursorforDelete INTO @tableID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		exec deleteData @tableID

		FETCH NEXT FROM cursorForDelete INTO @tableID
	END
	CLOSE cursorForDelete
END
GO
exec deleteDataFromAllTables @test_id = 2


-- Insert data into Collections Table

-- Single-column primary key with no foreign keys.
CREATE OR ALTER PROCEDURE insertDataIntoCollections
    @nrOfRows INT,
	@tableName VARCHAR(50)
AS
BEGIN
    DECLARE @newCollectionID INT
    DECLARE @newCollectionName VARCHAR(20)
    DECLARE @newCollectionDescription VARCHAR(100)

    SET @newCollectionID = (SELECT ISNULL(MAX(collection_id), 0) + 1 FROM Collections)

    WHILE @nrOfRows > 0
    BEGIN
        SET @newCollectionName = (
            SELECT CHOOSE(CAST(RAND() * 10 AS INT) + 1, 'Collection1', 'Collection2', 'Collection3', 'Collection4', 'Collection5', 'Collection6', 'Collection7', 'Collection8', 'Collection9', 'Collection10')
        )

        WHILE @newCollectionName IS NULL
        BEGIN
            SET @newCollectionName = (
                SELECT CHOOSE(CAST(RAND() * 10 AS INT) + 1, 'Collection1', 'Collection2', 'Collection3', 'Collection4', 'Collection5', 'Collection6', 'Collection7', 'Collection8', 'Collection9', 'Collection10')
            )
        END

        SET @newCollectionDescription = (
            SELECT CHOOSE(CAST(RAND() * 10 AS INT) + 1, 'Description1', 'Description2', 'Description3', 'Description4', 'Description5', 'Description6', 'Description7', 'Description8', 'Description9', 'Description10')
        )

        WHILE @newCollectionDescription IS NULL
        BEGIN
            SET @newCollectionDescription = (
                SELECT CHOOSE(CAST(RAND() * 10 AS INT) + 1, 'Description1', 'Description2', 'Description3', 'Description4', 'Description5', 'Description6', 'Description7', 'Description8', 'Description9', 'Description10')
            )
        END

        INSERT INTO Collections (collection_id, collection_name, collection_description)
        VALUES (@newCollectionID, @newCollectionName, @newCollectionDescription)

        SET @nrOfRows = @nrOfRows - 1
        SET @newCollectionID = @newCollectionID + 1
    END
END
exec insertDataIntoCollections @nrOfRows = 10, @tableName = 'Collections'
--select* from Collections


CREATE OR ALTER PROCEDURE insertDataIntoArtworkMedia
    @nrOfRows INT,
	@tableName VARCHAR(50)
AS
BEGIN
    DECLARE @newMediaID INT
    DECLARE @newMediaType VARCHAR(20)

    WHILE @nrOfRows > 0
    BEGIN
        SET @newMediaID = (SELECT ISNULL(MAX(media_id), 0) + 1 FROM ArtworkMedia)

        SET @newMediaType = (SELECT TOP 1 CHOOSE(CAST(RAND() * 5 AS INT) + 1, 'Oil', 'Watercolor', 'Acrylic', 'Pencil', 'Digital'))
		WHILE @newMediaType IS NULL
        BEGIN
		SET @newMediaType = (
			SELECT TOP 1 CHOOSE(CAST(RAND() * 5 AS INT) + 1, 'Oil', 'Watercolor', 'Acrylic', 'Pencil', 'Digital'))
        END
		INSERT INTO ArtworkMedia (media_id, media_type)
        VALUES (@newMediaID, @newMediaType)

        SET @nrOfRows = @nrOfRows - 1
    END
END
exec insertDataIntoArtworkMedia @nrOfRows = 10, @tableName = 'ArtworkMedia'
select* from ArtworkMedia
delete from ArtworkMedia



CREATE OR ALTER PROCEDURE insertDataIntoArtworkCategories
    @nrOfRows INT,
	@tableName VARCHAR(50)
AS
BEGIN
    DECLARE @newCategoryID INT
    DECLARE @newCategoryName VARCHAR(20)

    WHILE @nrOfRows > 0
    BEGIN
        SET @newCategoryID = (SELECT ISNULL(MAX(category_id), 0) + 1 FROM ArtworkCategories)

        SET @newCategoryName = (SELECT TOP 1 CHOOSE(CAST(RAND() * 5 AS INT) + 1, 'Abstract', 'Portrait', 'Landscape', 'Still Life', 'Surreal'))
		WHILE @newCategoryName IS NULL
        BEGIN
		SET @newCategoryName = (
			SELECT TOP 1 CHOOSE(CAST(RAND() * 5 AS INT) + 1, 'Abstract', 'Portrait', 'Landscape', 'Still Life', 'Surreal'))
        END
        INSERT INTO ArtworkCategories (category_id, category_name)
        VALUES (@newCategoryID, @newCategoryName)

        SET @nrOfRows = @nrOfRows - 1
    END
END
exec insertDataIntoArtworkCategories @nrOfRows = 10, @tableName = 'ArtworkCategories'
--select* from ArtworkCategories
--delete from ArtworkCategories

--Multicolumn primary key

CREATE OR ALTER PROC insertDataIntoArtworkArtists
@nrOfRows INT, 
@tableName VARCHAR(50)
AS
BEGIN
	DECLARE @newArtworkID INT
    DECLARE @newArtistID INT
	SET @newArtworkID = (SELECT TOP 1 A.artwork_id
						FROM Artworks A TABLESAMPLE (1000 ROWS)
							ORDER BY NEWID())
		WHILE @newArtworkID is NULL
		BEGIN
			SET @newArtworkID = (SELECT TOP 1 A.artwork_id
				FROM Artworks A TABLESAMPLE (1000 ROWS)
					ORDER BY NEWID())
		END

	SET @newArtistID = (SELECT TOP 1 A.artist_id
						FROM Artists A TABLESAMPLE (1000 ROWS)
							ORDER BY NEWID())
		WHILE @newArtistID is NULL
		BEGIN
			SET @newArtistID = (SELECT TOP 1 A.artist_id
				FROM Artists A TABLESAMPLE (1000 ROWS)
					ORDER BY NEWID())
		END
		BEGIN TRY
		INSERT INTO ArtworkArtists(artwork_id, artist_id) VALUES(@newArtworkID, @newArtistID)
		END TRY
		BEGIN CATCH
		END CATCH
	
		SET @nrOfRows = @nrOfRows - 1
		--SET @newArtworkID = @newArtworkID + 1
END


CREATE OR ALTER PROCEDURE insertDataIntoArtworks
    @nrOfRows INT,
	@tableName VARCHAR(50)
AS
BEGIN
    DECLARE @newArtworkID INT
    DECLARE @newTitle VARCHAR(50)
    DECLARE @newMediumArt VARCHAR(50)
    DECLARE @newDimensions VARCHAR(50)
    DECLARE @newDateCreated DATE
    DECLARE @newDescriptionArt VARCHAR(100)
    DECLARE @newPrice INT
    DECLARE @newArtistID INT
    DECLARE @newCollectionID INT
    DECLARE @newCategoryID INT 
    DECLARE @newMediaID INT
    WHILE @nrOfRows > 0
    BEGIN
        SET @newArtworkID = (SELECT ISNULL(MAX(artwork_id), 0) + 1 FROM Artworks)

		--title
        SET @newTitle = (SELECT TOP 1 CHOOSE(CAST(RAND() * 5 AS INT) + 1, 'Abstract', 'Portrait', 'Landscape', 'Still Life', 'Surreal'))
		WHILE @newTitle IS NULL
        BEGIN
		SET @newTitle = (
			SELECT TOP 1 CHOOSE(CAST(RAND() * 5 AS INT) + 1, 'Abstract', 'Portrait', 'Landscape', 'Still Life', 'Surreal'))
        END

		--mediumArt
		SET @newMediumArt = (SELECT TOP 1 CHOOSE(CAST(RAND() * 5 AS INT) + 1, 'Abstract', 'Portrait', 'Landscape', 'Still Life', 'Surreal'))
		WHILE @newMediumArt IS NULL
        BEGIN
		SET @newMediumArt = (
			SELECT TOP 1 CHOOSE(CAST(RAND() * 5 AS INT) + 1, 'Abstract', 'Portrait', 'Landscape', 'Still Life', 'Surreal'))
        END

		--date created  @newDateCreated
		
		SET @newDateCreated = (
			SELECT TOP 1 DATEADD(day, ROUND(RAND() * DATEDIFF(day, '2000-01-01', '2023-12-31'), 0), '2000-01-01'))
		WHILE @newDateCreated IS NULL
        BEGIN
		SET @newDateCreated = (
			SELECT TOP 1 DATEADD(day, ROUND(RAND() * DATEDIFF(day, '2000-01-01', '2023-12-31'), 0), '2000-01-01'))
        END

		--@newDescriptionArt
		SET @newDescriptionArt = (SELECT TOP 1 CHOOSE(CAST(RAND() * 5 AS INT) + 1, 'Abstract', 'Portrait', 'Landscape', 'Still Life', 'Surreal'))
		WHILE @newDescriptionArt IS NULL
        BEGIN
		SET @newDescriptionArt = (
			SELECT TOP 1 CHOOSE(CAST(RAND() * 5 AS INT) + 1, 'Abstract', 'Portrait', 'Landscape', 'Still Life', 'Surreal'))
        END

		--@newPrice
		SET @newPrice = DBO.RandIntBetween(10, 500, RAND())

		--@newArtistID
		SET @newArtistID = (SELECT TOP 1 A.artist_id
						FROM Artists A TABLESAMPLE (1000 ROWS)
							ORDER BY NEWID())
		WHILE @newArtistID is NULL
		BEGIN
			SET @newArtistID = (SELECT TOP 1 A.artist_id
				FROM Artists A TABLESAMPLE (1000 ROWS)
					ORDER BY NEWID())
		END

		--@newCollectionID
		SET @newCollectionID = (SELECT TOP 1 C.collection_id
						FROM Collections C TABLESAMPLE (1000 ROWS)
							ORDER BY NEWID())
		WHILE @newCollectionID is NULL
		BEGIN
			SET @newCollectionID = (SELECT TOP 1 C.collection_id
						FROM Collections C TABLESAMPLE (1000 ROWS)
							ORDER BY NEWID())
		END

		--@newCategoryID
		SET @newCategoryID = (SELECT TOP 1 A.category_id
						FROM ArtworkCategories A TABLESAMPLE (1000 ROWS)
							ORDER BY NEWID())
		WHILE @newCategoryID is NULL
		BEGIN
			SET @newCategoryID = (SELECT TOP 1 A.category_id
						FROM ArtworkCategories A TABLESAMPLE (1000 ROWS)
							ORDER BY NEWID())
		END

		--@newMediaID
		SET @newMediaID = (SELECT TOP 1 A.media_id
						FROM ArtworkMedia A TABLESAMPLE (1000 ROWS)
							ORDER BY NEWID())
		WHILE @newMediaID is NULL
		BEGIN
			SET @newMediaID = (SELECT TOP 1 A.media_id
						FROM ArtworkMedia A TABLESAMPLE (1000 ROWS)
							ORDER BY NEWID()))
		END

        INSERT INTO Artworks (artwork_id, title, medium_art, dimensions, date_created, description_art, price, artist_id, collection_id, category_id, media_id)
		VALUES(@newArtworkID, @newTitle, @newMediumArt, @newDimensions, @newDateCreated, @newDescriptionArt, @newPrice, @newArtistID, @newCollectionID, @newCategoryID, @newMediaID)
        SET @nrOfRows = @nrOfRows - 1
    END
END

CREATE OR ALTER PROCEDURE insertDataIntoArtworks
    @nrOfRows INT,
	@tableName VARCHAR(50)
AS
BEGIN
    DECLARE @newArtworkID INT
    DECLARE @newTitle VARCHAR(50)
    DECLARE @newMediumArt VARCHAR(50)
    DECLARE @newDimensions VARCHAR(50)
    DECLARE @newDateCreated DATE
    DECLARE @newDescriptionArt VARCHAR(100)
    DECLARE @newPrice INT
    DECLARE @newArtistID INT
    DECLARE @newCollectionID INT
    DECLARE @newCategoryID INT 
    DECLARE @newMediaID INT

    WHILE @nrOfRows > 0
    BEGIN
        SET @newArtworkID = (SELECT ISNULL(MAX(artwork_id), 0) + 1 FROM Artworks)

		--title
        SET @newTitle = (SELECT TOP 1 CHOOSE(CAST(RAND() * 5 AS INT) + 1, 'Abstract', 'Portrait', 'Landscape', 'Still Life', 'Surreal'))
		WHILE @newTitle IS NULL
        BEGIN
			SET @newTitle = (
				SELECT TOP 1 CHOOSE(CAST(RAND() * 5 AS INT) + 1, 'Abstract', 'Portrait', 'Landscape', 'Still Life', 'Surreal')
			)
        END

		--mediumArt
		SET @newMediumArt = (SELECT TOP 1 CHOOSE(CAST(RAND() * 5 AS INT) + 1, 'Abstract', 'Portrait', 'Landscape', 'Still Life', 'Surreal'))
		WHILE @newMediumArt IS NULL
        BEGIN
			SET @newMediumArt = (
				SELECT TOP 1 CHOOSE(CAST(RAND() * 5 AS INT) + 1, 'Abstract', 'Portrait', 'Landscape', 'Still Life', 'Surreal')
			)
        END

		--date created
		SET @newDateCreated = (
			SELECT TOP 1 DATEADD(day, ROUND(RAND() * DATEDIFF(day, '2000-01-01', '2023-12-31'), 0), '2000-01-01')
		)
		WHILE @newDateCreated IS NULL
        BEGIN
			SET @newDateCreated = (
				SELECT TOP 1 DATEADD(day, ROUND(RAND() * DATEDIFF(day, '2000-01-01', '2023-12-31'), 0), '2000-01-01')
			)
        END

		--@newDescriptionArt
		SET @newDescriptionArt = (SELECT TOP 1 CHOOSE(CAST(RAND() * 5 AS INT) + 1, 'Abstract', 'Portrait', 'Landscape', 'Still Life', 'Surreal'))
		WHILE @newDescriptionArt IS NULL
        BEGIN
			SET @newDescriptionArt = (
				SELECT TOP 1 CHOOSE(CAST(RAND() * 5 AS INT) + 1, 'Abstract', 'Portrait', 'Landscape', 'Still Life', 'Surreal')
			)
        END

		--@newPrice
		SET @newPrice = DBO.RandIntBetween(10, 500, RAND())

		--@newDimensions
		SET @newDimensions = DBO.RandIntBetween(100, 800, RAND())
		--@newArtistID
		SET @newArtistID = (
			SELECT TOP 1 A.artist_id
			FROM Artists A TABLESAMPLE (1000 ROWS)
			ORDER BY NEWID()
		)
		WHILE @newArtistID IS NULL
		BEGIN
			SET @newArtistID = (
				SELECT TOP 1 A.artist_id
				FROM Artists A TABLESAMPLE (1000 ROWS)
				ORDER BY NEWID()
			)
		END

		--@newCollectionID
		SET @newCollectionID = (
			SELECT TOP 1 C.collection_id
			FROM Collections C TABLESAMPLE (1000 ROWS)
			ORDER BY NEWID()
		)
		WHILE @newCollectionID IS NULL
		BEGIN
			SET @newCollectionID = (
				SELECT TOP 1 C.collection_id
				FROM Collections C TABLESAMPLE (1000 ROWS)
				ORDER BY NEWID()
			)
		END

		--@newCategoryID
		SET @newCategoryID = (
			SELECT TOP 1 A.category_id
			FROM ArtworkCategories A TABLESAMPLE (1000 ROWS)
			ORDER BY NEWID()
		)
		WHILE @newCategoryID IS NULL
		BEGIN
			SET @newCategoryID = (
				SELECT TOP 1 A.category_id
				FROM ArtworkCategories A TABLESAMPLE (1000 ROWS)
				ORDER BY NEWID()
			)
		END

		--@newMediaID
		SET @newMediaID = (
			SELECT TOP 1 A.media_id
			FROM ArtworkMedia A TABLESAMPLE (1000 ROWS)
			ORDER BY NEWID()
		)
		WHILE @newMediaID IS NULL
		BEGIN
			SET @newMediaID = (
				SELECT TOP 1 A.media_id
				FROM ArtworkMedia A TABLESAMPLE (1000 ROWS)
				ORDER BY NEWID()
			)
		END

        INSERT INTO Artworks (artwork_id, title, medium_art, dimensions, date_created, description_art, price, artist_id, collection_id, category_id, media_id)
		VALUES(@newArtworkID, @newTitle, @newMediumArt, @newDimensions, @newDateCreated, @newDescriptionArt, @newPrice, @newArtistID, @newCollectionID, @newCategoryID, @newMediaID)
        SET @nrOfRows = @nrOfRows - 1
    END
END

exec insertDataIntoArtworks @nrOfRows = 10, @tableName = 'Artworks'
--select* from Artworks
--delete from Artworks

-- Single-column primary key with one foreign key
CREATE OR ALTER PROC insertDataIntoArtistsBiographies
@nrOfRows INT,
@tableName VARCHAR(50)
AS
BEGIN
	DECLARE @newBiographyID INT
	DECLARE @newEducation VARCHAR(50)
	DECLARE @newCareerHighlights VARCHAR(50)
    DECLARE @newArtisticInfluences VARCHAR(50)
	DECLARE @newArtistID INT
	SET @newBiographyID = (SELECT MAX(biography_id) + 1 FROM ArtistsBiographies)
	if @newBiographyID is NULL
		SET @newBiographyID = 1
	WHILE @nrOfRows > 0
	BEGIN
				
		SET @newEducation = (
            SELECT CHOOSE(CAST(RAND() * 10 AS INT) + 1, 'Ed1', 'Ed2', 'Ed3', 'Ed4', 'Ed5', 'Ed6', 'Ed7', 'Ed8', 'Ed9', 'Ed10')
        )

        WHILE @newEducation IS NULL
        BEGIN
            SET @newEducation = (
                SELECT CHOOSE(CAST(RAND() * 10 AS INT) + 1, 'Ed1', 'Ed2', 'Ed3', 'Ed4', 'Ed5', 'Ed6', 'Ed7', 'Ed8', 'Ed9', 'Ed10')
            )
        END
		--CH = carrer highlights
        SET @newCareerHighlights = (
            SELECT CHOOSE(CAST(RAND() * 10 AS INT) + 1, 'CH1', 'CH2', 'CH3', 'CH4', 'CH5', 'CH6', 'CH7', 'CH8', 'CH9', 'CH10')
        )

        WHILE @newCareerHighlights IS NULL
        BEGIN
		SET @newCareerHighlights = (
            SELECT CHOOSE(CAST(RAND() * 10 AS INT) + 1, 'CH1', 'CH2', 'CH3', 'CH4', 'CH5', 'CH6', 'CH7', 'CH8', 'CH9', 'CH10')
        )
        END

		
		-- AI = artistic influences
		SET @newArtisticInfluences = (
            SELECT CHOOSE(CAST(RAND() * 10 AS INT) + 1, 'AI1', 'AI2', 'AI3', 'AI4', 'AI5', 'AI6', 'AI7', 'AI8', 'AI9', 'AI10')
        )

        WHILE @newArtisticInfluences IS NULL
        BEGIN
		SET @newArtisticInfluences = (
            SELECT CHOOSE(CAST(RAND() * 10 AS INT) + 1, 'AI1', 'AI2', 'AI3', 'AI4', 'AI5', 'AI6', 'AI7', 'AI8', 'AI9', 'AI10')
        )
        END

		SET @newArtistID = (SELECT TOP 1 A.artist_id
						FROM Artists A TABLESAMPLE (1000 ROWS)
							ORDER BY NEWID())
		WHILE @newArtistID is NULL
		BEGIN
			SET @newArtistID = (SELECT TOP 1 A.artist_id
				FROM Artists A TABLESAMPLE (1000 ROWS)
					ORDER BY NEWID())
		END

		INSERT INTO ArtistsBiographies(biography_id, education, career_highlights, artistic_influences, artist_id) VALUES(@newBiographyID, @newEducation, @newCareerHighlights, @newArtisticInfluences, @newArtistID)
		SET @nrOfRows = @nrOfRows - 1
		SET @newBiographyID = @newBiographyID + 1
	END
END
GO


exec insertDataIntoArtistsBiographies @nrOfRows = 10, @tableName = 'ArtistBiographies'
select* from ArtistsBiographies
delete from ArtistsBiographies


CREATE OR ALTER PROCEDURE insertDataIntoGalleryStaff
    @nrOfRows INT,
	@tableName VARCHAR(50)
AS
BEGIN
    DECLARE @newStaffID INT
    DECLARE @newStaffName VARCHAR(50)
    DECLARE @newPosition VARCHAR(50)
    DECLARE @newContactInfo VARCHAR(50)

	SET @newStaffID = (SELECT ISNULL(MAX(staff_id), 0) + 1 FROM GalleryStaff)

    WHILE @nrOfRows > 0
    BEGIN

        SET @newStaffName = (SELECT CHOOSE(CAST(RAND() * 10 AS INT) + 1, 'John', 'Alice', 'Bob', 'Emma', 'Charlie', 'Olivia', 'David', 'Sophia', 'James', 'Ava'))
		 WHILE @newStaffName IS NULL
        BEGIN
		SET @newStaffName = (
			SELECT CHOOSE(CAST(RAND() * 10 AS INT) + 1, 'John', 'Alice', 'Bob', 'Emma', 'Charlie', 'Olivia', 'David', 'Sophia', 'James', 'Ava'))
        END

        SET @newPosition = (SELECT CHOOSE(CAST(RAND() * 5 AS INT) + 1, 'Manager', 'Clerk', 'Curator', 'Security', 'Janitor'))
		WHILE @newPosition IS NULL
        BEGIN
		SET @newPosition = (
			SELECT CHOOSE(CAST(RAND() * 5 AS INT) + 1, 'Manager', 'Clerk', 'Curator', 'Security', 'Janitor')) 
		END

        SET @newContactInfo = (SELECT CHOOSE(CAST(RAND() * 5 AS INT) + 1, 'Email@example.com', 'Phone: XXX-XXX-XXXX', 'Mobile: XXX-XXX-XXXX', 'Skype: username', 'LinkedIn: profile'))
		WHILE @newContactInfo IS NULL
        BEGIN
		SET @newContactInfo = (
			SELECT CHOOSE(CAST(RAND() * 5 AS INT) + 1, 'Email@example.com', 'Phone: XXX-XXX-XXXX', 'Mobile: XXX-XXX-XXXX', 'Skype: username', 'LinkedIn: profile'))        
        END

		INSERT INTO GalleryStaff (staff_id, staff_name, position, contact_info)
        VALUES (@newStaffID, @newStaffName, @newPosition, @newContactInfo)
        SET @nrOfRows = @nrOfRows - 1
		SET @newStaffID = @newStaffID + 1
	END
END

exec insertDataIntoGalleryStaff @nrOfRows = 10, @tableName = 'GalleryStaff'
--select* from GalleryStaff
--delete from GalleryStaff


--Insert data in a specific table

CREATE OR ALTER PROC insertData
@testRunID INT,
@testID INT,
@tableID INT
AS
BEGIN
	--starting time before test runs
	DECLARE @startTime DATETIME = SYSDATETIME()

	-- we get the name of the table based on the tableID
	DECLARE @tableName VARCHAR(50) = (
		SELECT [Name] FROM [Tables] WHERE TableID = @tableID
	)

	PRINT 'Insert data into table ' + @tableName

	-- we get the number of rows we have to insert based on the tableID and on the testID
	DECLARE @nrOfRows INT = (
		SELECT [NoOfRows] FROM TestTables  
			WHERE TestID = @testID AND TableID = @tableID
	)
	if @tableName = 'Collections'
		EXEC insertDataIntoCollections @nrOfRows, @tableName

	else if @tableName = 'ArtistsBiographies'
		EXEC insertDataIntoArtistsBiographies @nrOfRows, @tableName

	else if @tableName = 'ArtworkArtists'
		EXEC insertDataIntoArtworkArtists @nrOfRows, @tableName
	
	else if @tableName = 'GalleryStaff'
		EXEC insertDataIntoGalleryStaff @nrOfRows, @tableName
	
	else if @tableName = 'ArtworkMedia'
		EXEC insertDataIntoArtworkMedia @nrOfRows, @tableName
	
	else if @tableName = 'ArtworkCategories'
		EXEC insertDataIntoArtworkCategories @nrOfRows, @tableName
	
	else if @tableName = 'Artworks'
		EXEC insertDataIntoArtworks @nrOfRows, @tableName
	-- we get the end time of the test
	DECLARE @endTime DATETIME = SYSDATETIME()

	-- we insert the performance
	INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt)
		VALUES (@testRunID, @tableID, @startTime, @endTime)

END
GO
EXEC insertData @testRunID = 1, @testID = 1, @tableID = 7;
select* from ArtworkArtists
--Insert data into all tables

CREATE OR ALTER PROCEDURE insertDataIntoAllTables
@testRunID INT,
@testID INT
AS
BEGIN
	DECLARE @tableID INT
	DECLARE cursorForInsert CURSOR LOCAL FOR
		SELECT TableID
		FROM TestTables TT
			INNER JOIN Tests T on TT.TestID = T.TestID
		WHERE T.TestID = @testID
		ORDER BY TT.Position ASC
	
	OPEN cursorForInsert
	FETCH cursorForInsert INTO @tableID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC insertData @testRunID, @testID, @tableID

		FETCH NEXT FROM cursorForInsert INTO @tableID
	END
	CLOSE cursorForInsert
END
GO
exec insertDataIntoAllTables @testRunID = 1, @testID = 1


CREATE OR ALTER PROCEDURE insertDataIntoAllTables
@testRunID INT,
@testID INT
AS
BEGIN
	DECLARE @tableID INT
	DECLARE cursorForInsert CURSOR LOCAL FOR
		SELECT TableID
		FROM TestTables TT
			INNER JOIN Tests T ON TT.TestID = T.TestID
		WHERE T.TestID = @testID
		ORDER BY TT.Position ASC
	
	OPEN cursorForInsert
	FETCH cursorForInsert INTO @tableID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @startTime DATETIME = SYSDATETIME()
		DECLARE @endTime DATETIME

		-- Your existing logic for executing insertData
		EXEC insertData @testRunID, @testID, @tableID

		SET @endTime = SYSDATETIME()

		-- Add a check for existing rows before inserting
		IF NOT EXISTS (SELECT 1 FROM TestRunTables WHERE TestRunID = @testRunID AND TableID = @tableID)
		BEGIN
			INSERT INTO TestRunTables (TestRunID, TableID, StartAt, EndAt)
			VALUES (@testRunID, @tableID, @startTime, @endTime)
		END
		ELSE
		BEGIN
			-- Handle update logic if needed
			-- You may update StartAt and EndAt or take other actions
			UPDATE TestRunTables
			SET StartAt = @startTime, EndAt = @endTime
			WHERE TestRunID = @testRunID AND TableID = @tableID
		END

		FETCH NEXT FROM cursorForInsert INTO @tableID
	END
	CLOSE cursorForInsert
END


-- ----------------------------------------------------------CREATE VIEWS----------------------------------------------
-- a view with a SELECT statement operating on one table
CREATE OR ALTER VIEW allCollections
AS
	SELECT *
	FROM Collections
GO

-- a view with a SELECT statement operating on at least 2 tables

-- A View that joins ArtworkMedia and ArtworkCategories
CREATE OR ALTER VIEW MediaCategoryView
AS
SELECT
    AM.media_id,
    AM.media_type,
    AC.category_id,
    AC.category_name
FROM
    ArtworkMedia AM
JOIN
    ArtworkCategories AC ON AM.media_id = AC.category_id;

--SELECT * FROM MediaCategoryView;


-- a view with a SELECT statement that has a GROUP BY clause and operates on at least 2 tables

-- Create or alter the view
CREATE OR ALTER VIEW ArtworksInCollectionsView
AS
SELECT
    C.collection_id,
    C.collection_name,
    COUNT(AA.artwork_id) AS total_artworks
FROM
    Collections C
JOIN
    Artworks A ON C.collection_id = A.collection_id
JOIN
    ArtworkArtists AA ON A.artwork_id = AA.artwork_id
GROUP BY
    C.collection_id, C.collection_name;

SELECT* from ArtworksInCollectionsView


--Select data from a specific view

CREATE OR ALTER PROC selectDataView
@viewID INT,
@testRunID INT
AS
BEGIN
	-- starting time before test runs
	DECLARE @startTime DATETIME = SYSDATETIME()

	DECLARE @viewName VARCHAR(100) = (
		SELECT [Name] FROM [Views]
			WHERE ViewID = @viewID
	)

	PRINT 'Selecting from view ' + @viewName

	DECLARE @query NVARCHAR(200) = N'SELECT * FROM '  + @viewName
	EXEC sp_executesql @query

	-- ending time after test
	DECLARE @endTime DATETIME = SYSDATETIME()

	INSERT INTO TestRunViews(TestRunID, ViewID, StartAt, EndAt)
		VALUES(@testRunID, @viewID, @startTime, @endTime)

END
GO

--DECLARE @viewID INT = 1; -- Replace with the actual ViewID
--DECLARE @testRunID INT = 1; -- Replace with the actual TestRunID

EXEC selectDataView @viewID = 1, @testRunID = 1;
SELECT * FROM TestRunViews;

--SELECT data from all views

CREATE OR ALTER PROC selectDataFromAllViews
@testRunID INT,
@testID INT
AS
BEGIN
	PRINT 'Select all view for test = ' + convert(VARCHAR, @testID)

	DECLARE @viewID INT

	DECLARE cursorForViews CURSOR LOCAL FOR
		SELECT TV.ViewID FROM TestViews TV
			INNER JOIN Tests T on T.TestID = TV.TestID
		WHERE TV.TestID = @testID

	OPEN cursorForViews
	FETCH cursorForViews INTO @viewID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- We select the view
		EXEC selectDataView @viewID, @testRunID
		FETCH NEXT FROM cursorForViews INTO @viewID
	END
	CLOSE cursorForViews
END
GO


--Run a test
CREATE OR ALTER PROC runTest
@testID INT,
@description VARCHAR(5000)
AS
BEGIN
	PRINT 'Running test with id: ' + CONVERT(VARCHAR, @testID) + ' with description: ' + @description

	-- We create a test run
	INSERT INTO TestRuns([Description]) values (@description)

	-- Get the current testRunID
	DECLARE @testRunID INT = (SELECT MAX(TestRunID) FROM TestRuns)

	-- Get the starting time before the test runs
	DECLARE @startTime DATETIME = SYSDATETIME()

	--Run all the inserts
	EXEC insertDataIntoAllTables @testRunID, @testID

	--Run all the views
	EXEC selectDataFromAllViews @testRunID, @testID

	-- Get the ending time after the test runs
	DECLARE @endTIME DATETIME = SYSDATETIME()

	--Delete all the data
	EXEC deleteDataFromAllTables @testID
	
	-- Now we update the start time and the end time for the entire RUN
	UPDATE [TestRuns] SET StartAt = @startTime, EndAt = @endTIME

	-- Compute the total number of seconds the test took
	DECLARE @totalTime INT = DATEDIFF(SECOND, @startTime, @endTime)

	PRINT 'Test with id = ' + CONVERT(VARCHAR, @testID) + ' took ' + CONVERT(VARCHAR, @totalTime) + ' seconds to execute !'

END
GO

--Run all tests

CREATE OR ALTER PROC runAllTests
AS
BEGIN
	DECLARE @testName VARCHAR(50)
	DECLARE @testID INT

	DECLARE cursorForTests CURSOR LOCAL FOR
		SELECT * FROM Tests

	OPEN cursorForTests
	FETCH cursorForTests INTO @testID, @testName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'Running ' + @testName + ' with id: ' + CONVERT(VARCHAR, @testID)

		-- Now we run the test
		EXEC runTest @testID, ' perfect ;P'

		FETCH NEXT FROM cursorForTests INTO @testID, @testName
	END
	CLOSE cursorForTests
END
GO

/*
1	Collections
2	ArtworkMedia
3	ArtworkCategories
4	Artworks
5	ArtworkArtists
6	GalleryStaff
7	ArtistsBiographies
*/

INSERT INTO [Tables]([Name])
VALUES ('Collections'), ('ArtworkMedia'), ('ArtworkCategories'), ('Artworks'), ('ArtworkArtists'), ('GalleryStaff'), ('ArtistsBiographies')


INSERT INTO [Tests]([Name])
VALUES ('Test 1'), ('Test 2')

--select* from [Tables]
--delete from [Tables]


INSERT INTO [TestTables]([TestID], [TableID], [NoOfRows], [Position])
VALUES
	(1,1,400,1),
	(1,2,100,2),
	(1,3,100,3),
	(1,4,100,4),
	(1,5,100,5),
	(1,6,100,6),
	(1,7,100,7),
	(2,1,300,1),
	(2,2,800,2),
	(2,3,600,3),
	(2,4,200,4),
	(2,5,500,5),
	(2,6,600,6),
	(2,7,200,7)
 delete from [TestTables]

	-- Insert data into [TestTables]
	-- another set of tests (smaller)
INSERT INTO [TestTables]([TestID], [TableID], [NoOfRows], [Position])
VALUES
    (1, 1, 40, 1),
    (1, 2, 10, 2),
    (1, 3, 10, 3),
    (1, 4, 10, 4),
    (1, 5, 10, 5),
    (1, 6, 10, 6),
    (1, 7, 10, 7),
    (2, 1, 30, 1)

select* from [TestTables]
SELECT* from [Views]
select* from [TestViews]

INSERT INTO [Views]([Name])
VALUES
	('allCollections'),
	('MediaCategoryView'),
	('ArtworksInCollectionsView')

INSERT INTO [TestViews]([TestID], [ViewID])
VALUES
	(1,1),
	(2,1),
	(2,2),
	(2,3)
GO
----------------------RUN-------------------------------
EXEC runTest 1, 'this is a test'

EXEC runAllTests
------------------------------------------------------


-- RELATIONAL STRUCTURE TABLES
SELECT* FROM [Tables]
SELECT* FROM Tests
SELECT* FROM TestTables
SELECT* FROM [Views]
SELECT* FROM [TestViews]

SELECT * FROM TestRunTables
SELECT * FROM TestRuns
SELECT * FROM TestRunViews

