#pragma newdecls required

#include <sourcemod>
#include <tf2attributes>
#include <tf2_stocks>

#define PLUGIN_VERSION "1.1.2"
#define PLUGIN_DESCRIPTION "Allows modifying weapon attributes with a command"


public Plugin myinfo = {
	name = "Attribute Setter", 
	author = "JoinedSenses", 
	description = PLUGIN_DESCRIPTION, 
	version = PLUGIN_VERSION, 
	url = "https://github.com/JoinedSenses"
};

public void OnPluginStart() {
	CreateConVar(
		"sm_attributesetter_version",
		PLUGIN_VERSION,
		PLUGIN_DESCRIPTION,
		FCVAR_SPONLY|FCVAR_NOTIFY|FCVAR_DONTRECORD\
	).SetString(PLUGIN_VERSION);
	
	RegAdminCmd("sm_attribute", cmdAttribute, ADMFLAG_ROOT);
	RegAdminCmd("sm_resetattributes", cmdReset, ADMFLAG_ROOT);
	RegAdminCmd("sm_getweapon", cmdWeaponEnt, ADMFLAG_ROOT);

	LoadTranslations("common.phrases");
}

public Action cmdAttribute(int client, int args) {
	if (args < 3 ) {
		ReplyToCommand(client, "Usage: sm_attribute <\"playername\"> <attribute> <value>");
		return Plugin_Handled;
	}

	char arg1[MAX_NAME_LENGTH];
	GetCmdArg(1, arg1, sizeof(arg1));

	int target = FindTarget(client, arg1, true, false);
	if (target == -1) {
		return Plugin_Handled;
	}

	char arg2[16];
	GetCmdArg(2, arg2, sizeof(arg2));
	int attribute = StringToInt(arg2);
	if (attribute < 1) {
		ReplyToCommand(client, "Second argument must be an integer greater than 0");
		return Plugin_Handled;
	}

	char arg3[16];
	GetCmdArg(3, arg3, sizeof(arg3));
	float value = StringToFloat(arg3);
	if (value < 0) {
		ReplyToCommand(client, "Third argument must be a float value greater than or equal to 0.0");
		return Plugin_Handled;
	}

	int weapon = GetEntPropEnt(target, Prop_Data, "m_hActiveWeapon");
	if (weapon == -1) {
		ReplyToCommand(client, "%N has no active weapon", target);
		return Plugin_Handled;
	}

	char classname[32];
	GetEntityClassname(weapon, classname, sizeof classname);

	TF2Attrib_SetByDefIndex(weapon, attribute, value);

	ReplyToCommand(client, "Changed attribute %i of %N's %s to %0.3f", attribute, target, classname, value);

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
	if (target == -1) {
		return Plugin_Handled;
	}

	TF2_RemoveAllWeapons(target);
	TF2_RegeneratePlayer(target);

	if (client == target) {
		ReplyToCommand(client, "Reset attributes of your weapons");
	}
	else {
		ReplyToCommand(client, "Reset attributes of  %N's weapons", target);
	}

	return Plugin_Handled;
}

public Action cmdWeaponEnt(int client, int args) {
	if (args < 1) {
		ReplyToCommand(client, "Usage: sm_getweapon <\"playername\">");
		return Plugin_Handled;
	}

	char arg1[MAX_NAME_LENGTH];
	GetCmdArg(1, arg1, sizeof(arg1));

	int target = FindTarget(client, arg1, true, false);
	if (target == -1) {
		return Plugin_Handled;
	}

	int weapon = GetEntPropEnt(target, Prop_Data, "m_hActiveWeapon")
	if (weapon == -1) {
		ReplyToCommand(client, "%N has no active weapon", target);
		return Plugin_Handled;
	}

	char classname[32];
	GetEntityClassname(weapon, classname, sizeof classname);

	ReplyToCommand(client, "Player weapon is %s %i", classname, weapon);

	return Plugin_Handled;
}