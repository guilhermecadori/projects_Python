/*
    Write a select statement that takes name from person table 
    and return "Hello, <name> how are you doing today?" results 
    in a column named greeting

    Make sure you type the exact thing I wrote or the program may 
    not execute properly]
*/
-- person table has name data
-- GC: Unit tests were checking whether "bad grammar" was replicated
SELECT 
  CASE
    WHEN name <> '' THEN CONCAT('Hello, ', name, ' how are you doing today?')
  END as greeting
FROM person

---------------------------------------------------------------------------------------------

/*
  It's pretty straightforward. Your goal is to create a function that removes the first and 
  last characters of a string. You're given one parameter, the original string.
  You don't have to worry about strings with less than two characters.
*/ 
-- Write your SQL statement here: you are given a table 'removechar' with column 's', 
-- Return a table with column 's' and your result in a column named 'res'.
SELECT s, SUBSTRING(s, 2, LENGTH(s) - 2) AS res
FROM removechar

---------------------------------------------------------------------------------------------

/*
  Nathan loves cycling.
  Because Nathan knows it is important to stay hydrated, he drinks 0.5 litres of water per hour of cycling.
  You get given the time in hours and you need to return the number of litres Nathan will drink, 
  rounded to the smallest value.
  
  For example:
  hours = 3 ----> liters = 1
  hours = 6.7---> liters = 3
  hours = 11.8--> liters = 5

  Input data is available from the table cycling, which has 2 columns: id and hours. 
  For each row, you have to return 3 columns: 
  id, hours and liters (not litres, it's a difference from the kata description)
*/

-- GC: Valid alternative
SELECT 
    id
  , hours
  , CASE
      WHEN hours IS NOT NULL THEN FLOOR(hours * 0.5) 
    END AS liters
FROM cycling

-- GC: Valid alternative as well
SELECT 
    id,
    hours,
    FLOOR(hours * 0.5) AS liters
FROM cycling;

---------------------------------------------------------------------------------------------










