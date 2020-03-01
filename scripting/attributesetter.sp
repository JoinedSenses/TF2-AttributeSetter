#include <sourcemod>
#include "smlib/clients.inc"
#include <tf2attributes>
#include <tf2_stocks>

#define PLUGIN_VERSION "1.1.1"
#define PLUGIN_DESCRIPTION "Allows modifying weapon attributes with a command"
#pragma newdecls required

public Plugin myinfo = {
	name = "Attribute Setter", 
	author = "JoinedSenses", 
	description = PLUGIN_DESCRIPTION, 
	version = PLUGIN_VERSION, 
	url = "https://github.com/JoinedSenses"
};

public void OnPluginStart() {
	CreateConVar("sm_attributesetter_version", PLUGIN_VERSION, PLUGIN_DESCRIPTION, FCVAR_SPONLY|FCVAR_NOTIFY|FCVAR_DONTRECORD).SetString(PLUGIN_VERSION);
	
	RegAdminCmd("sm_attribute", cmdAttribute, ADMFLAG_ROOT);
	RegAdminCmd("sm_resetattributes", cmdReset, ADMFLAG_ROOT);
	RegAdminCmd("sm_getweapon", cmdWeaponEnt, ADMFLAG_ROOT);
}

public Action cmdAttribute(int client, int args) {
	if (args < 3 ) {
		ReplyToCommand(client, "Requires three arguments");
		return Plugin_Handled;
	}

	char arg1[MAX_NAME_LENGTH];
	char arg2[16];
	char arg3[16];

	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));
	GetCmdArg(3, arg3, sizeof(arg3));

	int target = FindTarget(client, arg1, true, false);
	if (target < 0) {
		return Plugin_Handled;
	}

	int iArg2 = StringToInt(arg2);
	if (iArg2 < 1) {
		ReplyToCommand(client, "Second argument must be an integer greater than 0");
		return Plugin_Handled;
	}

	float fArg3 = StringToFloat(arg3);
	if (fArg3 < 0) {
		ReplyToCommand(client, "Third argument must be a float value greater than or equal to 0.0");
		return Plugin_Handled;
	}

	int iWeapon = Client_GetActiveWeapon(target);

	char sWeapon[32];
	Client_GetActiveWeaponName(target, sWeapon, sizeof(sWeapon));

	char target_name[MAX_NAME_LENGTH];
	GetClientName(target, target_name, sizeof(target_name));

	TF2Attrib_SetByDefIndex(iWeapon, iArg2, fArg3);

	ReplyToCommand(client, "Changed attribute %i of %s's %s to %0.3f", iArg2, target_name, sWeapon, fArg3);
	return Plugin_Handled;
}

public Action cmdReset(int client, int args) {
	if (args < 1) {
		TF2_RemoveAllWeapons(client);
		TF2_RegeneratePlayer(client);
		ReplyToCommand(client, "Reset attributes of your weapons");
		return Plugin_Handled;
	}

	char arg1[MAX_NAME_LENGTH];
	GetCmdArg(1, arg1, sizeof(arg1));

	int target = FindTarget(client, arg1, true, false);
	if (target < 0) {
		return Plugin_Handled;
	}

	TF2_RemoveAllWeapons(target);
	TF2_RegeneratePlayer(target);

	if (client == target) {
		TF2_RemoveAllWeapons(client);
		TF2_RegeneratePlayer(client);
		ReplyToCommand(client, "Reset attributes of your weapons");
		return Plugin_Handled;
	}

	char target_name[MAX_NAME_LENGTH];
	GetClientName(target, target_name, sizeof(target_name));

	ReplyToCommand(client, "Reset attributes of  %s's weapons", target_name);
	return Plugin_Handled;
}

public Action cmdWeaponEnt(int client, int args) {
	if (args < 1) {
		ReplyToCommand(client, "Need client name");
		return Plugin_Handled;
	}

	char arg1[MAX_NAME_LENGTH];
	GetCmdArg(1, arg1, sizeof(arg1));

	int target = FindTarget(client, arg1, true, false);
	if (target < 0) {
		return Plugin_Handled;
	}

	int iWeapon = Client_GetActiveWeapon(target);

	char sWeapon[32];
	Client_GetActiveWeaponName(target, sWeapon, sizeof(sWeapon));

	ReplyToCommand(client, "Player weapon is %s %i", sWeapon, iWeapon);
	return Plugin_Handled;
}
