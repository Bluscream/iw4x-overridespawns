#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

ScriptLog(message) {
    if (getDvarInt("gsc_override_spawns_debug") == 1) {
        PrintConsole("[Spawn Overrides] " + message + "\n");
    }
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

init() {
    ScriptLog("scripts/spawnoverride.gsc::init() start");
    setDvarIfUninitialized("gsc_override_spawns", 1);
    if (getDvarInt("gsc_override_spawns") == 0) {
        PrintConsole("gsc_override_spawns is disabled.");
        return;
    }
    setDvarIfUninitialized("gsc_override_spawns_debug", 0);
    setDvarIfUninitialized("gsc_override_spawns_allow_oob", 1);
    level thread onPlayerConnected();
    // level thread onBotConnect();
    ScriptLog("scripts/spawnoverride.gsc::init() end");
}

onBotConnect() {
    while (true) {
        level waittill("bot_connected", bot);
        bot thread onPlayerSpawned();
        // ScriptLog("Bot " + GetPlayerString(bot) + " connected");
    }
}

onPlayerConnected() {
    while (true) {
        level waittill("connected", player);
        player thread onPlayerSpawned();
        // ScriptLog("Player " + GetPlayerString(player) + " connected");
    }
}

onPlayerSpawned() {
    self endon("disconnect");
	while(true) {
        self waittill("spawned_player");
        // waittillframeend;
        // wait(1.1);
        teleportToNewSpawn(self);
    }
}

teleportToNewSpawn(player) {
    random = randomInt(100);
    teamname = player.pers["team"];
    mapname = GetDvar("mapname", "");
    newspawn = undefined;newangles = undefined;
	switch (mapname)
	{
		case "dcburning":
            if (random < 10) {
                newspawn = (-22549.3, -1746.62, -686.177); // Bunker back
                newangles = (0, 86.6001, 0);
            } else if (random < 20) {
                newspawn = (-21559.6, -1498.02, -671.875); // Bunker middle back
                newangles = (0, 93.7248, 0);
            } else if (random < 30) {
                newspawn = (-21132.2, -1410.37, -671.875); // Bunker middle front
                newangles = (0, 85.8256, 0);
            } else if (random < 40) {
                newspawn = (-20372.6, -1269.94, -663.875); // Bunker front
                newangles = (0, 99.5091, 0);
            } else if (random < 50) {
                newspawn = (-20428.1, 8115.98, 398.125); // balcony
            } else if (random < 60) {
                newspawn = (-21467.7, 7315.03, 734.125); // stairs lower
                newangles = (0, 172.195, 0);
            } else if (random < 70) {
                newspawn = (-21476.1, 7316.27, 870.125); // stairs upper
                newangles = (0, 171.189, 0);
            } else if (random < 75) {
                newspawn = (-22292.5, 6750.99, 534.125); // viewpoint
                if (randomInt(1) == 0) newangles = (0, -143.986, 0);
                else newangles = (0, 60.2385, 0);
            } else if (random < 80) {
                newspawn = (-20816.9, 7542.88, 1142.13); // roof
            }
            break;
        case "gulag":
        case "so_showers_gulag":
            if (random < 10) {
                newspawn = (-3705.47, 206.597, 1594.13); // stairs lower
                newangles = (0, 143.209, 0);
            } else if (random < 20) {
                newspawn = (-1694.65, 1212.62, 1872.13); // upper room 1
                newangles = (0, -91.0632, 0);
            } else if (random < 30) {
                newspawn = (-187.983, -357.429, 1868.63); // upper behind house 1
                newangles = (0, 117.155, 0);
            } else if (random < 40) {
                newspawn = (-1897.94, -1013.71, 1908.13); // upper helipad
                newangles = (0, 104.691, 0);
            } else if (random < 50) {
                newspawn = (-3458.2, -2.62114, 1869.24); // upper entrance
                newangles = (0, -39.0674, 0);
            } else if (getDvar("gsc_override_spawns_allow_oob") == 1) {
                random = randomInt(250);
                if (random < 5) {
                    newspawn = (-2826.48, -2789.37, 1868.12); // upper between buildings 1 (oob)
                    newangles = (0, 59.5624, 0);
                } else if (random < 10) {
                    newspawn = (-4788.83, -367.144, 1868.13); // upper above hole (oob)
                    newangles = (0, -105.093, 0);
                } else if (random < 15) {
                    newspawn = (-4855.49, -1209.13, 512.125); //hole 1st floor (oob)
                    newangles = (0, 42.1295, 0);
                } else if (random < 20) {
                    newspawn = (-4429.79, -1240.3, 224.125); // below hole (oob)
                    newangles = (0, 106.965, 0);
                } else if (random < 25) {
                    newspawn = (-6566.23, -2351.23, 142.125); // below hole long tunnel (oob)
                    newangles = (0, 49.9628, 0);
                } else if (random < 30) {
                    newspawn = (-4117.18, 1489.87, 144.125); // below hole before hole (oob)
                    newangles = (0, 167.626, 0);
                } else if (random < 35) {
                    newspawn = (-3253.25, 2179.9, 2491.43); // wall above default spawn (oob)
                    newangles = (0, -158.297, 0);
                } else if (random < 40) {
                    newspawn = (-1961.37, -3538.19, 2495.06); // wall above opposite (oob)
                    newangles = (0, 26.3672, 0);
                } else if (random < 45) {
                    newspawn = (-3875.73, -2448.43, 2764.13); // tower above opposite (oob)
                    newangles = (0, 55.7446, 0);
                } else if (random < 50) {
                    newspawn = (-1198.17, 1253.02, 2764.13); // tower above default spawn (oob)
                    newangles = (0, -124.519, 0);
                } else if (random < 55) {
                    newspawn = (-1593.9, 1465.63, 2120.13); // sandbags above default spawn 1 (oob)
                    newangles = (0, -71.2463, 0);
                } else if (random < 60) {
                    newspawn = (-4117.18, 1489.87, 144.125); // sandbags hole default spawn 2 (oob)
                } else if (random < 77) {
                    newspawn = (-4117.18, 1489.87, 144.125); // below hole before hole (oob)
                } else if (random < 65) {
                    newspawn = (-2216.11, 84.641, 1230.13); // lowest part reachable (oob)
                    newangles = (0, -122.443, 0);
                } else if (random < 70) {
                    newspawn = (-3304.78, 1174.95, 160.125); // below hole canals (oob)
                    newangles =(0, 134.442, 0);
                } else if (random < 75) {
                    newspawn = (-3616.38, 417.65, 144.125); // below hole sideway 1 (oob)
                    newangles = (0, 146.422, 0);
                } else if (random < 80) {
                    newspawn = (-3315.52, -1554.13, 224.125); // below hole sideway 2 (oob)
                    newangles = (0, -132.389, 0);
                } else if (random < 85) {
                    newspawn = (-5390, -1264.57, 224.125); // below hole kitchen (oob)
                    newangles = (0, -2.82687, 0);
                } else if (random < 90) {
                    newspawn = (-5377.55, -1271.02, 360.125); // below hole above kitchen (oob)
                    newangles = (0, 9.35155, 0);
                } else if (random < 95) {
                    newspawn = (-3315.52, -1554.13, 224.125); // below hole sideway 2 (oob)
                    newangles = (0, -132.389, 0);
                } else if (random < 100) {
                    newspawn = (-4062.92, 84.5243, 2496.13); // above castle (oob)
                    newangles = (0, -1.84349, 0);
                } else if (random < 105) {
                    newspawn = (-157.289, -2317.56, 1888.13); // above backpart 1 (oob)
                    newangles = (0, 142.207, 0);
                } else if (random < 110) {
                    newspawn = (210.761, 122.991, 1888.13); // above backpart 2 (oob)
                    newangles = (0, -136.159, 0);
                } else if (random < 115) {
                    newspawn = (-378.918, 1243.85, 1888.13); // above backpart 3 (oob)
                    newangles = (0, -145.228, 0);
                } else if (random < 120) {
                    newspawn = (-3158.03, 1016.56, 1988); // cell spawn 1 upper (oob)
                    newangles = (0, 106.672, 0);
                } else if (random < 125) {
                    newspawn = (-3176.93, 1010.18, 1868.13); // cell spawn 1 lower (oob)
                    newangles = (0, 111.599, 0);
                } else if (random < 130) {
                    newspawn = (-3617.31, 1851.83, 1872.13); // cell spawn 2 lower (oob)
                    newangles = (0, -94.1638, 0);
                } else if (random < 135) {
                    newspawn = (-2690.67, -521.544, 962.125); // lowest part above cage (oob)
                    newangles = (0, 143.533, 0);
                }  else if (random < 140) {
                    newspawn = (-2637.76, -502.642, 845.125); // lowest part in cage (oob)
                    newangles = (0, 53.4179, 0);
                }   else if (random < 145) {
                    newspawn = (-2640.06, -554.394, 723.125); // lowest part under cage (oob)
                    newangles = (0, -126.884, 0);
                }   else if (random < 150) {
                    newspawn = (-3112.51, -1976.21, 642.125); // dark rooms 1 (oob)
                    newangles = (0, 141.308, 0);
                }   else if (random < 155) {
                    newspawn = (-3431.87, -1748.09, 648.016); // dark rooms 2 (oob)
                    newangles = (0, -35.5935, 0);
                }   else if (random < 160) {
                    newspawn = (-2360.69, -3547.03, 650.68); // dark rooms floor 1 (oob)
                    newangles = (0, 103.521, 0);
                }   else if (random < 165) {
                    newspawn = (-2669.69, -2505.03, 672.125); // dark rooms pipes (oob)
                    newangles = (0, 17.2892, 0);
                }   else if (random < 170) {
                    newspawn = (-1989.97, -1932.12, 587.074); // dark rooms pipes end (oob)
                    newangles = (0, 99.791, 0);
                }   else if (random < 175) {
                    newspawn = (-1813.33, -1349.6, 543.805); // showers side left (oob)
                    newangles = (0, 3.59472, 0);
                }   else if (random < 180) {
                    newspawn = (-897.301, -1991.01, 541.385); // showers side right (oob)
                    newangles = (0, 101.466, 0);
                }   else if (random < 185) {
                    newspawn = (-1193.11, -924.109, 536.125); // showers main (oob)
                    newangles = (0, -34.3685, 0);
                }   else if (random < 190) {
                    newspawn = (-347.355, 363.906, 536.125); // showers main 2 (oob)
                    newangles = (0, -35.0442, 0);
                }   else if (random < 195) {
                    newspawn = (-142.259, -130.378, 338.125); // showers canals 1 (oob)
                    newangles = (0, 59.1361, 0);
                }    else if (random < 200) {
                    newspawn = (-559.787, 1179.86, 332.125); // showers canals 2 (oob)
                    newangles = (0, -23.2558, 0);
                }
            }
            break;
        case "dcemp":
            if (random < 20) {
                newspawn = (-43934, 13750.9, -259.875); // entrance door
                newangles = (0, -59.6314, 0);
            } else if (random < 30) {
                newspawn = (-44784.7, 16386, -83.875); // near window
                newangles = (0, -33.4235, 0);
            } else if (random < 40) {
                newspawn = (-43420.5, 18566.3, -381.875); // below parking 1
                newangles = (0, 56.3128, 0);
            } else if (random < 50) {
                newspawn = (-41631.4, 21965.6, -353.875); // inside glass
                newangles = (0, -12.6264, 0);
            } else if (random < 60) {
                newspawn = (-41271.4, 21657.5, -639.875); // inside below stairs
                newangles = (0, -2.13448, 0);
            } else if (random < 70) {
                newspawn = (-41119.7, 22642.6, -771.875); // inside lowest
                newangles = (0, -7.02889, 0);
            } else if (getDvar("gsc_override_spawns_allow_oob") == 1) {
                random = randomInt(100);
                if (random < 10) {
                    newspawn = (-44834.3, 12716.9, -377.875); // entrance door outside (oob)
                    newangles = (0, -19.1029, 0);
                } else if (random < 20) {
                    newspawn = (-45956.7, 9860.35, -369.875); // random shop 1 (oob)
                    newangles = (0, 166.676, 0);
                } else if (random < 30) {
                    newspawn = (-48164.3, 8956.87, -375.875); // grassy bits arch (oob)
                    newangles = (0, -77.3853, 0);
                }
            }
            break;

	}
    msg = GetPlayerString(player) + " ("+ mapname + ") " + player.origin;
    if (isDefined(newspawn)) {
        player setOrigin(newspawn);
        msg += " => " + newspawn;
        if (isDefined(newangles)) {
            player setPlayerAngles(newangles);
            msg += " / " + newangles;
        }
    } else {
        msg += " not teleported";
    }
    ScriptLog(msg);
}
