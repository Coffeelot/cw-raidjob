# PVE Raid Job 🔫

We loved the idea of PVE combat jobs and the [PS-Methjob](https://github.com/iplocator/ps-methrun) was such a great template. We decided to generalize it so more jobs with similar structure could be created without any coding. We kept the original job in the config as an example. 

# Preview 

COMING SOON

# Job Creation 🔧

## Job object (see MethJob for example)
**JobName**: Variable identifier for the job. Needs to be unique\
**Boss**: Object that contains info about the quest giving NPC\
**Guards**: Object that contains info about the guards\
**Vehicles**: Objetct that contain info on vehicles placed around the area\
**Items**: Object that contains info on the objects and items used in the job\
**MinimumPolice**: Integer of how many police are needed to start the job\
**RunCost**: Integer of how much the job costs to take\
**Payout**: Integer of how much the job pays out\
**SpecialRewards**: (optional) Object of special rewards

## Boss object (see MethBoss for example)
**coords**: Vector4 that sets location of boss\
**model**: Ped model of boss. See link at bottom for list\
**animation**: (optional) Animation for the boss. See link at bottom for list\
**missionTitle**: String that shows up in game\
**available = {from, to}**: (optional) Objetct that sets the time the job is available\

## Item object (see MethItems for example)
**FetchItemLocation**: Vector4 that sets location of fetch object\
**FetchItemTime**: Time it takes for the object to "open" after it has been taken\
**FetchItem**: Name of the object you want to use (that shows up in inventory)\  
**FetchItemProp**: (optional) Name of the in game prop that shows up\
**FetchItemContents**: Name of the object you want to get (that shows up in inventory). This is the item that is returned to the boss\
**FetchItemContentsAmount**: Integer of how many you get.\

[ped models](https://docs.fivem.net/docs/game-references/ped-models/#scenario-male)\
[animation pastebin](https://pastebin.com/6mrYTdQv)

## Guard object (see MethGuards for example) 
This contains a list of object that has info on guards, each item consists of
**coords**:  Vector4 that sets location of guard\
**model**: model of the npc. See link at bottom for list\
**weapon**: (optional) name of the weapon this npc will use\  

## Vehicles object (see MethVehicles for example)
This contains a list of object that has info on vehicles, each item consists of
**coords**:  Vector4 that sets location of vehicle\
**model**: model of the vehicle\

## Special Rewards object (see MethSpecialRewards for example)
This contains a list of objects that has info on rewards, each item consists of
**Item**:  variable name of  item (found in items.lua in QB-core)\
**Amount**: How many of this item is given\
**Chance**: Chance of getting this item\

# Add to qb-core ❗
Items to add to qb-core>shared>items.lua 
```
["securitycase"] =        {["name"] = "securitycase",       ["label"] = "Security Case",        ["weight"] = 1000, ["type"] = "item", ["image"] = "images/securitycase.png", ["unique"] = true, ["useable"] = false, ['shouldClose'] = false, ["combinable"] = nil, ["description"] = "Security case with a timer lock"},
["meth_cured"] =          {["name"] = "meth_cured",         ["label"] = "Ice",                  ["weight"] = 100, 
["coke_pure"] =          {["name"] = "coke_pure",         ["label"] = "Cocaine paste",                  ["weight"] = 100, ["type"] = "item", ["image"] = "meth_cured.png", ["unique"] = false, ["useable"] = false, ['shouldClose'] = false, ["combinable"] = nil, ["description"] = "High grade cocaine paste, this is above your paygrade"},
["type"] = "item", ["image"] = "images/meth_cured.png", ["unique"] = false, ["useable"] = false, ['shouldClose'] = false, ["combinable"] = nil, ["description"] = "Crystal meth"},
["casekey"] =             {["name"] = "casekey",            ["label"] = "Case Key",             ["weight"] = 0, ["type"] = "item", ["image"] = "images/key1.png", ["unique"] = true, ["useable"] = false, ['shouldClose'] = false, ["combinable"] = nil, ["description"] = "Key for a case"},
["weed_notes"] =          {["name"] = "weed_notes",         ["label"] = "Strange Documents",                  ["weight"] = 100, ["type"] = "item", ["image"] = "deliverynote.png", ["unique"] = false, ["useable"] = false, ['shouldClose'] = false, ["combinable"] = nil, ["description"] = "Documents that is clearly above your paygrade"},
```

Also make sure the images are in qb-inventory>html>images


# Dependencies
* Memory Game - https://github.com/NathanERP/memorygame_2
* qb-target - https://github.com/BerkieBb/qb-target

## Developed by Coffeelot#1586 and Wuggie#1683
Inspired by the [PS-Methjob](https://github.com/iplocator/ps-methrun)
