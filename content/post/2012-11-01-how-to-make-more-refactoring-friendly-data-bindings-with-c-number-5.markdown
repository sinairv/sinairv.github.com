---
layout: post
title: "How to make more refactoring friendly data-bindings with C# 5"
date: 2012-11-01 19:46:29 +1000
comments: true
categories: 
- C#
- Data Binding
---
Imagine that we want to create a `Person` business object for whose properties we desire a two-way data binding. The source-to-target data-binding can be triggered by implementing `INotifyPropertyChanged` interface, like this:

```csharp
public class Person : INotifyPropertyChanged
{
    private string _name;
    private double _age;

    public string Name 
    {
        get
        {
            return _name;
        }

        set
        {
            if (value != _name)
            {
                _name = value;
                OnPropertyChanged("Name");
            }
        }
    }

    public double Age 
    {
        get
        {
            return _age;
        }

        set
        {
            if (_age != value)
            {
                _age = value;
                OnPropertyChanged("Age");
            }
        }
    }

    public event PropertyChangedEventHandler PropertyChanged;

    private void OnPropertyChanged(string propertyName)
    {
        if (PropertyChanged != null)
        {
            PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
```

See how the setters pass the property name in a `string`. This is not nice, because whenever we change the property name through refactoring tools, the string value remains untouched and we have to manually change them as well (if we are lucky enough to get notified before run-time). Anyway we had to tolerate them for years...

C# 5 comes with a nice feature, which is addition of two attributes `[CallerFilePath]` and `[CallerMemberName]` in the `System.Runtime.CompilerServices` namespace. If you decorate an **optional** string parameter of a method with one of these attributes, then the value of that parameter will be replaced with the caller's file name or the caller's member name at runtime, if no explicit value is passed for the optional parameter. They come very handy in logging scenarios, but we can use the latter for making our data-binding code nicer. This is how:

```csharp
public class Person : INotifyPropertyChanged
{
    private string _name;
    private double _age;

    public string Name 
    {
        get
        {
            return _name;
        }

        set
        {
            if (value != _name)
            {
                _name = value;
                OnPropertyChanged();
            }
        }
    }

    public double Age 
    {
        get
        {
            return _age;
        }

        set
        {
            if (_age != value)
            {
                _age = value;
                OnPropertyChanged();
            }
        }
    }

    public event PropertyChangedEventHandler PropertyChanged;

    private void OnPropertyChanged([CallerMemberName]string propertyName = "")
    {
        if (PropertyChanged != null)
        {
            PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
```
    
Now that string constants are removed from the setters we can more freely refactor our code. After being spoiled by automatic properties, this is still a very verbose way of defining properties; however it is much better than before.
