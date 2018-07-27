---
layout: post
title: "Problem with finding local resources in Intellij IDEA"
date: 2011-05-10 22:33:07 +1000
comments: true
categories: 
- Java
- Intellij Idea
---
Some classes use external data files which are located in the same directory as the one that the `.java` file is located, or somewhere nearby which can be easily addressed with a relative path. This happens a lot for me, esp. when I am running open source programs developed by someone else. As an example, imagine a class called `SampleClass` located in a directory in which there exists a text file with the name of `SomeFile.txt`. One way to have access to the file is through calling the class-loader's `getResource` function:

```java
URL theURL = this.getClass().getResource("SomeFile.txt");
System.out.println(theURL.toString());
```

I tested this piece of code in *NetBeans* and it works fine. But not in *Intellij IDEA*! To solve this (annoying) problem, I needed to add the path of the source directory to `classpath`. For this purpose I did the following steps in Intellij IDEA 10.0.3 Community Edition:

1. Right click on the module name and select "Open Module Settings"
2. Select "Modules" from the leftmost pane
3. Select "Dependencies" tab
4. Press "Add..." button and select "1 Single-Entry Module Library…" from the popup menu
5. Find and select the "src" folder of your sources.
6. Under the "Scope" column, change the scope to "Runtime"
7. Press Apply and OK
