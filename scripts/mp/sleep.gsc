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
    PrintConsole("[Sleep] " + message + "\n");
}
InitTimeLimitDvars() {
    if( !isDefined( level.timelimitDisabled ) ) level.timelimitDisabled = false;
    if( !isDefined( level.timelimitDvars ) ) {
        level.timelimitDvars = [];
        level.timelimitDvars["scr_dm_timelimit"] = getDvar("scr_dm_timelimit", 10);
        level.timelimitDvars["scr_war_timelimit"] = getDvar("scr_war_timelimit", 10);
        level.timelimitDvars["scr_dom_timelimit"] = getDvar("scr_dom_timelimit", 20);
        level.timelimitDvars["scr_dd_timelimit"] = getDvar("scr_dd_timelimit", 2.5);
        level.timelimitDvars["scr_sd_timelimit"] = getDvar("scr_sd_timelimit", 2.5);
        level.timelimitDvars["scr_sab_timelimit"] = getDvar("scr_sab_timelimit", 20);
        level.timelimitDvars["scr_ctf_timelimit"] = getDvar("scr_ctf_timelimit", 10);
        level.timelimitDvars["scr_oneflag_timelimit"] = getDvar("scr_oneflag_timelimit", 3);
        level.timelimitDvars["scr_koth_timelimit"] = getDvar("scr_koth_timelimit", 15);
        level.timelimitDvars["scr_arena_timelimit"] = getDvar("scr_arena_timelimit", 2.5);
        level.timelimitDvars["scr_gtnw_timelimit"] = getDvar("scr_gtnw_timelimit", 10);
    }
}
SaveTimelimitDvars() {
    level.timelimitDisabled = true;
    foreach (name, value in level.timelimitDvars) {
        level.timelimitDvars[name] = getDvar(name);
        ScriptLog("Saved " + name + " as " + level.timelimitDvars[name]);
        setdvar(name, "0");
    }
    ScriptLog("Timelimit dvars saved and set to infinite.");
}
ResetTimelimitDvarsAndRestart() {
    foreach (name, value in level.timelimitDvars) {
        setDvar(name, value);
        ScriptLog("Reset " + name + " to " + getDvar(name));
    }
    level.timelimitDisabled = false;
    // map_restart(false);
    ScriptLog("Timelimit dvars reset and map restarted.");
}

init() {
    ScriptLog("scripts/sleep.gsc::init() start");
    setDvarIfUninitialized("gsc_sleep", 0);
    if (getDvarInt("gsc_sleep") == 0) {
        ScriptLog("sv_sleep is disabled.");
        return;
    }
    if (!isDefined(level.timelimitDvars)) {
        InitTimeLimitDvars();
        SaveTimelimitDvars();
        level thread onPlayerConnect();
    }
    ScriptLog("scripts/sleep.gsc::init() end");
}

onPlayerConnect() {
    level waittill("connected", player);
    player thread onPlayerSpawned();
    player thread onPlayerDisconnected();
}

onPlayerSpawned() {
    self endon("disconnect");
    self waittill("spawned_player");
    if (GetRealPlayerCount() ==  1 && isDefined(level.timelimitDisabled) && level.timelimitDisabled) {
        ResetTimelimitDvarsAndRestart();
    }
}

onPlayerDisconnected() {
    self waittill("disconnect");
    if (GetRealPlayerCount() ==  0 && isDefined(level.timelimitDisabled) && !level.timelimitDisabled) {
        SaveTimelimitDvars();
    }
}