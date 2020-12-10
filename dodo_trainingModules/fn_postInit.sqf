/*
Author : callmedodo
LastUpdate : 28.10.2020
Changelog:
28.10.2020:
	-added Module Trainingsinterruption
	-added Module Spectatorcamera
	-added Module Draw3DSymbol
	-added Module Delete3DSymbol

31.10.2020:
	-tweaked jip for symbols
22.11.2020:
	-renamed unterbruch to unterbrechung
*/ 

//Module:Trainingsinterruption
//Usage: Place as Zeus, Select Options
[
    "TacticalTrainingTeam",
    "Trainingsunterbrechung umschalten",
    {
		params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];

		if (isNull _objectUnderCursor) exitWith {

				["No object was selected!"] call Achilles_fnc_showZeusErrorMessage;
			};
		private _selectedObject = _objectUnderCursor;
		
		private _allGroupsWithPlayers = [];
		{_allGroupsWithPlayers pushBackUnique groupId group _x} forEach allPlayers;

		private _dialogResult =
		[
			"Trainingsunterbrechung",
			[
				["Training", ["unterbrechung","fortsetzen"]],
				["Für Alle Unterbrechen",["Ja","Nein"]],
				["Wirkungsbereich","","200"]
			]
		] call Ares_fnc_showChooseDialog;

		//if dialog is exited without results
		if (_dialogResult isEqualTo []) exitWith{};

		private ["_interrupt","_forAll","_radius","_groupName"];

		//read selected values
		if(_dialogResult select 0 == 0) then {
			_interrupt = true;
		} else {
			_interrupt = false;
		};
		
		//interrupt for everyone or just specific groups
		if(_dialogResult select 1 == 0) then {
			_forAll = true;
		} else {
			_forAll = false;
		};

		//check if radius is a number
		_radius =  _dialogResult select 2 call BIS_fnc_parseNumber;
		if(_radius <= 0 ) then {
			_radius = 200;
		};

		_groupId = group _selectedObject;

		//execute pause Training script
    	[_interrupt,_forAll,_groupId,_radius,_position] remoteExecCall ["dodo_fnc_pauseTraining"];
	}
] call Ares_fnc_RegisterCustomModule;

//Module: Open Ace Spectatorcamera
//Usage: Place on Player, Select if either single unit/group/all players open Camera
[
	"TacticalTrainingTeam",
	"Zuschauerkamera öffnen",
	{
		params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];

		if (isNull _objectUnderCursor) exitWith {

				["No object was selected!"] call Achilles_fnc_showZeusErrorMessage;
			};
		private _selectedObject = _objectUnderCursor;
		
		private _dialogResult =
		[
			"Zuschauerkamera Oeffnen",
			[
				["Zuschauerkamera Oeffnen", ["Spieler","Gruppe","Alle Spieler"]]
			]
		] call Ares_fnc_showChooseDialog;

		// If the dialog was closed.
		if (_dialogResult isEqualTo []) exitWith{};

		// Get the selected data
		_dialogResult params ["_comboBoxResult"];

		//open spectator cam for selected players
		switch(_comboBoxResult) do {
			case 0: {
					[true,false,false] remoteExecCall ["dodo_fnc_openSpectator",_selectedObject];
					//[true,false,false] remoteExecCall ["ace_spectator_fnc_setSpectator",_selectedObject];

				};
			case 1: {
					[true,false,false] remoteExecCall ["dodo_fnc_openSpectator",group _selectedObject];
					//[true,false,false] remoteExecCall ["ace_spectator_fnc_setSpectator",group _selectedObject];

				};
			case 2: {
					[true,false,false] remoteExecCall ["dodo_fnc_openSpectator"];
					//[true,false,false] remoteExecCall ["ace_spectator_fnc_setSpectator"];

				};
		}

	}
] call Ares_fnc_RegisterCustomModule;


//Module: Draw 3d Symbol
//Usage: Place as Zeus, Select Text and Marker Type
[
	"TacticalTrainingTeam",
	"3D Symbol zeichnen",
	{
		params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];
		

		//falls globale Variable nicht existiert wird diese gesetzt
		if (isNil "DODO_drawedIcon") then
 		{
  			DODO_drawedIcon =[];
			publicVariable "DODO_drawedIcon";
 		};

		//das array der configs wird einmal gelesen und dann abgespeichert
		
		_milIconConfigs = missionNamespace getVariable "MilIconConfigs";
		_iconNames = missionNamespace getVariable "IconNames";
		_milIcons = missionNamespace getVariable "MilIcons";
		_natoIcons = missionNamespace getVariable "NatoIcons";
		if(isNil "_milIconConfigs") then {

			_milIcons = [];
			_natoIcons = [];
			_milIcons append ("getText (_x >> 'markerClass') == 'Military'" configClasses (configFile >> "CfgMarkers"));
			_natoIcons append ("getText (_x >> 'markerClass') == 'NATO_BLUFOR'" configClasses (configFile >> "CfgMarkers"));
			_natoIcons append ("getText (_x >> 'markerClass') == 'NATO_OPFOR'" configClasses (configFile >> "CfgMarkers"));
			_natoIcons append ("getText (_x >> 'markerClass') == 'NATO_Independent'" configClasses (configFile >> "CfgMarkers"));

			_milIconConfigs = _milIcons + _natoIcons;
			missionNamespace setVariable ["MilIconConfigs",_milIconConfigs];//Same as: YourString = 3;
			_iconNames = [];
			_iconAllNames = [];
			_iconAllPaths = [];
			//markerClass
			{
				_markerClass = getText (_x >> "markerClass");
				_iconShort = "";
				if (_markerClass == "Military") then {
					_iconShort = "Standard";
				} else {
					_iconShort = [_markerClass,5] call BIS_fnc_trimString;
				};
				_iconName = _iconShort+" " +getText (_x >> "name") ;
				_iconAllNames pushBackUnique _iconName;
				_iconAllPaths pushBackUnique getText (_x >> "icon");

				//_iconNames pushBackUnique [getText (_x >> "name"),getText (_x >> icon)];
				 
			} forEach _milIconConfigs;
			
			_iconNames append [_iconAllNames,_iconAllPaths];
			

			missionNamespace setVariable ["IconNames",_iconNames];
		};

		//die Namen der Icon's werden ausgelsen um diese im Gui zu wiedergeben
		
		//Abfrage auf Inhalt des Markers
		private _dialogResult =
		[
			"Markierung auswählen",
			[
				["Name des Wegpunkts","" ],
				["Typ des Icons",_iconNames select 0]
			]
		] call Ares_fnc_showChooseDialog;
		
		if (_dialogResult isEqualTo []) exitWith{};

		//_dialogResult params ["_nameOfMarker","iconName"];
		_iconId = _dialogResult select 1;
	
		
		_path = _iconNames select 1 select _iconId;
		_iconColor = [0,0,0,1];
		_sideName = [_iconNames select 0 select _iconId,0,0] call BIS_fnc_trimString;
		
		switch (_sideName) do {
			case "S": {
				_iconColor = [0,0,0,1];
				};
			case "B": {
				//blufor
				_iconColor = [0,0.3,0.6,1];
				};
			case "O": { 
				//opfor
				_iconColor = [0.5,0,0,1];
			};
			case "I": {
				//independent
			 	_iconColor =[0,0.5,0,1];
				};
			
		};

		//add icon to global variable
		DODO_drawedIcon pushBack [_position,_dialogResult select 0, _path, _iconColor]; //Position, Name, Pfad, Farbe
		publicVariable "DODO_drawedIcon";
		
				
		//execute drawIcon
		remoteExecCall ["dodo_fnc_drawIcon"];
 		
		
	}
] call Ares_fnc_RegisterCustomModule;

//Module: Delete 3D Symbol
//Usage: Place as Zeus, Select Text off Marker to Delete
[
	"TacticalTrainingTeam",
	"3D Symbole löschen",
	{
		params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];
		_dialogNames = ["Alle löschen"];
		
		
		if (isNil "DODO_drawedIcon") exitWith {		 
		};

		{
			// Current result is saved in variable _x
			_dialogNames pushBack (_x select 1);
		} forEach DODO_drawedIcon;

		private _dialogResult =
		[
			"Markierung auswählen",
			[
				
				["Combo Box Control",_dialogNames]
			]
		] call Ares_fnc_showChooseDialog;

		if (_dialogResult isEqualTo []) exitWith{};

		if (_dialogResult select 0 != 0) then {
			_itemsToRemove = DODO_drawedIcon select {_dialogNames select (_dialogResult select 0)  == _x select 1};

			DODO_drawedIcon = DODO_drawedIcon - _itemsToRemove;
		} else {
			DODO_drawedIcon = [];
		};
		
		publicVariable "DODO_drawedIcon";
	}
] call Ares_fnc_RegisterCustomModule;

true