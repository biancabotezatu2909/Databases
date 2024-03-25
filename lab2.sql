-- a. 2 queries with the union operation; use UNION [ALL] and OR;
-- combines and retrieves a list of names from tables "Artists" and "GalleryStaff" without duplicates.
SELECT artist_name
FROM Artists
UNION
SELECT staff_name
FROM GalleryStaff;
select* from Artists
select* from GalleryStaff

--selects artist names from the "Artists" table where the style is either "Impressionism" or "Surrealism."
SELECT artist_name
FROM Artists
WHERE style = 'Impressionism'
OR style = 'Surrealism';

--b. 2 queries with the intersection operation; use INTERSECT and IN;
-- Query 1: Using INTERSECT
-- Using INTERSECT to find common artworks between exhibitions and appraisals
SELECT artwork_id
FROM Exhibitions
INTERSECT
SELECT artwork_id
FROM ArtworkAppraisals;

-- Using IN to find artworks by specific artists
SELECT artwork_id
FROM Artworks
WHERE artist_id IN (1, 2, 10);

--c. 2 queries with the difference operation; use EXCEPT and NOT IN;
-- retrieves all the artist names from the "Artists" table that are not present in the "GalleryStaff" table.
-- all of them except for john
SELECT artist_name
FROM Artists
EXCEPT
SELECT staff_name
FROM GalleryStaff;

--retrieves all the artworks that do not have corresponding entries in the "Exhibitions" table.
SELECT title
FROM Artworks
WHERE artwork_id NOT IN (
    SELECT DISTINCT artwork_id
    FROM Exhibitions
);

select* from Exhibitions


--d. 4 queries with INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN 
--(one query per operator); one query will join at least 3 tables, while another 
--one will join at least two many-to-many relationships;

--INNER JOIN
--This query starts with the "Artworks" table and then joins it with the "ArtworkArtists"
--table to associate each artwork with its artists. It further joins the "Artists" table 
--to retrieve artist names. Additionally, it joins the "Collections" table to get the collection
--names for the artworks and the "ArtworkCategories" table to retrieve category names for the artworks. 
--This query successfully combines information from these tables, illustrating how to work with two many-to-many 
--relationships in a single query.

SELECT A.title, AR.artist_name, C.collection_name, AC.category_name
FROM Artworks A
INNER JOIN ArtworkArtists AA ON A.artwork_id = AA.artwork_id
INNER JOIN Artists AR ON AA.artist_id = AR.artist_id
INNER JOIN Collections C ON A.collection_id = C.collection_id
INNER JOIN ArtworkCategories AC ON A.category_id = AC.category_id;


-- LEFT JOIN to find artists and their artworks (including artists without artworks)
--This query retrieves a list of artists along with the artworks they have created, 
--even if some artists have not created any artworks. It involves the "Artists," "Artworks," 
--and "ArtworkCategories" table
SELECT AR.artist_name, A.title, AC.category_name
FROM Artists AR
LEFT JOIN Artworks A ON AR.artist_id = A.artist_id
LEFT JOIN ArtworkCategories AC ON A.category_id = AC.category_id;

--RIGHT JOIN
--retrieves a list of artworks along with their associated artists,
--even if some artworks do not have associated artists
SELECT A.title, AR.artist_name
FROM Artworks A
RIGHT JOIN ArtworkArtists AA ON A.artwork_id = AA.artwork_id
RIGHT JOIN Artists AR ON AA.artist_id = AR.artist_id;

--FULL JOIN to find a combination of artists and their artworks
--This query retrieves a combination of artists and their associated artworks.
--It includes artists without artworks and artworks without associated artists. It involves the "Artists"
--and "ArtworkArtists" tables.
SELECT AR.artist_name, A.title
FROM Artists AR
FULL JOIN ArtworkArtists AA ON AR.artist_id = AA.artist_id
FULL JOIN Artworks A ON AA.artwork_id = A.artwork_id;

--e. 2 queries with the IN operator and a subquery in the WHERE clause; 
--in at least one case, the subquery must include a subquery in its own WHERE clause;
--retrieves the titles and artist IDs of artworks created by artists with nationalities
--that are either Italian, Dutch, or Spanish.
SELECT title, artist_id
FROM Artworks
WHERE artist_id IN (
    SELECT artist_id
    FROM Artists
    WHERE nationality IN ('Italian', 'Dutch', 'Spanish')
);

select* from Artists
select* from Artworks

--filter artworks based on their collection
SELECT title, collection_id
FROM Artworks
WHERE collection_id IN (
    SELECT collection_id
    FROM Collections
    WHERE collection_id IN (
        SELECT collection_id
        FROM Exhibitions
        WHERE exhibition_id = 1
    )
);

--f.2 queries with the EXISTS operator and a subquery in the WHERE clause;
--Query 1: Retrieve artists who have at least one artwork associated with them.
SELECT artist_id, artist_name
FROM Artists
WHERE EXISTS (
    SELECT 1
    FROM Artworks
    WHERE Artworks.artist_id = Artists.artist_id
);

--Query 2: Retrieve artworks that have been part of at least one exhibition.
SELECT title
FROM Artworks
WHERE EXISTS (
    SELECT 1
    FROM Exhibitions
    WHERE Exhibitions.artwork_id = Artworks.artwork_id
);

--g.2 queries with a subquery in the FROM clause; 
--Query 1: Retrieve the average price of artworks for each artist.
SELECT artist_id, artist_name, AVG(artwork_price) AS average_price
FROM (
    SELECT A.artist_id, A.artist_name, W.price AS artwork_price
    FROM Artists A
    JOIN Artworks W ON A.artist_id = W.artist_id
) AS ArtistArtworks
GROUP BY artist_id, artist_name;

--Query 2: Retrieve the total sales value for each exhibition.
SELECT E.exhibition_id, E.exhibition_name, SUM(SAT.sale_price) AS total_sales
FROM Exhibitions E
LEFT JOIN SalesAndTransactions SAT ON E.artwork_id = SAT.artwork_id
GROUP BY E.exhibition_id, E.exhibition_name;


--h 4 queries with the GROUP BY clause, 3 of which also contain the HAVING clause; 
--2 of the latter will also have a subquery in the HAVING clause; use the aggregation 
--operators: COUNT, SUM, AVG, MIN, MAX;

-- counts the total number of artworks in each category and retrieves 
--the category ID for each, utilizing a GROUP BY statement for aggregation.
SELECT category_id, COUNT(*) AS total_artworks
FROM Artworks
GROUP BY category_id;

--calculates the total sales (price sum) for each artist and retrieves their 
--artist ID, applying a HAVING clause to filter and display only artists with total sales exceeding $1,000.
SELECT artist_id, SUM(price) AS total_sales
FROM Artworks
GROUP BY artist_id
HAVING SUM(price) > 1000;

--calculates and compares the average prices of artworks within collections
--to the overall average price, displaying collections with higher-than-average prices.
SELECT collection_id, AVG(price) AS avg_price
FROM Artworks
GROUP BY collection_id
HAVING AVG(price) > (SELECT AVG(price) FROM Artworks);

--selects artists whose artworks have a minimum price higher than the average 
--price across all artworks, showing their artist ID, minimum price, and maximum price.
SELECT artist_id, MIN(price) AS min_price, MAX(price) AS max_price
FROM Artworks
GROUP BY artist_id
HAVING MIN(price) > (SELECT AVG(price) FROM Artworks);


--i. 4 queries using ANY and ALL to introduce a subquery in the WHERE clause
--(2 queries per operator); rewrite 2 of them with aggregation operators, and the 
--other 2 with IN / [NOT] IN.

--retrieves artist names from the "Artists" table who have created at least three artworks,
--using a subquery with the ANY operator to match their artist IDs.
SELECT artist_name
FROM Artists
WHERE artist_id = ANY (
    SELECT artist_id
    FROM Artworks
    GROUP BY artist_id
    HAVING COUNT(*) >= 3
);

--selects artist names from the "Artists" table whose artworks have a total price sum of 
--at least 500, using a subquery with the ANY operator to match their artist IDs.
SELECT artist_name
FROM Artists
WHERE artist_id = ANY (
    SELECT artist_id
    FROM Artworks
    GROUP BY artist_id
    HAVING SUM(price) >= 500
);

--not all artists have artworks
SELECT artist_name
FROM Artists
WHERE artist_id = ALL (
    SELECT artist_id
    FROM Artworks
    WHERE price IN (800, 1500, 1200, 700)
);
select* from Artworks

--not all artists have artworks
SELECT artist_name
FROM Artists
WHERE artist_id = ALL (
    SELECT artist_id
    FROM Artworks
    WHERE price NOT IN (1000, 1500, 2000)
);
