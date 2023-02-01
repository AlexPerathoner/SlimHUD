<!--©Alexander Perathoner 19/03/2020-->

<img align="right" width="25%" src="Screens/Icon1024.png"> 

# SlimHUD
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2FAlexPerathoner%2FSlimHUD.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2FAlexPerathoner%2FSlimHUD?ref=badge_shield)
[![CodeFactor](https://www.codefactor.io/repository/github/alexperathoner/slimhud/badge)](https://www.codefactor.io/repository/github/alexperathoner/slimhud)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=alexpera_slimhud&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=alexpera_slimhud)


The macOS HUD, redesigned.

Every day you change your volume or brightness, an ugly and unbelievably old overlay animation appears. *SlimHUD* is what you need.
## Features
Instead of a large, bulky square in the middle of your screen, a small and slim bar appears on the side.

<kbd><img width="600" alt="screenshot" src="https://user-images.githubusercontent.com/104660117/215924604-d38774a5-5bdf-450a-ad01-280d12a02b83.png"></kbd>

There are several appearance effects that you can tailor to your liking.

<img width="450" alt="effects" src="https://user-images.githubusercontent.com/104660117/215937256-ffb6e579-40d8-4b42-90ee-c36337e54be0.png">

You can choose from multiple appearance animations.

<p>
<img src = "https://user-images.githubusercontent.com/104660117/215941948-2b297736-2925-4964-8b26-795fdba21d56.gif" width=42 height=244>
<body>⠀</body>
<img src = "https://user-images.githubusercontent.com/104660117/215941955-d765a172-fea5-4b16-9e26-12be5c5da905.gif" width=42 height=244>
<body>⠀</body>
<img src = "https://user-images.githubusercontent.com/104660117/215941958-24fa8a00-7b7c-46f5-9bec-7e5448b13b46.gif" width=42 height=244>
<body>⠀</body>
<img src = "https://user-images.githubusercontent.com/104660117/215941959-609eff09-6aee-4a9f-a8e5-fa91c7e1da67.gif" width=42 height=244>
<body>⠀</body>
<img src = "https://user-images.githubusercontent.com/104660117/215941960-9cb988f2-ad89-4594-aa69-6465da595b5b.gif" width=42 height=244>
<body>⠀</body>
<img src = "https://user-images.githubusercontent.com/104660117/215941961-c88195f6-69ce-4b42-8f09-3eaf91a99683.gif" width=42 height=244>
<body>⠀</body>
<img src = "https://user-images.githubusercontent.com/104660117/215941964-0be9c0fd-096b-438d-ae44-cb000e2bfc24.gif" width=42 height=244>
<br>
<img src = "https://user-images.githubusercontent.com/104660117/215944787-0e009af2-af16-4a28-ae2a-cc0fe6541a25.png" width=434 height=145>
</br>
</p>


Every HUD (volume, brightness, keyboard backlight) has its own appearance.


* The HUDs can appear on any edge: left, right, bottom or top; it's up to you!

|<img src = "Screens/Position/left.png">|<img src = "Screens/Position/right.png">|
|--:|---|
|<img src = "Screens/Position/top.png">|<img src = "Screens/Position/bottom.png">|


* Lastly don't forget to **enable the launch at login function!**

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
