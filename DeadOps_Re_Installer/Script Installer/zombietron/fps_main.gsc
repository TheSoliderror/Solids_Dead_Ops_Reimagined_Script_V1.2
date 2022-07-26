#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombietron_utility;

init()
{
	thread thread_restarter();
	thread scripts\sp\zombietron\weapons::weap_init();
	thread scripts\sp\zombietron\huds::hud_init();
	thread scripts\sp\zombietron\perks::perks_init();
	thread onConnect();
}

onConnect()
{
	for(;;)
	{
		level waittill( "connecting", player );

		player thread scripts\sp\zombietron\perks::perk_cheak();
		player thread fps_tron();

		//perk variables
		player.jugg = false;
		player.norm = false;
		player.has_tank = false;
		player.has_heli = false;
		
		//health to 2 hits (kinda works, regen is wack)
		player waittill("spawned_player");
		{
		player SetMaxHealth(600);
		player normhealth();
		//player EnableOffhandWeapons();
		//player EnableWeaponCycling();
		}
	}
}

normhealth()
{
	//self iPrintLn("Norm Health Loaded");
	while(1)
	{
		if (self.health < 0)
		{
			//self iPrintLn("You have died!");
			wait 2;
			self SetMaxHealth(600);
			
		}
		wait 0.05;
	}
}

fps_tron() //will always be fps no matter what
{
	for(;;)
	{
		players = GetPlayers();	
		for(i = 0; i < players.size; i ++)
		{
			players[i] setclientdvar("player_topDownCamMode", 0 );
		}
		wait 0.05;
	}
	
}

//this is the trigger resetter, this may stay or may not, depending on server mods in use
thread_restarter()
{
	wait 5;
	for(;;)
	{
		wait 0.05;
		level notify("notifier_1");
		wait 3.5;
		level notify("notifier_2");
	}
}