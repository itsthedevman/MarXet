![logo](http://puu.sh/pp1ty/864b4d13b2.jpg)
# Welcome to MarXet!
##### Exile's Leading Inmate Based Marketplace

MarXet is a server/client script made for Exile to provide a unique and dynamic player based market. Players can create new "listings" for any item or persistent vehicle in game with it's own price. Other players can then purchase any item/vehicle from MarXet.

#### Features
* Dynamic, player based marketplace
* Built using Exile's Security
* Sell any item or any persistent vehicles
* Accessible via placed MarXet Traders
* GUI built to match Exile's GUI theme
* Persistent, saves to the database

#### Installation
Installation is simple and easy with only one Exile overwrite.

#### extDB
1. Copy `MarXet-SQL.sql` into your favorite mySQL viewer's query window and run it.
2. Confirm you have a `marxet` table.
3. Copy the contents of `MarXet-extDB.ini` into your `@ExileServer\extDB\sql_custom_v2\exile.ini` file at the bottom.

##### Server
1. PBO `MarXet_Server` in `SERVER_FILES` and copy that to your `@ExileServer\addons` folder.

##### Client
1. Copy `MarXet` from `CLIENT_FILES` into the root of your exile.MAPNAME folder.
2. In either `init.sqf` or `initPlayerLocal.sqf`, add `[] execVM "MarXet\MarXet_Init.sqf";`
3. `CfgNetworkMessages.hpp` both will depend on your set up.
    1. If you **ALREADY** have `class CfgNetworkMessages` **ANYWHERE** in your `description.ext` or `config.cpp` in your exile.MAPNAME folder:
        1. Add `#include "MarXet\CfgMarXetNetworkMessages.hpp` to `class CfgNetworkMessages`
        2. It should look something like what is below.
    2. If you don't have `class CfgNetworkMessages`, in your `config.cpp`, add this at the top.

            class CfgNetworkMessages
            {
                #include "MarXet\CfgMarXetNetworkMessages.hpp"
            };
4. At the top of `config.cpp` add `#include "MarXet\CfgMarXet.cpp"`
4. At the top of `description.ext` add the following:

        #include "MarXet\dialog\RscMarXetDefines.hpp"
        #include "MarXet\dialog\RscMarXetDialog.hpp"
5. You are done! Head on down to configuration.

#### Configuration

##### Traders and Objects
Located in `MarXet` folder in your `exile.MAPNAME` mission folder, there is a file called `MarXet_Traders.sqf`.
The trader setup code is like Exiles', except instead of a setVariable, they have a pushBack.

##### General Config
The file called `CfgMarXet.cpp`, located in `MarXet\` in your `exile.MAPNAME` mission folder, has a few important system settings in it. Please make sure to read them.
As MarXet updates and evolves, this file will be the source of 90% of the config options, make sure to continue to check it.


#### Changelog
**Version 2.2 [June 29 2016]**

Happy Exile update! This is the compatibility patch for Exile version 0.9.8. This patch **WILL NOT** work with any Exile versions before 0.9.8
* Switched to new Exile money.
    * Note: Selling and buying both use the "physical" money. Unfortunately, as that lockers are server configurable, the player may lose money if a payment from a sold item went to their locker. I will look into a better way of handling this for version 3.0. If you have an idea, feel free to comment on the forums
* Switched from CfgHints to Exile's new "toast" notification system.
* Added checks to make sure CfgMarXet and CfgNetworkMessages exist in the missionConfigFile.
    * If not, server RPT will be spammed, MarXet won't run and client won't place traders ;)
* Added ability to disable item restriction and item deletion in database.
    * Change the settings in CfgMarXet to -1 to disable.
* "buyNowRequest" no longer keeps the item locked if it reaches an error.
* Changed MarXet trader parameters to new Exile format
* Updated CfgNetworkMessages

**Version 2.0 [June 19 2016]**
* Added ability to sort listings (GUI dropdown)
* Listings now have a restriction date (Configurable, check CfgMarXet.cpp)
    * If a listing hasn't been bought in a certain timeline, the database will set the sellersUID to 0, which keeps the seller from making any money on the item
* Listings that have been restricted will be removed after a certain time (Configurable, check CfgMarXet.cpp)
* Listing a vehicle will prompt you with a confirmation before listing
* Purchasing a listed vehicle now requires you to set the pin first
* Listed vehicles now have a "rekey charge" added onto the list price.
    * Price is pulled from config.cpp and is the same price as Exile's default rekey price
    * (If buyer is seller) Buying back listed vehicles will cost just the rekey charge.
    * (if buyer is seller) Buying back listed vehicles will warn the player that they originally listed that vehicle and it will cost them a rekey charge.
* Listed items that the player originally listed will show up as 0 or the rekey charge if a vehicle.
* Added ability for vehicles to spawn on pre-placed helipads (Check CfgMarXet.cpp)
* Fixed standard sorting filter (It was backwards!)
* Clean up code a little
* Probably created more bugs

#### Updating to version 2.2 from 2.0
Client and server have been updated.
##### Client
* Remove `class CfgHints {};` if MarXet was the only thing in it. Or remove `#include "MarXet\CfgMarXetHints.hpp"`
* (If you overwrote this via config.cpp) Remove the `ExileServer_system_network_dispatchIncomingMessage` overwrite from config.cpp as that it's included in Exile 0.9.8 by default.
* Delete `MarXet` folder from Mission folder and copy the one from the github
* **NOTE:** If you made custom traders for your map, make sure you adjust them for the new format that Exile uses or your traders will not spawn.

##### Server
* Delete `MarXet_Server.pbo`
* PBO `MarXet_Server.pbo` from the github and place it in `@ExileServer\addons` folder.
