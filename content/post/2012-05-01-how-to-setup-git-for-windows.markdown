---
layout: post
title: "How to setup Git for Windows"
date: 2012-05-01 23:27:40 +1000
comments: true
categories: 
- Git
- Windows
---
These are some easy steps required to setup Git for Windows:

1. Download msysGit from: http://code.google.com/p/msysgit    
I prefer to use the portable version. At the time of this writing there's no difference between 32 bit and 64 bit versions and the filename for the portable version is: `PortableGit-1.7.10-preview20120409.7z`. Currently it seems that the development of the project has been moved to [GitHub](http://github.com/msysgit), but the releases are still located in Google Code.

2. Extract the contents in a proper location. I made them into:    
`D:\PortableProgs\msysGit`

3. If you intend to use the git command-line for every git operation simply run `git-bash.bat` in the root folder of *msysGit*. This is the old lovely *Cygwin* command-line.

4. If you don't intend to use command-line (like me) install *TortoiseGit*. It is hosted on Google Code:    
http://code.google.com/p/tortoisegit/    
Note that it comes with different releases for 32-bit and 64-bit systems. At the time of this writing the latest version is 1.7.8.0. After installing *TortoiseGit* you may need to restart Windows, or the Windows explorer process, or none.

5. Right click somewhere on a Windows Explorer window, and from the context menu select: *TortoiseGit > Settings*. There will be a message-box appearing begging for adjusting the path to *msysGit*. Click on "Set MSysGit path" button (If you have ever missed this window, or want to change the path to an already existing *msysGit*, simply go to: *TortoiseGit > Settings >> the General branch*).    
In the field titled as *"Git.exe path:"* enter the path to the *bin* folder of the *msysGit* installation/copy.

6. You don't have to, but it is highly recommended that before starting any git operations you set some global settings such as your name, email, and AutoCrlf. To this aim in the Windows explorer's context menu go to: *TortoiseGit > Settings >> the Git branch*. Fill in the fields labelled *Name* and *Email* with proper values. Then make sure that *AutoCrlf* check-box is unchecked, so that you don't touch every file in order to change their line-endings. Read more about this kind of problem [here](http://code52.org/line-endings.html), and see [here](http://stackoverflow.com/questions/4181870/git-on-windows-what-do-the-crlf-settings-mean) to know more what AutoCrlf and SafeCrlf options do for you.

7. **[UPDATED on 3 May 2012]** When performing some git operations, git may complain that it cannot connect through a *null* proxy. It may happen for some versions if in git settings the value for proxy is assigned to an empty string. If this is the case for you, simply remove proxy settings in the global `.gitconfig` file. To do this, right click somewhere in Windows explorer, go to: *TortoiseGit > Settings >> The Git Branch >> Edit Global .gitconfig button*. From there remove the line that assigns proxy, or the whole `[http]` section if it only contains proxy settings.

See also:    
[Using Git With CodePlex on Windows](/blog/2012/05/02/using-git-with-codeplex-on-windows/)    
[Using Git With GitHub on Windows](/blog/2012/05/05/using-git-with-github-on-windows/)
