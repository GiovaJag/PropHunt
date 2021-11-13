/*
 * Copyright (C) 2021  Mikusch
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

static Handle g_SDKCallSetSwitchTeams;
static Handle g_SDKCallGetProjectileDamage;
static Handle g_SDKCallGetMeleeDamage;
static Handle g_SDKCallGetDamageType;

void SDKCalls_Initialize(GameData gamedata)
{
	g_SDKCallSetSwitchTeams = PrepSDKCall_SetSwitchTeams(gamedata);
	g_SDKCallGetProjectileDamage = PrepSDKCall_GetProjectileDamage(gamedata);
	g_SDKCallGetMeleeDamage = PrepSDKCall_GetMeleeDamage(gamedata);
	g_SDKCallGetDamageType = PrepSDKCall_GetDamageType(gamedata);
}

static Handle PrepSDKCall_SetSwitchTeams(GameData gamedata)
{
	StartPrepSDKCall(SDKCall_GameRules);
	PrepSDKCall_SetFromConf(gamedata, SDKConf_Virtual, "CTeamplayRules::SetSwitchTeams");
	PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_ByValue);
	
	Handle call = EndPrepSDKCall();
	if (!call)
		LogMessage("Failed to create SDK call: CTeamplayRules::SetSwitchTeams");
	
	return call;
}

static Handle PrepSDKCall_GetProjectileDamage(GameData gamedata)
{
	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(gamedata, SDKConf_Virtual, "CTFWeaponBaseGun::GetProjectileDamage");
	PrepSDKCall_SetReturnInfo(SDKType_Float, SDKPass_ByValue);
	
	Handle call = EndPrepSDKCall();
	if (!call)
		LogMessage("Failed to create SDK call: CTFWeaponBaseGun::GetProjectileDamage");
	
	return call;
}

static Handle PrepSDKCall_GetMeleeDamage(GameData gamedata)
{
	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(gamedata, SDKConf_Virtual, "CTFWeaponBaseMelee::GetMeleeDamage");
	PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Pointer, _, VENCODE_FLAG_COPYBACK);
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Pointer, _, VENCODE_FLAG_COPYBACK);
	PrepSDKCall_SetReturnInfo(SDKType_Float, SDKPass_ByValue);
	
	Handle call = EndPrepSDKCall();
	if (!call)
		LogMessage("Failed to create SDK call: CTFWeaponBaseMelee::GetMeleeDamage");
	
	return call;
}

static Handle PrepSDKCall_GetDamageType(GameData gamedata)
{
	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(gamedata, SDKConf_Virtual, "CBaseEntity::GetDamageType");
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
	
	Handle call = EndPrepSDKCall();
	if (!call)
		LogMessage("Failed to create SDK call: CBaseEntity::GetDamageType");
	
	return call;
}

void SDKCall_SetSwitchTeams(bool shouldSwitch)
{
	if (g_SDKCallSetSwitchTeams)
		SDKCall(g_SDKCallSetSwitchTeams, shouldSwitch);
}

float SDKCall_GetProjectileDamage(int weapon)
{
	if (g_SDKCallGetProjectileDamage)
		return SDKCall(g_SDKCallGetProjectileDamage, weapon);
	else
		return 0.0;
}

float SDKCall_GetMeleeDamage(int weapon, int target, int damageType, int customDamage)
{
	if (g_SDKCallGetMeleeDamage)
		return SDKCall(g_SDKCallGetMeleeDamage, weapon, target, damageType, customDamage);
	else
		return 0.0;
}

int SDKCall_GetDamageType(int entity)
{
	if (g_SDKCallGetDamageType)
		return SDKCall(g_SDKCallGetDamageType, entity);
	else
		return DMG_GENERIC;
}
