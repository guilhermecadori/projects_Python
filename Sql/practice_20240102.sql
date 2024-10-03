-- Ex 1
SELECT name, age
FROM users
WHERE age >= 18

-- Ex 2
SELECT number1 % number2 AS mod
FROM decimals

-- Ex 3
-- You are given a table 'otherangle' with columns 'a' and 'b'.
-- return a table with these columns and your result in a column named 'res'.
SELECT a, b, (180 - a - b) AS res
FROM otherangle

-- Ex 4
SELECT DISTINCT age
FROM people

-- Ex 5
/*
    This kata is about multiplying a given number by eight if it is an even number 
    and by nine otherwise.

    Write your SQL statement here: you are given a table 'multiplication' 
    with column 'number', return a table with column 'number' and your result 
    in a column named 'res'.

*/
SELECT 
    number,
    CASE 
        WHEN number % 2 = 0 THEN number * 8
        ELSE number * 9
    END AS res
FROM multiplication
