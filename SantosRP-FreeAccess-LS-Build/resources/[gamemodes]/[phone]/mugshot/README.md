# mugshot

### Description
Grabs the mugshot of a ped and uploads it. I made this mainly to be able to easily grab mugshots of a ped and use it in NUI.

### Installation
1. Install my modified <a href="https://github.com/jonassvensson4/screenshot-basic">screenshot-basic</a> resource.
2. Add `start mugshot`to your server.cfg. Remember to start it after screenshot-basic and before your scripts that are using the exports.

### Usage
This will upload a screenshot of your own ped and return the image url. This is a client event. Use the export or add the code in the client.lua to your own client file.
```
local url = exports["mugshot"]:getMugshotUrl(GetPlayerPed(-1))
```
