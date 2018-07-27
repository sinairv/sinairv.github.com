---
layout: post
title: "How to Explore Special Folders (like GAC) in Windows Explorer"
date: 2010-05-15 21:09:33 +1000
comments: true
categories: 
- GAC
---
In normal situations you cannot view the content of special folders, such as `Windows/assembly` or `Windows/fonts`, and so on. The way these folders are shown are set through the `desktop.ini` file in each of these folders, which is normally hidden and protected. One trick that I learned from here [[+](http://blogs.msdn.com/cumgranosalis/archive/2005/10/03/476275.aspx)] is described below. Open a command prompt and type:

```
cd /d %windows%\assembly
attrib -r -h -s desktop.ini
ren desktop.ini desktop.bak
```

Using the above commands, we kill the `desktop.ini` file, which will cause Windows Explorer to successfully open and explore the real contents of the folder.