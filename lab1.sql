 --DROP TABLE Artists; -- Uncomment this line if you want to drop and recreate the table

 CREATE TABLE ArtworkMedia (
    media_id INT PRIMARY KEY,
    media_type VARCHAR(20)
);

CREATE TABLE ArtworkCategories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(20)
);

CREATE TABLE Collections (
    collection_id INT PRIMARY KEY,
    collection_name VARCHAR(20),
    collection_description VARCHAR(100)
);

CREATE TABLE Artists (
    artist_id INT PRIMARY KEY,
    artist_name VARCHAR(50),
    birthdate DATE,
    nationality VARCHAR(50),
    biography VARCHAR(50),
    style VARCHAR(20)
);

CREATE TABLE Artworks (
    artwork_id INT PRIMARY KEY,
    title VARCHAR(50),
    medium_art VARCHAR(50),
    dimensions VARCHAR(50),
    date_created DATE,
    description_art VARCHAR(100),
    price INT,
    artist_id INT FOREIGN KEY (artist_id)
		REFERENCES Artists(artist_id),
    collection_id INT REFERENCES Collections(collection_id) on delete cascade on update cascade,
    category_id INT REFERENCES ArtworkCategories(category_id) on delete cascade on update cascade,
    media_id INT REFERENCES ArtworkMedia(media_id) on delete cascade on update cascade
);
select* from Artworks
CREATE TABLE ArtistsBiographies (
    biography_id INT PRIMARY KEY,
    education VARCHAR(50),
    career_highlights VARCHAR(50),
    artistic_influences VARCHAR(50),
    artist_id INT REFERENCES Artists(artist_id) on delete cascade on update cascade
);

CREATE TABLE GalleryStaff (
    staff_id INT PRIMARY KEY,
    staff_name VARCHAR(50),
    position VARCHAR(50),
    contact_info VARCHAR(50)
);

CREATE TABLE Exhibitions (
    exhibition_id INT PRIMARY KEY,
    exhibition_name VARCHAR(50),
    date_start DATE,
    date_end DATE,
    location_exhibition VARCHAR(50),
    description_exhibition VARCHAR(100),
    artwork_id INT REFERENCES Artworks(artwork_id),
    staff_id INT REFERENCES GalleryStaff(staff_id)
);



CREATE TABLE ArtworkAppraisals (
    appraisal_id INT PRIMARY KEY,
    appraisal_value INT,
    appraisal_date DATE,
    appraisal_name VARCHAR(50),
    appraisal_contact_info VARCHAR(50),
    artwork_id INT REFERENCES Artworks(artwork_id),
	artist_id INT REFERENCES Artworks(artwork_id)
);

CREATE TABLE SalesAndTransactions (
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    buyer_name VARCHAR(50),
    buyer_contact_info VARCHAR(80),
    sale_price INT,
    payment_method VARCHAR(20),
    artwork_id INT REFERENCES Artworks(artwork_id),
    appraisal_id INT REFERENCES ArtworkAppraisals(appraisal_id)
);

CREATE TABLE ArtworkArtists (
    artwork_id INT,
    artist_id INT,
    PRIMARY KEY (artwork_id, artist_id),
    FOREIGN KEY (artwork_id) REFERENCES Artworks(artwork_id) on delete cascade on update cascade,
    FOREIGN KEY (artist_id) REFERENCES Artists(artist_id) on delete cascade on update cascade
);

select* from Artists
select* from Artworks
-- Insert data into the Artists table
INSERT INTO Artists (artist_id, artist_name, birthdate, nationality, biography, style)
VALUES (2, 'Leonardo da Vinci', '1452-04-15', 'Italian', 'Renowned polymath, painter, and inventor.', 'Renaissance');
	
INSERT INTO Artists (artist_id, artist_name, birthdate, nationality, biography, style)
VALUES (3, 'Vincent van Gogh', '1853-03-30', 'Dutch', 'Post-Impressionist painter', 'Post-Impressionism');

INSERT INTO Artists (artist_id, artist_name, birthdate, nationality, biography, style)
VALUES (4, 'Pablo Picasso', '1881-10-25', 'Spanish', 'Pioneering Cubist artist.', 'Cubism');

INSERT INTO Artists (artist_id, artist_name, birthdate, nationality, biography, style)
VALUES (5, 'Michelangelo Buonarroti', '1475-03-06', 'Italian', 'Renowned sculptor and painter.', 'High Renaissance');	

INSERT INTO Artists (artist_id, artist_name, birthdate, nationality, biography, style)
VALUES (6, 'Rembrandt van Rijn', '1606-07-15', 'Dutch', 'Master of Dutch Golden Age painting.', 'Baroque');

INSERT INTO Artists (artist_id, artist_name, birthdate, nationality, biography, style)
VALUES (7, 'Claude Monet', '1840-11-14', 'French', 'Founder of French Impressionist painting.', 'Impressionism');

INSERT INTO Artists (artist_id, artist_name, birthdate, nationality, biography, style)
VALUES (8, 'Salvador Dalí', '1904-05-11', 'Spanish', 'Leading figure of Surrealism.', 'Surrealism');

INSERT INTO Artists (artist_id, artist_name, birthdate, nationality, biography, style)
VALUES (9, 'Frida Kahlo', '1907-07-06', 'Mexican', 'Self-portraits and symbolic art.', 'Surrealism');

INSERT INTO Artists (artist_id, artist_name, birthdate, nationality, biography, style)
VALUES (10, 'Georgia OKeeffe', '1887-11-15', 'American', 'Known for large-scale flower paintings.', 'Precisionism');

INSERT INTO Artists (artist_id, artist_name, birthdate, nationality, biography, style)
VALUES (11, 'Wassily Kandinsky', '1866-12-16', 'Russian', 'Pioneer of abstract art.', 'Abstract Art');

INSERT INTO Artists (artist_id, artist_name, birthdate, nationality, biography, style)
VALUES (12, 'Henri Matisse', '1869-12-31', 'French', 'Leading figure of Fauvism.', 'Fauvism');

INSERT INTO Artists (artist_id, artist_name, birthdate, nationality, biography, style)
VALUES (13, 'Gustav Klimt', '1862-07-14', 'Austrian', 'Symbolist painter and co-founder of the Vienna Secession movement.', 'Symbolism, Art Nouveau');

INSERT INTO Artists (artist_id, artist_name, birthdate, nationality, biography, style)
VALUES (14, 'Andy Warhol', '1928-08-06', 'American', 'Pop art pioneer and leading figure.', 'Pop Art');

INSERT INTO Artists (artist_id, artist_name, birthdate, nationality, biography, style)
VALUES (15, 'Andy Warhol', '1928-08-06', 'American', 'Pop art pioneer and leading figure.', 'Pop Art');

INSERT INTO Artists (artist_id, artist_name, birthdate, nationality, biography, style)
VALUES (16, 'Edvard Munch', '1863-12-12', 'Norwegian', 'Renowned for "The Scream."', 'Symbolism');

INSERT INTO Artists (artist_id, artist_name, birthdate, nationality, biography, style)
VALUES (17, 'Pierre-Auguste Renoir', '1841-02-25', 'French', 'Prominent Impressionist painter.', 'Impressionism');

INSERT INTO Artists (artist_id, artist_name, birthdate, nationality, biography, style)
VALUES (18, 'Hieronymus Bosch', '1450-01-11', 'Dutch', 'Famous for fantastical, symbolic art.', 'Northern Renaissance');

INSERT INTO Artists (artist_id, artist_name, birthdate, nationality, biography, style)
VALUES (19, 'Paul Cézanne', '1839-01-19', 'French', 'Post-Impressionist painter.', 'Post-Impressionism');

INSERT INTO Artists (artist_id, artist_name, birthdate, nationality, biography, style)
VALUES (20, 'Roy Lichtenstein', '1923-10-27', 'American', 'Leading figure of pop art.', 'Pop Art');

INSERT INTO Artists (artist_id, artist_name, birthdate, nationality, biography, style)
VALUES (21, 'Joan Miró', '1893-04-20', 'Spanish', 'Surrealist and abstract artist.', 'Surrealism');

select* from Artists

select* from ArtistsBiographies

-- Insert data into the ArtistsBiographies table
INSERT INTO ArtistsBiographies (biography_id, education, career_highlights, artistic_influences, artist_id)
VALUES
    (1, 'Studied at Art Academy', 'Exhibited in major galleries', 'Influenced by Van Gogh', 1),
    (2, 'PhD in Fine Arts', 'Won multiple awards', 'Inspired by Picasso', 2),
    (3, 'Master of Fine Arts', 'Published art books', 'Admired Monet', 3),
    (4, 'Self-taught artist', 'Known for unique style', 'Influenced by Klimt', 4),
    (5, 'Art degree from University', 'Curated art exhibitions', 'Inspired by Matisse', 5);
select* from ArtistsBiographies

-- Insert data into the GalleryStaff table
INSERT INTO GalleryStaff (staff_id, staff_name, position, contact_info)
VALUES
    (1, 'John Smith', 'Curator', 'j.smith@email.com'),
    (2, 'Emily Johnson', 'Gallery Director', 'e.johnson@email.com'),
    (3, 'Michael Brown', 'Art Consultant', 'm.brown@email.com'),
    (4, 'Sarah Davis', 'Exhibition Coordinator', 's.davis@email.com'),
    (5, 'David Lee', 'Marketing Manager', 'd.lee@email.com');
	
select* from GalleryStaff

-- Insert data into the Collections table
INSERT INTO Collections (collection_id, collection_name, collection_description)
VALUES (1, 'Classical Art', 'A collection of classical artworks');

INSERT INTO Collections (collection_id, collection_name, collection_description)
VALUES (2, 'Impressionism', 'A collection of Impressionist paintings');

INSERT INTO Collections (collection_id, collection_name, collection_description)
VALUES (3, 'Modern Art', 'A curated selection of contemporary artworks');

INSERT INTO Collections (collection_id, collection_name, collection_description)
VALUES (4, 'Renaissance', 'A collection of Renaissance art');

INSERT INTO Collections (collection_id, collection_name, collection_description)
VALUES (5, 'Abstract Art', 'A collection of abstract art');

INSERT INTO Collections (collection_id, collection_name, collection_description)
VALUES (6, 'Landscapes', 'A collection of landscape and seascape paintings');

INSERT INTO Collections (collection_id, collection_name, collection_description)
VALUES (7, 'Portraits', 'A collection of portrait paintings');

INSERT INTO Collections (collection_id, collection_name, collection_description)
VALUES (8, 'Sculptures', 'A collection of contemporary sculptures');

INSERT INTO Collections (collection_id, collection_name, collection_description)
VALUES (9, 'Ancient Art', 'A collection of ancient art from various civilizations');

INSERT INTO Collections (collection_id, collection_name, collection_description)
VALUES (10, 'Pop Art', 'A collection of iconic Pop Art pieces');

-- Insert data into the ArtworkCategories table
INSERT INTO ArtworkCategories (category_id, category_name)
VALUES (1, 'Paintings');

INSERT INTO ArtworkCategories (category_id, category_name)
VALUES (2, 'Sculptures');

INSERT INTO ArtworkCategories (category_id, category_name)
VALUES (3, 'Photography');

INSERT INTO ArtworkCategories (category_id, category_name)
VALUES (4, 'Drawings');

INSERT INTO ArtworkCategories (category_id, category_name)
VALUES (5, 'Mixed Media');

SELECT * FROM ArtworkCategories

--Insert data into the ArtworkMedia table
INSERT INTO ArtworkMedia (media_id, media_type)
VALUES (1, 'Oil on Canvas');

INSERT INTO ArtworkMedia (media_id, media_type)
VALUES (2, 'Acrylic on Canvas');

INSERT INTO ArtworkMedia (media_id, media_type)
VALUES (3, 'Watercolor');

INSERT INTO ArtworkMedia (media_id, media_type)
VALUES (4, 'Digital Art');

INSERT INTO ArtworkMedia (media_id, media_type)
VALUES (5, 'Guache');

SELECT * FROM ArtworkMedia

-- Insert data into the Artworks table
-- Artworks associated with Artist 1
INSERT INTO Artworks (artwork_id, title, medium_art, dimensions, date_created, description_art, price, artist_id, collection_id, category_id, media_id)
VALUES
    (1, 'Sunset', 'Oil on Canvas', '24x36', '2023-11-01', 'Beautiful sunset painting', 1000, 2, 1, 1, 1),
    (2, 'Portrait of a Lady', 'Acrylic on Canvas', '30x40', '2023-10-15', 'Elegant portrait painting', 1200, 3, 2, 2, 2);
delete from Artworks
-- Artworks associated with Artist 2
INSERT INTO Artworks (artwork_id, title, medium_art, dimensions, date_created, description_art, price, artist_id, collection_id, category_id, media_id)
VALUES
    (3, 'Abstract Symphony', 'Mixed Media', '20x20', '2023-09-30', 'Dynamic abstract composition', 800, 2, 3, 3, 3),
    (4, 'Blue Dreams', 'Oil on Canvas', '36x48', '2023-08-20', 'Surreal dream-like artwork', 1500, 2, 4, 1, 1),
    (5, 'Wild Nature', 'Watercolor', '18x24', '2023-07-05', 'Vibrant nature-inspired painting', 700, 2, 3, 4, 4);

-- Artworks not associated with any artist
INSERT INTO Artworks (artwork_id, title, medium_art, dimensions, date_created, description_art, price, artist_id, collection_id, category_id, media_id)
VALUES
    (6, 'Mystic Abstraction', 'Mixed Media', '24x24', '2023-06-15', 'Abstract artwork with a mysterious touch', 900, 10, 10, 2, 2);
	delete from Artworks where artwork_id = 6;



SELECT * FROM Artworks;

-- Insert data into the Exhibitions table
INSERT INTO Exhibitions (exhibition_id, exhibition_name, date_start, date_end, location_exhibition, description_exhibition, artwork_id, staff_id)
VALUES
    (1, 'Impressionist Masterpieces', '2023-11-15', '2023-12-15', 'Art Gallery A', 'A showcase of Impressionist art.', 1, 1),
    (2, 'Modern Art Extravaganza', '2023-10-01', '2023-11-01', 'Art Gallery B', 'Exploring contemporary art trends.', 2, 2),
    (3, 'Renaissance Revisited', '2023-12-01', '2024-01-01', 'Art Gallery C', 'A journey through the Renaissance era.', 3, 3),
    (4, 'Sculpture Symposium', '2023-09-15', '2023-10-15', 'Art Gallery D', 'Celebrating the art of sculpture.', 4, 4);
--    (5, 'Abstract Art Unleashed', '2023-08-01', '2023-09-01', 'Art Gallery E', 'An exploration of abstract creativity.', 5, 5),
SELECT * FROM Exhibitions;
delete from Exhibitions where exhibition_id = 5;

-- Insert data into the ArtworkAppraisals table
INSERT INTO ArtworkAppraisals (appraisal_id, appraisal_value, appraisal_date, appraisal_name, appraisal_contact_info, artwork_id, artist_id)
VALUES
    (1, 1500, '2023-11-20', 'Appraisal 1', 'Contact Info 1', 1, 5),
    (2, 900, '2023-11-18', 'Appraisal 2', 'Contact Info 2', 2, 4),
    (3, 1200, '2023-11-25', 'Appraisal 3', 'Contact Info 3', 3, 3),
    (4, 1100, '2023-11-22', 'Appraisal 4', 'Contact Info 4', 4, 12),
    (5, 1300, '2023-11-30', 'Appraisal 5', 'Contact Info 5', 5, 18);
SELECT * FROM ArtworkAppraisals

-- Insert data into the SalesAndTransactions table
INSERT INTO SalesAndTransactions (transaction_id, sale_date, buyer_name, buyer_contact_info, sale_price, payment_method, artwork_id, appraisal_id)
VALUES
    (1, '2023-11-01', 'John Smith', 'john.smith@example.com', 1500, 'Credit Card', 1, 1),
    (2, '2023-11-02', 'Alice Johnson', 'alice.johnson@example.com', 1200, 'PayPal', 2, 2),
    (3, '2023-11-03', 'David Brown', 'david.brown@example.com', 900, 'Cash', 3, 3),
    (4, '2023-11-04', 'Sarah Davis', 'sarah.davis@example.com', 1800, 'Check', 4, 4),
    (5, '2023-11-05', 'Michael Wilson', 'michael.wilson@example.com', 1300, 'Credit Card', 5, 5);
SELECT * FROM SalesAndTransactions

-- Insert data into the ArtworkArtists table to associate artworks with artists
INSERT INTO ArtworkArtists (artwork_id, artist_id)
VALUES
    (1, 2),  -- Artwork with ID 1 is associated with Artist with ID 2
    (2, 3);  -- Artwork with ID 2 is associated with Artist with ID 3
    --(1, 1),  -- Artwork with ID 3 is associated with Artist with ID 1
    --(2, 4),  -- Artwork with ID 4 is associated with Artist with ID 4
    --(1, 2);  -- Artwork with ID 5 is associated with Artist with ID 2
select* from ArtworkArtists

drop table SalesAndTransactions
drop table ArtworkAppraisals
drop table ArtworkExhibition
drop table Exhibitions
drop table GalleryStaff
drop table ArtistsBiographies
drop table ArtworkArtists
drop table Artworks
drop table Artists
drop table Collections
drop table ArtworkCategories
drop table ArtworkMedia

select* from Artists
-- UPDATE
UPDATE Artworks
SET description_art = 'Updated description',
    price = 1500
WHERE (price >= 1000 OR price <= 2000)
    AND description_art LIKE '%sunset%'
    AND artist_id IN (1, 2, 3)
    AND category_id = 1;

SELECT* FROM Artworks

UPDATE Collections
SET collection_description = 'Updated description'
WHERE collection_id NOT IN (1, 2)
    AND (collection_name LIKE 'Modern%' OR collection_name LIKE 'Abstract%');

SELECT* FROM Collections

-- UPDATE using various operators
UPDATE Artists
SET nationality = 'French',
    biography = 'Updated biography'
WHERE (birthdate BETWEEN '1800-01-01' AND '1900-12-31')
    OR (style IS NULL)
    OR (style NOT LIKE '%ism%');
SELECT* FROM Artists



--DELETE
-- First, delete any related data from other tables
DELETE FROM Artworks WHERE artist_id = 8;  -- Delete artworks associated with the artist
DELETE FROM ArtistsBiographies WHERE artist_id = 8;  -- Delete the artist's biography
-- Now, delete the artist
DELETE FROM Artists WHERE artist_id = 8;
