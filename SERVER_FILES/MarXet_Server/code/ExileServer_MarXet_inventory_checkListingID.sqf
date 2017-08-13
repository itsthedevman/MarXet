/*

 	Name: ExileServer_MarXet_inventory_checkListingID

 	Author(s): Mezo, Shix, and WolfkillArcadia
    Copyright (c) 2016 Evolved Survival Gaming

    This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
    To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

 	Description:
    Simple script to confirm that the listing ID doesn't already exist

*/

_listingID = _this;
_isAvailable = true;

{
    if ((_x find _listingID) != -1) then {
        _isAvailable = false;
    };
} forEach MarXetInventory;

_isAvailable
