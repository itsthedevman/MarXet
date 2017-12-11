/**
 *
 * Author: WolfkillArcadia
 * www.arcasindustries.com
 * © 2017 Arcas Industries
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_option","_display"];
disableSerialization;

_option = _this select 0;
_display = uiNamespace getVariable ["RscMarXetDialog",displayNull];

switch (_option) do
{
    case ("Load"):
    {
        private ["_display","_rightDropdown","_rightLB","_leftLB","_leftDropdown","_priceEditBox","_purchaseBtn"];
        disableSerialization;
        _display = uiNamespace getVariable ["RscMarXetDialog",displayNull];
        ////////////////////////////////////////////////////////////
        // LOAD VARIABLES
        ////////////////////////////////////////////////////////////
        MarXet_TempVehicleArray = [];
        MarXet_VehicleObjectArray = [];
        MarXet_ListingArray = [];
        MarXet_SelectedListingID = "";
        MarXet_TempListingClassname = "";
        MarXet_BuyerIsSeller = false;
        MarXet_Confirmed = false;
        MarXet_Poptab = 0;
        MarXet_WhichSideAreYouOn = 0;
        MarXet_Sorting = 0;

        ////////////////////////////////////////////////////////////
        // SET-UP DROPDOWNS
        ////////////////////////////////////////////////////////////

        ["LoadDropdown","Left"] call ExileClient_MarXet_gui_load;
        ["LoadDropdown","Right"] call ExileClient_MarXet_gui_load;
        ["LoadDropdown","Sort"] call ExileClient_MarXet_gui_load;

        ////////////////////////////////////////////////////////////
        // SET-UP PANELS
        ////////////////////////////////////////////////////////////
        ["LoadRight"] call ExileClient_MarXet_gui_load;
        ["LoadLeft"] call ExileClient_MarXet_gui_load;

        ////////////////////////////////////////////////////////////
        // SET-UP EVENT HANDLERS
        ////////////////////////////////////////////////////////////

        _rightDropdown = (_display displayCtrl 21016);
        _rightDropdown ctrlRemoveAllEventHandlers "LBSelChanged";
        _rightDropdown ctrlSetEventHandler ["LBSelChanged", "[""LoadRight""] call ExileClient_MarXet_gui_load;"];

        _rightLB = (_display displayCtrl 21017);
        _rightLB ctrlRemoveAllEventHandlers "LBSelChanged";
        _rightLB ctrlSetEventHandler ["LBSelChanged", "[""LoadCenter"",0,_this select 1] call ExileClient_MarXet_gui_load;"];

        _leftLB = (_display displayCtrl 21018);
        _leftLB ctrlRemoveAllEventHandlers "LBSelChanged";
        _leftLB ctrlSetEventHandler ["LBSelChanged", "[""LoadCenter"",1,_this select 1] call ExileClient_MarXet_gui_load;"];

        _leftDropdown = (_display displayCtrl 21019);
        _leftDropdown ctrlRemoveAllEventHandlers "LBSelChanged";
        _leftDropdown ctrlSetEventHandler ["LBSelChanged", "[""LoadLeft""] call ExileClient_MarXet_gui_load;"];

        _priceEditBox = (_display displayCtrl 21011);
        _priceEditBox ctrlRemoveAllEventHandlers "KeyUp";
        _priceEditBox ctrlSetEventHandler ["KeyUp","if ((count(ctrlText (_this select 0))) > 0) then {ctrlEnable [21024,true];}else{ctrlEnable [21024,false];};"];

        _pinCodeEditBox = (_display displayCtrl 21032);
        _pinCodeEditBox ctrlRemoveAllEventHandlers "KeyUp";
        _pinCodeEditBox ctrlSetEventHandler ["KeyUp","if ((count(ctrlText (_this select 0))) isEqualTo 4) then {ctrlEnable [21014,true];}else{ctrlEnable [21014,false];};"];

        _sortingDropdown = (_display displayCtrl 21033);
        _sortingDropdown ctrlRemoveAllEventHandlers "LBSelChanged";
        _sortingDropdown ctrlSetEventHandler ["LBSelChanged", "[""Sort""] call ExileClient_MarXet_gui_load;"];


        ////////////////////////////////////////////////////////////
        // DISABLE STUFF
        ////////////////////////////////////////////////////////////

        // Purchase button
        _purchaseBtn = _display displayCtrl 21014;
        _purchaseBtn ctrlEnable false;

        // Edit box
        _priceEditBox ctrlEnable false;

        true call ExileClient_gui_postProcessing_toggleDialogBackgroundBlur;

        ctrlSetFocus (_display displayCtrl 21025);
    };
    case ("LoadRight"):
    {
        private ["_display","_dropdown","_dropdownOption","_location","_itemsLB","_clientMoney"];
        disableSerialization;
        _display = uiNamespace getVariable ["RscMarXetDialog",displayNull];

        // Disable the purchase button to avoid dupes
        _purchaseBtn = _display displayCtrl 21014;
        _purchaseBtn ctrlEnable false;

        // Disable the edit box to avoid dupes
        _priceEditBox = (_display displayCtrl 21011);
        _priceEditBox ctrlEnable false;
        _priceEditBox ctrlSetText "";

        // Set the title to nothing
        _title = _display displayCtrl 21009;
        _title ctrlSetText "";

        _dropdown = _display displayCtrl 21016;
        _dropdownOption = lbCurSel _dropdown;
        _location = _dropdown lbValue _dropdownOption;

        _clientMoney = player getVariable ["ExileMoney",0];

        _itemsLB = (_display displayCtrl 21017);
        lbClear _itemsLB;
        switch (_location) do
        {
            // Items / Equipment / Magazines
            case 0:
            {
                private ["_text","_ClassName","_listingID","_price","_configName","_name","_index","_sellerUID","_type"];

                {
                    ctrlShow [_x,false];
                }
                forEach [21020,21021,21022,21023,21031,21032];

                {
                    _text = "";
                    _ClassName = (_x select 2) select 0;
                    _listingID = _x select 0;
                    _price = parseNumber(_x select 3);
                    _sellersUID = _x select 4;
                    // Only display avaiable items
                    if ((_x select 1) isEqualTo 1) then
                    {
                        _configName = _ClassName call ExileClient_util_gear_getConfigNameByClassName;
                        _type = _ClassName call ExileClient_util_cargo_getType;
                        if (!(_configName isEqualTo "CfgVehicles") || (_configName isEqualTo "CfgVehicles" && _type isEqualTo 3)) then
                        {
                            _name = getText(configFile >> _configName >> _ClassName >> "displayName");
                            _index = _itemsLB lbAdd _name;
                            _itemsLB lbSetPicture [_index, getText(configFile >> _configName >> _ClassName >> "picture")];
                            if (_sellersUID isEqualTo (getPlayerUID player) && {getNumber(missionConfigFile >> "CfgMarXet" >> "Settings" >> "disableSellerBuyback") isEqualTo 0}) then
                            {
                                _divisor = getNumber(missionConfigFile >> "CfgMarXet" >> "Settings" >> "sellerBuybackPercentage");
                                _price = if (_divisor > 0 && {_divisor < 1}) then { _price - (_price * _divisor) } else { 0 };
                            };
                            _itemsLB lbSetTextRight [_index, format["%1", round(_price)]];
                	    	_itemsLB lbSetPictureRight [_index, "exile_assets\texture\ui\poptab_trader_ca.paa"];
                            if (_clientMoney < _price) then
                            {
                                _itemsLB lbSetColorRight [_index, [0.8,0,0,1]];
                            };
                            _text = format["%1:%2:%3:%4:%5",_name,str(_price),_listingID,_ClassName,_sellersUID];
                            _itemsLB lbSetData [_index,_text];
                        };
                    };
                } forEach MarXetInventory;
            };
            // Vehicles
            case 1:
            {
                private ["_text","_ClassName","_listingID","_price","_configName","_name","_index","_fuel","_health","_sellerUID","_type"];

                {
                    _text = "";
                    _ClassName = (_x select 2) select 0;
                    _listingID = _x select 0;

                    _vehicleCost = getNumber (missionConfigFile >> "CfgExileArsenal" >> _ClassName >> "price");
                    _rekeyCost = _vehicleCost * (getNumber (missionConfigFile >> "CfgTrading" >> "rekeyPriceFactor"));

                    _price = str(parseNumber(_x select 3) + _rekeyCost);

                    // Only display avaiable items
                    if ((_x select 1) isEqualTo 1) then
                    {
                        _configName = _ClassName call ExileClient_util_gear_getConfigNameByClassName;
                        _type = _ClassName call ExileClient_util_cargo_getType;
                        if (_configName isEqualTo "CfgVehicles" && _type != 3) then
                        {
                            _fuel = (_x select 2) select 1;
                            _health = (_x select 2) select 2;
                            _sellersUID = _x select 4;
                            if (_sellersUID isEqualTo (getPlayerUID player)) then
                            {
                                _price = str(_rekeyCost);
                            };
                            _name = getText(configFile >> "CfgVehicles" >> _ClassName >> "displayName");
                            _index = _itemsLB lbAdd _name;
                            _itemsLB lbSetPicture [_index, getText(configFile >> "CfgVehicles" >> _ClassName >> "picture")];
                            _itemsLB lbSetTextRight [_index, format["%1",_price]];
                            _itemsLB lbSetPictureRight [_index, "exile_assets\texture\ui\poptab_trader_ca.paa"];
                            if (_clientMoney < parseNumber(_price)) then
                            {
                                lbSetColorRight [21017,_index, [0.8,0,0,1]];
                            };
                            _text = format["%1:%2:%3:%4:%5:%6:%7",_name,_price,_listingID,_health,_fuel,_sellersUID,_rekeyCost];
                            _itemsLB lbSetData [_index,_text];
                        };
                    };
                } forEach MarXetInventory;
            };
        };
    };
    case ("Sort"):
    {
        private ["_sortingOption","_sortDropdown","_dropdownOption"];

        _sortDropdown = _display displayCtrl 21033;
        _dropdownOption = lbCurSel _sortDropdown;
        _sortingOption = _sortDropdown lbValue _dropdownOption;

        switch (_sortingOption) do
        {
            // SORT BY CLASSNAME A-Z
            case 0:
            {
                MarXetInventory = [MarXetInventory, [], {(_x select 2) select 0}, "DESCEND"] call BIS_fnc_sortBy;
                MarXet_Sorting = 0;
                ["LoadRight"] call ExileClient_MarXet_gui_load;
            };
            // SORT BY CLASSNAME Z-A
            case 1:
            {
                MarXetInventory = [MarXetInventory, [], {(_x select 2) select 0}, "ASCEND"] call BIS_fnc_sortBy;
                MarXet_Sorting = 1;
                ["LoadRight"] call ExileClient_MarXet_gui_load;
            };
            // Sort by PRICE low-high
            case 2:
            {
                MarXetInventory = [MarXetInventory,{_x select 3},"ASCEND"] call ExileClient_MarXet_util_sortNumberString;
                MarXet_Sorting = 2;
                ["LoadRight"] call ExileClient_MarXet_gui_load;
            };
            // Sort by PRICE high - low
            case 3:
            {
                MarXetInventory = [MarXetInventory,{_x select 3},"DESCEND"] call ExileClient_MarXet_util_sortNumberString;
                MarXet_Sorting = 3;
                ["LoadRight"] call ExileClient_MarXet_gui_load;
            };
        };
    };
    case ("LoadLeft"):
    {
        private ["_display","_playerMoney","_dropdown","_dropdownIndex","_location","_inventoryListBox","_items","_configName","_name","_index","_text","_clientMoney"];
        disableSerialization;
        _display = uiNamespace getVariable ["RscMarXetDialog",displayNull];

        _clientMoney = player getVariable ["ExileMoney",0];

        _playerMoney = _display displayCtrl 21025;
        _playerMoney ctrlSetStructuredText parseText format["<t valign='middle' align='right' size='0.9' shadow='0'>%1</t>",_clientMoney];

        // Disable the purchase button to avoid dupes
        _purchaseBtn = _display displayCtrl 21024;
        _purchaseBtn ctrlEnable false;

        // Disable the edit box to avoid dupes
        _priceEditBox = (_display displayCtrl 21011);
        _priceEditBox ctrlEnable false;
        _priceEditBox ctrlSetText "";

        // Set the title to nothing
        _title = _display displayCtrl 21009;
        _title ctrlSetText "";


        // Update inventory dropdown
        _dropdown = _display displayCtrl 21019;
        _dropdownIndex = lbCurSel _dropdown;
        _location = _dropdown lbValue _dropdownIndex;

        _inventoryListBox = _display displayCtrl 21018;
        lbClear _inventoryListBox;
        _items = [];
        MarXet_VehicleObjectArray = [];
        switch (_location) do
        {
        	case 0:
        	{
        		_items = [player, true] call ExileClient_util_playerEquipment_list;
        	};
        	case 1:
        	{
        		_items = (uniformContainer player) call ExileClient_util_containerCargo_list;
        	};

        	case 2:
        	{
        		_items = (vestContainer player) call ExileClient_util_containerCargo_list;
        	};

        	case 3:
        	{
        		_items = (backpackContainer player) call ExileClient_util_containerCargo_list;
        	};

        	default
        	{
                if (getNumber(missionConfigFile >> "CfgMarXet" >> "Settings" >> "disableVehicleListing") isEqualTo 0) then 
                {
                    private ["_nearVehicles","_name","_index","_text"];
                    _nearVehicles = nearestObjects [player, ["LandVehicle", "Air", "Ship"], 50];
                    {
                        if (((locked _x) != 2) && (locked _x) != 1) then
                        {
                            if (local _x) then
                            {
                                if (alive _x) then
                                {
                                    _name = getText(configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName");
                                    _index = _inventoryListBox lbAdd _name;
                                    _inventoryListBox lbSetPicture [_index, getText(configFile >> "CfgVehicles" >> (typeOf _x) >> "picture")];
                                    _text = format["%1:%2",(typeOf _x),_name];
                                    _inventoryListBox lbSetData [_index,_text];
                                    MarXet_VehicleObjectArray pushBack _x;
                                };
                            };
                        };
                    } forEach _nearVehicles;
                };
        	};
        };

        {
            _className = _x;
            _configName = _x call ExileClient_util_gear_getConfigNameByClassName;
            _name = getText(configFile >> _configName >> _x >> "displayName");
            _index = _inventoryListBox lbAdd _name;
            _inventoryListBox lbSetPicture [_index, getText(configFile >> _configName >> _x >> "picture")];
            _canList = true;
            if (_location isEqualTo 0) then
            {
                {
                    if (_className isEqualTo (_x select 0)) then
                    {
                        _items = (_x select 1) call ExileClient_util_containerCargo_list;

                        if !((count _items) isEqualTo 0) then
                        {
                            _canList = false;
                        };
                    };
                }
                forEach
                [
                    [uniform player, uniformContainer player],
                    [vest player, vestContainer player],
                    [backpack player, backpackContainer player]
                ];
            };
            if (_canList) then
            {
                _text = format["%1:%2",_x, _name];
                _inventoryListBox lbSetData [_index,_text];
            }
            else
            {
                _inventoryListBox lbSetData [_index,""];
            };
        } forEach _items;

        lbSetCurSel [_inventoryListBox,0];
    };
    case ("LoadCenter"):
    {
        private ["_display","_clientMoney"];
        disableSerialization;
        _display = uiNamespace getVariable ["RscMarXetDialog",displayNull];

        _clientMoney = player getVariable ["ExileMoney", 0];

        _purchaseBtn = _display displayCtrl 21014;
        _purchaseBtn ctrlSetText "Purchase";

        switch (_this select 1) do
        {
            // Right LB click
            case 0:
            {
                private ["_rightLB","_priceEditBox","_dropdown","_dropdownOption","_location","_dataString","_dataArray","_purchaseBtn","_location","_health","_fuel","_healthText","_fuelText","_price"];
                MarXet_SelectedListingID = "";
                MarXet_Poptab = 0;
                MarXet_BuyerIsSeller = false;
                _sellerUID = "";
                _rightLB = (_display displayCtrl 21017);

                _priceEditBox = _display displayCtrl 21011;
                ctrlEnable [21011,false];
                _priceEditBox ctrlSetText "";

                _dropdown = _display displayCtrl 21016;
                _dropdownOption = lbCurSel _dropdown;
                _location = _dropdown lbValue _dropdownOption;

                ctrlEnable [21024,false];

                {
                    ctrlShow [_x,false];
                }
                forEach [21020,21021,21022,21023,21024,21031,21032];

                _dataString = lbData [21017,_this select 2];
                if !(_dataString isEqualTo "") then
                {
                    _dataArray = _dataString splitString ":";

                    _purchaseBtn = _display displayCtrl 21014;
                    _purchaseBtn ctrlShow true;

                    // Display the Vehicle info
                    if (_location isEqualto 1) then
                    {
                        _health = parseNumber(_dataArray select 3);
                        _fuel = parseNumber(_dataArray select 4);

                        _health = round((1 - _health) * 100);

                        // Because fucking arma decided to switch it up now...
                        _fuel = round(_fuel * 100);

                        _healthText = format["%1%2",_health,"%"];
                        _fuelText = format["%1%2",_fuel,"%"];
                        ctrlSetText [21021,_healthText];
                        ctrlSetText [21023,_fuelText];
                        {
                            ctrlShow [_x,true];
                        }
                        forEach [21020,21021,21022,21023,21031,21032];
                        ctrlSetText [21032,""];
                        _sellerUID = _dataArray select 5;
                        MarXet_Poptab = _dataArray select 6;
                    }
                    else
                    {
                        _sellerUID = _dataArray select 4;
                    };

                    if ( _sellerUID isEqualTo (getPlayerUID player)) then
                    {
                        MarXet_BuyerIsSeller = true;
                    };

                    ctrlSetText [21009,_dataArray select 0];
                    ctrlSetText [21011,_dataArray select 1];

                    _price = parseNumber(_dataArray select 1);

                    if (_clientMoney < _price) then
                    {
                        // Disable the purchase Button
                        ctrlEnable [21014,false];
                        // if it's a vehicle and the player doesn't have enough for the rekey cost,
                        _pinEditBox = _display displayCtrl 21032;
                        _pinEditBox ctrlEnable false;
                    }
                    else
                    {
                        if !(_location isEqualTo 1) then
                        {
                            _leftdropdown = _display displayCtrl 21019;
                            _leftdropdownOption = lbCurSel _leftdropdown;
                            _leftlocation = _leftdropdown lbValue _leftdropdownOption;
                            _itemClassName = _dataArray select 3;
                            try
                            {
                                switch (_leftlocation) do
                                {
                                    case 0: {
                                        if !([player,_itemClassName] call ExileClient_util_playerCargo_canAdd) then
                                        {
                                            throw 0;
                                        };
                                    };
                                    case 1:
                                    {
                                        if !(player canAddItemToUniform _itemClassName) then
                        				{
                        					throw 0;
                        				};
                                    };
                                    case 2:
                                    {
                                        if !(player canAddItemToVest _itemClassName) then
                        				{
                        					throw 0;
                        				};
                                    };
                                    case 3:
                                    {
                                        if !(player canAddItemToBackpack _itemClassName) then
                        				{
                        					throw 0;
                        				};
                                    };
                                    case 4:
                                    {
                                        // This is a vehicle
                                        throw 1;
                                    };
                                };
                                _purchaseBtn ctrlSetText "Purchase";
                                ctrlEnable [21014,true];
                                MarXet_SelectedListingID = _dataArray select 2;
                            }
                            catch
                            {
                                if (_exception isEqualTo 1) then
                                {
                                    ctrlEnable [21014,false];
                                }
                                else
                                {
                                    _purchaseBtn ctrlSetText "NO SPACE";
                                    ctrlEnable [21014,false];
                                };
                            };
                        }
                        else
                        {
                            ctrlEnable [21014,false];
                            MarXet_SelectedListingID = [_dataArray select 2];
                        };
                    };
                };
            };

            // Left LB click
            case 1:
            {

                private ["_leftLB","_priceEditBox","_dataString","_dataArray","_dropdown","_dropdownOption","_location","_purchaseBtn","_health","_fuel","_healthText","_fuelText"];
                MarXet_TempListingClassname = "";
                _leftLB = (_display displayCtrl 21018);
                {
                    ctrlShow [_x,false];
                }
                forEach [21020,21021,21022,21023,21012,21013,21014];

                _priceEditBox = _display displayCtrl 21011;
                ctrlEnable [21011,false];
                _priceEditBox ctrlSetText "";

                _dataString = _leftLB lbData (_this select 2);
                if !(_dataString isEqualTo "") then
                {
                    _dataArray = _dataString splitString ":";

                    _dropdown = _display displayCtrl 21019;
                    _dropdownOption = lbCurSel _dropdown;
                    _location = _dropdown lbValue _dropdownOption;

                    ctrlSetText [21009,_dataArray select 1];
                    ctrlEnable [21024,false];
                    ctrlEnable [21014,false];
                    ctrlEnable [21011,true];
                    _purchaseBtn = _display displayCtrl 21024;
                    _purchaseBtn ctrlShow true;

                    if (_location isEqualTo 4) then
                    {
                        MarXet_TempListingClassname = [_dataArray select 0,(netID (MarXet_VehicleObjectArray select (_this select 2)))];
                        _health = (1 - (damage (MarXet_VehicleObjectArray select (_this select 2)))) * 100;
                        _fuel = (fuel (MarXet_VehicleObjectArray select (_this select 2))) * 100;
                        _healthText = format["%1%2",round(_health),"%"];
                        _fuelText = format["%1%2",round(_fuel),"%"];
                        ctrlSetText [21021,_healthText];
                        ctrlSetText [21023,_fuelText];
                        {
                            ctrlShow [_x,true];
                        } forEach [21021,21023,21020,21022];
                    }
                    else
                    {
                        MarXet_TempListingClassname = [_dataArray select 0];
                    };
                }
                else
                {
                    _priceEditBox ctrlSetText "NOT EMPTY";
                };
            };
        };

    };
    case ("LoadDropdown"):
    {
        private ["_display"];
        disableSerialization;
        _display = uiNamespace getVariable ["RscMarXetDialog",displayNull];

        switch (_this select 1) do
        {
            case ("Left"):
            {
                private ["_leftDropdown","_index","_nearVehicles","_addVeh"];
                _leftDropdown = (_display displayCtrl 21019);
                lbClear _leftDropdown;

                _index = _leftDropdown lbAdd "Equipment";
                _leftDropdown lbSetValue [_index, 0];

                if !((uniform player) isEqualTo "") then
                {
                	_index = _leftDropdown lbAdd "Uniform";
                	_leftDropdown lbSetValue [_index, 1];
                };

                if !((vest player) isEqualTo "") then
                {
                	_index = _leftDropdown lbAdd "Vest";
                	_leftDropdown lbSetValue [_index, 2];
                };

                if !((backpack player) isEqualTo "") then
                {
                	_index = _leftDropdown lbAdd "Backpack";
                	_leftDropdown lbSetValue [_index, 3];
                };
                _nearVehicles = nearestObjects [player, ["LandVehicle", "Air", "Ship"], 50];
                if !(_nearVehicles isEqualTo []) then
                {
                    _addVeh = false;
                    {
                        if (((locked _x) != 2) && (locked _x) != 1) then
                        {
                            if (local _x) then
                            {
                                if (alive _x) then
                                {
                                    _addVeh = true;
                                };
                            };
                        };
                    } forEach _nearVehicles;

                    if (_addVeh) then
                    {
                        _index = _leftDropdown lbAdd "Nearby Vehicles";
                        _leftDropdown lbSetValue [_index, 4];
                    };
                };
                _leftDropdown lbSetCurSel -1;

            };
            case ("Right"):
            {
                private ["_rightDropdown","_index"];
                _rightDropdown = (_display displayCtrl 21016);
                lbClear _rightDropdown;
                _index = _rightDropdown lbAdd "Equipment Listings";
                _rightDropdown lbSetValue [_index,0];

                if (getNumber(missionConfigFile >> "CfgMarXet" >> "Settings" >> "disableVehicleListing") isEqualTo 0) then 
                {
                    _index = _rightDropdown lbAdd "Vehicle Listings";
                    _rightDropdown lbSetValue [_index,1];
                };
                
                _rightDropdown lbSetCurSel 0;
            };
            case ("Sort"):
            {
                private ["_sortingDropdown","_index"];
                _sortingDropdown = (_display displayCtrl 21033);
                lbClear _sortingDropdown;
                _index = _sortingDropdown lbAdd "Classname (A-Z)";
                _sortingDropdown lbSetValue [_index,0];

                _index = _sortingDropdown lbAdd "Classname (Z-A)";
                _sortingDropdown lbSetValue [_index,1];

                _index = _sortingDropdown lbAdd "Price (Low-High)";
                _sortingDropdown lbSetValue [_index,2];

                _index = _sortingDropdown lbAdd "Price (High-Low)";
                _sortingDropdown lbSetValue [_index,3];

                _sortingDropdown lbSetCurSel MarXet_Sorting;
            };
        };
    };
    case ("buttonPressed"):
    {
        private ["_display"];
        disableSerialization;
        _display = uiNamespace getVariable ["RscMarXetDialog",displayNull];
        switch (_this select 1) do
        {
            // Purchase
            case 0:
            {
                private ["_dropdown","_dropdownIndex","_location","_rightDropdown","_rightDropdownOption","_rightLocation","_newPinCode"];
                (_display displayCtrl 21014) ctrlEnable false;
                if !(MarXet_SelectedListingID isEqualTo "" || MarXet_SelectedListingID isEqualTo []) then
                {
                    _dropdown = _display displayCtrl 21019;
                    _dropdownIndex = lbCurSel _dropdown;
                    _location = _dropdown lbValue _dropdownIndex;

                    if (typeName(MarXet_SelectedListingID) isEqualTo "ARRAY") then
                    {
                        if (MarXet_BuyerIsSeller && !(MarXet_Confirmed)) then
                        {
                            _newPinCode = ctrlText 21032;
                        	_forbiddenCharacter = [_newPinCode, "1234567890"] call ExileClient_util_string_containsForbiddenCharacter;

                        	if !(_forbiddenCharacter isEqualTo -1) exitWith
                        	{
                        		["Whoops",["Forbidden Character in Pin Code!"]] call ExileClient_gui_notification_event_addNotification;
                        	};
                            ["DisplayNotification",0,"Rekeying Required",0,"Purchase","Cancel"] call ExileClient_MarXet_gui_load;
                            MarXet_WhichSideAreYouOn = 0;
                        }
                        else
                        {
                            _newPinCode = ctrlText 21032;
                            ["buyNowRequest",[(MarXet_SelectedListingID select 0),_newPinCode]] call ExileClient_system_network_send;
                            MarXet_SelectedListingID = nil;
                            MarXet_Confirmed = false;
                        };
                    }
                    else
                    {
                        ["buyNowRequest",[MarXet_SelectedListingID,str(_location)]] call ExileClient_system_network_send;
                        MarXet_SelectedListingID = nil;
                    };
                };
                ["LoadRight"] call ExileClient_MarXet_gui_load;
                ["LoadLeft"] call ExileClient_MarXet_gui_load;

            };
            // List
            case 1:
            {
                private ["_dropdown","_dropdownIndex","_location","_vehicle"];
                MarXet_ListingArray = [];
                (_display displayCtrl 21024) ctrlEnable false;
                (_display displayCtrl 21011) ctrlEnable false;

                _dropdown = _display displayCtrl 21019;
                _dropdownIndex = lbCurSel _dropdown;
                _location = _dropdown lbValue _dropdownIndex;

                if !(parseNumber(ctrlText 21011) isEqualTo 0) then
                {
                    _vehicle = false;
                    if (count(MarXet_TempListingClassname) isEqualTo 1) then
                    {
                        // Items
                        MarXet_ListingArray = [MarXet_TempListingClassname select 0,str(round(abs(parseNumber(ctrlText 21011)))),_location];
                    }
                    else
                    {
                        // vehicles
                        MarXet_ListingArray = [MarXet_TempListingClassname select 0,str(round(abs(parseNumber(ctrlText 21011)))),_location,MarXet_TempListingClassname select 1];
                        _vehicle = true;
                    };
                    if (!(MarXet_Confirmed) && _vehicle) then
                    {
                        ["DisplayNotification",0,"Please Confirm",1,"List it!","Nevermind"] call ExileClient_MarXet_gui_load;
                        MarXet_WhichSideAreYouOn = 1;
                    }
                    else
                    {
                        ["createNewListingRequest",[MarXet_ListingArray]] call ExileClient_system_network_send;
                        MarXet_ListingArray = nil;
                        MarXet_Confirmed = false;
                    };
                }
                else
                {
                    ["Whoops",["Please set a list price"]] call ExileClient_gui_notification_event_addNotification;
                    MarXet_ListingArray = nil;
                };
            };
        };
    };
    case ("DisplayNotification"):
    {
        private ["_display"];
        disableSerialization;
        _display = uiNamespace getVariable ["RscMarXetDialog",displayNull];

        switch (_this select 1) do
        {
            case 0:
            {
                private ["_title","_textOption","_confirmBtnText","_cancelBtnText","_titleCtrl","_textCtrl","_price","_confirmBtnCtrl","_cancelBtnCtrl"];
                {
                    ctrlEnable [_x,false];
                }
                forEach[21011,21014,21024,21015,21016,21017,21018,21019,21025,21007,21008,21032,21033];

                _title = _this select 2;
                _textOption = _this select 3;
                _confirmBtnText = _this select 4;
                _cancelBtnText = _this select 5;

                {
                    ctrlShow [_x,true];
                    if !(_x isEqualTo 21029) then
                    {
                        ctrlEnable [_x,true];
                    };
                }
                forEach[21029,21026,21027,21028,21030];

                _titleCtrl = _display displayCtrl 21030;
                _textCtrl = _display displayCtrl 21026;

                switch (_textOption) do
                {
                    case 0:
                    {
                        _textCtrl ctrlSetStructuredText parseText format["<t size='1'>Looks like you are the person who listed this vehicle!<br/>Unfortunately, the vehicle has to be rekeyed.<br/>There is a <t color='#e32636'>%1</t> poptab rekeying fee on this vehicle.<br/>Are you sure you want to continue?</t>",MarXet_Poptab];
                    };
                    case 1:
                    {
                        _price = ctrlText 21011;
                        _textCtrl ctrlSetStructuredText parseText format["<t size='1'>You are about to list your vehicle for <t color='#e32636'>%1</t> poptabs<br/>Are you sure?</t>",_price];
                    };
                };
                _titleCtrl ctrlSetStructuredText parseText format["<t size='2'>%1</t>",_title];

                _confirmBtnCtrl = _display displayCtrl 21027;
                _confirmBtnCtrl ctrlSetText _confirmBtnText;

                _cancelBtnCtrl = _display displayCtrl 21028;
                _cancelBtnCtrl ctrlSetText _cancelBtnText;
            };
            case 1:
            {
                {
                    ctrlEnable [_x,true];
                }
                forEach[21014,21024,21015,21016,21017,21018,21019,21025,21007,21008,21032,21033];

                {
                    ctrlShow [_x,false];
                    if !(_x isEqualTo 21029) then
                    {
                        ctrlEnable [_x,false];
                    };
                }
                forEach[21029,21026,21027,21028,21030];

                MarXet_Confirmed = true;
                ["buttonPressed",MarXet_WhichSideAreYouOn] call ExileClient_MarXet_gui_load;
            };
            case 2:
            {
                {
                    ctrlEnable [_x,true];
                }
                forEach[21014,21024,21015,21016,21017,21018,21019,21025,21007,21008,21032,21033];

                {
                    ctrlShow [_x,false];
                    if !(_x isEqualTo 21029) then
                    {
                        ctrlEnable [_x,false];
                    };
                }
                forEach[21029,21026,21027,21028,21030];

                if (MarXet_WhichSideAreYouOn isEqualTo 0) then
                {
                    ctrlEnable [21014,false];
                    ctrlSetText [21032,""];
                }
                else
                {
                    ctrlEnable [21024,true];
                    ctrlEnable [21011,true];
                };
            };
        };
    };
    case ("UnLoad"):
    {
        disableSerialization;

        ////////////////////////////////////////////////////////////
        // DESTROY VARIABLES
        ////////////////////////////////////////////////////////////

        MarXet_VehicleObjectArray = nil;
        MarXet_SelectedListingID = nil;
        MarXet_ListingArray = nil;
        MarXet_TempListingClassname = nil;
        MarXet_BuyerIsSeller = nil;
        MarXet_Confirmed = nil;
        MarXet_Poptab = nil;
        MarXet_WhichSideAreYouOn = nil;
        MarXet_Sorting = nil;

        MarXetInventory = [MarXetInventory, [], {(_x select 2) select 0}, "ASCEND"] call BIS_fnc_sortBy;
        false call ExileClient_gui_postProcessing_toggleDialogBackgroundBlur;

        closeDialog 21000;
    };
};
