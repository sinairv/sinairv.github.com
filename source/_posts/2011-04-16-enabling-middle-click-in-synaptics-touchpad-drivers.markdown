---
layout: post
title: "Enabling Middle Click in Synaptics Touchpad Drivers"
date: 2011-04-16 00:25:53 +1000
comments: true
categories: 
- Synaptic Touchpad Middle Click
---
Recently I upgraded my currently installed Synaptics touchpad driver to version 15.x, and I found that I cannot emulate the middle-click effect by pressing both right and left click buttons. I found no options in the settings to enable that functionality. Finally after searching the web I found a workaround here [[+](http://forum.notebookreview.com/hp-compaq/205207-those-synaptics-touchstyk-trackpoint-any-way-enable-middle-button-scrolling.html)]:

1. Run the registry editor (`regedit`)
2. Go to key: `HKEY_LOCAL_MACHINE\Software\Synaptics\SynTP\Defaults\`
3. Here create a new key as a `DWORD` and name it `HasBothButtonFeature` and set the value to 1.
4. Log off and Log on again

It worked fine for me.