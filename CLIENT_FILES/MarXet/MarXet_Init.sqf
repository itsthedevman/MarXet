if (!hasInterface || isServer) exitWith {};

// Wait until the server makes this variable public
waitUntil {!isNil "MarXetLoaded"};

if (MarXetLoaded) then
{
    {
        _code = compileFinal (preprocessFileLineNumbers (_x select 1));
        missionNamespace setVariable [(_x select 0), _code];
    }
    forEach
    [
        ['ExileClient_MarXet_gui_load','MarXet\functions\ExileClient_MarXet_gui_load.sqf'],
        ['ExileClient_MarXet_network_buyerBuyNowResponse','MarXet\functions\ExileClient_MarXet_network_buyerBuyNowResponse.sqf'],
        ['ExileClient_MarXet_network_createNewListingResponse','MarXet\functions\ExileClient_MarXet_network_createNewListingResponse.sqf'],
        ['ExileClient_MarXet_network_sellerBuyNowResponse','MarXet\functions\ExileClient_MarXet_network_sellerBuyNowResponse.sqf'],
        ['ExileClient_MarXet_network_updateInventoryResponse','MarXet\functions\ExileClient_MarXet_network_updateInventoryResponse.sqf'],
        ['ExileClient_MarXet_util_log','MarXet\functions\ExileClient_MarXet_util_log.sqf'],
        ['ExileClient_MarXet_util_sortNumberString','MarXet\functions\ExileClient_MarXet_util_sortNumberString.sqf']
    ];

    [] execVM "MarXet\MarXet_Traders.sqf";

    [5, {["updateInventoryRequest",[0]] call ExileClient_system_network_send}, [], false] call ExileClient_system_thread_addtask;

    [format["MarXet Client init completed"],"Client Init"] call ExileClient_MarXet_util_log;

}
else
{
    [format["MarXet server failed to load! Client load has been disabled!"],"Client Init"] call ExileClient_MarXet_util_log;
};
