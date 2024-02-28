#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

GetRealPlayerCount() {
    players = 0;
    foreach (player in level.players) {
        if (!player IsBot()) {
            players++;
        }
    }
    return players;
}
ScriptLog(message) {
    PrintConsole("[Delayed Bots] " + message + "\n");
}

init() {
    ScriptLog("scripts/delayed_bots.gsc::init() start");
    setDvarIfUninitialized("gsc_delayed_bots", 1);
    if (getDvarInt("gsc_delayed_bots") == 0) {
        ScriptLog("gsc_delayed_bots is disabled.");
        return;
    }
	setDvarIfUninitialized( "bots_manage_fill", 0 );
	setDvarIfUninitialized( "bots_manage_fill_later", getDvarInt("bots_manage_fill") );
    ScriptLog("bots_manage_fill: " + getDvarInt("bots_manage_fill") + " | bots_manage_fill_later: " + getDvarInt("bots_manage_fill_later"));
	setDvar( "bots_manage_fill", 0 );
    if (getDvarInt("bots_manage_fill_later") > 0) {
        level thread onPlayerConnect();
    }
    ScriptLog("scripts/delayed_bots.gsc::init() end");
    
}

onPlayerConnect() {
    level waittill("connected", player);
    player thread onPlayerSpawned();
}

onPlayerSpawned() {
    self endon("disconnect");
    self waittill("spawned_player");

    bots_to_spawn = getDvarInt("bots_manage_fill_later");
    if (bots_to_spawn > 0) {
        setDvar("bots_manage_fill", bots_to_spawn);
        setDvar("bots_manage_fill_later", 0);
        self iPrintlnBold("Spawning " + bots_to_spawn + " bots now...");
    }
}
