#pragma semicolon 1

#define DEBUG

#include <sourcemod>
#include <sdktools>
#include <cstrike>
//#include <sdkhooks>

#pragma newdecls required

EngineVersion g_Game;

public Plugin myinfo = 
{
	name = "No Late Spawns",
	author = "xFlane",
	description = "blocks late spawns",
	version = "1.00",
	url = "http://steamcommunity.com/id/xflane/"
};

float g_fRoundStartTime;

ConVar g_cvRespawnOnDeathT;
ConVar g_cvRespawnOnDeathCT;
ConVar g_cvLateSpawnTime;

public void OnPluginStart()
{
	g_Game = GetEngineVersion();
	if(g_Game != Engine_CSGO && g_Game != Engine_CSS)
	{
		SetFailState("This plugin is for CSGO/CSS only.");		
	}
	
	/* ConVars */
	
	g_cvRespawnOnDeathT = FindConVar("mp_respawn_on_death_t");
	g_cvRespawnOnDeathCT = FindConVar("mp_respawn_on_death_ct");
	
	g_cvLateSpawnTime = CreateConVar("sm_latespawn_max", "15.0", "Max time allowed for late spawns.");
	AutoExecConfig();
	
	/* */
	
	/* Hooks */
	HookEvent("round_prestart", Event_OnRoundStart); // called before spawn.
	HookEvent("player_spawn", Event_OnPlayerSpawn);
}

public Action Event_OnPlayerSpawn(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));

	if(GetGameTime() - g_fRoundStartTime > g_cvLateSpawnTime.FloatValue && !g_cvRespawnOnDeathT.IntValue && !g_cvRespawnOnDeathCT.IntValue) // if more then x seconds has past and auto respawn is disabled.
	{
		PrintToChat(client, " \x04No late spawns!");
		ForcePlayerSuicide(client);
	}	
}

public Action Event_OnRoundStart(Handle event, char[] info, bool dontBroadcast)
{
	g_fRoundStartTime = GetGameTime(); // getting the game time.
}