# docshot

It's docshot!

To run [this .ahk file](https://raw.githubusercontent.com/silentdragoon/docshot/main/docshot.ahk), you'll need [AutoHotKey](https://autohotkey.com/download/).

By default, pressing F12 will take a pair of screenshots (HDR and SDR) using Windows Game Bar, copy the SDR one to the clipboard for postin' on Twitter and copy both of them to a directory of the user's choice (currently the desktop). 

To change the hotkey and/or save directory, just change the script. If you want to avoid overwriting keys that might be used elsewhere (e.g. F12), then you could make the trigger a higher F-key (e.g. F13), as long as you have the option to bind this in your keyboard / controller / mouse software of choice. Alternatively, choose a little-used key with some modifiers - Ctrl + Shift + Insert should be pretty safe (that's written as ^!Insert btw). All of the keys and how to reference them in AHK are [written down here](https://www.autohotkey.com/docs/KeyList.htm).

I've added commments (lines that start with ;) in the AHK file to give you some pointers; the two lines you need to change are fairly far down but it's not a long file. If you open the .AHK file in Visual Studio, and install the .AHK plugin as it suggests, then you'll get syntax highlighting and fun stuff if you want to start tweaking - but not necessary for simple changes.

*If you have any issues or feature requests, please let me know - I'm only a Twitter DM away. Have fun!*
