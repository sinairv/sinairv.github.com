---
layout: post
title: "How to Disable Hibernate and Free Some Disk Space in Windows 7"
date: 2011-05-26 23:07:00 +1000
comments: true
categories: 
- Windows
---
Run a command prompt as administrator.

Run the following command:

```
powercfg.exe -h off
```

The disk space is freed immediately. To turn it back on run:

```
powercfg.exe -h on
```
Reference: [[+](http://helpdeskgeek.com/windows-7/windows-7-delete-hibernation-file-hiberfil-sys/)]
