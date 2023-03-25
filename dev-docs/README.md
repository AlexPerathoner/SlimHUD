
# Developer documentation


This directory contains developer documentation for SlimHUD.

## How to build

1. Clone the repository
2. Open the project in Xcode (open `SlimHUD.xcodeproj`)
3. Wait for Swift Package Manager to download the dependencies. See [Dependencies](#dependencies) for more info.
3. Build the project (⌘B)
4. Run the project (⌘R)

## Dependencies

- MediaKeyTap: needed to listen for media key presses (volume, brightness, play/pause, etc.), which triggers the HUDs.
- Sparkle: needed to support automatic updates. See [Detailed release process](dev-ops/README.md#detailed-release-process) for more info.
- SwiftImage: needed to access pixel colors from the screen, used in UI tests. See [Testing](#testing) for more info.

## Basic concepts

### HUDs

HUDs are the different elements that are displayed on the screen. They are windows that are always on top of other windows, non clickable and transparent.
There are 3 HUDs:
- volume
- brightness
- keyboard brightness

A HUD contains a BarView

### BarView
BarViews are the non-transparent parts of HUDs. Each contains an icon and a ProgressBar

### ProgressBar
Bars with a float value between 0 and 1. They are used to display the current value of the HUD.

### Customization
Each HUD and Bar has a set of customizable properties. Most can be changed for each HUD individually, but some are global (see configs in Design tab).

## Architecture

### Controllers
> connect UI elements to SettingsManager
- all ..Controller classes in SlimHUD/Controllers/SettingsViewController
- MainMenuController: handles the menu bar icon and shortcuts for the settings window
- SettingsWindowController: handles the displaying of the preview hud, when the settings window is open

### Services
> handle the logic of the HUDs

TODO: add as graph

- KeyPressObserver: main class, listens for media key presses and notifies the ChangesObserver
- **SettingsManager**: stores all settings, reads them from the user defaults on launch and writes them to the user defaults when they change
    - UserDefaultsManager: utility class to simplify the reading and writing of user defaults, used by the SettingsManager
- **ChangesObserver**: stores the current values of the HUDs, check if they change and notifies the Displayer when they change
    - KeyboardManager: used by the ChangesObserver to get the current keyboard brightness
    - VolumeManager: used by the ChangesObserver to get the current volume info, calls AppleScriptRunner
        - AppleScriptRunner: runs AppleScript code, allows to get output volume info
- **Displayer**: shows the HUDs, when notified by the ChangesObserver
    - **PositionManager**: used by the Displayer to calculate the position of the HUDs on the screen
    - HudAnimator: used by the Displayer to animate the HUDs with the correct style
    - IconManager: used by the Displayer to retrieve the icons for the HUDs
- OSDUIManager: used by the AppDelegate to hide the default MacOS HUDs when SlimHUD is launched and to show them again when SlimHUD quits
- UpdaterDelegate: used by Sparkle to get the channel to update from
