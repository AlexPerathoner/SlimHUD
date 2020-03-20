<!--©Alexander Perathoner 19/03/2020-->

<img align="right" width="25%" src="Screens/Icon1024.png">
# SlimHUD - Cyanocitta
Replacement for MacOS' HUDs.

Every day you change your volume or brightness and an ugly and unbelievably old overlay animation appears. *SlimHUD* is what you need.
## Features - Settings
Each feature can be toggled from the settings window.<br>To access the settings window search the *Cyanocitta* in you menu app and select **Settings...**


<img align="left"  width="23%" src="Screens/menubar.png">

<p align="center">
<img src = "Screens/settingsWindow.png" height=300>
</p>

Here's a full list of the features:

* When changing volume / brightness / keyboard's backlight a small icon is shown under the bar. The icons are:
<div style="height: auto;display: flex;width: 50%;">
	<div style="flex: 25%;">
		<p align="center">
	  		<img src = "SlimHUD/Assets.xcassets/volume.imageset/volume.png" width=50>
	  	</p>
	</div>
	<div style="flex: 25%;">
		<p align="center">
	  		<img src = "SlimHUD/Assets.xcassets/noVolume.imageset/noVolume.png" width=50>
	  	</p>
	</div>
	<div style="flex: 25%;">
		<p align="center">
	  		<img src = "SlimHUD/Assets.xcassets/brightness.imageset/brightness.png" width=50>
	  	</p>
	</div>
	<div style="flex: 25%;">
		<p align="center">
	  		<img src = "SlimHUD/Assets.xcassets/backlight.imageset/backlight.png" width=50>
	  	</p>
	</div>
</div>

* If you don't the flat look of the bar you can enable a shadow effect
<div style="height: auto;display: flex;width: 50%;">
	<div style="flex: 25%;">
		<p align="center">
	  		<img src = "Screens/Shadows/noShadow.jpeg" height=250>
	  	</p>
	</div>
	<div style="flex: 25%;">
		<p align="center">
	  		<img src = "Screens/Shadows/shadow.jpeg" height =250>
	  	</p>
	</div>
</div>


* If you don't like the slide-in animation you can disable it. The bar will then just appear and disappear. 
<p align="center">
<img src = "Screens/Animations/animations2.gif" width=250>
<img src = "Screens/Animations/animations.gif" height=250>
<img src = "Screens/Animations/noAnimations.gif" height=250>
<img src = "Screens/Animations/noAnimations2.gif" width=250>
</p>

* Continuously check for changes (*reccomended if you have the TouchBar*): SlimHUD usually shows the volume bar when relative key has been pressed. This means that if you use the volume slider on your TouchBar nothing won't show up. <br>Note that enabling this option *will* fix this problem, but will also increase the CPU usage (which will still be almost none)

* Each bar (volume / brightness / keyboard's backlight) has it's own color. If you want to reset the colors to the default values click on the reset icon.<p align="center">
<img src = "Screens/colors.png" width=250>
</p>The background color is the same for every bar.<br>You can also choose the color of the volume when its muted.

* If you think that the default bar is too small you can easily adjust its size.<img src = "Screens/Size/small.png" width=75%><details>
  <summary>See more</summary><p align="center">
<img src = "Screens/Size/middle.png" width=75%>
<img src = "Screens/Size/big.png" width=75%>
</p></details>

* You can change the position the bar will appear: on the left, right, bottom or top; it's up to you!<br>Note that when you change the orientation of the bar (E.g. left->bottom or right->top) you need to restart SlimHUD.<br><img src = "Screens/Position/left.png" width=75%><details>
  <summary>See more</summary><p align="center">
<img src = "Screens/Position/right.png" width=75%>
<img src = "Screens/Position/top.png" width=75%>
<img src = "Screens/Position/bottom.png" width=75%></p></details>

* Lastly don't forget to enable the launch at login function!


## Installation
Download the [latest release](https://github.com/AlexPerathoner/SlimHUD/releases/latest).

Launching SlimHud is easy: copy the app into your Application's folder and then open it.
<br>**However**, as you probably also want it to replace MacOS' HUDs we'll have to follow a few steps more...<br>Please note that the following instructions will temporarily deactivate Sysem Integrity Protection. By proceeding you acknowledge that you are aware of which risks this leads to.<br>But don't be scared, just follow everything and you should be fine (source: [here](https://alanvitullo.wordpress.com/2018/02/20/remove-control-overlay-on-mac-os-high-sierra/) and [here](https://www.reddit.com/r/MacOS/comments/caiue5/macos_catalina_readonly_file_system_with_sip/)):

<details>
  <summary>Follow steps</summary>
  
1. Enter Recovery Mode by restarting your mac and holding ⌘+R while it's booting up.
2. Launch the terminal by clicking on Utilities > Terminal.
3. Disable SIP with ```crsutil disable```.
4. Restart your mac and login into an admin account.
5. Run ```sudo mount -uw /; killall Finder``` in your terminal.
6. Now run ```sudo nano /System/Library/LaunchAgents/com.apple.OSDUIHelper.plist```.
6. Remove all of the text between \<plist version=”1.0″> and \</plist>. Save the file by hitting control + X, answering yes and hitting return.
8. Re-enter Recovery mode.
9. Enable SIP with ```crsutil enable```.
  
</details>


You have now successfully replaced those ugly and old overlays! Congrats!

For future updates it won't be necessary to go through all of these steps. Just copy the [latest release](https://github.com/AlexPerathoner/SlimHUD/releases/latest) into your application Folder. You already have 




## Credits
Thanks to [w0lfschild](https://gist.github.com/w0lfschild) and [massimobio](https://gist.github.com/massimobio) for creating respectively
 [cleanHUD](https://github.com/w0lfschild/cleanHUD) and [ProgressHUD-Mac](https://github.com/massimobio/ProgressHUD-Mac) and inspiring me to create this project.
 
 Also thanks to [pirate](https://gist.github.com/pirate) and [kaunteya](https://gist.github.com/kaunteya), whose code from these project ([mac-keyboard-brightness](https://github.com/pirate/mac-keyboard-brightness) and [ProgressKit](https://github.com/kaunteya/ProgressKit)) was used to complete this project.

## License

This project is licensed under the GPL-3.0 License - see the [LICENSE.md](LICENSE.md) file for details

---
Donations are welcome!

[![Donate-Paypal](https://img.shields.io/badge/donate-paypal-yellow.svg?style=flat)](https://paypal.me/AlexanderPerathoner)
