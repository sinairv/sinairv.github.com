---
layout: post
title: "Syntax Highlighter for Windows Forms Rich Text Box"
date: 2014-12-01 18:18:48 +1000
comments: true
categories: 
  - C#
  - Windows Forms
  - RichTextBox
  - Syntax Highlighting
---
Years ago I created a tool called [Code4Public](http://code4public.codeplex.com) to convert source code into HTML called. I was using this tool to put nice code snippets in the blog I used to maintain at that time. The tool is able to get the code, apply syntax highlighting to it based on the syntax of the language selected, and then create HTML based on the theme selected (e.g., MSDN theme). I didn't assign more time on making the tool better and better, as better ways of doing the same task were emerging, and also other by-products of the tool were becoming more interesting at the time; e.g., [YAXLib](https://github.com/sinairv/YAXLib) was a little by-product of Code4Public used to store settings, themes and language syntaxes in XML files.

This post is to introduce yet another by-product of Code4Public: [WinFormsSyntaxHighlighter](https://github.com/sinairv/WinFormsSyntaxHighlighter). This library enables syntax highlighting on a `RichTextBox` based on patterns that the developer defines.

The syntax highlighter hooks into `RichTextBox` events in the constructor.

```csharp
var syntaxHighlighter = new SyntaxHighlighter(theRichTextBox);
```

That's it. Now I need to define patterns and colors. For example I want to see `for`, `foreach`, `int` and `var` in blue:

```csharp
// 1st set of keywords; I'd like to see them in Blue
syntaxHighlighter.AddPattern(
    new PatternDefinition("for", "foreach", "int", "var"), 
    new SyntaxStyle(Color.Blue));
```

I can also define whether I want to see a pattern in *bold* or *italics*. For example I want to see `public`, `partial`, `class`, and `void` in bold navy but not italics. I want the match these words case-insensitively, so that `PuBlIc` will be shown in navy blue as well. Note that this is an imaginary syntax for demonstration purposes only:

```csharp
// 2nd set of keywords; I'd like to see them in bold Navy, and they must be case insensitive
syntaxHighlighter.AddPattern(
    new CaseInsensitivePatternDefinition("public", "partial", "class", "void"), 
    new SyntaxStyle(Color.Navy, bold: true, italic: false));
```

I can also define the patterns directly with regular expression:

```csharp
// numbers; I'd like to see them in purple
syntaxHighlighter.AddPattern(
    new PatternDefinition(@"\d+\.\d+|\d+"), 
    new SyntaxStyle(Color.Purple));
```

Since the input string is partitioned by the patterns defined in the order of their definition, they must be added in the proper order. E.g., I want to see numbers in purple, but not those numbers inside a comment or inside a string. So the pattern definition for a comment block must be added first, then the pattern for string literal, and at last the pattern for numbers. The following is a more complete example from the beginning to the end.

```csharp
var syntaxHighlighter = new SyntaxHighlighter(theRichTextBox);

// That's it. Now tell me how you'd like to see what...

// multi-line comments; I'd like to see them in dark-sea-green and italic
syntaxHighlighter.AddPattern(
    new PatternDefinition(new Regex(@"/\*(.|[\r\n])*?\*/", 
        RegexOptions.Multiline | RegexOptions.Compiled)), 
    new SyntaxStyle(Color.DarkSeaGreen, bold: false, italic: true));

// singlie-line comments; I'd like to see them in Green and italic
syntaxHighlighter.AddPattern(
    new PatternDefinition(new Regex(@"//.*?$", 
        RegexOptions.Multiline | RegexOptions.Compiled)), 
    new SyntaxStyle(Color.Green, bold: false, italic: true));

// double quote strings; I'd like to see them in Red
syntaxHighlighter.AddPattern(
    new PatternDefinition(@"\""([^""]|\""\"")+\"""), 
    new SyntaxStyle(Color.Red));

// single quote strings; I'd like to see them in Salmon 
syntaxHighlighter.AddPattern(
    new PatternDefinition(@"\'([^']|\'\')+\'"), 
    new SyntaxStyle(Color.Salmon));
            
// 1st set of keywords; I'd like to see them in Blue
syntaxHighlighter.AddPattern(
    new PatternDefinition("for", "foreach", "int", "var"), 
    new SyntaxStyle(Color.Blue));
            
// 2nd set of keywords; I'd like to see them in bold Navy, and they must be case insensitive
syntaxHighlighter.AddPattern(
    new CaseInsensitivePatternDefinition("public", "partial", "class", "void"), 
    new SyntaxStyle(Color.Navy, true, false));

// numbers; I'd like to see them in purple
syntaxHighlighter.AddPattern(
    new PatternDefinition(@"\d+\.\d+|\d+"), 
    new SyntaxStyle(Color.Purple));

// operators; I'd like to see them in Brown
syntaxHighlighter.AddPattern(
    new PatternDefinition("+", "-", ">", "<", "&", "|"), 
    new SyntaxStyle(Color.Brown));
``` 

Please also note that, nobody can model a whole language like C# or Java with regular expressions, because these languages are not regular. So this tool is by no means a complete and error-free way of modeling languages. Use this just for simple key-word matching or pattern matching and coloring them as you like; but don't expect too much.

[WinFormsSyntaxHighlighter](https://github.com/sinairv/WinFormsSyntaxHighlighter) is hosted in GitHub and is licensed under MIT.
