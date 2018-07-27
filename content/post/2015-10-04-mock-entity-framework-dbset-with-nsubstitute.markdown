---
layout: post
title: "Mock Entity Framework DbSet with NSubstitute"
date: 2015-10-04 23:33:40 +1100
comments: true
categories: 
- Entity Framework
- NSubstitute
- Unit Test
- C#
---
The source code for this post is on [GitHub](https://github.com/sinairv/MockEfDbSetWithNSubstitute).

When it comes to mocking a `DbSet` to test various read and write operations things may get a little bit tricky. Mocking a `DbSet` for a write operation (`Add`, `Update`, or `Remove`) is quite straightforward. But testing a synchronous read operation requires mocking the whole `IQueryable` interface. Even more trickier than that is testing an asynchronous read operation which requires mocking an `IDbAsyncQueryProvider` interface. [Here](https://msdn.microsoft.com/en-au/data/dn314429.aspx) is a very good article that demonstrates how to work around these difficulties using [Moq](https://github.com/Moq/moq4). This blog post shows how to achieve the same thing using [NSubstitute](http://nsubstitute.github.io/).

Mocking a `DbSet` for a write operation is quite straightforward:

```csharp
var mockSet = Substitute.For<DbSet<Person>>();
var mockContext = Substitute.For<IPeopleDbContext>();
mockContext.People.Returns(mockSet);
var service = new PeopleService(mockContext);

// Act
service.AddPersonAsync(new Person { FirstName = "John", LastName = "Doe" });

// Assert
mockSet.Received(1).Add(Arg.Any<Person>());
mockContext.Received(1).SaveChangesAsync();
```

As seen above mocking the `DbSet` is as easy as one single call to `Substitute.For<DbSet<T>>()`.

However mocking a `DbSet` for a synchronous read operation needs a little bit more work. It needs to mock the whole `IQueryable` interface:

```csharp
var data = new List<Person> 
{ 
    new Person { Id = 1, FirstName = "BBB" }, 
    new Person { Id = 2, FirstName = "ZZZ" }, 
    new Person { Id = 3, FirstName = "AAA" }, 
}.AsQueryable();

// create a mock DbSet exposing both DbSet and IQueryable interfaces for setup
var mockSet = Substitute.For<DbSet<Person>, IQueryable<Person>>();

// setup all IQueryable methods using what you have from "data"
((IQueryable<Person>)mockSet).Provider.Returns(data.Provider);
((IQueryable<Person>)mockSet).Expression.Returns(data.Expression);
((IQueryable<Person>)mockSet).ElementType.Returns(data.ElementType);
((IQueryable<Person>)mockSet).GetEnumerator().Returns(data.GetEnumerator());

// do the wiring between DbContext and DbSet
var mockContext = Substitute.For<IPeopleDbContext>();
mockContext.People.Returns(mockSet);
var service = new PeopleService(mockContext);

// Act
var people = service.GetAllPeople();

// Assert
Assert.That(people.Length, Is.EqualTo(3));
Assert.That(people[0].FirstName, Is.EqualTo("BBB"));
Assert.That(people[1].FirstName, Is.EqualTo("ZZZ"));
Assert.That(people[2].FirstName, Is.EqualTo("AAA"));
```

Mocking a `DbSet` for an asynchronous read operation requires much more work and a bunch of extra classes. [This article](https://msdn.microsoft.com/en-au/data/dn314429.aspx) lists the required extra classes. To name add [`TestDbAsyncEnumerable`](https://github.com/sinairv/MockEfDbSetWithNSubstitute/blob/master/MockEfDbSet.Test/TestUtils/TestDbAsyncEnumerable.cs), [`TestDbAsyncEnumerator`](https://github.com/sinairv/MockEfDbSetWithNSubstitute/blob/master/MockEfDbSet.Test/TestUtils/TestDbAsyncEnumerator.cs), and [`TestDbAsyncQueryProvider`](https://github.com/sinairv/MockEfDbSetWithNSubstitute/blob/master/MockEfDbSet.Test/TestUtils/TestDbAsyncQueryProvider.cs) classes to your test project. This is how you'd be able to mock `DbSet` for asynchronous read operations:

```csharp
var data = new List<Person> 
{ 
    new Person { Id = 1, FirstName = "BBB" }, 
    new Person { Id = 2, FirstName = "ZZZ" }, 
    new Person { Id = 3, FirstName = "AAA" }, 
}.AsQueryable();

// create a mock DbSet exposing both DbSet, IQueryable, and IDbAsyncEnumerable interfaces for setup
var mockSet = Substitute.For<DbSet<Person>, IQueryable<Person>, IDbAsyncEnumerable<Person>>();

// setup all IQueryable and IDbAsyncEnumerable methods using what you have from "data"
// the setup below is a bit different from the test above
((IDbAsyncEnumerable<Person>)mockSet).GetAsyncEnumerator()
    .Returns(new TestDbAsyncEnumerator<Person>(data.GetEnumerator()));
((IQueryable<Person>)mockSet).Provider.Returns(new TestDbAsyncQueryProvider<Person>(data.Provider));
((IQueryable<Person>)mockSet).Expression.Returns(data.Expression);
((IQueryable<Person>)mockSet).ElementType.Returns(data.ElementType);
((IQueryable<Person>)mockSet).GetEnumerator().Returns(data.GetEnumerator());

// do the wiring between DbContext and DbSet
var mockContext = Substitute.For<IPeopleDbContext>();
mockContext.People.Returns(mockSet);
var service = new PeopleService(mockContext);

// Act
var people = await service.GetAllPeopleAsync();

// Assert
Assert.That(people.Length, Is.EqualTo(3));
```

The amount of code per unit test seems a little bit too much. So I created a utility method that creates the mock `DbSet`:

```csharp
public static class NSubstituteUtils
{
    public static DbSet<T> CreateMockDbSet<T>(IEnumerable<T> data = null)
        where T: class
    {
        var mockSet = Substitute.For<DbSet<T>, IQueryable<T>, IDbAsyncEnumerable<T>>();

        if (data != null)
        {
            var queryable = data.AsQueryable();

            // setup all IQueryable and IDbAsyncEnumerable methods using what you have from "data"
            // the setup below is a bit different from the test above
            ((IDbAsyncEnumerable<T>) mockSet).GetAsyncEnumerator()
                .Returns(new TestDbAsyncEnumerator<T>(queryable.GetEnumerator()));
            ((IQueryable<T>) mockSet).Provider.Returns(new TestDbAsyncQueryProvider<T>(queryable.Provider));
            ((IQueryable<T>) mockSet).Expression.Returns(queryable.Expression);
            ((IQueryable<T>) mockSet).ElementType.Returns(queryable.ElementType);
            ((IQueryable<T>) mockSet).GetEnumerator().Returns(queryable.GetEnumerator());
        }

        return mockSet;
    }
}
``` 

Exploiting this, the unit test code would become shorter and more readable:

```csharp
var data = new List<Person> 
{ 
    new Person { Id = 1, FirstName = "BBB" }, 
    new Person { Id = 2, FirstName = "ZZZ" }, 
    new Person { Id = 3, FirstName = "AAA" }, 
};

var mockSet = NSubstituteUtils.CreateMockDbSet(data);
var mockContext = Substitute.For<IPeopleDbContext>();
mockContext.People.Returns(mockSet);
var service = new PeopleService(mockContext);

// Act
var secondPerson = await service.GetPersonAsync(2);

// Assert
Assert.That(secondPerson.Id, Is.EqualTo(2));
```

The source code for this post is accessible from [here](https://github.com/sinairv/MockEfDbSetWithNSubstitute).
