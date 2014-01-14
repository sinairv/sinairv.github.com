---
layout: post
title: "A Helper Method for Performing K-Fold Cross Validation"
date: 2011-05-15 22:41:05 +1000
comments: true
categories: 
- C#
- K-fold Cross Validation
- Machine Learning
---
The following method is a utility method for creating the *K* divisions upon which one is going to perform the *K*-fold cross validation operation. The input of the method is the length of the training data, and the number *K*. The output conveys which indices of the training-data is to be put in each division.

<script src="https://gist.github.com/sinairv/2693647.js"></script>
