
## Minesweeper Board Game

Game basic implementation,
1 st click safe,
also safe 4 edge corners on the board, 
<br> (x - all safe cells)
<br>[x----x]
<br>[-x----]
<br>[x----x]
<br>
Board size can be adjusted only programmatically for the
moment.
<br>
<br>
For game design, I've used Adobe Animate and Photoshop for bitmaps,
Also there were free assets downloaded from **chatterstok**
<br><br>
There is almost no animations,
since all the time took asset design works,
game logic implementation.
Animations in fact, can be added at any time,
plus this requires involving Design person.
<br><br>
For **AS3 IDE**, I've been using **IntellijIdea**, since this is the tool 
I'm used for years of my professional carrier.

There are number of options, available on marked for free,
<br>
Haxe (IDE's)
<br>* Visual studio code with plugins,
<br>* Flash develop, (outdated + Windows Platform)
<br>* Flex Builder (outdated)
<br>
<br>
As another option, it can be any editor, just need 
to configure 2 things,
<br>* Apache Ant (build tool)
<br>* Adobe AIR SDK
<br>
<br>
As for packaging for iOS/Android, certificates required, 
so this targets skipped. 

### Project Setup
Game sources structure:
<br>
**[.]**
<br> **| -** **`assets`** (Asset files *swf, *swc, *png)
<br> **| -** **`design-assets`** (Adobe animate *fla file)
<br> **| -** **`bin`** (Output compiled files/binaries )
<br> **| -** **`src`** AS# source files
<br> **| -** .....- `src/com/rmu/mnswp/Main.as` - Main.as file, entry point.
<br>
<br>
#### Setup
Any IDE by your choice,
<br> get/install Harman Adobe AIR SDK, 50.2.4
https://airsdk.harman.com/download
<br>Configure your IDE to use Air SDK
<br>Clone repository
<br>https://github.com/rmustafaiev/minesweeper-as3
<br>`git clone https://github.com/rmustafaiev/minesweeper-as3.git`
<br>Open sources in IDE
<br>Set `src/com/rmu/mnswp/Main.as` as Main entry point
<br>You should be ready to build/compile.
<br>
<br>
Checkout an article to Setup AS3 Project
in Visual Studio Code.
https://github.com/BowlerHatLLC/vscode-as3mxml/wiki/Create-a-new-ActionScript-project-in-Visual-Studio-Code-that-targets-Adobe-AIR-for-desktop-platforms

