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
    PrintConsole("[Laser] " + message + "\n");
}

SetServerDvars(value) {
	setDvar( "laserLight", value );
	setDvar( "cg_laserlight", value );
	setDvar( "laserLightWithoutNightvision", value );
	setDvar( "laserForceOn", value );
    if (value == 1) {
        ScriptLog("Laser Enabled");
    } else {
        ScriptLog("Laser Disabled");
    }
}
SetClientDvars(client, value) {
    client setClientDvar( "laserLight", value );
    client setClientDvar( "cg_laserlight", value );
    client setClientDvar( "laserLightWithoutNightvision", value );
    client setClientDvar( "laserForceOn", value );
    if (value == 1) {
        client iPrintlnBold("Laser Enabled");
    } else {
        client iPrintlnBold("Laser Disabled");
    }

}

init() {
    ScriptLog("scripts/laser.gsc::init() start");
    setDvarIfUninitialized("gsc_laser", 1);
    laser = getDvarInt("gsc_laser");
    if (laser == 1) {
        SetServerDvars(1);
    } else if (laser == 0) {
        SetServerDvars(0);
    }
    level thread onPlayerConnect();
    ScriptLog("scripts/laser.gsc::init() end");
    
}

onPlayerConnect() {
	while(true) {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned() {
    self endon("disconnect");
	while(true) {
        self waittill("spawned_player");
        laser = getDvarInt("gsc_laser");
        if (laser == 1) {
            SetClientDvars(self, 1);
        } else if (laser == 0) {
            SetClientDvars(self, 0);
        }
    }
}
