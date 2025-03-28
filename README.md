<!--©Alexander Perathoner 19/03/2020-->

<img align="right" width="25%" src="Screens/Icon1024.png"> 

# SlimHUD
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2FAlexPerathoner%2FSlimHUD.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2FAlexPerathoner%2FSlimHUD?ref=badge_shield)
[![CodeFactor](https://www.codefactor.io/repository/github/alexperathoner/slimhud/badge)](https://www.codefactor.io/repository/github/alexperathoner/slimhud)


Replacement for MacOS' HUDs.

Every day you change your volume or brightness and an ugly and unbelievably old overlay animation appears. *SlimHUD* is what you need.
## Features - Settings
Each feature can be toggled from the settings window.<br>To access the settings window start SlimHUD again, while it's already running. The settings window will appear:


<p align="center">
<img src = "Screens/settings/settings-general.png" height=300>
<img src = "Screens/settings/settings-style.png" height=300>
<img src = "Screens/settings/settings-design.png" height=300>
</p>

Here's are some of the things you can customise:

* When changing volume / brightness / keyboard's backlight a small **icon** is shown under the bar.

* If you don't like the flat look of the bar you can enable a **shadow** effect.
<p align="center">
	<img src = "Screens/shadows.gif" height=250>
</p>


* There are multiple **animation** styles: 

|<img src = "Screens/animations/no.gif" height=250>|<img src = "Screens/animations/fade.gif" height=250>|<img src = "Screens/animations/grow.gif" height=250>|<img src = "Screens/animations/popinfadeout.gif" height=250>|<img src = "Screens/animations/shrink.gif" height=250>|<img src = "Screens/animations/side.gif" height=250>|<img src = "Screens/animations/sidegrow.gif" height=250>|
|--:|---|---|---|---|---|--:|

* Continuously check for changes (*recommended if you use a **TouchBar***): shows the HUDs when using the volume / brightness slider.

* Each bar (volume / brightness / keyboard's backlight) has it's own **color**.<br>You can also choose the color of the volume when its muted.
<p align="center">
<img src = "Screens/volumeDisabled.gif" height=250>
</p>

* Each **icon** (volume / brightness / keyboard's backlight) also has it's own color! <sup>[1](#note1)</sup>

* If you think that the default bar is too small you can easily adjust its **size**.

|<img src = "Screens/Size/small.png">|<img src = "Screens/Size/middle.png">|<img src = "Screens/Size/big.png">|
|--:|---|--:|

* The HUDs can appear on any **edge**: left, right, bottom or top; it's up to you!

|<img src = "Screens/Position/left.png">|<img src = "Screens/Position/right.png">|
|--:|---|
|<img src = "Screens/Position/top.png">|<img src = "Screens/Position/bottom.png">|


* Lastly don't forget to enable the **launch at login** function!

<a name="note1"></a><sup>[1](#note1)</sup>:
> Only available in MacOS 10.14 and later.

## Installation
You can use `brew install slimhud`!

Or download the [latest release](https://github.com/AlexPerathoner/SlimHUD/releases/latest) and move it to `/Applications`.

Credits to [GameParrot](https://github.com/GameParrot) for making it so easy!


### Uninstalling
If you'd like to restore the system's HUDs:

1. Disable "launch at login" or delete SlimHUD from `/Applications`

## Credits
Thanks to [w0lfschild](https://gist.github.com/w0lfschild) and [massimobio](https://gist.github.com/massimobio) for creating respectively
 [cleanHUD](https://github.com/w0lfschild/cleanHUD) and [ProgressHUD-Mac](https://github.com/massimobio/ProgressHUD-Mac) and inspiring me to create this project.
 
Also thanks to [pirate](https://gist.github.com/pirate) and [kaunteya](https://gist.github.com/kaunteya), whose code from these project ([mac-keyboard-brightness](https://github.com/pirate/mac-keyboard-brightness) and [ProgressKit](https://github.com/kaunteya/ProgressKit)) was used to complete this project.

Thanks to [reitermarkus](https://gist.github.com/reitermarkus), [ans87gh](https://gist.github.com/ans87gh) and [p-linnane](https://gist.github.com/p-linnane) for adding this project to brew.
 
SlimHUD is using [Sparkle](https://sparkle-project.org) to support automatic updates. Binaries are stored on GitHub and connections use HTTPs.

## Support
Even starring this project is a great support! If you want to support me even more, you can buy me a beer! :D

<br><a href="https://www.buymeacoffee.com/alexpera"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a beer&emoji=🍺&slug=alexpera&button_colour=94e3fe&font_colour=000000&font_family=Bree&outline_colour=000000&coffee_colour=FFDD00" /></a>

## License

This project is licensed under the GPL-3.0 License - see the [LICENSE.md](LICENSE.md) file for details


[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2FAlexPerathoner%2FSlimHUD.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2FAlexPerathoner%2FSlimHUD?ref=badge_large)
