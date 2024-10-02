-- Ex 1
SELECT name, age
FROM users
WHERE age >= 18

-- Ex 2
SELECT number1 % number2 AS mod
FROM decimals

-- Ex 3
-- you are given a table 'otherangle' with columns 'a' and 'b'.
-- return a table with these columns and your result in a column named 'res'.
SELECT a, b, (180 - a - b) AS res
FROM otherangle

-- Ex 4
SELECT DISTINCT age
FROM people