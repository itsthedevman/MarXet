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
