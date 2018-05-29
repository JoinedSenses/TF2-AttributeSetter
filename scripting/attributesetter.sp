#include <sourcemod>
#include <smlib>
#include <tf2attributes>

public Plugin myinfo = {
	name = "Attribute Setter", 
	author = "JoinedSenses", 
	description = "Attribute Setter", 
	version = "1.0.0", 
	url = "https://github.com/JoinedSenses"
};
public void OnPluginStart(){
	RegAdminCmd("sm_attribute", cmdAttribute, ADMFLAG_ROOT);
	RegAdminCmd("sm_getweapon", cmdWeaponEnt, ADMFLAG_ROOT);
}
public Action cmdAttribute(int client, int args){
	if (args < 3 ){
		ReplyToCommand(client, "Requires three arguments");
		return Plugin_Handled;
	}
	char arg1[MAX_NAME_LENGTH], arg2[16], arg3[16];
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));
	GetCmdArg(3, arg3, sizeof(arg3));
	int target = FindTarget2(client, arg1, true, false);
	if (target < 0){
		ReplyToCommand(client, "Could not find target");
		return Plugin_Handled;
	}
	int iArg2 = StringToInt(arg2);
	if (iArg2 == 0){
		ReplyToCommand(client, "Second argument must be an integer greater than 0");
		return Plugin_Handled;
	}
	float fArg3 = StringToFloat(arg3);
	if (fArg3 == 0.0){
		ReplyToCommand(client, "Third argument must be a float greater than 0.0");
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
	
public Action cmdWeaponEnt(int client, int args){
	if (args < 1){
		ReplyToCommand(client, "Need client name");
		return Plugin_Handled;
	}
	char arg1[MAX_NAME_LENGTH];
	GetCmdArg(1, arg1, sizeof(arg1));
	new target = FindTarget2(client, arg1, true, false);
	if (target < 0){
		ReplyToCommand(client, "Could not find target");
		return Plugin_Handled;
	}
	int iWeapon = Client_GetActiveWeapon(target);
	char sWeapon[32];
	Client_GetActiveWeaponName(target, sWeapon, sizeof(sWeapon));
	ReplyToCommand(client, "Player weapon is %s %i", sWeapon, iWeapon);
	return Plugin_Handled;
}

stock FindTarget2(client, const String:target[], bool:nobots = false, bool:immunity = true){
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[1], target_count, bool:tn_is_ml;
	new flags = COMMAND_FILTER_NO_MULTI;
	if (nobots){
		flags |= COMMAND_FILTER_NO_BOTS;
	}
	if (!immunity){
		flags |= COMMAND_FILTER_NO_IMMUNITY;
	}
	if ((target_count = ProcessTargetString(target, client, target_list, 1, flags, target_name, sizeof(target_name), tn_is_ml)) > 0){
		return target_list[0];
	}
	else{
		if (target_count == 0) { return -1; }
		ReplyToCommand(client, "\x01[\x03JA\x01] %t", "No matching client");
		return -1;
	}
}