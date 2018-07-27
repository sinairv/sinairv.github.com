---
layout: post
title: "Code Snippet for Determining How Two Intervals Overlap"
date: 2010-08-09 23:45:00 +1000
comments: true
categories: 
- C#
- Snippets
---
The following pieces of code help figure out how two intervals overlap, and provides helper methods to represent them in a way that is useful for debugging purposes. This job is quite easy to accomplish, but since I've written it too many times from scratch, I put them in the following gist.

The `IntervalOverlapKinds.cs` file defines the `IntervalOverlapKinds` enumeration. The interval detection is carried out in the static methods of the `IntervalOverlap` class.

<script src="https://gist.github.com/sinairv/2693975.js"></script>