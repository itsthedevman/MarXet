/**
 *
 * Author: WolfkillArcadia
 * www.arcasindustries.com
 * © 2017 Arcas Industries
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */

["Loading MarXet Inventory...","InventoryInitalize"] call ExileServer_MarXet_util_log;

MarXetInventory = [];

_listings = format ["getListings"] call ExileServer_system_database_query_selectFull;

if !(count(_listings) isEqualTo 0) then
{
    MarXetInventory = [_listings, [], {(_x select 2) select 0}, "DESCEND"] call BIS_fnc_sortBy;
    ["Loaded MarXet Inventory! MarXetInventory is public!","InventoryInitalize"] call ExileServer_MarXet_util_log;
}
else
{
    ["MarXet inventory is empty. :( We've still made it public for your enjoyment. :D","InventoryInitalize"] call ExileServer_MarXet_util_log;
};
