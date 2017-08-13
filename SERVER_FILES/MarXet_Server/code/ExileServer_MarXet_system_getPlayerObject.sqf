_playerUID = _this;
_playerObject = "";

{
    if ((getPlayerUID _x) isEqualTo _playerUID) then
    {
        _playerObject = _x;
    };
} forEach allPlayers;

_playerObject
