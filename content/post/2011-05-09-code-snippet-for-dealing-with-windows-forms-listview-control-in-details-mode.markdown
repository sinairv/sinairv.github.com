---
layout: post
title: "Code Snippet for Dealing with Windows Forms ListView control in details mode"
date: 2011-05-09 00:39:37 +1000
comments: true
categories: 
- C#
- ListView
- Windows Forms
- Snippet
---
I needed a piece of code to manage list-view controllers. I needed to use `ListView` controls in the details mode, which automatically sort its contents when I click on the header, and also pastes the content in a tabular format when I press `Ctrl`+`C` or `Ctrl`+`Insert` on it. So I created the following classes. The code that carries out the sorting stuff when the header is clicked is taken from [this](http://msdn.microsoft.com/en-us/library/ms996467.aspx) following MSDN article.

So these are the contributions of these pieces of code: 1) Sort `ListView` items when the column header is clicked, 2) Paste the contents of the `ListView` control to clipboard in a tabular format, and 3) Provide an easy to use API to append data to a `ListView` control.

The following gist contains the code to accomplish this. It consists of 3 files. The `ListViewColumnSorter.cs` file is responsible for the sorting stuff. The `ListViewUtils.cs` file provides the utility methods for a ListView control. The main methods that perform the job are located in the `ListViewUtils` class. The two needed methods are `InitListView` and `AppendToListView`. And finally the `Usage.cs` file provides a small demo of the utility methods.

<script src="https://gist.github.com/sinairv/2693729.js"></script>
