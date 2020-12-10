/*
Author : callmedodo
Changelog
31.10.2020:
	-added basic functionality
*/
["Die Zuschauerkamera wird geöffnet. Versuche Störgeräusche zu vermeiden, alle Spieler werden dich hören können. Um aus der Zuschauerkamera rauszukommen drücke die ESC-Taste","Zuschauerkamera wird geöffnet","Verstanden",false] spawn BIS_fnc_guiMessage;

[] spawn {
	sleep 10;
	[true,false,false] call ace_spectator_fnc_setSpectator;
};