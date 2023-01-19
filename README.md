
# RSVP Movies Data Analysis - SQL

## Problem Introduction
RSVP Movies is an Indian film production company which has produced many super-hit movies. They have usually released movies for the Indian audience but for their next project, they are planning to release a movie for the global audience in 2022.

 

The production company wants to plan their every move analytically based on data and have approached you for help with this new project. You have been provided with the data of the movies that have been released in the past three years. You have to analyse the data set and draw meaningful insights that can help them start their new project. 

 

As a data analyst and an SQL expert, use SQL to analyse the given data and give recommendations to RSVP Movies based on the insights. The entire analytics process has been divided into four segments, where each segment leads to significant insights from different combinations of tables. The questions in each segment with business objectives given below.

## Data Model & ER Diagram
**Refer IMDb+movies+Data+and+ERD+final.xlsx file in this repository to know data structure and ER diagram of all the tables and its relationships.**

## Business questions
1. Find the total number of rows in each table of the schema?
2. Which columns in the movie table have null values?
3. Find the total number of movies released each year? How does the trend look month wise?
4. How many movies were produced in the USA or India in the year 2019?
5. Find the unique list of the genres present in the data set?
6. Which genre had the highest number of movies produced overall?
7. How many movies belong to only one genre?
8. What is the average duration of movies in each genre?
9. What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced?
10. Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
11. Which are the top 10 movies based on average rating?
12. Summarise the ratings table based on the movie counts by median ratings.
13. Which production house has produced the most number of hit movies (average rating > 8)?
14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
17. Do German movies get more votes than Italian movies?
18. Which columns in the names table have null values?
19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
20. Who are the top two actors whose movies have a median rating >= 8?
21. Which are the top three production houses based on the number of votes received by their movies?
22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
23. Find out the top five actresses in Hindi movies released in India based on their average ratings?
24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
25. What is the genre-wise running total and moving average of the average movie duration?

## Code Implementation & Executive Summary
**Refer IMDB+question.sql SQL and execution submission slides present in this repository to know about insights and recommendations mentioned.**

## DBMS Product Used
- **MySQL**

## Contributors
- [Ganesh Jalakam](https://github.com/GaneshJalakam)
- [Puneet Dadich](https://github.com/Puneet192)
