---
layout: page
title: "Trigger Exists"
comments: true
sharing: true
footer: true
---
```sql
-- Method 1
-- Use the name without database owner (such as dbo, etc)
IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'MyTrigger' AND type = 'TR')
   PRINT 'Exists'
   -- DROP TRIGGER reminder
GO
 
-- Method 2
-- Use the name with or without the database owner (such as dbo, etc)
IF OBJECT_ID ('dbo.MyTrigger','TR') IS NOT NULL
   PRINT 'Exists'
 
-- or 
 
IF OBJECT_ID ('MyTrigger','TR') IS NOT NULL
   PRINT 'Exists'
 
GO
```

The `deleted` table stores copies of the affected rows during `DELETE` and `UPDATE` statements. During the execution of a `DELETE` or `UPDATE` statement, rows are `deleted` from the trigger table and transferred to the `deleted` table. The `deleted` table and the trigger table ordinarily have no rows in common.

The `inserted` table stores copies of the affected rows during `INSERT` and `UPDATE` statements. During an `INSERT` or `UPDATE` transaction, new rows are added to both the `inserted` table and the trigger table. The rows in the `inserted` table are copies of the new rows in the trigger table.

An `UPDATE` transaction is similar to a delete operation followed by an `INSERT` operation; the old rows are copied to the `deleted` table first, and then the new rows are copied to the trigger table and to the `inserted` table.

When you set trigger conditions, use the `inserted` and `deleted` tables appropriately for the action that fired the trigger. Although referencing the `deleted` table when testing an `INSERT` or the `inserted` table when testing a DELETE does not cause any errors, these trigger test tables do not contain any rows in these cases.

From: http://msdn.microsoft.com/en-us/library/ms191300.aspx