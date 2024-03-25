USE [Art Gallery];
--a. modify the type of a column;
-- Create or alter the stored procedure
CREATE OR ALTER PROCEDURE ModifyArtworksPrice
AS
BEGIN
    -- Check if the column exists before altering it
    IF COL_LENGTH('Artworks', 'price') IS NOT NULL
    BEGIN
        -- Modify the type of the 'price' column in the 'Artworks' table
        EXEC('
            ALTER TABLE Artworks
            ALTER COLUMN price DECIMAL(10,2);
        ');

        PRINT 'ALTER TABLE Artworks: Changed data type of price to DECIMAL(10,2)';
    END
    ELSE
    BEGIN
        PRINT 'Column price does not exist in table Artworks';
    END
END
GO

CREATE OR ALTER PROCEDURE UndoModifyArtworksPrice
AS
BEGIN
    -- Check if the column exists before reverting it
    IF COL_LENGTH('Artworks', 'price') IS NOT NULL
    BEGIN
        -- Revert the type of the 'price' column in the 'Artworks' table to INT
        EXEC('
            ALTER TABLE Artworks
            ALTER COLUMN price INT;
        ');

        PRINT 'ALTER TABLE Artworks: Reverted data type of price to INT';
    END
    ELSE
    BEGIN
        PRINT 'Column price does not exist in table Artworks';
    END
END
GO


exec ModifyArtworksPrice;
select* from Artworks;

exec UndoModifyArtworksPrice;
select* from Artworks;

--b. add / remove a column;
-- add a column
CREATE OR ALTER PROCEDURE AddNewColumnArtworks
AS
BEGIN
    -- Check if the column does not exist before adding it
    IF COL_LENGTH('Artworks', 'new_column') IS NULL
    BEGIN
        -- Add a new column 'new_column' to the 'Artworks' table
        EXEC('
            ALTER TABLE Artworks
            ADD new_column INT;
        ');

        PRINT 'ALTER TABLE Artworks: Added new_column';
    END
    ELSE
    BEGIN
        PRINT 'Column new_column already exists in table Artworks';
    END
END
GO
exec AddNewColumnArtworks;
select * from Artworks;

-- remove a column
CREATE OR ALTER PROCEDURE RemoveColumnArtworks
AS
BEGIN
	-- Check if the column exists before removing it
	IF COL_LENGTH('Artworks', 'new_column') IS NOT NULL
	BEGIN
	    -- Remove the column 'new_column' from the 'Artworks' table
		EXEC('
		     ALTER TABLE Artworks
			 DROP COLUMN new_column
			 ');
			 PRINT 'ALTER TABLE Artworks: Removed new_column';
	    END
		ELSE
		BEGIN
			PRINT 'Column new_column does not exist';
		END
END
GO

exec RemoveColumnArtworks;
select* from Artworks;

--c. add / remove a DEFAULT constraint;
CREATE OR ALTER PROCEDURE addDefaultToStyleToArtist 
AS
	ALTER TABLE Artists
		ADD CONSTRAINT default_style
			DEFAULT '' FOR style
GO


exec addDefaultToStyleToArtist;

-- remove default style from artist

CREATE OR ALTER PROCEDURE removeDefaultFromStyleFromArtist
AS
	ALTER TABLE Artists
		DROP CONSTRAINT default_style
GO

CREATE OR ALTER PROCEDURE removeDefaultFromStyleFromArtwork
AS
	ALTER TABLE Artworks
		DROP CONSTRAINT DF_Artworks_YourColumn;
GO
exec removeDefaultFromStyleFromArtist;


--g. create / drop a table.
-- create table ArtEvent

CREATE OR ALTER PROCEDURE addTableArtEvent
AS
	CREATE TABLE ArtEvent (
		id INT,
		name_event VARCHAR(50),
		event_date DATE,
		collection_id INT
	)
GO

exec addTableArtEvent;
select* from ArtEvent;

-- drop table ArtEvent

CREATE OR ALTER PROCEDURE dropTableArtEvent
AS
	DROP TABLE IF EXISTS ArtEvent
GO

exec dropTableArtEvent;
select* from ArtEvent;

--d. add / remove a primary key;
CREATE OR ALTER PROCEDURE addPrimaryKeyToArtEvent
AS
BEGIN
    -- Check if the primary key does not exist before adding it
	-- there is no existing primary key constraint
    IF NOT EXISTS (
        SELECT 1
        FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        WHERE TABLE_NAME = 'ArtEvent'
            AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    )
    BEGIN
        -- Make the 'id' column NOT NULL
        EXEC('
            ALTER TABLE ArtEvent
            ALTER COLUMN id INT NOT NULL;
        ');

        -- Add a primary key constraint to the 'id' column in the 'ArtEvent' table
        EXEC('
            ALTER TABLE ArtEvent
            ADD CONSTRAINT PK_ArtEvent_Id PRIMARY KEY (id);
        ');

        PRINT 'ALTER TABLE ArtEvent: Added primary key constraint to id column';
    END
    ELSE
    BEGIN
        PRINT 'Primary key constraint already exists on table ArtEvent';
    END
END
GO

 exec addPrimaryKeyToArtEvent


 CREATE OR ALTER PROCEDURE removePrimaryKeyFromArtEvent
AS
BEGIN
    -- Check if the primary key exists before removing it
    IF EXISTS (
        SELECT 1
        FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        WHERE TABLE_NAME = 'ArtEvent'
            AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    )
    BEGIN
        -- Remove the primary key constraint from the 'id' column in the 'ArtEvent' table
        EXEC('
            ALTER TABLE ArtEvent
            DROP CONSTRAINT PK_ArtEvent_Id;
        ');

        PRINT 'ALTER TABLE ArtEvent: Removed primary key constraint from table ArtEvent';
    END
    ELSE
    BEGIN
        PRINT 'Primary key constraint does not exist on table ArtEvent';
    END
END
GO

exec removePrimaryKeyFromArtEvent;


--e. add / remove a candidate key;
-- add candidate key to fan

CREATE OR ALTER PROCEDURE addCandidateKeyToArtEvent
AS
	ALTER TABLE ArtEvent
	ADD CONSTRAINT UQ_ArtEvent_Date UNIQUE (event_date);
GO

exec addCandidateKeyToArtEvent;

-- remove candidate key from art event

CREATE OR ALTER PROCEDURE removeCandidateKeyFromArtEvent
AS
	ALTER TABLE ArtEvent
		DROP CONSTRAINT IF EXISTS UQ_ArtEvent_Date
GO

exec removeCandidateKeyFromArtEvent;

-- Check if the unique constraint - event_date exists 
IF EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE TABLE_NAME = 'ArtEvent'
        AND CONSTRAINT_TYPE = 'UNIQUE'
        AND CONSTRAINT_NAME = 'UQ_ArtEvent_Date'
)
BEGIN
    PRINT 'Unique constraint event_date exists on the date event column';
END
ELSE
BEGIN
    PRINT 'Unique constraint event_date does not exist on the date event column';
END


--f. add / remove a foreign key;
-- Add a foreign key constraint to the 'collection_id' column in the ArtEvent table
CREATE OR ALTER PROCEDURE addArtEventForeignKey
AS
BEGIN
    -- Check if the foreign key constraint exists before attempting to add it
    IF NOT EXISTS (
        SELECT 1
        FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        WHERE TABLE_NAME = 'ArtEvent'
            AND CONSTRAINT_TYPE = 'FOREIGN KEY'
            AND CONSTRAINT_NAME = 'FK_ArtEvent_Collections'
    )
    BEGIN
        -- Add a foreign key constraint to the 'collection_id' column in the ArtEvent table
        EXEC('
            ALTER TABLE ArtEvent
            ADD CONSTRAINT FK_ArtEvent_Collections
            FOREIGN KEY (collection_id)
            REFERENCES Collections(collection_id);
        ');

        PRINT 'Foreign key constraint added to ArtEvent table';
    END
    ELSE
    BEGIN
        PRINT 'Foreign key constraint already exists on ArtEvent table';
    END
END
exec addArtEventForeignKey;

CREATE OR ALTER PROCEDURE removeArtEventForeignKey
AS
BEGIN
    -- Check if the foreign key constraint exists before attempting to remove it
    IF EXISTS (
        SELECT 1
        FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        WHERE TABLE_NAME = 'ArtEvent'
            AND CONSTRAINT_TYPE = 'FOREIGN KEY'
            AND CONSTRAINT_NAME = 'FK_ArtEvent_Collections'
    )
    BEGIN
        -- Remove the foreign key constraint from the 'collection_id' column in the ArtEvent table
        EXEC('
            ALTER TABLE ArtEvent
            DROP CONSTRAINT FK_ArtEvent_Collections;
        ');

        PRINT 'Foreign key constraint removed from ArtEvent table';
    END
    ELSE
    BEGIN
        PRINT 'Foreign key constraint does not exist on ArtEvent table';
    END
END
exec removeArtEventForeignKey;

-- Check if the foreign key constraint exists on the 'collection_id' column in the ArtEvent table
IF EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE TABLE_NAME = 'ArtEvent'
        AND CONSTRAINT_TYPE = 'FOREIGN KEY'
        AND CONSTRAINT_NAME = 'FK_ArtEvent_Collections'
)
BEGIN
    PRINT 'Foreign key constraint exists on the ArtEvent table';
END
ELSE
BEGIN
    PRINT 'Foreign key constraint does not exist on the ArtEvent table';
END

/* Create a new table that holds the current version of the database schema. 
   Simplifying assumption: the version is an integer number.*/

-- versions table

CREATE TABLE versionsTable (
	version INT
)

INSERT INTO versionsTable VALUES (1) --the initial version

CREATE TABLE proceduresTable (
	fromVersion INT,
	toVersion INT,
	PRIMARY KEY(fromVersion, toVersion),
	procedureName VARCHAR(100)
)

INSERT INTO proceduresTable
	(fromVersion, toVersion, procedureName)
VALUES
	(1, 2, 'ModifyArtworksPrice'),
	(2, 1, 'UndoModifyArtworksPrice'),
	(2, 3, 'AddNewColumnArtworks'),
	(3, 2, 'RemoveColumnArtworks'),
	(3, 4, 'addDefaultToStyleToArtist'),
	(4, 3, 'removeDefaultFromStyleFromArtist'),
	(4, 5, 'addTableArtEvent'),
	(5, 4, 'dropTableArtEvent'),
	(5, 6, 'addPrimaryKeyToArtEvent'),
	(6, 5, 'removePrimaryKeyFromArtEvent'),
	(6, 7, 'addCandidateKeyToArtEvent'),
	(7, 6, 'removeCandidateKeyFromArtEvent'),
	(7, 8, 'addArtEventForeignKey'),
	(8, 7, 'removeArtEventForeignKey');

	CREATE OR ALTER PROCEDURE goToVersion(@newVersion INT) 
AS
	DECLARE @current INT
	DECLARE @procedureName VARCHAR(100)
	SELECT @current = version FROM versionsTable
	
	IF  @newVersion < 1
		RAISERROR ('Bad version', 10, 1)
	IF  @newVersion > (SELECT MAX(toVersion) FROM proceduresTable)
		RAISERROR ('Bad version', 10, 1)
	ELSE
	BEGIN
		IF @newVersion = @current
			PRINT('Already on this version!');
		ELSE
		BEGIN
			IF @current > @newVersion
			BEGIN
				WHILE @current > @newVersion
				BEGIN
					SELECT @procedureName = procedureName FROM proceduresTable 
					WHERE fromVersion = @current AND toVersion = @current - 1
					PRINT('executing: ' + @procedureName);
					EXEC(@procedureName)
					SET @current = @current - 1
				END
			END

			IF @current < @newVersion
			BEGIN
				WHILE @current < @newVersion
					BEGIN
						SELECT @procedureName = procedureName FROM proceduresTable
						WHERE fromVersion = @current AND toVersion = @current + 1
						PRINT('executing: ' + @procedureName);
						EXEC (@procedureName)
						SET @current = @current + 1
					END
			END

			UPDATE versionsTable SET version = @newVersion
		END
	END
GO


EXEC goToVersion 10


SELECT * FROM proceduresTable;
SELECT * FROM versionsTable;
SELECT * FROM Artworks;
select* FROM Artists;
