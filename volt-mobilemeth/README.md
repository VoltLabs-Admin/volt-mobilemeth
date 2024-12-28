Mobile Meth Lab Script Installation and Usage Guide
Installation Instructions
Follow these steps to install and configure the Mobile Meth Lab script on your FiveM server.

1. Download and Add Script
Download the Script:

Download all script files (fxmanifest.lua, client.lua, server.lua, config.lua, items.lua) from the repository or provided files.
Create a Folder:

Create a new folder in your server's resources directory:
bash
Copy code
resources/[custom]/mobilemethlab
Place Files:

Place all downloaded files into the mobilemethlab folder.
Add Script to server.cfg:

Open your server.cfg file and add the following line:
plaintext
Copy code
ensure mobilemethlab
2. Configure Inventory System
The script supports ox_inventory, qb-inventory, and qs-inventory.

Ox Inventory
Open the data/items.lua file in your ox_inventory resource.
Add the following items:
lua
Copy code
["ephedrine"] = {
    label = "Ephedrine",
    weight = 200,
    stack = true,
    description = "Used in meth production",
},
["acetone"] = {
    label = "Acetone",
    weight = 150,
    stack = true,
    description = "Used in meth production",
},
["chemicals"] = {
    label = "Chemicals",
    weight = 300,
    stack = true,
    description = "Used in meth production",
},
["meth_bag"] = {
    label = "Meth Bag",
    weight = 500,
    stack = true,
    description = "The final product of meth production",
},
QB Inventory
Open the qb-core/shared/items.lua file.
Add the following items:
lua
Copy code
["ephedrine"] = {
    name = "ephedrine",
    label = "Ephedrine",
    weight = 200,
    type = "item",
    image = "ephedrine.png",
    unique = false,
    useable = false,
    combinable = nil,
    description = "Used in meth production",
},
["acetone"] = {
    name = "acetone",
    label = "Acetone",
    weight = 150,
    type = "item",
    image = "acetone.png",
    unique = false,
    useable = false,
    combinable = nil,
    description = "Used in meth production",
},
["chemicals"] = {
    name = "chemicals",
    label = "Chemicals",
    weight = 300,
    type = "item",
    image = "chemicals.png",
    unique = false,
    useable = false,
    combinable = nil,
    description = "Used in meth production",
},
["meth_bag"] = {
    name = "meth_bag",
    label = "Meth Bag",
    weight = 500,
    type = "item",
    image = "meth_bag.png",
    unique = false,
    useable = false,
    combinable = nil,
    description = "The final product of meth production",
},
QS Inventory
Open the item configuration file for your qs-inventory.
Add the above items in a format compatible with QS inventory.
3. Install Dispatch System (Optional)
The script supports ps-dispatch and qs-dispatch for police notifications.

Install Dispatch System:

Ensure either ps-dispatch or qs-dispatch is installed on your server.
Add to server.cfg:

Ensure ps-dispatch or qs-dispatch is running by adding:
plaintext
Copy code
ensure ps-dispatch
or
plaintext
Copy code
ensure qs-dispatch
Configuration:

The script autodetects the dispatch system and triggers a Suspicious Activity alert with a configurable chance.
Set Alert Chance:

Adjust the Config.PoliceAlertChance in config.lua:
lua
Copy code
Config.PoliceAlertChance = 50 -- Set percentage chance (0 to 100)
Usage Instructions
1. Spawn the Meth Lab Vehicle
Use any vehicle spawner (e.g., admin menu or /car journey) to spawn the Journey vehicle.
The Journey acts as the meth lab.
2. Ingredients
Ensure you have the following items in your inventory:
Ephedrine (2)
Acetone (1)
Chemicals (1)
3. Start Meth Production
Approach the Journey:

Walk up to the Journey vehicle and use the targeting system (ox_target, qb-target, or qtarget) to interact.
Interact:

Select the option Start Cooking Meth.
Minigame:

Complete the W, A, S, D minigame to proceed.
Cooking:

If successful, meth production begins and takes 60 seconds.
A progress bar appears, and smoke billows from the vehicle.
Receive Meth:

After production is complete, receive Meth Bags in your inventory.
4. Police Notifications
If the dispatch system is installed:
There is a chance (configurable) for police to be notified of suspicious activity near the vehicle.
Police receive GPS coordinates and a description of the activity.
Optional Configuration
1. Adjust Cooking Time
Open config.lua and modify:
lua
Copy code
Config.CookingTime = 60 -- Time in seconds
2. Explosion Chance
Set the chance of an explosion on meth-making failure:
lua
Copy code
Config.ExplosionChance = 20 -- Percentage
3. Reward Amount
Adjust the amount of meth produced:
lua
Copy code
Config.Reward = {item = "meth_bag", amount = 5}
Features
Immersive Meth Production:
Realistic animations and progress bar for meth-making.
Police Notifications:
Autodetection of ps-dispatch or qs-dispatch.
Dynamic Smoke:
Heavy smoke effect during meth production for added realism.