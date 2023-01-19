USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
    
SELECT 'director_mapping' AS table_name,
       COUNT(*) AS records_count
FROM   director_mapping
UNION
SELECT 'genre',
       COUNT(*)
FROM   genre
UNION
SELECT 'movie',
       COUNT(*)
FROM   movie
UNION
SELECT 'names',
       COUNT(*)
FROM   names
UNION
SELECT 'ratings',
       COUNT(*)
FROM   ratings
UNION
SELECT 'role_mapping',
       COUNT(*)
FROM   role_mapping; 

/*
+------------------+---------------+
| table_name       | records_count |
+------------------+---------------+
| director_mapping |          3867 |
| genre            |         14662 |
| movie            |          7997 |
| names            |         25735 |
| ratings          |          7997 |
| role_mapping     |         15615 |
+------------------+---------------+
*/

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
	COUNT(*) - COUNT(id) AS id_null_count,
	COUNT(*) - COUNT(title) AS title_null_count,
	COUNT(*) - COUNT(year) AS year_null_count,
	COUNT(*) - COUNT(date_published) AS date_published_null_count,
	COUNT(*) - COUNT(duration) AS duration_null_count,
	COUNT(*) - COUNT(country) AS country_null_count,
	COUNT(*) - COUNT(worlwide_gross_income) AS worlwide_gross_income_null_count,
	COUNT(*) - COUNT(languages) AS languages_null_count,
	COUNT(*) - COUNT(production_company) AS production_company_null_count
FROM 
	movie; 

/*
----------------------------------------------------------------------------
Following columns having NULL records:
# Column_Name					No. of NULL records
country							20
worlwide_gross_income			3724
languages						194
production_company				528
----------------------------------------------------------------------------
*/

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Total number of movies released each year.
SELECT Year,
       COUNT(*) AS number_of_movies
FROM movie
GROUP BY Year
ORDER BY Year; 

/*
+------+------------------+
| Year | number_of_movies |
+------+------------------+
| 2017 |             3052 |
| 2018 |             2944 |
| 2019 |             2001 |
+------+------------------+
*/

-- Total number of movies released month wise.
SELECT MONTH(date_published) AS month_num,
       COUNT(*) AS number_of_movies
FROM movie
GROUP BY month_num
ORDER BY month_num;

/*
+-----------+------------------+
| month_num | number_of_movies |
+-----------+------------------+
|         1 |              804 |
|         2 |              640 |
|         3 |              824 |
|         4 |              680 |
|         5 |              625 |
|         6 |              580 |
|         7 |              493 |
|         8 |              678 |
|         9 |              809 |
|        10 |              801 |
|        11 |              625 |
|        12 |              438 |
+-----------+------------------+
*/

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT Year,
       COUNT(id) AS number_of_movies
FROM movie
WHERE country REGEXP '(USA)|(India)'
	AND year = 2019
GROUP BY year; 
/*
+------+------------------+
| Year | number_of_movies |
+------+------------------+
| 2019 |             1059 |
+------+------------------+
*/

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT genre as movie_genre
FROM genre
GROUP BY movie_genre
ORDER BY movie_genre;
/*
+-------------+
| movie_genre |
+-------------+
| Action      |
| Adventure   |
| Comedy      |
| Crime       |
| Drama       |
| Family      |
| Fantasy     |
| Horror      |
| Mystery     |
| Others      |
| Romance     |
| Sci-Fi      |
| Thriller    |
+-------------+
*/


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT gen.genre AS movie_genre,
       COUNT(gen.movie_id) AS number_of_movies
FROM genre gen
INNER JOIN movie mov
	ON gen.movie_id = mov.id
GROUP BY movie_genre
ORDER BY number_of_movies DESC
LIMIT 1; 

/*
+-------------+------------------+
| movie_genre | number_of_movies |
+-------------+------------------+
| Drama       |             4285 |
+-------------+------------------+
*/


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT COUNT(mov_count.movie_id) AS no_of_movies_with_one_genre
FROM (SELECT movie_id,
			 COUNT(genre)
	  FROM genre
	  GROUP BY movie_id
	  HAVING COUNT(genre) = 1) mov_count; 

/*
+-----------------------------+
| no_of_movies_with_one_genre |
+-----------------------------+
|                        3289 |
+-----------------------------+
*/

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT gen.genre AS genre,
       ROUND(AVG(mov.duration), 2) AS avg_duration
FROM genre gen
INNER JOIN movie mov
	ON gen.movie_id = mov.id
GROUP BY genre
ORDER BY avg_duration DESC; 

/*
+-----------+--------------+
| genre     | avg_duration |
+-----------+--------------+
| Action    |       112.88 |
| Romance   |       109.53 |
| Crime     |       107.05 |
| Drama     |       106.77 |
| Fantasy   |       105.14 |
| Comedy    |       102.62 |
| Adventure |       101.87 |
| Mystery   |       101.80 |
| Thriller  |       101.58 |
| Family    |       100.97 |
| Others    |       100.16 |
| Sci-Fi    |        97.94 |
| Horror    |        92.72 |
+-----------+--------------+
*/

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_details AS 
(
	SELECT gen.genre AS genre,
		   COUNT(gen.movie_id) AS movie_count,
		   RANK() OVER (ORDER BY COUNT(gen.movie_id) DESC) AS genre_rank
    FROM  genre gen
    INNER JOIN movie mov
		ON gen.movie_id = mov.id
	GROUP BY gen.genre
)
SELECT *
FROM   genre_details
WHERE  genre = 'thriller'; 

/*
+----------+-------------+------------+
| genre    | movie_count | genre_rank |
+----------+-------------+------------+
| Thriller |        1484 |          3 |
+----------+-------------+------------+
*/

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT MIN(avg_rating) AS min_avg_rating,
       MAX(avg_rating) AS max_avg_rating,
       MIN(total_votes) AS min_total_votes,
       MAX(total_votes) AS max_total_votes,
       MIN(median_rating) AS min_median_rating,
       MAX(median_rating) AS max_median_rating
FROM   ratings; 

/*
+----------------+----------------+-----------------+-----------------+-------------------+-------------------+
| min_avg_rating | max_avg_rating | min_total_votes | max_total_votes | min_median_rating | max_median_rating |
+----------------+----------------+-----------------+-----------------+-------------------+-------------------+
|            1.0 |           10.0 |             100 |          725138 |                 1 |                10 |
+----------------+----------------+-----------------+-----------------+-------------------+-------------------+
*/

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH avg_movie_rating_details
AS
(
	 SELECT mov.title AS title,
			rat.avg_rating AS avg_rating,
			rank() over (ORDER BY rat.avg_rating DESC) AS movie_rank
	 FROM movie mov
	 INNER JOIN ratings rat
		ON mov.id = rat.movie_id
	 GROUP BY title
)
SELECT *
FROM avg_movie_rating_details
WHERE movie_rank <= 10
ORDER BY movie_rank;

/*
+--------------------------------+------------+------------+
| title                          | avg_rating | movie_rank |
+--------------------------------+------------+------------+
| Kirket                         |       10.0 |          1 |
| Love in Kilnerry               |       10.0 |          1 |
| Gini Helida Kathe              |        9.8 |          3 |
| Runam                          |        9.7 |          4 |
| Fan                            |        9.6 |          5 |
| Android Kunjappan Version 5.25 |        9.6 |          5 |
| Yeh Suhaagraat Impossible      |        9.5 |          7 |
| Safe                           |        9.5 |          7 |
| The Brighton Miracle           |        9.5 |          7 |
| Shibu                          |        9.4 |         10 |
| Our Little Haven               |        9.4 |         10 |
| Zana                           |        9.4 |         10 |
| Family of Thakurganj           |        9.4 |         10 |
| Ananthu V/S Nusrath            |        9.4 |         10 |
+--------------------------------+------------+------------+
*/

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
       COUNT(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating DESC; 

/*
+---------------+-------------+
| median_rating | movie_count |
+---------------+-------------+
|            10 |         346 |
|             9 |         429 |
|             8 |        1030 |
|             7 |        2257 |
|             6 |        1975 |
|             5 |         985 |
|             4 |         479 |
|             3 |         283 |
|             2 |         119 |
|             1 |          94 |
+---------------+-------------+
*/

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
WITH production_company_details AS 
(
	SELECT mov.production_company AS production_company,
           Count(mov.id) AS movie_count,
		   RANK() OVER (ORDER BY Count(mov.id) DESC) AS prod_company_rank
	FROM movie mov
    INNER JOIN ratings rat
		ON mov.id = rat.movie_id AND rat.avg_rating > 8
	WHERE mov.production_company IS NOT NULL
	GROUP BY production_company
)
SELECT *
FROM production_company_details
WHERE prod_company_rank = 1; 

/*
+------------------------+-------------+-------------------+
| production_company     | movie_count | prod_company_rank |
+------------------------+-------------+-------------------+
| Dream Warrior Pictures |           3 |                 1 |
| National Theatre Live  |           3 |                 1 |
+------------------------+-------------+-------------------+
*/

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT gen.genre AS genre,
       COUNT(mov.id) AS movie_count
FROM movie mov
INNER JOIN genre gen
	ON mov.id = gen.movie_id
INNER JOIN ratings rat
	ON mov.id = rat.movie_id
WHERE mov.year = 2017
	AND MONTH(date_published) = 3
	AND country REGEXP 'USA'
	AND rat.total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC; 

/*
+-----------+-------------+
| genre     | movie_count |
+-----------+-------------+
| Drama     |          24 |
| Comedy    |           9 |
| Action    |           8 |
| Thriller  |           8 |
| Sci-Fi    |           7 |
| Crime     |           6 |
| Horror    |           6 |
| Mystery   |           4 |
| Romance   |           4 |
| Fantasy   |           3 |
| Adventure |           3 |
| Family    |           1 |
+-----------+-------------+
*/

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT mov.title AS title,
       rat.avg_rating AS avg_rating,
       gen.genre AS genre
FROM movie mov
INNER JOIN genre gen
	ON mov.id = gen.movie_id
INNER JOIN ratings rat
	ON mov.id = rat.movie_id
WHERE mov.title LIKE 'The%'
	AND rat.avg_rating > 8
GROUP BY title, avg_rating, genre
ORDER BY avg_rating DESC;

/*
+--------------------------------------+------------+----------+
| title                                | avg_rating | genre    |
+--------------------------------------+------------+----------+
| The Brighton Miracle                 |        9.5 | Drama    |
| The Colour of Darkness               |        9.1 | Drama    |
| The Blue Elephant 2                  |        8.8 | Drama    |
| The Blue Elephant 2                  |        8.8 | Horror   |
| The Blue Elephant 2                  |        8.8 | Mystery  |
| The Irishman                         |        8.7 | Crime    |
| The Irishman                         |        8.7 | Drama    |
| The Mystery of Godliness: The Sequel |        8.5 | Drama    |
| The Gambinos                         |        8.4 | Crime    |
| The Gambinos                         |        8.4 | Drama    |
| Theeran Adhigaaram Ondru             |        8.3 | Action   |
| Theeran Adhigaaram Ondru             |        8.3 | Crime    |
| Theeran Adhigaaram Ondru             |        8.3 | Thriller |
| The King and I                       |        8.2 | Drama    |
| The King and I                       |        8.2 | Romance  |
+--------------------------------------+------------+----------+
*/

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT COUNT(mov.id) AS movies_count
FROM movie mov
INNER JOIN ratings rat
	ON mov.id = rat.movie_id
WHERE rat.median_rating = 8
	AND mov.date_published BETWEEN '2018-04-01' AND '2019-04-01'; 
       
/*
+--------------+
| movies_count |
+--------------+
|          361 |
+--------------+
*/

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

WITH german_movies AS
(
	SELECT row_number() over (ORDER BY sum(rat.total_votes)) AS gid,
		   sum(rat.total_votes) AS german_movies_votes
	FROM movie mov
	INNER JOIN ratings rat
		ON mov.id = rat.movie_id
	WHERE mov.country REGEXP 'Germany' 
),
italian_movies AS
(
	SELECT row_number() over (ORDER BY sum(rat.total_votes)) AS iid,
		   sum(rat.total_votes) AS italian_movies_votes
	FROM movie mov
	INNER JOIN ratings rat
		ON mov.id = rat.movie_id
	WHERE mov.country REGEXP 'Italy' 
)
SELECT ger.german_movies_votes AS german_movies_votes,
	   ita.italian_movies_votes AS italian_movies_votes,
	   CASE
		WHEN ger.german_movies_votes > ita.italian_movies_votes THEN 'German movies have more votes than Italian movies'
		ELSE 'Italian movies have more votes than German movies'
		END AS comparison
FROM german_movies ger
INNER JOIN italian_movies ita
	ON ger.gid = ita.iid;

/*
+---------------------+----------------------+---------------------------------------------------+
| german_movies_votes | italian_movies_votes | comparison                                        |
+---------------------+----------------------+---------------------------------------------------+
|             2026223 |               703024 | German movies have more votes than Italian movies |
+---------------------+----------------------+---------------------------------------------------+
*/

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT COUNT(*) - COUNT(name) AS name_nulls,
       COUNT(*) - COUNT(height) AS height_nulls,
       COUNT(*) - COUNT(date_of_birth) AS date_of_birth_nulls,
       COUNT(*) - COUNT(known_for_movies) AS known_for_movies_nulls
FROM names; 

/*
+------------+--------------+---------------------+------------------------+
| name_nulls | height_nulls | date_of_birth_nulls | known_for_movies_nulls |
+------------+--------------+---------------------+------------------------+
|          0 |        17335 |               13431 |                  15226 |
+------------+--------------+---------------------+------------------------+
*/

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_genres AS
(
	SELECT gen.genre AS genre,
		   count(mov.id) AS movie_count,
		   rank() over (ORDER BY count(mov.id) DESC) AS genre_rank
	FROM genre gen
	LEFT JOIN movie mov
		ON gen.movie_id = mov.id
	INNER JOIN ratings rat
		ON mov.id = rat.movie_id
	WHERE rat.avg_rating > 8
	GROUP BY genre
)
SELECT n.name AS director_name,
	   count(mov.id) AS movie_count
FROM names n
INNER JOIN director_mapping dm
	ON n.id = dm.name_id
INNER JOIN movie mov
	ON mov.id = dm.movie_id
INNER JOIN genre gen
	ON mov.id = gen.movie_id
INNER JOIN ratings rat
	ON mov.id = rat.movie_id
WHERE gen.genre IN 
	(
		SELECT genre 
        FROM top_genres 
        WHERE genre_rank <=3
	)
AND rat.avg_rating > 8
GROUP BY director_name
ORDER BY movie_count DESC
LIMIT 3;

/*
+---------------+-------------+
| director_name | movie_count |
+---------------+-------------+
| James Mangold |           4 |
| Joe Russo     |           3 |
| Anthony Russo |           3 |
+---------------+-------------+
*/

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT n.name AS actor_name,
       COUNT(mov.id) AS movie_count
FROM names n
INNER JOIN role_mapping rm
	ON n.id = rm.name_id
INNER JOIN movie mov
	ON mov.id = rm.movie_id
INNER JOIN ratings rat
	ON mov.id = rat.movie_id
WHERE rat.median_rating >= 8
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2; 

/*
+------------+-------------+
| actor_name | movie_count |
+------------+-------------+
| Mammootty  |           8 |
| Mohanlal   |           5 |
+------------+-------------+
*/

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH production_company_details AS 
(
	SELECT mov.production_company AS production_company,
           SUM(total_votes) AS vote_count,
           RANK() OVER (ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
    FROM movie mov
    INNER JOIN ratings rat
		ON mov.id = rat.movie_id
    GROUP BY production_company
)
SELECT *
FROM production_company_details
WHERE prod_comp_rank <= 3; 

/*
+-----------------------+------------+----------------+
| production_company    | vote_count | prod_comp_rank |
+-----------------------+------------+----------------+
| Marvel Studios        |    2656967 |              1 |
| Twentieth Century Fox |    2411163 |              2 |
| Warner Bros.          |    2396057 |              3 |
+-----------------------+------------+----------------+
*/

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actor_details AS
(
   SELECT n.name AS actor_name,
		  SUM(rat.total_votes) AS total_votes,
		  COUNT(mov.id) AS movie_count,
		  ROUND(SUM(rat.avg_rating * rat.total_votes) / SUM(rat.total_votes), 2) AS actor_avg_rating,
		  RANK() OVER rating_w AS actor_rank
   FROM movie mov
   INNER JOIN ratings rat
		ON mov.id = rat.movie_id
   INNER JOIN role_mapping rm
		ON mov.id = rm.movie_id
   INNER JOIN names n
		ON rm.name_id = n.id
   WHERE rm.category = 'Actor'
		AND mov.country = 'India'
   GROUP BY actor_name
   HAVING COUNT(mov.id)>=5 
   WINDOW rating_w AS (ORDER BY ROUND(SUM(rat.avg_rating * rat.total_votes) / SUM(rat.total_votes), 2) DESC) 
)
SELECT *
FROM actor_details
WHERE actor_rank = 1;

/*
+------------------+-------------+-------------+------------------+------------+
| actor_name       | total_votes | movie_count | actor_avg_rating | actor_rank |
+------------------+-------------+-------------+------------------+------------+
| Vijay Sethupathi |       23114 |           5 |             8.42 |          1 |
+------------------+-------------+-------------+------------------+------------+
*/

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_details AS
(
   SELECT n.name AS actress_name,
		  SUM(rat.total_votes) AS total_votes,
		  COUNT(mov.id) AS movie_count,
		  ROUND(SUM(rat.avg_rating * rat.total_votes) / SUM(rat.total_votes), 2) AS actress_avg_rating,
		  RANK() OVER rating_w AS actress_rank
   FROM movie mov
   INNER JOIN ratings rat
		ON mov.id = rat.movie_id
   INNER JOIN role_mapping rm
		ON mov.id = rm.movie_id
   INNER JOIN names n
		ON rm.name_id = n.id
   WHERE rm.category = 'Actress'
		AND mov.country = 'India'
		AND mov.languages = 'Hindi'
   GROUP BY actress_name
   HAVING COUNT(mov.id)>=3 
   WINDOW rating_w AS (ORDER BY ROUND(SUM(rat.avg_rating * rat.total_votes) / SUM(rat.total_votes), 2) DESC) 
)
SELECT *
FROM actress_details
WHERE actress_rank <= 5;

/*
+-----------------+-------------+-------------+--------------------+--------------+
| actress_name    | total_votes | movie_count | actress_avg_rating | actress_rank |
+-----------------+-------------+-------------+--------------------+--------------+
| Taapsee Pannu   |       18061 |           3 |               7.74 |            1 |
| Divya Dutta     |        8579 |           3 |               6.88 |            2 |
| Kriti Kharbanda |        2549 |           3 |               4.80 |            3 |
| Sonakshi Sinha  |        4025 |           4 |               4.18 |            4 |
+-----------------+-------------+-------------+--------------------+--------------+
*/

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT mov.title AS movie_title,
       rat.avg_rating AS avg_rating,
       CASE
         WHEN rat.avg_rating > 8 THEN 'Superhit'
         WHEN rat.avg_rating BETWEEN 7 AND 8 THEN 'Hit'
         WHEN rat.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
         ELSE 'Flop'
		 END AS avg_rating_class
FROM movie mov
INNER JOIN ratings rat
	ON mov.id = rat.movie_id
INNER JOIN genre gen
	ON mov.id = gen.movie_id
WHERE gen.genre = 'Thriller'
ORDER BY avg_rating DESC; 

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


WITH genre_avg_duration AS
(
	SELECT gen.genre AS genre,
		   ROUND(AVG(mov.duration),2) AS avg_duration
	FROM genre gen
	LEFT JOIN movie mov
		ON gen.movie_id = mov.id
	GROUP BY genre 
)
SELECT  *,
		SUM(avg_duration) OVER genre_w AS running_total_duration,
		ROUND(AVG(avg_duration) OVER genre_w,2) AS moving_avg_duration
FROM genre_avg_duration 
WINDOW genre_w AS (ORDER BY genre ASC ROWS UNBOUNDED PRECEDING);
  
  /*
  +-----------+--------------+------------------------+---------------------+
| genre     | avg_duration | running_total_duration | moving_avg_duration |
+-----------+--------------+------------------------+---------------------+
| Action    |       112.88 |                 112.88 |              112.88 |
| Adventure |       101.87 |                 214.75 |              107.38 |
| Comedy    |       102.62 |                 317.37 |              105.79 |
| Crime     |       107.05 |                 424.42 |              106.11 |
| Drama     |       106.77 |                 531.19 |              106.24 |
| Family    |       100.97 |                 632.16 |              105.36 |
| Fantasy   |       105.14 |                 737.30 |              105.33 |
| Horror    |        92.72 |                 830.02 |              103.75 |
| Mystery   |       101.80 |                 931.82 |              103.54 |
| Others    |       100.16 |                1031.98 |              103.20 |
| Romance   |       109.53 |                1141.51 |              103.77 |
| Sci-Fi    |        97.94 |                1239.45 |              103.29 |
| Thriller  |       101.58 |                1341.03 |              103.16 |
+-----------+--------------+------------------------+---------------------+
*/

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
SELECT gen.genre AS genre,
	   COUNT(mov.id) AS movie_count
FROM movie mov
INNER JOIN genre gen
	ON mov.id = gen.movie_id
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 3;

/*
+----------+-------------+
| genre    | movie_count |
+----------+-------------+
| Drama    |        4285 |
| Comedy   |        2412 |
| Thriller |        1484 |
+----------+-------------+

The top 3 genres are 'Drama', 'Comedy' and 'Thriller'.

*/

-- Top five highest-grossing movies of each year that belong to the top three genres
WITH top_three_genres
AS
(
   SELECT gen.genre AS genre,
          COUNT(mov.id) AS movie_count
   FROM movie mov
   INNER JOIN genre gen
		ON mov.id = gen.movie_id
   GROUP BY genre
   ORDER BY movie_count DESC
   LIMIT 3 
),
top_five_movies
AS
(
   SELECT gen.genre AS genre,
          mov.year AS year,
          mov.title AS movie_name,
          CASE
			WHEN SUBSTR(SUBSTRING_INDEX(mov.worlwide_gross_income,' ',1),1) = 'INR' THEN CONCAT('$ ', ROUND(SUBSTR(SUBSTRING_INDEX(worlwide_gross_income,' ',-1),1)/76.05))
			ELSE mov.worlwide_gross_income
            END  AS worldwide_gross_income,
		  RANK() OVER gross_income_w AS movie_rank
    FROM movie mov
    INNER JOIN genre gen
		ON mov.id = gen.movie_id
    WHERE gen.genre IN
          (
              SELECT genre
              FROM top_three_genres
		  ) 
	WINDOW gross_income_w AS (partition BY gen.genre, mov.year 
			ORDER BY CASE
                        WHEN SUBSTR(SUBSTRING_INDEX(mov.worlwide_gross_income,' ',1),1) = 'INR' THEN CONVERT(ROUND(SUBSTR(SUBSTRING_INDEX(mov.worlwide_gross_income,' ',-1),1)/76.05), UNSIGNED INT)
                        ELSE CONVERT(SUBSTR(SUBSTRING_INDEX(mov.worlwide_gross_income,' ',-1),1),UNSIGNED INT)
					 END DESC) 
)
SELECT *
FROM top_five_movies
WHERE movie_rank <= 5
ORDER BY genre,
		 year,
		 movie_rank;

/*
+----------+------+---------------------------------------+------------------------+------------+
| genre    | year | movie_name                            | worldwide_gross_income | movie_rank |
+----------+------+---------------------------------------+------------------------+------------+
| Comedy   | 2017 | Despicable Me 3                       | $ 1034799409           |          1 |
| Comedy   | 2017 | Jumanji: Welcome to the Jungle        | $ 962102237            |          2 |
| Comedy   | 2017 | Guardians of the Galaxy Vol. 2        | $ 863756051            |          3 |
| Comedy   | 2017 | Thor: Ragnarok                        | $ 853977126            |          4 |
| Comedy   | 2017 | Sing                                  | $ 634151679            |          5 |
| Comedy   | 2018 | Deadpool 2                            | $ 785046920            |          1 |
| Comedy   | 2018 | Ant-Man and the Wasp                  | $ 622674139            |          2 |
| Comedy   | 2018 | Tang ren jie tan an 2                 | $ 544061916            |          3 |
| Comedy   | 2018 | Ralph Breaks the Internet             | $ 529323962            |          4 |
| Comedy   | 2018 | Hotel Transylvania 3: Summer Vacation | $ 528583774            |          5 |
| Comedy   | 2019 | Toy Story 4                           | $ 1073168585           |          1 |
| Comedy   | 2019 | Pokémon Detective Pikachu             | $ 431705346            |          2 |
| Comedy   | 2019 | The Secret Life of Pets 2             | $ 429434163            |          3 |
| Comedy   | 2019 | Once Upon a Time... in Hollywood      | $ 371207970            |          4 |
| Comedy   | 2019 | Shazam!                               | $ 364571656            |          5 |
| Drama    | 2017 | Zhan lang II                          | $ 870325439            |          1 |
| Drama    | 2017 | Logan                                 | $ 619021436            |          2 |
| Drama    | 2017 | Dunkirk                               | $ 526940665            |          3 |
| Drama    | 2017 | War for the Planet of the Apes        | $ 490719763            |          4 |
| Drama    | 2017 | La La Land                            | $ 446092357            |          5 |
| Drama    | 2018 | Bohemian Rhapsody                     | $ 903655259            |          1 |
| Drama    | 2018 | Hong hai xing dong                    | $ 579220560            |          2 |
| Drama    | 2018 | Wo bu shi yao shen                    | $ 451183391            |          3 |
| Drama    | 2018 | A Star Is Born                        | $ 434888866            |          4 |
| Drama    | 2018 | Fifty Shades Freed                    | $ 371985018            |          5 |
| Drama    | 2019 | Avengers: Endgame                     | $ 2797800564           |          1 |
| Drama    | 2019 | The Lion King                         | $ 1655156910           |          2 |
| Drama    | 2019 | Joker                                 | $ 995064593            |          3 |
| Drama    | 2019 | Liu lang di qiu                       | $ 699760773            |          4 |
| Drama    | 2019 | It Chapter Two                        | $ 463326885            |          5 |
| Thriller | 2017 | The Fate of the Furious               | $ 1236005118           |          1 |
| Thriller | 2017 | Zhan lang II                          | $ 870325439            |          2 |
| Thriller | 2017 | xXx: Return of Xander Cage            | $ 346118277            |          3 |
| Thriller | 2017 | Annabelle: Creation                   | $ 306515884            |          4 |
| Thriller | 2017 | Split                                 | $ 278454358            |          5 |
| Thriller | 2018 | Venom                                 | $ 856085151            |          1 |
| Thriller | 2018 | Mission: Impossible - Fallout         | $ 791115104            |          2 |
| Thriller | 2018 | Hong hai xing dong                    | $ 579220560            |          3 |
| Thriller | 2018 | Fifty Shades Freed                    | $ 371985018            |          4 |
| Thriller | 2018 | The Nun                               | $ 365550119            |          5 |
| Thriller | 2019 | Joker                                 | $ 995064593            |          1 |
| Thriller | 2019 | Ne Zha zhi mo tong jiang shi          | $ 700547754            |          2 |
| Thriller | 2019 | John Wick: Chapter 3 - Parabellum     | $ 326667460            |          3 |
| Thriller | 2019 | Us                                    | $ 255105930            |          4 |
| Thriller | 2019 | Glass                                 | $ 246985576            |          5 |
+----------+------+---------------------------------------+------------------------+------------+
*/

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_movies_rank AS 
(
	SELECT mov.production_company AS production_company,
		   COUNT(mov.id) AS movie_count,
           RANK() OVER (ORDER BY COUNT(mov.id) DESC) AS prod_comp_rank
	FROM movie mov
    INNER JOIN ratings rat
		ON mov.id = rat.movie_id
	WHERE rat.median_rating >= 8
		AND mov.production_company IS NOT NULL
        AND POSITION(',' IN mov.languages) > 0
    GROUP  BY production_company
)
SELECT *
FROM production_movies_rank
WHERE prod_comp_rank <= 2; 

/*
+-----------------------+-------------+----------------+
| production_company    | movie_count | prod_comp_rank |
+-----------------------+-------------+----------------+
| Star Cinema           |           7 |              1 |
| Twentieth Century Fox |           4 |              2 |
+-----------------------+-------------+----------------+
*/

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_details AS
(
   SELECT n.name AS actress_name,
		  SUM(rat.total_votes) AS total_votes,
		  COUNT(mov.id) AS movie_count,
		  ROUND(SUM(rat.avg_rating * rat.total_votes) / SUM(rat.total_votes), 2) AS actress_avg_rating,
		  RANK() OVER rating_w AS actress_rank
   FROM movie mov
   INNER JOIN ratings rat
		ON mov.id = rat.movie_id
   INNER JOIN role_mapping rm
		ON mov.id = rm.movie_id
   INNER JOIN names n
		ON rm.name_id = n.id
   INNER JOIN genre gen
		ON mov.id = gen.movie_id
   WHERE rm.category = 'Actress'
		AND rat.avg_rating > 8
		AND gen.genre = 'Drama'
   GROUP BY actress_name 
   WINDOW rating_w AS 
		(ORDER BY ROUND(SUM(rat.avg_rating * rat.total_votes) / SUM(rat.total_votes), 2) DESC, 
				  SUM(rat.total_votes) DESC) 
)
SELECT *
FROM actress_details
WHERE actress_rank <= 3;

/*
+-----------------+-------------+-------------+--------------------+--------------+
| actress_name    | total_votes | movie_count | actress_avg_rating | actress_rank |
+-----------------+-------------+-------------+--------------------+--------------+
| Sangeetha Bhat  |        1010 |           1 |               9.60 |            1 |
| Fatmire Sahiti  |        3932 |           1 |               9.40 |            2 |
| Adriana Matoshi |        3932 |           1 |               9.40 |            2 |
+-----------------+-------------+-------------+--------------------+--------------+
*/

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH top_directors AS 
(
	SELECT dm.name_id AS director_id,
		   COUNT(mov.id) AS movie_count,
		   ROW_NUMBER() OVER (ORDER BY COUNT(mov.id) DESC) AS director_rank
	FROM movie mov
	INNER JOIN director_mapping dm
		ON mov.id = dm.movie_id
	GROUP BY director_id
),
director_movies AS 
(
	SELECT n.id AS director_id,
		   n.NAME AS director_name,
		   mov.id AS movie_id,
		   DATEDIFF(LEAD(mov.date_published) 
			  OVER (partition BY n.id ORDER BY mov.date_published),mov.date_published) AS inter_movie_days, 
		   rat.avg_rating AS avg_rating, 
		   rat.total_votes AS total_votes, 
		   mov.duration AS duration
	FROM movie mov
	INNER JOIN director_mapping dm
		ON mov.id = dm.movie_id
	INNER JOIN names n
		ON n.id = dm.name_id
	INNER JOIN ratings rat
		ON mov.id = rat.movie_id
	WHERE n.id IN 
		(
			SELECT director_id 
            FROM top_directors 
            WHERE director_rank <= 9
		)
) 
SELECT
	director_id,
	director_name,
	COUNT(movie_id) AS number_of_movies,
	ROUND(AVG(inter_movie_days), 0) AS avg_inter_movie_days,
	ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS avg_rating,
	SUM(total_votes) AS total_votes,
	MIN(avg_rating) AS min_rating,
	MAX(avg_rating) AS max_rating,
	SUM(duration) AS total_duration
FROM director_movies
GROUP BY director_id
ORDER BY number_of_movies DESC,
		 avg_rating DESC;

/*
+-------------+-------------------+------------------+----------------------+------------+-------------+------------+------------+----------------+
| director_id | director_name     | number_of_movies | avg_inter_movie_days | avg_rating | total_votes | min_rating | max_rating | total_duration |
+-------------+-------------------+------------------+----------------------+------------+-------------+------------+------------+----------------+
| nm1777967   | A.L. Vijay        |                5 |                  177 |       5.65 |        1754 |        3.7 |        6.9 |            613 |
| nm2096009   | Andrew Jones      |                5 |                  191 |       3.04 |        1989 |        2.7 |        3.2 |            432 |
| nm0001752   | Steven Soderbergh |                4 |                  254 |       6.77 |      171684 |        6.2 |        7.0 |            401 |
| nm0515005   | Sam Liu           |                4 |                  260 |       6.32 |       28557 |        5.8 |        6.7 |            312 |
| nm0814469   | Sion Sono         |                4 |                  331 |       6.31 |        2972 |        5.4 |        6.4 |            502 |
| nm0425364   | Jesse V. Johnson  |                4 |                  299 |       6.10 |       14778 |        4.2 |        6.5 |            383 |
| nm2691863   | Justin Price      |                4 |                  315 |       4.93 |        5343 |        3.0 |        5.8 |            346 |
| nm0831321   | Chris Stokes      |                4 |                  198 |       4.32 |        3664 |        4.0 |        4.6 |            352 |
| nm6356309   | Özgür Bakar       |                4 |                  112 |       3.96 |        1092 |        3.1 |        4.9 |            374 |
+-------------+-------------------+------------------+----------------------+------------+-------------+------------+------------+----------------+
*/

