CREATE DATABASE streaming_service;

SHOW DATABASES;

USE streaming_service;

DESCRIBE Users;

CREATE TABLE Users(
user_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
username VARCHAR(50) NOT NULL, 
email VARCHAR(50) UNIQUE NOT NULL, 
password VARCHAR(50) NOT NULL,
joined_date DATETIME NOT NULL,
gender ENUM("male", "female","not_binary") NOT NULL,
age INT UNSIGNED NOT NULL, 
subscription_id INT UNSIGNED NOT NULL, 
role_id INT UNSIGNED NOT NULL, 
balance DOUBLE UNSIGNED NOT NULL);

CREATE TABLE Roles(role_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
role_name VARCHAR(50) NOT NULL);



ALTER TABLE Users
ADD CONSTRAINT FK_role_id 
FOREIGN KEY (role_id) 
REFERENCES Roles(role_id);


CREATE TABLE Plans(
plan_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
plan_name VARCHAR(50) NOT NULL, 
base_rate INT UNSIGNED NOT NULL,
duration_months INT UNSIGNED NOT NULL,
plan_description VARCHAR(250));





CREATE TABLE Subscriptions(
subscription_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
start_date DATETIME NOT NULL,
end_date DATETIME NOT NULL,
plan_id INT UNSIGNED NOT NULL, 
role_id INT UNSIGNED NOT NULL, 
is_active BOOL NOT NULL,
FOREIGN KEY (plan_id) REFERENCES Plans(plan_id));





ALTER TABLE Users
ADD CONSTRAINT FK_subscription_id 
FOREIGN KEY (subscription_id) 
REFERENCES Subscriptions(subscription_id);

CREATE TABLE Devices(
device_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
device_name VARCHAR(45) NOT NULL,
device_type ENUM("tv", "pc", "smartphone") NOT NULL);


CREATE TABLE Sessions(
session_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
start_time DATETIME NOT NULL,
end_time DATETIME,
device_id INT UNSIGNED NOT NULL,
user_id INT UNSIGNED NOT NULL,
FOREIGN KEY (device_id) REFERENCES Devices(device_id));


CREATE TABLE Movies(
movie_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
movie_name VARCHAR(255) NOT NULL,
rating DOUBLE UNSIGNED ,
time  TIME NOT NULL,
description VARCHAR(100),
subtitles_available BOOL,
year YEAR NOT NULL,
age_restriction INT UNSIGNED);


CREATE TABLE sessions_has_movie(
session_id INT UNSIGNED NOT NULL,
movie_id INT UNSIGNED NOT NULL,
PRIMARY KEY (session_id, movie_id),
FOREIGN KEY (session_id) REFERENCES Sessions (session_id),
FOREIGN KEY (movie_id) REFERENCES Movies (movie_id));



CREATE TABLE Actors(
actor_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
actor_name VARCHAR(255) NOT NULL,
actor_surname VARCHAR(45) NOT NULL,
date_of_birth DATETIME NOT NULL,
gender ENUM("male", "female","not_binary") NOT NULL
);

CREATE TABLE movie_has_actor(
movie_id INT UNSIGNED NOT NULL,
actor_id INT UNSIGNED NOT NULL,
PRIMARY KEY (actor_id, movie_id),
FOREIGN KEY (actor_id) REFERENCES Actors (actor_id),
FOREIGN KEY (movie_id) REFERENCES Movies (movie_id));





CREATE TABLE Directors(
director_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
director_name VARCHAR(255) NOT NULL,
director_surname VARCHAR(45) NOT NULL,
date_of_birth DATETIME NOT NULL,
gender ENUM("male", "female","not_binary") NOT NULL
);


CREATE TABLE movie_has_director(
movie_id INT UNSIGNED NOT NULL,
director_id INT UNSIGNED NOT NULL,
PRIMARY KEY (director_id, movie_id),
FOREIGN KEY (director_id) REFERENCES Directors (director_id),
FOREIGN KEY (movie_id) REFERENCES Movies (movie_id));




CREATE TABLE Genres(
genre_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
genre_name VARCHAR(255) NOT NULL);

CREATE TABLE movie_has_genre(
genre_id INT UNSIGNED NOT NULL,
movie_id INT UNSIGNED NOT NULL,
PRIMARY KEY (genre_id, movie_id),
FOREIGN KEY (genre_id) REFERENCES Genres (genre_id),
FOREIGN KEY (movie_id) REFERENCES Movies (movie_id));



CREATE TABLE Payments(
payment_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
payment_date DATETIME NOT NULL,
payment_method VARCHAR(45) NOT NULL,
total_amount DOUBLE UNSIGNED NOT NULL,
transaction_id INT UNSIGNED NOT NULL,
payment_status ENUM("successful", "failed", "pending") NOT NULL,
user_id INT UNSIGNED NOT NULL,
FOREIGN KEY (user_id) 
REFERENCES Users(user_id));



CREATE TABLE Logger(
logger_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
action ENUM("create", "read", "update", "delete") NOT NULL,
action_category ENUM("session", "payment", "subscription", "plan", "director", "actor", "movie", "genre", "device") NOT NULL,
time DATETIME NOT NULL,
user_id INT UNSIGNED NOT NULL,
FOREIGN KEY (user_id) REFERENCES Users (user_id));


CREATE TABLE Reviews(
review_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
review_name VARCHAR(45) NOT NULL,
review_text VARCHAR(255) NOT NULL,
author_id INT UNSIGNED NOT NULL,
movie_id INT UNSIGNED NOT NULL,
moderator_id INT UNSIGNED NOT NULL,

FOREIGN KEY (author_id) 
REFERENCES Users(user_id),

FOREIGN KEY (moderator_id) 
REFERENCES Users(user_id),

FOREIGN KEY (movie_id) 
REFERENCES Movies(movie_id));



CREATE INDEX movies_movie_name_idx
ON Movies (movie_name);

CREATE INDEX directors_director_name_surname_idx
ON Directors (director_name, director_surname);

CREATE INDEX actors_actor_name_surname_idx
ON Actors (actor_name, actor_surname);

CREATE INDEX genres_genre_name_idx
ON Genres (genre_name);

INSERT INTO Roles(role_name) VALUES
('admin'),
('moderator'),
('user');

INSERT INTO Plans(plan_name, base_rate, duration_months, plan_discription) VALUES
('basic', '15', '1', '1 month plan'),
('standard', '36', '3', '3 months plan'),
('premium', '120', '12', 'year plan');


INSERT INTO Devices(device_name, device_type) VALUES
('WebOS LG TV', 'tv'),
('Redmi 5', 'smartphone'),
('MacBook Air (M1, 2020)', 'pc'),
('POCO X3 NFC', 'smartphone');


INSERT INTO Directors(director_name, director_surname, date_of_birth, gender) VALUES
('Martin', 'Scorcese', '1942-11-17', 'male'),
('Christopher', 'Nolan', '1970-07-30', 'male'),
('Allen', 'Woody', '1935-12-01', 'male'),
('Joel', 'Coen', '1954-11-29', 'male'),
('Ethan', 'Coen', '1957-09-21', 'male');


INSERT INTO Actors(actor_name, actor_surname, date_of_birth, gender) VALUES
('Timothée', 'Chalamet', '1995-12-27', 'male'),
('Selena', 'Gomez', '1992-07-22', 'female'),
('Matthew', 'McConaughey', '1969-11-04', 'male'),
('Margot', 'Robbie', '1990-07-02', 'female');


INSERT INTO Genres(genre_name) VALUES
('drama'),
('comedy'),
('adventure'),
('criminal'),
('melodrama');


INSERT INTO Movies(
movie_name, time,
description, subtitles_available,
year,
age_restriction) VALUES
('Interstellar', '02:59', "When Earth becomes uninhabitable in the future, a", '1', '2014', '18'),
('A Rainy Day in New York', '01:32', "A young couple arrives in New York", '1', '2020', '18');


INSERT INTO streaming_service.movie_has_director (movie_id, director_id) VALUES 
(1, 2),
(2,3);


INSERT INTO streaming_service.movie_has_actor (movie_id, actor_id) VALUES 
(1, 3),
(2,1),
(2,2);



INSERT INTO streaming_service.movie_has_genre (movie_id, genre_id) VALUES 
(1, 3),
(1,1),
(2,1),
(2,2),
(2,5);



INSERT INTO streaming_service.subscriptions (end_date, start_date, is_active, plan_id) VALUES 
('2022-11-02 00:00:00', '2022-12-02 00:00:00', 1, 1),
('2022-11-03 00:00:00', '2023-02-02 00:00:00', 1, 2),
('2022-11-03 01:01:01', '2023-11-03 01:01:01', 1, 3);




INSERT INTO streaming_service.Users(username,
Email,
Password,
joined_date,
Gender,
Age,
subscription_id,
role_id,
Balance) VALUES  
( 'mary0110', 'mashenka0110@gmail.com', 'password1', '2022-11-02 00:00:00', 'female', 20, '1', 1, 0 ),
('mashaaa_k25','mashaaa_k25@gmail.com', 'password2', '2022-11-03 00:00:00', 'female', 19, '2', '2', 0),
('Lumpen', 'lizak@gmail.com', 'password3','2022-11-03 01:01:01', 'not_binary', '20', '3', '3', '5000.98');


INSERT INTO streaming_service.payments (payment_date, payment_method, total_amount, transaction_id, payment_status, user_id) VALUES 
('2022-11-02 00:00:00', 'card','15','123456', 'successful', '7'),
('2022-11-03 00:00:00', 'method2','36','223456', 'successful', '8'),
('2022-11-03 01:01:01', 'method3','5100.98','323456', 'successful', '9');


INSERT INTO streaming_service.sessions (start_time, end_time, device_id, user_id) VALUES 
('2022-11-02 00:01:00', '2022-11-02 00:03:00', '1','1'),
('2022-11-03 00:02:00','2022-11-03 00:03:00',  '2','2'),
('2022-11-03 01:03:01', '2022-11-03 08:03:01','3','3');


INSERT INTO streaming_service.sessions_has_movie (session_id, movie_id) VALUES 
(1,1),
(1,2),
(2,2),
(3,1);


INSERT INTO reviews(review_name, review_text, author_id, movie_id, moderator_id) VALUES 
('Good film', 'I liked this movie', '9', '1', '8'),
('Also good film', 'I liked this movie too ', '9', '1', '8');


INSERT INTO Logger(action, action_category, time, user_id) VALUES 
('create', 'session', '2022-11-03 00:02:00', '7'),('create', 'session', '2022-11-03 00:02:00', '8'),('create', 'session', '2022-11-03 01:03:01', '9'),('create', 'subscription', '2022-11-02 00:00:00', '7');




SELECT m.movie_name, d.director_name
FROM movies m JOIN movie_has_director mhd ON m.movie_id = mhd.movie_id JOIN directors d ON mhd.director_id = d.director_id
GROUP BY 1, 2
HAVING m.movie_name IN (
SELECT m.movie_name
FROM movies m JOIN movie_has_genre mhg ON m.movie_id = mhg.movie_id JOIN genres g ON mhg.genre_id = g.genre_id
WHERE g.genre_name LIKE 'dram%'
GROUP BY 1
);

UPDATE subscriptions
SET 
plan_id = (
		SELECT plan_id FROM plans
		WHERE duration_months = 3),
start_date = now(),
end_date = date_add(start_date, interval 3 month),
is_active = 1
WHERE subscription_id = 
(SELECT subscription_id FROM users
WHERE username = 'lumpen');

SELECT movie_name, year FROM MOvies m JOIN movie_has_actor mha  ON m.movie_id = mha.movie_id JOIN actors a ON mha.actor_id = a.actor_id
 WHERE a.actor_name LIKE '%ele%' AND a.actor_surname LIKE '%omez';

SELECT movie_name, year, age_restriction
FROM movies
WHERE age_restriction >= 18;

SELECT m.movie_name, a.actor_surname FROM movies m LEFT JOIN movie_has_actor mha ON m.movie_id = mha.movie_id LEFT JOIN actors a ON mha.actor_id = a.actor_id;

SELECT movie_name
FROM Movies
WHERE director_id = (
	SELECT director_id
	FROM Directors 
	WHERE director_name = ‘Martin’ AND director_surname = ‘Scorcese’);


INSERT INTO Movies(
movie_name, time,
description, subtitles_available,
year,
age_restriction) VALUES
('The Godfather', '02:55', "The aging patriarch of an organized crime dynasty in postwar New York", '1', '1972', '18'),
('The Dark Night', '02:32', "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham", '1', '2008', '18'),
('Pulp Fiction', '02:34', "The lives of two mob hitmen, a boxer, a gangster and his wife", '1', '1994', '18'),
('Forrest Gump', '02:22', "The presidencies of Kennedy and Johnson, the Vietnam War, the Watergate scandal and", '1', '1994', '12'),
('Fight Club', '02:19', "An insomniac office worker and a devil-may-care soap maker form an underground fight club", '1', '1999', '18'),
('Goodfellas', '02:25', "The story of Henry Hill and his life in the mob, covering his relationship with his wife Karen Hill", '1', '1990', '18'),
('City of God', '02:10', "In the slums of Rio, two kids' paths diverge as one struggles to become a photographer", '1', '2002', '18')
;


INSERT INTO Actors(actor_name, actor_surname, date_of_birth, gender) VALUES
('Alexandre', 'Rodrigues', '1983-05-21', 'male'),
('Robert', 'De Niro', '1943-08-17', 'male'),
('Joe', 'Pesci', '1943-02-09', 'male'),
('Brad', 'Pitt', '1969-08-18', 'male'),
('Edward', 'Norton', '1963-12-18', 'male'),
('Tom', 'Hanks', '1956-07-09', 'male'),
('Robin', 'Wright', '1966-04-08', 'female'),
('Christian', 'Bale', '1974-01-30', 'male');


INSERT INTO streaming_service.movie_has_actor (movie_id, actor_id) VALUES 
(16, 5),
(14,8),
(14,9),
(13, 11),
(15, 6),
(11,12),
(10, 6),
(10,7);


CREATE VIEW films_with_authors AS
SELECT m.movie_id, m.movie_name, GROUP_CONCAT(a.actor_name SEPARATOR ', ') as actor_names,
GROUP_CONCAT(a.actor_surname SEPARATOR ', ') as actor_surnames
FROM movies m
LEFT JOIN movie_has_actor mha ON m.movie_id = mha.movie_id
LEFT JOIN actors a ON a.actor_id = mha.actor_id
GROUP BY m.movie_id;

CREATE VIEW reiews_view_tmp AS 
SELECT r.review_name , r.review_text, u.username AS author, r.moderator_id
FROM reviews r
LEFT JOIN users u ON u.user_id = r.author_id;

CREATE VIEW reviews_view AS
SELECT rvt.review_name, rvt.review_text, rvt.author,
u.username AS moderator
FROM reiews_view_tmp rvt
LEFT JOIN users u ON u.user_id = rvt.moderator_id; 
SELECT u.user_id, d.device_name FROM Devices d LEFT JOIN Sessions s ON d.device_id = s.device_id LEFT JOIN users u ON u.user_id = s.user_id 
WHERE d.device_type = 'tv';


