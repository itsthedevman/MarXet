/**
 *
 * Author: WolfkillArcadia
 * www.arcasindustries.com
 * © 2017 Arcas Industries
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */

MarXetLoaded = false;

try
{

    if !(isClass(missionConfigFile >> "CfgNetworkMessages" >> "buyNowRequest")) then
    {
        throw "MarXet's CfgNetworkMessages don't exist in config.cpp!";
    };

    if !(isClass(missionConfigFile >> "CfgMarXet")) then
    {
        throw "MarXet's config doesn't exist in config.cpp!";
    };

    // We okay? We run!
    call ExileServer_MarXet_inventory_cleanup;
    call ExileServer_MarXet_inventory_initalize;

    MarXetLoaded = true;
}
catch
{
    for "_i" from 0 to 4 do
    {
        // NOPE!
        [format["WE HAD AN ISSUE STARTING MARXET, MARXET WILL NOT START. ERROR: %1",_exception],"!!!WARNING!!!"] call ExileServer_MarXet_util_log;
    };
};

publicVariable "MarXetLoaded";
true
