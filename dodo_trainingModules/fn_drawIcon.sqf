/*
Author : callmedodo
Changelog
28.10.2020:
	-added eventhandler
31.10.2020:
	-tweaked jip for symbols
*/ 

private _handlerHasBeenAdded = localNamespace getVariable "dodo_handlerHasBeenAdded";
//first check if Handler already exists
if (isNil "_handlerHasBeenAdded") then
 	{
  			
		localNamespace setVariable ["dodo_handlerHasBeenAdded",true];

		//add Handler and draw each icon
		addMissionEventHandler ["Draw3D", {
			{
				//Position, Name, Pfad, Farbe
				private ["_position","_text","_iconPath","_iconColor"];

				_position = _x select 0;
				_text = _x select 1;
				_iconPath = _x select 2;
				_iconColor = _x select 3;
		
				drawIcon3D 
				[
					_iconPath,
					_iconColor,
					_position,
					1,
					1,
					0,
					_text
				];
		

			} forEach DODO_drawedIcon;
		}];
	};