---
layout: post
title: "An example for C# dynamic in action"
date: 2012-07-23 17:20:53 +1000
comments: true
categories: 
- C#
- Dynamic
---
Recently I was involved with enabling validation for a Windows Forms form containing several pages shown through a tree view. There were one user control defined for each page, therefore whenever a node in tree-view got activated, an instance of that user-control were shown. The user-controls did not have a common user-defined parent base-class or interface. The author of the existing code had defined a `Save` method in each control separately which performed updating data with values entered in the forms.

First, I changed all `void Save()` methods to `bool Save()`, and performed the validation stuff in each control separately. Then in the parent form, I created an array of `Control`s, so that I could loop through them, and call their `Save` method. But wait, `Save` is not inherited from any base-class or interface, so there's no polymorphism at hand. How can I call them through references of type `Control`?

Well honestly, the best solution would be adding a new interface to the project, say `ISavableControl` or something, add the `Save` method to it, and let the controls implement that interface. But I wanted to make a quick fix to the problem without adding new files and types to the code. Here C#'s `dynamic` comes into action.

Using `dynamic` keyword, one postpones binding methods, properties, and fields to run-time. In our scenario we know that the user-controls each have a method called `Save`, which is not derived from a parent. Without `dynamic`, I would need to have a reference explicitly from each user control's type, and I would have to call them one by one, as in:

```csharp
bool succeeded = false;
succeeded = userControl1.Save();
succeeded = succeeded || userControl2.Save();
succeeded = succeeded || userControl3.Save();
// ...
succeeded = succeeded || userControln.Save();
```


However using `dynamic` keyword, life gets a lot easier:

```csharp
// objects are not inherited from a base class or interface,
// therefore we cannot call Save using polymorphism
bool succeeded = false;
foreach(var ctrl in controlsArray)
{
    dynamic dynCtrl = ctrl;
    succeeded = succeeded || dynCtrl.Save();
}

// do something with the value of succeeded
```

Take care that binding the `Save` methods to controls happen at runtime. Therefore if a control does not implement a `Save` method, or if another one misspells `Save`, as say `Svae`, you will get no hints at compile time. So, try to avoid this style of coding, unless you have good reasons for doing so.
