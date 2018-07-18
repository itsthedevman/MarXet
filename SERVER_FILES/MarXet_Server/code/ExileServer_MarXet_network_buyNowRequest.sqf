/**
 *
 * Author: WolfkillArcadia
 * www.arcasindustries.com
 * © 2017 Arcas Industries
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */

//
//          [format[""],"DEBUG"] call ExileServer_MarXet_util_log;
//
_sessionID = _this select 0;
_package = _this select 1;
_listingID = _package select 0;
_thatOneThingThatISentToTheServer = _package select 1;
_vehicleObject = "";
_buyerIsSeller = false;

try {
    // Perform the usual checks to make sure the player is real.
    _playerObject = _sessionID call ExileServer_system_session_getPlayerObject;
    if (isNull _playerObject) then
	{
		throw "Who are you again?";
	};

    if (_listingID isEqualTo "") then
    {
        throw "Listing ID doesn't exist!";
    };

    // Return our stock
    _stock = _listingID call ExileServer_MarXet_inventory_confirmStock;

    // Not available? Shoot, send it back to the client.
    if (_stock isEqualTo false) then
    {
        throw "Oh noes! The item is no longer available!";
    };

    _sellersUID = _stock select 4;
    _buyerUID = getPlayerUID _playerObject;

    // Assume the seller is different than the buyer.
    _price = parseNumber(_stock select 3);
    
    // Check to see if the sellers locker is maxed (thx to Adam Kadmon)
    _sellerLocker = format["getLocker:%1", _sellersUID] call ExileServer_system_database_query_selectSingleField;
    _lockerLimit = (getNumber(missionConfigFile >> "CfgLocker" >> "maxDeposit"));

    if ((_sellerLocker + _price) > _lockerLimit) then
    {
       throw "Seller's locker is maxed out. They will need to remove some poptabs before this item can be purchased!";
    };

    // But we are going to check to make sure anyway, set the price to 0 if they are.
    if (_buyerUID isEqualTo _sellersUID && {getNumber(missionConfigFile >> "CfgMarXet" >> "Settings" >> "disableSellerBuyback") isEqualTo 0}) then
    {
        _divisor = getNumber(missionConfigFile >> "CfgMarXet" >> "Settings" >> "sellerBuybackPercentage");
        _price = if (_divisor > 0 && {_divisor < 1}) then { _price - (_price * _divisor) } else { 0 };
        _buyerIsSeller = true;
    };

    _playerMoney = _playerObject getVariable ["ExileMoney",0];

    // If vehicle, spawn it in
    if (count(_stock select 2) > 1) then
    {
        _listingArray = _stock select 2;
        _vehicleClass = _listingArray select 0;

        // before anything else, see if they have enough money including the rekeying charge
        _vehicleCost = getNumber (missionConfigFile >> "CfgExileArsenal" >> _vehicleClass >> "price");
        _rekeyCost = _vehicleCost * (getNumber (missionConfigFile >> "CfgTrading" >> "rekeyPriceFactor"));
        if (_buyerIsSeller) then
        {
            _price = _rekeyCost;
        }
        else
        {
            _price = _price + _rekeyCost;
        };

        if (_playerMoney < _price) then
        {
            throw "You don't have enough money to purchase";
        };

        // Check to see if it's got anything in it that would make the server unhappy
    	_forbiddenCharacter = [_thatOneThingThatISentToTheServer, "1234567890"] call ExileClient_util_string_containsForbiddenCharacter;

    	if !(_forbiddenCharacter isEqualTo -1) then
    	{
    		throw format ["Forbidden character in PIN! I have no idea how it got there. [%1]", _forbiddenCharacter];
    	};
        _pinCode = _thatOneThingThatISentToTheServer;

        // Check to see if they preset helipads or not
        _staticVehicleSpawning = (getNumber(missionConfigFile >> "CfgMarXet" >> "Settings" >> "staticVehicleSpawning") isEqualTo 1);
        if (_staticVehicleSpawning) then
        {
            if (_vehicleClass isKindOf "Ship") then
            {
                _helipad = nearestObject [(getPosATL _playerObject), "Land_HelipadEmpty_F"];
                if (isNull _helipad) then
                {
                    throw "Couldn't find a suitable position for the ship";
                };
                _position = (getPosASL _helipad);
                _position set [2,0];
                _vehicleObject = [_vehicleClass, _position, (random 360), false, _pinCode] call ExileServer_object_vehicle_createPersistentVehicle;
            }
            else
            {
                if (_vehicleClass isKindOf "Air") then
                {
                    _helipad = nearestObject [(getPosATL _playerObject), "Land_HelipadSquare_F"];
                    if (isNull _helipad) then
                    {
                        throw "Couldn't find a suitable position for the air vehicle";
                    };
                    _position = (getPosATL _helipad);
                    _position set [2,0];
                }
                else
                {
                    _helipad = nearestObject [(getPosATL _playerObject), "Land_HelipadEmpty_F"];
                    if (isNull _helipad) then
                    {
                        throw "Couldn't find a suitable position for the vehicle";
                    };
                    _position = (getPosATL _helipad);
                    _position set [2,0];
                };
                _vehicleObject = [_vehicleClass, _position, (random 360), true, _pinCode] call ExileServer_object_vehicle_createPersistentVehicle;
            };
        }
        else
        {
            if (_vehicleClass isKindOf "Ship") then
            {
                _position = [(getPosATL _playerObject), 80, 10] call ExileClient_util_world_findWaterPosition;

                _vehicleObject = [_vehicleClass, _position, (random 360), false, _pinCode] call ExileServer_object_vehicle_createPersistentVehicle;
            }
            else
            {
                _position = (getPos _playerObject) findEmptyPosition [10, 175, _vehicleClass];

                if (_position isEqualTo []) then
                {
                    throw "Couldn't find a suitable position for vehicle";
                };

                _vehicleObject = [_vehicleClass, _position, (random 360), true, _pinCode] call ExileServer_object_vehicle_createPersistentVehicle;
            };
        };

        // Set ownership
        _vehicleObject setVariable ["ExileOwnerUID", _buyerUID];
        _vehicleObject setVariable ["ExileIsLocked",0];
        _vehicleObject lock 0;

        // Save vehicle in database
        _vehicleObject call ExileServer_object_vehicle_database_insert;

        // Set fuel and damage
        _vehicleObject setFuel (_listingArray select 1);
        _vehicleObject setDamage (_listingArray select 2);

        // Set the hitpoints
        _hitpoints = _listingArray select 3;

        if ((typeName _hitpoints) isEqualTo "ARRAY") then
        {
        	{
        		_vehicleObject setHitPointDamage [_x select 0, _x select 1];
        	}
        	forEach _hitpoints;
        };

        // update position/stats
        _vehicleObject call ExileServer_object_vehicle_database_update;
        _vehicleObject = netID _vehicleObject;
    }
    else
    {
        if (_playerMoney < _price) then
        {
            throw "You don't have enough money to purchase the item";
        };
    };

    // Make sure to update our inventory
    _listingID call ExileServer_MarXet_inventory_updateStock;

    // What if we buy our thing back?
    if (_buyerIsSeller) then
    {
        // Charge the seller the rekey cost of the vehicle
        if (_price > 0) then
        {
            _playerMoney = _playerMoney - _price;
            _playerObject setVariable ["ExileMoney",_playerMoney,true];
            format["setPlayerMoney:%1:%2",_playerMoney,_playerObject getVariable ["ExileDatabaseID", 0]] call ExileServer_system_database_query_fireAndForget;
        };
        [_sessionID,"buyerBuyNowResponse",[_stock,_thatOneThingThatISentToTheServer,_vehicleObject,str(_price)]] call ExileServer_system_network_send_to;
        [format["Player: %1 bought their %2 back. Vehicle: %3. Rekey Cost if vehicle: %4",_buyerUID, (_stock select 2) select 0, (_price > 0), _price],"BuyNowRequest"] call ExileServer_MarXet_util_log;
    }
    else
    {
        // Looks good, set their account money
        _newMoney = _playerMoney - _price;
        _playerObject setVariable ["ExileMoney",_newMoney,true];


        format["setPlayerMoney:%1:%2",_newMoney,_playerObject getVariable ["ExileDatabaseID", 0]] call ExileServer_system_database_query_fireAndForget;

        [_sessionID,"buyerBuyNowResponse",[_stock,_thatOneThingThatISentToTheServer,_vehicleObject,str(_price)]] call ExileServer_system_network_send_to;

        // Get the seller's player object if they are connected.
        _sellerPlayerObject = _sellersUID call ExileServer_MarXet_system_getPlayerObject;

        // If seller isn't connected, update the database. If they are, process like normal.
        if (_sellerPlayerObject isEqualTo "") then
        {
            _stats = format["getAccountStats:%1", _sellersUID] call ExileServer_system_database_query_selectSingle;
            _sellersMoney = _stats select 4;
            _newSellerMoney = _sellersMoney + _price;
            format["updateLocker:%1:%2",_newSellerMoney, _sellersUID] call ExileServer_system_database_query_fireAndForget;
        }
        else
        {
            _sellersMoney = _sellerPlayerObject getVariable ["ExileLocker", 0];
            _newSellerMoney = _sellersMoney + _price;
            _sellerSessionID = _sellerPlayerObject getVariable ["ExileSessionID",-1];
            _sellerPlayerObject setVariable ["ExileLocker",_newSellerMoney,true];
            format["updateLocker:%1:%2",_newSellerMoney, _sellersUID] call ExileServer_system_database_query_fireAndForget;
            if !(_sellerSessionID isEqualTo -1) then
            {
                [_sellerSessionID,"sellerBuyNowResponse",[_stock]] call ExileServer_system_network_send_to;
            };
        };
        [format["Player: %1 bought player: %2's %3 for %4",_buyerUID,_sellersUID, (_stock select 2) select 0, _price],"BuyNowRequest"] call ExileServer_MarXet_util_log;
    };
}
catch
{
    [_sessionID, "toastRequest", ["ErrorTitleAndText", ["FAILED!", _exception]]] call ExileServer_system_network_send_to;
    [_exception,"BuyNowRequest"] call ExileServer_MarXet_util_log;
    if (!isNil "_stock" && !(_stock isEqualTo false)) then
    {
        _count = -1;
        {
            if ((_x find _listingID) != -1) then
            {
                _count = _forEachIndex;
            };
        } forEach MarXetInventory;
        (MarXetInventory select _count) set [1,1];
    };
};
