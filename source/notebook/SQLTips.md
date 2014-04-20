---
layout: page
title: "SQL Tips"
comments: true
sharing: true
footer: true
---
# SQL Tips

### Get the name of day of week

Use the `DATENAME` function with `WEEKDAY` or `DW` parameter:

```sql
SELECT DATENAME(WEEKDAY, '20120101')
-- Sunday
```

### Retrieve only the date part from a `DATETIME`

Method 1: by keeping the `DATETIME` data type:

```sql
DATEADD(D, 0, DATEDIFF(D, 0, '2012-11-09 20:30'))
```

Method 2: by converting `DATETIME` to `VARCHAR`:

```sql
CONVERT(VARCHAR(10), '2012-11-09 20:30', 111)
```

[Source](http://blog.sqlauthority.com/2007/07/23/sql-server-udf-get-the-day-of-the-week-function/)

### See if two date-times belong to a same day

The ugly solution is to strip both dates of their time section (as described above), and then compare if the results are equal. 
The better solution is to use the `DATEDIFF` function, with the `DAY` or `D` parameter, and make sure if the result is 0:

```sql
DATEDIFF(DAY,@StartDate,@EndDate)
```

### Getting Weekday Number Regardless of Database Settings

Use this to have Monday as 0, Tuesday as 1, and so on:

```sql
SELECT (DATEPART(dw, @SomeDate) + @@DATEFIRST - 2) % 7
```

Use this to have Sunday as 0, Monday as 1, and so on. This is in correspondance with C# `DayOfWeek` Enum:

```sql
SELECT (DATEPART(dw, @SomeDate) + @@DATEFIRST - 1) % 7
```

### Number of weekdays (workdays) between two dates

```sql
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
SET @StartDate = '2008/10/01'
SET @EndDate = '2008/10/31'


SELECT
   (DATEDIFF(dd, @StartDate, @EndDate) + 1)
  -(DATEDIFF(wk, @StartDate, @EndDate) * 2)
  -(CASE WHEN DATENAME(dw, @StartDate) = 'Sunday' THEN 1 ELSE 0 END)
  -(CASE WHEN DATENAME(dw, @EndDate) = 'Saturday' THEN 1 ELSE 0 END)
```

(Source)[http://stackoverflow.com/questions/252519/count-work-days-between-two-dates-in-t-sql]

### Remove carriage return and line breaks

And replace duplicate spaces with a single one:

```sql
SELECT 
    REPLACE(
        REPLACE(
            REPLACE(   
                REPLACE(@string, CHAR(13), ''), 
            CHAR(10), ' '), 
        '  ', ' '),
    '  ', ' ')
```

### T-SQL `LEN` function does not count trailing spaces

```sql
LEN('word') = LEN('word ') = LEN('word     ') = 4
```

However the leading spaces are taken into account:

```sql
LEN(' word') = 5
```

### Ammend query rsults with 0 counts for all possible items

Assuming `DS` as the data-source, we want the count for all items for all persons to be returned. If an item is missing for a person in `DS` it should be returned with the value of 0. This is how to do it, and it's inspired from [here](http://stackoverflow.com/questions/13576402/how-to-include-count-equal-to-0-on-this-query#comment18604831_13576402):

```sql
WITH DS (Person, Item, Unit) AS 
(
    SELECT 'P1', 'a', 1
    UNION ALL
    SELECT 'P1', 'b', 2
    UNION ALL
    SELECT 'P2', 'a', 3
    UNION ALL
    SELECT 'P3', 'b', 4
    UNION ALL
    SELECT 'P4', 'c', 1
)
SELECT P.Person AS Person, T.Item, COALESCE(DS.Unit, 0) AS Unit, T.SortOrder
FROM 
( 
    SELECT 'a' AS Item, 1 As SortOrder
    UNION ALL
    SELECT 'b' AS Item, 2 As SortOrder
    UNION ALL
    SELECT 'c' AS Item, 3 As SortOrder
) T 
LEFT JOIN 
(
    SELECT DISTINCT DS.Person AS Person
    FROM DS

) P ON 1 = 1
LEFT JOIN DS ON DS.Item = T.Item AND DS.Person = P.Person
ORDER BY P.Person, T.SortOrder
```

Note that constant tables are comming first in the join-chain, and `DS` is comming last. Also note that the last join condition binding `DS` with constant tables must have conditions for all constant tables (here `P` and `T`).

### Cursor syntax

```sql
DECLARE @myVar varchar(MAX)

DECLARE my_cursor CURSOR FOR 
SELECT *
FROM myTable

OPEN my_cursor

FETCH NEXT FROM my_cursor
INTO @myVar

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Do something with @myVar

   
    FETCH NEXT FROM my_cursor
    INTO @myVar
END

CLOSE my_cursor
DEALLOCATE my_cursor
```


### Kill all connections to a SQL Server Database

Run the first statement and immediately after that the second one to revert the effect of the first statement:

```sql
alter database dbName set single_user with rollback immediate 

alter database dbName set multi_user with rollback immediate
```

[Source](http://blog.tech-cats.com/2008/01/kill-all-database-connections-to-sql.html)

### Great Syntax to back-up a table into a temp table

```sql
SELECT * INTO #backup_temp_table_name FROM SomeTable
GO
```

