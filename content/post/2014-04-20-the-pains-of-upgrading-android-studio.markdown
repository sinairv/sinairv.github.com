---
layout: post
title: "The pains of upgrading Android Studio"
date: 2014-04-20 20:32:23 +1000
comments: true
categories: 
- Android
- Android Studio
---
I could gracefully install and test earlier versions of Android Studio before they adopted [Gradle](http://www.gradle.org/) for their build system. After doing the upgrade I could no longer build a single project with weird error messages relating to Gradle. I searched the web, and found some workarounds in stackoverflow, e.g., manually installing Gradle, updating environment variables and so and so. None of them were helpful for me, although they seemed to be solving the issue for many (who have voted for the answers). I had to do the following steps instead:

1. Downloaded the latest version of SDK which is bundled with Eclipse. Although many answers suggested to upgrade the SDK to the latest version through SDK Manager, and I did so; it did not solve my problem. So I downloaded a fresh copy of latest SDK bundled with eclipse, and then updated Android Studio settings to refer to this new SDK. This trick solved the build problem.
2. When running the emulator I got a very descriptive error message (#NOT) that says: *PANIC: could not open Nexus*, in which *Nexus* is the name of my emulator. For this problem what I found on stackoverflow was quite helpful, for example see [this thread](http://stackoverflow.com/questions/15103782/avd-panic-could-not-open-not-a-path-issue). The trick is to create an environment variable called `ANDROID_SDK_HOME` and set it to the path of the folder containing `.android` folder. If you don't know where is your `.android` folder, AVD Manager will give you the path in its main screen right above the list of existing virtual devices. For my case it was in `D:\Documents`. After setting the environment variable I had to restart both AVD Manager and Android Studio.
