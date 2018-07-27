---
layout: post
title: "How to reduce the pain of working with TFS using Git TFS"
date: 2016-11-24 14:51:08 +1100
comments: true
categories: 
- Git
- TFS
---
*Git TFS* is a program that extends git commands to talk to a TFS remote repository (instead of a git repository). 
It creates a real git repository and replays the TFS history on top of it. It can be treated as a real git repository except 
for when it comes to cloning and syncing. In spite of that it still makes a programmer's life much easier.

The best starting point is the [project's ReadMe file on GitHub](https://github.com/git-tfs/git-tfs/). Here's a brief overview of basic commands I needed to use.

To install via [chocolatey](https://chocolatey.org/), run:

```
choco install gittfs
```

Make sure to add `gittfs.exe` to path. Chocolatey installed mine in "C:\Tools\Gittfs\".

Cloning from TFS is a bit different from that of Git:

```
git tfs clone http://url-to-tfs:8080/tfs/DefaultCollection $/ProjectName
```

It will create an empty git repository and then replays the TFS repository on top preserving all the history. 
If the TFS repository is too big there are some switches available to the `git tfs clone` command that allows you to *quickly clone* the latest or a specific 
revision from the history. For more information, see the documentation for [*quick-clone*](https://github.com/git-tfs/git-tfs/blob/master/doc/commands/quick-clone.md). 

After cloning, it has created a *real* git repository to which you can make as many local commits as you like. 
To push your local commits (or *check-in* in TFS terminology) you need to run the following command:

```
git tfs rcheckin
```

The [`rcheckin`](https://github.com/git-tfs/git-tfs/blob/master/doc/commands/rcheckin.md) command will 
preserve all outstanding local commits and checks them in one by one to the remote TFS repository. Note that `git push` doesn't work here as there's no standard git remote being tracked.

There are other alternatives to `rcheckin`, such as `git tfs checkin -m "message"` which squashes your local commits into one using the specified message, or 
`git tfs checkintool` which opens up the TFS tools checkin window to perform the check-in. My preference is `rcheckin` because it keeps me mindful of my local commits, 
and abstracts TFS away better than others.   

To update local repository with remote changes made in TFS `default` branch, you can pull and rebase, which is my preference:

```
git tfs pull --rebase
```

Pretty much like git, it pulls down outstanding remote commits and then replays local commits on top of it avoiding the need for an extra merge commit. 
Alternatively you can also pull and merge:

```
git tfs pull
```

which may end up creating a merge commit on top of your local changes (unless it can fast-forward). Have a look at documentations for 
[git tfs pull](https://github.com/git-tfs/git-tfs/blob/master/doc/commands/pull.md) to learn more about pulling from branches other than `default`.

As you can see when it comes to cloning and syncing, the commands are different from those of standard git. 
However the fact that you can easily modify the files you need to modify, have a much better diff status of what has been 
changed before every commit, and possibility of using your git client and tools that you like are what makes life easier with Git TFS.