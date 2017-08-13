/**
 *
 * Author: WolfkillArcadia
 * www.arcasindustries.com
 * © 2017 Arcas Industries
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */

_playerUID = _this;
_playerObject = "";

{
    if ((getPlayerUID _x) isEqualTo _playerUID) then
    {
        _playerObject = _x;
    };
} forEach allPlayers;

_playerObject
