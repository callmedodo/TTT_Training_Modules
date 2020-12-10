/*
Author : callmedodo
Changelog
28.10.2020:
	-added functionality

TODO: ADD some sort of countdown for players to be prepared to open spectator Camera
*/ 

params["_interruption","_forAll","_groupId","_radius","_centerPos"];

//get all AI-units in radius
_unitsInArea = allUnits-playableUnits inAreaArray [_centerPos, _radius, _radius];
if (_interruption) then {

	//disable AI
	{
		_x enableSimulation false;
	} forEach _unitsInArea;

	//force players in spectator cam
	if (_forAll) then {
		[true,false,false] remoteExecCall ["dodo_fnc_openSpectator"];
		//[true,false,false] remoteExecCall ["ace_spectator_fnc_setSpectator"];
	} else {
		[true,false,false] remoteExecCall ["dodo_fnc_openSpectator",_groupId];
		//[true,false,false] remoteExecCall ["ace_spectator_fnc_setSpectator",_selectedGroup];
	};

} else {

	//enalbeAI, interruption is over
	{
		_x enableSimulation true;
	} forEach _unitsInArea;

};

