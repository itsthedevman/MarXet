/**
 *
 * Author: WolfkillArcadia
 * www.arcasindustries.com
 * © 2017 Arcas Industries
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
_stockArray = _this select 0;
_location = parseNumber(_this select 1);
_vehicleNetID = _this select 2;
_price = parseNumber(_this select 3);
_itemClassName = (_stockArray select 2) select 0;
_sellersUID = _stockArray select 4;

if !(_vehicleNetID isEqualTo "") then
{
    _vehicleObject = objectFromNetId _vehicleNetID;
    player moveInDriver _vehicleObject;
    closeDialog 21000;
    //["Success", [format["%1 POPTABS, VEHICLE PINCODE: %2",(parseNumber(_stockArray select 3) * -1),(_stockArray select 2) select 4]]] call ExileClient_gui_notification_event_addNotification;
    _name = getText(configFile >> "CfgVehicles" >> ((_stockArray select 2) select 0) >> "displayName");
    if (_sellersUID isEqualTo (getplayerUID player)) then
    {
        ["SuccessTitleAndText", [

            "Vehicle Bought!",
            format ["Congratulations on your purchase of your old <t color='#ff0000'>%1</t>. Couldn't let go of it huh?<br/>Thank you for choosing Mar<t color='#531517'>X</t>et: Exile's leading marketplace!", _name]

        ]] call ExileClient_gui_toaster_addTemplateToast;

    }
    else
    {
        ["SuccessTitleAndText", [

            "Vehicle Bought!",
            format ["Congratulations on your purchase of your new <t color='#ff0000'>%1</t><br/>Your total cost was <t color='#ff0000'>%2</t><img image='\exile_assets\texture\ui\poptab_inline_ca.paa' size='24'/>.<br/>Thank you for choosing Mar<t color='#531517'>X</t>et: Exile's leading marketplace!", _name, _price]

        ]] call ExileClient_gui_toaster_addTemplateToast;
    };
}
else
{
    // Thx to Exile for the logic
    switch (_location) do
	{
		case 0:
		{
			// When you buy a uniform/vest/backpack in to your equipment, show the newest drop down options
			_containersBefore = [uniform player, vest player, backpack player];

			[player, _itemClassName] call ExileClient_util_playerCargo_add;

			_containersAfter = [uniform player, vest player, backpack player];

			if !(_containersAfter isEqualTo _containersBefore) then
			{
				["LoadDropdown","Left"] call ExileClient_MarXet_gui_load;
			};
		};

		case 1:
		{
			[(uniformContainer player), _itemClassName] call ExileClient_util_containerCargo_add;
		};

		case 2:
		{
			[(vestContainer player), _itemClassName] call ExileClient_util_containerCargo_add;
		};

		case 3:
		{
			[(backpackContainer player), _itemClassName] call ExileClient_util_containerCargo_add;
		};
	};

    if (_sellersUID isEqualTo (getplayerUID player) && {getNumber(missionConfigFile >> "CfgMarXet" >> "Settings" >> "disableSellerBuyback") isEqualTo 0}) then
    {
        ["SuccessTitleAndText", ["Bought Back", "Couldn't let go of it, huh? I understand :)"]] call ExileClient_gui_toaster_addTemplateToast;
    }
    else
    {
        // Show notification
        ["SuccessTitleAndText", ["Successful Purchase", format["%1",_price]]] call ExileClient_gui_toaster_addTemplateToast;
    };

    // Update the trader dialog
    _dialog = uiNameSpace getVariable ["RscMarXetDialog", displayNull];

    // Only update it when its still opened
    if !(_dialog isEqualTo displayNull) then
    {
        ["Sort",MarXet_Sorting] call ExileClient_MarXet_gui_load;
        ["LoadLeft"] call ExileClient_MarXet_gui_load;
        ["LoadRight"] call ExileClient_MarXet_gui_load;
        //ctrlEnable [21024,true];
        //ctrlEnable [21011,true];
    };

};
