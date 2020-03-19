
<img align="right" width="25%" src="Screens/Icon1024.png"></img>
# SlimHUD - Cyanocitta
Replacement for MacOS' HUDs.

Every day you change your volume or brightness and an ugly and unbelievably old overlay animation appears. *SlimHUD* is what you need.
## Features


###Settings

## Installation
Download the [latest release](https://github.com/AlexPerathoner/SlimHUD/releases/latest).

Launching SlimHud is easy: copy the app into your Application's folder and then open it.
<br>**However**, as you probably also want it to replace MacOS' HUDs we'll have to follow a few steps more...<br>Please note that the following instructions will temporarily deactivate Sysem Integrity Protection. By proceeding you acknowledge that you are aware of which risks this leads to.<br>But don't be scared, just follow everything and you should be fine (source: [here](https://alanvitullo.wordpress.com/2018/02/20/remove-control-overlay-on-mac-os-high-sierra/) and [here](https://www.reddit.com/r/MacOS/comments/caiue5/macos_catalina_readonly_file_system_with_sip/)):

1. Enter Recovery Mode by restarting your mac and holding ⌘+R while it's booting up.
2. Launch the terminal by clicking on Utilities > Terminal.
3. Disable SIP with ```crsutil disable```.
4. Restart your mac and login into your account.
5. Navigate to /System/Library/LaunchAgents/com.apple.OSDUIHelper.plist
6. As com.apple.OSDUIHelper.plist is a read-only file, to modify it, you'll first need to run ```sudo mount -uw; killall Finder```
7. You can now open com.apple.OSDUIHelper.plist and remove all of the text between \<plist version=”1.0″> and \</plist>. Save the file.
8. Re-enter Recovery mode.
9. Enable SIP with ```crsutil enable```.

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
