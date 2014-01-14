---
layout: post
title: "How to Include .eps Images with pdflatex"
date: 2011-05-21 23:03:15 +1000
comments: true
categories: 
- LaTeX
---
PdfLaTeX does not support `eps` files by default. Add the following imports in the beginning:

```latex
\usepackage{graphicx} % already added
\usepackage{epstopdf}
```

After that the `includegraphics` commands with `eps` arguments should produce no problems.

Reference: [[+](http://mactex-wiki.tug.org/wiki/index.php?title=Graphics_inclusion)]