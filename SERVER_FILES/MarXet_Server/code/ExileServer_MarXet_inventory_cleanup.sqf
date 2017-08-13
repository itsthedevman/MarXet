/**
 *
 * Author: WolfkillArcadia
 * www.arcasindustries.com
 * © 2017 Arcas Industries
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */

_restrictTime = getNumber(missionConfigFile >> "CfgMarXet" >> "Database" >> "restrictTime");
_deleteTime = getNumber(missionConfigFile >> "CfgMarXet" >> "Database" >> "deleteTime");

if !(_restrictTime isEqualTo -1) then
{
    format["restrictOldListings:%1",_restrictTime] call ExileServer_system_database_query_fireAndForget;
};

if !(_deleteTime isEqualTo -1) then
{
    format["deleteOldListings:%1",_deleteTime] call ExileServer_system_database_query_fireAndForget;
};
