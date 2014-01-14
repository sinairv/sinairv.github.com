---
layout: post
title: "Assigning values to private fields using reflection"
date: 2010-03-06 14:19:38 +1000
comments: true
categories: 
- C#
- Reflection
---
Suppose that you have a class with various non-public fields, e.g., the class named `ClassToTest` below servers as a good example.

```csharp
public class ClassToTest
{
    public int SomeNumber { get; set; }

    private int m_somePrivateProperty { get; set; }
    private int m_somePrivateVar;

    private static int s_someStaticNumber;
}
```

And suppose that we desire to assign some value to the private variable `m_somePrivateVar`, and the private property `m_somePrivateProperty`. The approach is to iterate through the fields of the `ClassToTest` type to find the desired field. If it is a variable we should type-cast it to `FieldInfo`, and if it is a property we should type-cast it to `PropertyInfo`. Then we should call the `SetValue` method appropriately. This is shown below:

```csharp
ClassToTest c = new ClassToTest();

Type t = typeof(ClassToTest);
foreach (var member in t.GetMembers(BindingFlags.Instance |
                                    BindingFlags.NonPublic | 
                                    BindingFlags.Public))
{
    if (member.Name == "m_somePrivateVar")
    {
        // changing the variable
        FieldInfo fi = (FieldInfo)member;
        fi.SetValue(c, 18);
    }
    else if (member.Name == "m_somePrivateProperty")
    {
        // changing the property
        PropertyInfo pi = (PropertyInfo)member;
        pi.SetValue(c, 13, null);
    }
}
```

Here we have successfully assigned values to selected private fields of our class.
