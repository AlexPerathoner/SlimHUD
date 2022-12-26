<!--©Alexander Perathoner 19/03/2020-->

<img align="right" width="25%" src="Screens/Icon1024.png"> 

# SlimHUD
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2FAlexPerathoner%2FSlimHUD.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2FAlexPerathoner%2FSlimHUD?ref=badge_shield)
[![CodeFactor](https://www.codefactor.io/repository/github/alexperathoner/slimhud/badge)](https://www.codefactor.io/repository/github/alexperathoner/slimhud)


Replacement for MacOS' HUDs.

Every day you change your volume or brightness and an ugly and unbelievably old overlay animation appears. *SlimHUD* is what you need.
## Features - Settings
Each feature can be toggled from the settings window.<br>To access the settings window search the SlimHUD icon in you menu app and select **Settings...**


<img align="left"  width="23%" src="Screens/menubar.png">

<p align="center">
<img src = "Screens/settingsWindow.png" height=300>
</p>

Here's a full list of the features:

* When changing volume / brightness / keyboard's backlight a small icon is shown under the bar. The icons are:

<p align="center">
	<img src = "SlimHUD/Assets.xcassets/TemplateBars/backlight.imageset/backlight.png" width=50 margin="10 10 10 10">
	<img src = "SlimHUD/Assets.xcassets/TemplateBars/noVolume.imageset/noVolume.png" width=50 margin="10 10 10 10">
	<img src = "SlimHUD/Assets.xcassets/TemplateBars/brightness.imageset/brightness.png" width=50 margin="10 10 10 10">
	<img src = "SlimHUD/Assets.xcassets/TemplateBars/backlight.imageset/backlight.png" width=50 margin="10 10 10 10">
</p>	


* If you don't like the flat look of the bar you can enable a shadow effect.
<p align="center">
	<img src = "Screens/Shadows/noShadow.jpeg" height=250>
	<img src = "Screens/Shadows/shadow.jpeg" height =250>
</p>


* If you don't like the slide-in animation you can disable it. The bar will then just appear and disappear. 

<p align="center">
<img src = "Screens/Animations/animations2.gif" width=250 height=47>
<img src = "Screens/Animations/animations.gif"  width=47 height=250>
<img src = "Screens/Animations/noAnimations.gif" width=47 height=250>
<img src = "Screens/Animations/noAnimations2.gif" width=250 height=47>
</p>

* Continuously check for changes (*reccomended if you have the TouchBar*): SlimHUD usually shows the volume bar when relative key has been pressed. This means that if you use the volume slider on your TouchBar nothing won't show up. <br>Note that enabling this option *will* fix this problem, but will also increase the CPU usage (which will still be almost none)

* Each bar (volume / brightness / keyboard's backlight) has it's own color. If you want to reset the colors to the default values click on the reset icon.<br>The background color is the same for every bar.<br>You can also choose the color of the volume when its muted.
<p align="center">
<img src = "Screens/colors.png" width=250>
</p>

* Each icon (volume / brightness / keyboard's backlight) also has it's own color! <sup>[1](#note1)</sup>

* If you think that the default bar is too small you can easily adjust its size.

|<img src = "Screens/Size/small.png">|<img src = "Screens/Size/middle.png">|<img src = "Screens/Size/big.png">|
|--:|---|--:|


* You can change the position the bar will appear: on the left, right, bottom or top; it's up to you!<br>Note that when you change the orientation of the bar (E.g. left->bottom or right->top) you need to restart SlimHUD.<br>

|<img src = "Screens/Position/left.png">|<img src = "Screens/Position/right.png">|
|--:|---|
|<img src = "Screens/Position/top.png">|<img src = "Screens/Position/bottom.png">|


* Lastly don't forget to **enable the launch at login function!**

<a name="note1"></a><sup>[1](#note1)</sup>:
> Only available in MacOS 10.14 and later.

## Installation
Download the [latest release](https://github.com/AlexPerathoner/SlimHUD/releases/latest).

Launching SlimHud is easy:

1. Copy the app into your Application's folder
2. Open it
3. You have now successfully replaced those ugly and old overlays! Congrats!

Credits to [GameParrot](https://github.com/GameParrot) for making it so easy!


### Uninstalling
If you'd like to restore the system's HUDs:

1. Disable "launch at login" or delete SlimHUD
2. Relog into your account


## Credits
Thanks to [w0lfschild](https://gist.github.com/w0lfschild) and [massimobio](https://gist.github.com/massimobio) for creating respectively
 [cleanHUD](https://github.com/w0lfschild/cleanHUD) and [ProgressHUD-Mac](https://github.com/massimobio/ProgressHUD-Mac) and inspiring me to create this project.
 
Also thanks to [pirate](https://gist.github.com/pirate) and [kaunteya](https://gist.github.com/kaunteya), whose code from these project ([mac-keyboard-brightness](https://github.com/pirate/mac-keyboard-brightness) and [ProgressKit](https://github.com/kaunteya/ProgressKit)) was used to complete this project.
 
SlimHUD is using [Sparkle](https://sparkle-project.org) to support automatic updates. Binaries are stored on GitHub and connections use HTTPs.

## License

This project is licensed under the GPL-3.0 License - see the [LICENSE.md](LICENSE.md) file for details


[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2FAlexPerathoner%2FSlimHUD.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2FAlexPerathoner%2FSlimHUD?ref=badge_large)