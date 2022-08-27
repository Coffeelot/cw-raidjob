# PVE Raid Job 🔫

We loved the idea of PVE combat jobs and the [PS-Methjob](https://github.com/Project-Sloth/ps-methrun) was such a great template. We decided to generalize it so more jobs with similar structure could be created without any coding. We kept the original job in the config as an example. 

The job is simple:
You find the mission giver NPC (at the time of day when you are willing to give you the mission). Pay the fee. You'll get an email with info and a GPS marker. Go there, shoot some dudes up and steal the loot. The first security layer is a puzzle, the second is timed. Make sure you DO NOT bring this close to the boss while it's ticking. After the mission-specific timer is over the case will open and you will recieve the item the boss wants. You can turn it in at any time and get the reward.

# Developed by Coffeelot and Wuggie
[More scripts by us](https://github.com/stars/Coffeelot/lists/cw-scripts)  👈

**Support, updates and script previews**:

[![Join The discord!](https://cdn.discordapp.com/attachments/977876510620909579/1013102122985857064/discordJoin.png)](https://discord.gg/FJY4mtjaKr )

**All our scripts are and will remain free**. If you want to support what we do, you can buy us a coffee here:

[![Buy Us a Coffee](https://www.buymeacoffee.com/assets/img/guidelines/download-assets-sm-2.svg)](https://www.buymeacoffee.com/cwscriptbois )

# Preview 

[![YOUTUBE VIDEO](http://img.youtube.com/vi/QXkydMqS_ok/0.jpg)](https://youtu.be/QXkydMqS_ok)

# Tokens 🔑

At the top of the Config you will find `Config.UseTokens = false`. Change `false` to `true` if you want to use [cw-tokens](https://github.com/Coffeelot/cw-tokens).
# Job Creation 🔧
All you need to do to add more jobs is to add new Job objects (with all the required things) in the config.lua file. We included several examples showcasing a variety of functionality. Don't forget to add the job object into the *Config.Jobs* object at the bottom of the file! 
## Job object (see CokeJob for example)
**JobName**: Variable identifier for the job. Needs to be unique\
**Boss**: Object that contains info about the quest giving NPC\
**Guards**: Object that contains info about the guards\
**Vehicles**: Objetct that contain info on vehicles placed around the area\
**Items**: Object that contains info on the objects and items used in the job\
**MinimumPolice**: Integer of how many police are needed to start the job\
**RunCost**: Integer of how much the job costs to take\
**Payout**: Integer of how much the job pays out\
**SpecialRewards**: (optional) Object of special rewards

## Boss object (see CokeBoss for example)
**coords**: Vector4 that sets location of boss\
**model**: Ped model of boss. See link at bottom for list\
**animation**: (optional) Animation for the boss. See link at bottom for list\
**missionTitle**: String that shows up in game\
**available = {from, to}**: (optional) Objetct that sets the time the job is available\

## Item object (see CokeItems for example)
**FetchItemLocation**: Vector4 that sets location of fetch object\
**FetchItemTime**: Time it takes for the object to "open" after it has been taken (milliseconds)\
**FetchItem**: Name of the object you want to use (that shows up in inventory)\  
**FetchItemProp**: (optional) Name of the in game prop that shows up\
**FetchItemContents**: Name of the object you want to get (that shows up in inventory). This is the item that is returned to the boss\
**FetchItemContentsAmount**: Integer of how many you get.\
**FetchItemMinigame = { Type, Variables = {var1, var2...} }**: (optional) Sets the minigame or the difficulty. Defaults to a thermite game. The *Type* is the name of the minigame. The *Variables* follow the same order as shown on the PS-UI github page (link at bottom) but here is the quick version:

```
Circle: NumberOfCircles, MS
Maze: Hack Time Limit (this one seems to be broken, but might get fixed in future PS-UI updates)
VarHack: Number of Blocks, Time (seconds)
Thermite: Time, Gridsize (5, 6, 7, 8, 9, 10), IncorrectBlocks
Scrambler: Type (alphabet, numeric, alphanumeric, greek, braille, runes), Time (Seconds), Mirrored (0: Normal, 1: Normal + Mirrored 2: Mirrored only )
``` 

[ped models](https://docs.fivem.net/docs/game-references/ped-models/#scenario-male)\
[animation pastebin](https://pastebin.com/6mrYTdQv)

## (optional) GuardPositionObject (see CokeGuardPositions for example) 
This contains a list of vecors where NPCs will spawn if they have not been given a specific coordinate in the following object

## Guard object (see CokeGuards for example) 
This contains a list of object that has info on guards, each item consists of
**coords**:  Vector4 that sets location of guard\
**model**: model of the npc. See link at bottom for list\
**weapon**: (optional) name of the weapon this npc will use\  
**accuracy**: (optional) how good they are at shooting. Default is 75\  
**armor**: (optional) how much extra armor they have. Default is 50\  

## Vehicles object (see CokeVehicles for example)
This contains a list of object that has info on vehicles, each item consists of
**coords**:  Vector4 that sets location of vehicle\
**model**: model of the vehicle\

## Special Rewards object (see CokeSpecialRewards for example)
This contains a list of objects that has info on rewards, each item consists of
**Item**:  variable name of  item (found in items.lua in QB-core)\
**Amount**: How many of this item is given\
**Chance**: Chance of getting this item\

# Add to qb-core ❗
Items to add to qb-core>shared>items.lua 
```
["securitycase"] =        {["name"] = "securitycase",       ["label"] = "Security Case",        ["weight"] =1000, ["type"] = "item", ["image"] = "securitycase.png", ["unique"] = true, ["useable"] = false,['shouldClose'] = false, ["combinable"] = nil, ["description"] = "Security case with a timer lock"},
["casekey"] =             {["name"] = "casekey",            ["label"] = "Case Key",             ["weight"] =0, ["type"] = "item", ["image"] = "key1.png", ["unique"] = true, ["useable"] = false, ['shouldClose'] = false,["combinable"] = nil, ["description"] = "Key for a case"},
["meth_cured"] =          {["name"] = "meth_cured",         ["label"] = "Ice",                  ["weight"] =100, ["type"] = "item", ["image"] = "meth_cured.png", ["unique"] = false, ["useable"] = false, ['shouldClose']= false, ["combinable"] = nil, ["description"] = "Pure Crystal meth, this is above your paygrade"},
["coke_pure"] =          {["name"] = "coke_pure",         ["label"] = "Cocaine paste",                 ["weight"] = 100, ["type"] = "item", ["image"] = "meth_cured.png", ["unique"] = false, ["useable"] = false,['shouldClose'] = false, ["combinable"] = nil, ["description"] = "High grade cocaine paste, this is above yourpaygrade"},
["weed_notes"] =          {["name"] = "weed_notes",         ["label"] = "Strange Documents",                 ["weight"] = 100, ["type"] = "item", ["image"] = "deliverynote.png", ["unique"] = false, ["useable"] =false, ['shouldClose'] = false, ["combinable"] = nil, ["description"] = "Documents that is clearly above yourpaygrade"},
["clown_notes"] =          {["name"] = "clown_notes",         ["label"] = "StrangeDocuments",                  ["weight"] = 100, ["type"] = "item", ["image"] = "deliverynote.png",["unique"] = false, ["useable"] = false, ['shouldClose'] = false, ["combinable"] = nil, ["description"] ="Documents that is clearly above your paygrade. Honk honk"},
["art_notes"] =          {["name"] = "art_notes",         ["label"] = "Strange Documents",                 ["weight"] = 100, ["type"] = "item", ["image"] = "deliverynote.png", ["unique"] = false, ["useable"] =false, ['shouldClose'] = false, ["combinable"] = nil, ["description"] = "Documents that is clearly above yourpaygrade."},
	


```

Also make sure the images are in qb-inventory>html>images


# Dependencies
* PS-UI - https://github.com/Project-Sloth/ps-ui/blob/main/README.md
* qb-target - https://github.com/BerkieBb/qb-target

Inspired by the [PS-Methjob](https://github.com/iplocator/ps-methrun)
