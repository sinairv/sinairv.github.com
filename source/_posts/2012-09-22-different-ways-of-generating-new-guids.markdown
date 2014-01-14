---
layout: post
title: "Different ways of generating new GUIDs"
date: 2012-09-22 17:49:59 +1000
comments: true
categories: 
- Guid
---

### In C# Code

```csharp
var newGuid = Guid.NewGuid();
```

### In Visual Studio
Go to: `Tools > Create GUID`


### In SQL Server Management Studio
Execute either of the following queries:

```sql
SELECT NEWID()
```

or

```sql
PRINT NEWID()
```

### None of the above
Go to [newguid.com](http://newguid.com/), and refresh the page as many times as you want.
