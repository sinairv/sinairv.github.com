---
layout: post
title: "A Code Snippet for Searching and Highlighting a token or string in a RichTextBox"
date: 2010-08-08 21:28:07 +1000
comments: true
categories: 
- C#
- Snippets
- Strings
---
Suppose that you intend to find a string or a token (i.e., whole word, instead of a substring) and change their color in some Windows Forms `RichTextBox`. The following code snippets will help. The `FindStringAndSetColor` method looks for instances of an arbitrary string in the contents of the `RichTextBox`, while the `FindTokenAndSetColor` method looks for whole words (tokens).

<script src="https://gist.github.com/sinairv/2694067.js"></script>
