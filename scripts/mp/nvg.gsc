#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

ScriptLog(message) {
    PrintConsole("[NVG] " + message + "\n");
}

init() {
    ScriptLog("scripts/nvg.gsc::init() start");
    setDvarIfUninitialized("scr_forceAllowNightVisionGoggles", 1);
    level thread onPlayerConnect();
    ScriptLog("scripts/nvg.gsc::init() end");
    
}

onPlayerConnect() {
	while(true) {
        level waittill("connected", player);
		player thread onPlayerGiveloadout();
    }
}

onPlayerGiveloadout()
{
	self endon("disconnect");
	while(true) {
		self waittill("giveLoadout");

		if(getDvar("scr_forceAllowNightVisionGoggles") == 1)
		{
            self _SetActionSlot(1, "nightvision");
		}
	}
}
