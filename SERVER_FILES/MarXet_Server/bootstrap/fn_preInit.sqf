/**
 *
 * Author: WolfkillArcadia
 * www.arcasindustries.com
 * © 2017 Arcas Industries
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */

{
    _code = compileFinal (preprocessFileLineNumbers (_x select 1));
    missionNamespace setVariable [(_x select 0), _code];
}
forEach
[
    ['ExileServer_MarXet_inventory_checkListingID','MarXet_Server\code\ExileServer_MarXet_inventory_checkListingID.sqf'],
    ['ExileServer_MarXet_inventory_cleanup','MarXet_Server\code\ExileServer_MarXet_inventory_cleanup.sqf'],
    ['ExileServer_MarXet_inventory_confirmStock','MarXet_Server\code\ExileServer_MarXet_inventory_confirmStock.sqf'],
    ['ExileServer_MarXet_inventory_createListingID','MarXet_Server\code\ExileServer_MarXet_inventory_createListingID.sqf'],
    ['ExileServer_MarXet_inventory_initalize','MarXet_Server\code\ExileServer_MarXet_inventory_initalize.sqf'],
    ['ExileServer_MarXet_inventory_updateStock','MarXet_Server\code\ExileServer_MarXet_inventory_updateStock.sqf'],
    ['ExileServer_MarXet_network_buyNowRequest','MarXet_Server\code\ExileServer_MarXet_network_buyNowRequest.sqf'],
    ['ExileServer_MarXet_network_createNewListingRequest','MarXet_Server\code\ExileServer_MarXet_network_createNewListingRequest.sqf'],
    ['ExileServer_MarXet_network_updateInventoryRequest','MarXet_Server\code\ExileServer_MarXet_network_updateInventoryRequest.sqf'],
    ['ExileServer_MarXet_system_getPlayerObject','MarXet_Server\code\ExileServer_MarXet_system_getPlayerObject.sqf'],
    ['ExileServer_MarXet_util_log','MarXet_Server\code\ExileServer_MarXet_util_log.sqf']
];

[format["MarXet has been compiled"],"PreInit"] call ExileServer_MarXet_util_log;
true
