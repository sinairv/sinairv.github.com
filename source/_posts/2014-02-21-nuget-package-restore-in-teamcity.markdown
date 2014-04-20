---
layout: post
title: "NuGet Package Restore in TeamCity"
date: 2014-02-21 21:16:24 +1000
comments: true
published: false
categories: 
- NuGet
- TeamCity
---

> Package restore is disabled by default. To give consent, open the Visual Studio Options dialog, click on Package Manager node and check 'Allow NuGet to download missing packages during build.' You can also give consent by setting the environment variable 'EnableNuGetPackageRestore' to 'true'.

Go to TeamCity, select your project from the Projects drop-down menu on top. In the new screen, there should be a drop-down next to your Build Configuration field, when clicked select the Edit Settings item. In the new screen select Parameters from the left pane. Press on the button "Add new Parameter". Enter `env.EnableNuGetPackageRestore` as Name, Environment variable (env.) as Kind, and ture as Value.

Try again with the build.

![](/images/posts/TeamCityParameters.png)

![](/images/posts/TeamCityEnvVariable.png)
