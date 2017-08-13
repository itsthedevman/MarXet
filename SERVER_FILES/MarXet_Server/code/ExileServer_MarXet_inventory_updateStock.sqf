_listingID = _this;

try {
    if (_listingID isEqualTo "") then
    {
        throw 1;
    };

    _count = -1;
    {
        if ((_x find _listingID) != -1) then
        {
            _count = _forEachIndex;
        };
    } forEach MarXetInventory;

    // Our item isn't in stock, the fuck?
    if (_count isEqualTo -1) then
    {
        throw 2;
    };

    MarXetInventory deleteAt _count;
    format["deleteListing:%1",_listingID] call ExileServer_system_database_query_fireAndForget;

    // Send to all clients
    ["updateInventoryResponse",[MarXetInventory]] call ExileServer_system_network_send_broadcast;

}
catch
{
    [_exception,"updateStock"] call ExileServer_MarXet_util_log;
};
