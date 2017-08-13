_listingID = _this;

_stock = [];

try {
    // If listingID not what we expect, error out
    if (_listingID isEqualTo "") then
    {
        throw 1;
    };

    // Find which index our inventory is sitting at
    _count = -1;
    {
        if ((_x find _listingID) != -1) then
        {
            _count = _forEachIndex;
        };
    } forEach MarXetInventory;

    // Didn't find the item? Not in stock!
    if (_count isEqualTo -1) then
    {
        throw 2;
    };

    _listingInformation = MarXetInventory select _count;

    // This is 1 when the item is available
    if ((_listingInformation select 1) isEqualTo 0) then
    {
        throw 3;
    };

    // Set the item to not available so other players can't grab it just in case.
    (MarXetInventory select _count) set [1,0];

    // Item must be available, lets send the data back
    _stock = _listingInformation;
}
catch
{
    _stock = false;
    if (_exception isEqualTo 1) then
    {
        [format["Listing ID was blank, DAFUQ?!?!?!"],"ConfirmStock"] call ExileServer_MarXet_util_log;
    };
};

_stock
