/**
 *
 * Author: WolfkillArcadia
 * www.arcasindustries.com
 * © 2017 Arcas Industries
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */

_numbers = "1234567890";
_alpha = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
_listingID = "";
_generatingListingID = true;
while {_generatingListingID} do
{
	_listingID = "";
	for "_i" from 1 to 2 do
	{
		_listingID = _listingID + (_alpha select [floor (random 51), 1]);
	};
    for "_i" from 1 to 6 do
	{
		_listingID = _listingID + (_numbers select [floor (random 9), 1]);
	};
	if (_listingID call ExileServer_MarXet_inventory_checkListingID) then
	{
		_generatingListingID = false;
	};
};
_listingID
