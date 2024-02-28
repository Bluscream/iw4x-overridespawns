#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

GetPlayerCount() {
    return level.players.size;
}
GetRealPlayerCount() {
    players = 0;
    foreach (player in level.players) {
        if (!player IsBot()) {
            players++;
        }
    }
    return players;
}
GetBotCount() {
    bots = 0;
    foreach (player in level.players) {
        if (player IsBot()) {
            bots++;
        }
    }
    return bots;
}
ScriptLog(message) {
    PrintConsole("[Logger] " + message + "\n");
}
GetPlayerString(player) {
    s = "";
    if (isdefined( self.pers[ "isBot" ])) s += "[BOT] ";
    s += player.name + " (#" + player getEntityNumber();
    if (isDefined(player.guid)) s += "/" + player.guid;
    if (!isdefined( self.pers[ "isBot" ] )) {
        if (isDefined(player.xuid)) s += "/" + player.xuid;
        if (isDefined(player GetIp())) s += "/" + player GetIp();
    }
    if (isDefined(player.pers["team"])) s += "/" + player.pers["team"];
    return s + ")";
}
// GetPlayerDlcString(player) {
//     dlcstr = "Installed DLCs: ";
//     if (player getClientDvar("isDlcInstalled_1") == 1)
//         dlcstr += "Stimulus Pack, ";
//     if (player getClientDvar("isDlcInstalled_2") == 1)
//         dlcstr += "Resurgence Pack, ";
//     if (player getClientDvar("isDlcInstalled_3") == 1)
//         dlcstr += "IW4x Classics, ";
//     if (player getClientDvar("isDlcInstalled_4") == 1)
//         dlcstr += "Call Of Duty 4 Pack, ";
//     if (player getClientDvar("isDlcInstalled_5") == 1)
//         dlcstr += "Modern Warfare 3 Pack, ";
//     if (player getClientDvar("isDlcInstalled_All") == 1)
//         dlcstr += "All";
//     return dlcstr;
// }
GetPlayerCountString() {
    return "Clients: " + GetPlayerCount() + " / " + GetDvarInt("sv_maxclients", -1) + " (Players: " + GetRealPlayerCount() + " Bots: " + GetBotCount() + ")";
}

init() {
    ScriptLog("scripts/logger.gsc::init() start");
    setDvarIfUninitialized("gsc_logger", 1);
    if (getDvarInt("gsc_logger") == 0) {
        ScriptLog("gsc_logger is disabled.");
        return;
    }
    level thread onPlayerConnect();
    ScriptLog("scripts/logger.gsc::init() end");
}

onPlayerConnect() {
    level waittill("connected", player);
    ScriptLog(GetPlayerString(player) + " connected");
    // ScriptLog(GetPlayerDlcString(player));
    if (GetRealPlayerCount() ==  1) {
        ScriptLog("This is the first player");
    }
    // player thread onPlayerSpawned();
    player thread onPlayerDisconnected();
    waittillframeend;
    ScriptLog(GetPlayerCountString());
}

onPlayerSpawned() {
    self endon("disconnect");
    self waittill("spawned_player");
    ScriptLog(GetPlayerString(self) + " spawned");
}

onPlayerDisconnected() {
    self waittill("disconnect");
    ScriptLog(GetPlayerString(self) + " disconnected");
    ScriptLog(GetPlayerCountString());
    if (GetRealPlayerCount() == 0) {
        ScriptLog("This was the last player");
    }
}