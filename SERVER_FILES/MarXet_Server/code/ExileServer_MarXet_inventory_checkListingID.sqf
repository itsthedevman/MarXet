/**
 *
 * Author: WolfkillArcadia
 * www.arcasindustries.com
 * © 2017 Arcas Industries
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */

_listingID = _this;
_isAvailable = true;

{
    if ((_x find _listingID) != -1) then {
        _isAvailable = false;
    };
} forEach MarXetInventory;

_isAvailable
