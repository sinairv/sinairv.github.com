---
layout: post
title: "On SQL Server Transactions"
date: 2019-02-10T20:09:11+11:00
comments: true
categories: 
- TSQL
- Microsoft SQL Server
- SQL
---

**TL;DR**

* A single `INSERT`/`UPDATE`/`DELETE` statement is run within an implicit transaction scope regardless of how many records they modify
* A transaction must be explicitly rolled back upon error
* After a transaction is rolled back, the error should be raised so that the script runner becomes aware of the error

## A single INSERT/UPDATE/DELETE statement

Each individual `INSERT`/`UPDATE`/`DELETE` statement is run by SQL Server within an implicit transaction scope. This is regardless of the number of
records affected by these statements. If you run an update statement that is to update 10,000 records; it either successfully updates the whole lot or none of them. Therefore you don't need to wrap it inside a transaction block. However if your scripts consists of multiple such statements, then depending on the requirement you ought to put them within a transaction block.

How to verify this? Create a table called `Person` with a `Name` column of maximum 3 characters. Insert a few records with various name lengths of 1, 2, and 3. 

```sql
CREATE TABLE Person
(
    Id INT IDENTITY(1, 1),
    [Name] VARCHAR(3)
);
GO

INSERT INTO Person
    ([Name])
VALUES 
    ('A'),
    ('AB'),
    ('ABC')
GO
```

Write an update statement that appends one character to the name. This should succeed for `Person`s with name shorter 3 characters, and should fail for the `Person` named `ABC`, because the column in the table doesn't allow more than 3 characters. 

```sql
UPDATE Person
SET [Name] = [Name] + 'D'
```

After `SELECT`ing the contents of the table, you'd see that nothing was changed. Which means the `UPDATE` statement was run within an implicit transaction scope by SQL Server.

## A transaction must be explicitly rolled back

Transactions must be explicitly rolled back, when an error happens. SQL Server doesn't roll it back for you. This is an example of how it should NOT be written:

```sql
-- This is the WRONG way of using transactions.
BEGIN TRANSACTION
GO

INSERT Person([Name])
VALUES ('XYZ')
GO

UPDATE Person 
SET [Name] = [Name] + 'D'
GO

COMMIT TRANSACTION
GO
-- BAD, BAD, BAD
```

If you `SELECT` the contents of the table, you'd see that `XYZ` ended up in the database, which is not what we want.

In order to write it properly, use the following snippet as a template for the code you want to wrap in a transaction:

```sql
BEGIN TRANSACTION

BEGIN TRY

    -- do something
    -- if a condition is not met then 
    -- BEGIN
    --    RAISERROR('could not find record', 16,1)
    -- END

    COMMIT TRANSACTION

END TRY
BEGIN CATCH

    ROLLBACK TRANSACTION

    -- this is quite necessary otherwise the error would be silenced.
    DECLARE @errorMessage NVARCHAR(200);
    SELECT @errorMessage = ERROR_MESSAGE()
    RAISERROR(@errorMessage, 16,1)

END CATCH
```

What does it do? It executes the SQL statements in a `TRY` block, if an error is occurred the `CATCH` block will catch it and rolls back the transaction.
The `RAISEERROR` bit after transaction roll-back is very important. If it's left out the runner of the script would think the execution succeeded with no errors. 

This is how to rewrite our script properly:

```sql
BEGIN TRANSACTION

BEGIN TRY

    INSERT Person([Name])
    VALUES ('HJK');

    UPDATE Person 
    SET [Name] = [Name] + 'D';

    COMMIT TRANSACTION

END TRY
BEGIN CATCH

    ROLLBACK TRANSACTION

    DECLARE @errorMessage NVARCHAR(200);
    SELECT @errorMessage = ERROR_MESSAGE()
    RAISERROR(@errorMessage, 16,1)

END CATCH
```

If you run the above, you'd see `HJK` is not inserted to the database because the following `UPDATE` has failed. This is what's expected from a transaction.

I sometimes see programmers that don't roll-back transactions and assume if something goes wrong SQL Server takes care of it. This is wrong, and probably rooted in the fact that some high level languages and libraries hide the roll-back bit from you. For example in C#, you create a transaction scope in a `using` block, and in the end `commit` it. You never explicitly write the code for rolling back the transaction. But the roll back statement is hidden there. It's in the `Dispose` method of the transaction scope which is called as soon as the `using` block ends. We don't have such syntactic sugars in TSQL, hence we have to explicitly call the roll back statement.
