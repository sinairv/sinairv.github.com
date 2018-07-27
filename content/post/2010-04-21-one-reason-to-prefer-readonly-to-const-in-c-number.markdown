---
layout: post
title: "One reason to prefer readonly to const in C#"
date: 2010-04-21 14:19:38 +1000
comments: true
categories: 
- C#
---
First off, let's talk about what's going on in C# compiler when you use `const` or `readonly` in your field definitions. The `const` qualifier can be used with primitive data types, and strings only. When used, the value assigned to a `const` field, is inserted directly in all its references in the generated IL code. This is true about other assemblies too. Other assemblies that refer to that `const` field, are compiled as if they have used directly the value itself. This can be the source of problem that I'm going to talk about soon. `readonly` fields are run-time constants. They occupy some space in memory, and references to them are resolved at run-time, as if we have referred to an ordinary variable. Actually they are variables that resemble constants.

Imagine that you have created and released a project to public. Your project contains several assemblies in form of `.dll` files. They make use of some constant value in one of the `.dll` files, e.g., `SomeLibrary.dll` stores a constant value in one of its classes, e.g.,

```csharp
public class Options
{
   ...
   public const int NetworkTimeout = 2000; 
   ...
}
```

You realize that the value assigned to `NetworkTimeout` is less than expected, so you decide to update `SomeLibrary.dll` files in all your customer machines with a new one in which `NetworkTimeout` is set to 3000. But it will not work. Because all references to `NetworkTimeout` in other assemblies have been replaced with the constant 2000, and the new value will not be fetched any more. In this case the problem will be solved only when all other assemblies are rebuilt. No other update scenarios will do.

But if we have used `readonly` instead of `const` the problem would have been solved with updating `SomeLibrary.dll` only.

```csharp
public class Options
{
    ...
    public static readonly int NetworkTimeout = 2000;
    ...
}
```

The `static` modifier has been added only to make the two codes above compatible. Note that all `const` fields are also static, but `readonly` fields can be either `static` or an instance field.
