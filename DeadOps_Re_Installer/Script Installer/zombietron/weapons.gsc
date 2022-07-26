#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombietron_utility;
#include maps\_zombietron_score;

weap_init()
{	
	//Spawn Room
	//level thread custom_wb( (-8182.02, -2470.03, -80.957), (0, 0, 0), "Tank",50 , "t5_veh_tank_t55_mini" ); // tank buy
	//level thread custom_wb( (-8182.02, -2470.03, -80.957), (0, 0, 0), "Heli",50 , "t5_veh_helo_hind_mini" ); // heli buy
	level thread custom_wb( (-8182.02, -2470.03, -80.957), (0, 0, 0), "Spas",1500 , "spas_zt" ); //Spas floor buy Lmao
	//Roof Top
	level thread custom_wb( (-7950.45, 886.32, 186), (0, 0, 0), "Ray Gun",50000 , "ray_gun_zt" );
	level thread custom_wb( (-7832.65, 1889.04, 0.125), (0, 0, 0), "Tank",50000 , "t5_veh_tank_t55_mini" );
	//Summit
	level thread custom_wb( (-2212.09, 1357.99, 7.875), (0, 90, 0), "Heli",50000 , "t5_veh_helo_hind_mini" );
	level thread custom_wb( (-2654.32, 1549.59, 13), (0, 0, 0), "Death Machine",50000 , "minigun_zt" ); 
	//Bull Run
	level thread custom_wb( (-2828.98, -3097.1, 13), (0, 0, 0), "RPG",50000 , "rpg_zt" ); 
	//Prison
	level thread custom_wb( (-2806.73, -5536.79, -1), (0, 0, 0), "Death Machine",50000 , "minigun_zt" );
	//Slums
	level thread custom_wb( (-244.778, -3762.93, 96), (0, 0, 0), "Spas",1500 , "spas_zt" ); 
	level thread custom_wb( (-429.575, -4411.83, 96.325), (0, 0, 0), "Heli",50000 , "t5_veh_helo_hind_mini" );
	//Court yard
	level thread custom_wb( (-581.359, -1224.14, -84.875), (0, 0, 0), "Tank",50000 , "t5_veh_tank_t55_mini" );
	//Rocket
	level thread custom_wb( (-141.957, 1351.1, -77.463), (0, 0, 0), "Tank",25000 , "t5_veh_tank_t55_mini" ); // tank buy
	level thread custom_wb( (-644.463, 1437.25, -28.375), (0, 0, 0), "Heli",25000 , "t5_veh_helo_hind_mini" ); // heli buy
	// there are more areas, but Im not making the weapons to OP
}

//wall buy trigger
custom_wb( location, angles, weapon_name, cost, weapon)
{
    vender_wallbuy = spawn( "script_model", location );
	if(weapon == "t5_veh_helo_hind_mini"){
		vender_wallbuy setModel( weapon );
	}
	else if(weapon == "t5_veh_tank_t55_mini"){
		vender_wallbuy setModel( weapon );
	}
	else{
    vender_wallbuy setModel( getWeaponModel(weapon) );
	}
    vender_wallbuy rotateTo(angles, .1);

    trig_wallbuy = spawn("trigger_radius", location, 1, 25, 25);
    trig_wallbuy SetCursorHint( "HINT_NOICON" );


	trig_wallbuy setHintString("Press ^3&&1^7 to buy " + weapon_name + " [Cost: " + cost + "]");
	
	
    for(;;)
    {
        level waittill("notifier_1");

        trig_wallbuy thread wb_think( weapon, cost);
    }
}

//the brains of the wall buy
wb_think( weapon, cost)
{
    level endon("notifier_2");

    for(;;)
    {
        self waittill( "trigger", player);

		
		if(IsPlayer(player)) {
            if( player UseButtonPressed() && (player.score >= cost) && !(player getCurrentWeapon(weapon)))
			{ 
                while( player UseButtonPressed() )
                    wait 0.05;
				player minus_to_player_score( cost ); 
				if(weapon == "t5_veh_helo_hind_mini")
				{
					player thread heli_press_to_give();
				}
				else if(weapon == "t5_veh_tank_t55_mini")
				{
					player thread tank_press_to_give();
				}
				else{
				player weapon_give( weapon );
				player.new_weapon = weapon;
				}
				//Result: Buy the gun
			}
			else if( player UseButtonPressed() && ( player.score >= cost ) && (player getCurrentWeapon(weapon)))
			{
				while( player UseButtonPressed() )
				{
					wait 0.05;
				}
			}
			else if( player UseButtonPressed() && !( player.score >= cost ) ) //if does not have weapon but does not have the points to buy it
			{
				while( player UseButtonPressed() )
				{
					wait 0.05;
				}
			}
		}
    }
}

//heli buy stuff
heli_press_to_give()
{
	// this needs a tank cheak, if you have tank, take it away and replace it with this. other wise...idk what will happen...
	self iprintln("Press ^3l^7 To Give Heli");
	self.heli_cooldown = 0;
	self.heli_cooldown_cheak = true;
	self.has_heli = true;
	if(self.has_tank == true)
	{
		self iprintln("You no longer have the Tank");
		self.has_tank = false;
	}
	while(1)
	{
		// cool down
		if(self.has_heli == true && self.heli_cooldown < 1200 && self.heli_cooldown_cheak == false)
		{
			self.heli_cooldown++;
		}
		else if (self.has_heli == true && self.heli_cooldown >= 1200 && self.heli_cooldown_cheak == false)
		{
			self.heli_cooldown_cheak = true;
		}
		
		//the press to give
		if(self buttonPressed("l") && self.has_heli == true && self.heli_cooldown_cheak == true && !self.usingvehicle)
		{
			self thread give_heli(self);
			self.heli_cooldown_cheak = false;
			self.heli_cooldown = -1200;
		}
		else if (self buttonPressed("l") && self.has_heli == true && self.heli_cooldown_cheak == false)
		{
			self iprintln("You are on cool down!");
		}
		wait 0.05;
	}
}

give_heli( pickup )	// self is player
{
	set_zombie_var( "heli_alive_time_buy", 60 ); //this is set to 5 for testing
	
	self EnableInvulnerability();

	origin = maps\_zombietron_pickups::push_origin_out( self.origin, 30 );

	heli = SpawnVehicle( "t5_veh_helo_hind_mini", "player_heli", "heli_mini_zt", origin + (0,0,level.heli_height), self.angles );
	heli.health = 100000;
	heli.lockheliheight = true;
	heli MakeVehicleUsable();
	heli UseBy( self );
	heli MakeVehicleUnusable();
	heli.takedamage = false;
	self.heli = heli;
	heli.player = self;
	heli maps\_vehicle::turret_attack_think();
	heli thread maps\_zombietron_pickups::heli_rocket_loop( heli );

	self notify ("veh_activated");
	
	self setclientflag(level._ZT_PLAYER_CF_HELI_PILOT);
	
	time_left = level.zombie_vars["heli_alive_time_buy"];
	if ( isDefined(self.fate_fortune) )
	{
		time_left *= level.zombie_vars["fate_fortune_drop_mod"];
	}
	heli thread maps\_zombietron_pickups::heli_zombie_poi(self);
	heli thread maps\_zombietron_pickups::veh_chicken_watcher();
	//maybe add a for loop??
	self waittill_any_or_timeout(time_left,"disconnect","heli_abort");
	self iprintln("Cool Down Started!");
	self notify ("veh_done");
	self clearclientflag(level._ZT_PLAYER_CF_HELI_PILOT);
	self.heli = undefined;
	if( self.usingvehicle )	// just in case lets make sure we are in a vehicle
	{
		heli MakeVehicleUsable();
		heli UseBy( self );
	}
	heli Delete();

	PlayFx( level._effect["respawn"], self.origin, AnglesToForward(self.angles) );
	self RadiusDamage( self.origin, 200, 10000, 10000, self );

	self DisableInvulnerability();

	self maps\_zombietron_pickups::turn_shield_on( true );
}

//tank buy stuff
tank_press_to_give()
{
	// this needs a heli cheak, if you have heli, take it away and replace it with this. other wise...idk what will happen...
	self iprintln("Press ^3l^7 To Give Tank");
	self.tank_cooldown = 0;
	self.tank_cooldown_cheak = true;
	self.has_tank = true;
	if(self.has_heli == true)
	{
		self iprintln("You no longer have the Heli");
		self.has_heli = false;
	}
	while(1)
	{
		// cool down
		if(self.has_tank == true && self.tank_cooldown < 1200 && self.tank_cooldown_cheak == false)
		{
			self.tank_cooldown++;
		}
		else if (self.has_tank == true && self.tank_cooldown >= 1200 && self.tank_cooldown_cheak == false)
		{
			self.tank_cooldown_cheak = true;
		}
		
		//the press to give
		if(self buttonPressed("l") && self.has_tank == true && self.tank_cooldown_cheak == true && !self.usingvehicle)
		{
			self thread give_tank(self);
			self.tank_cooldown_cheak = false;
			self.tank_cooldown = -1200;
		}
		else if (self buttonPressed("l") && self.has_tank == true && self.tank_cooldown_cheak == false)
		{
			self iprintln("You are on cool down!");
		}
		wait 0.05;
	}
}

give_tank( pickup )
{
	set_zombie_var( "tank_alive_time_buy", 60 ); //this is set to 5 for testing
	
	self EnableInvulnerability();

	origin = maps\_zombietron_pickups::push_origin_out( pickup.origin, 30 );

	tank = SpawnVehicle( "t5_veh_tank_t55_mini", "player_tank", "tank_t55_mini", origin, self.angles );
	tank.health = 100000;
	tank MakeVehicleUsable();
	tank UseBy( self );
	tank MakeVehicleUnusable();
	tank.takedamage = false;
	self.tank 	= tank;
	tank.player = self;
	tank maps\_vehicle::turret_attack_think();
	//give the tank your color
	PlayFxOnTag( level._effect[self.light_playFX], tank, "tag_origin" ); 

	time_left = level.zombie_vars["tank_alive_time_buy"];
	if ( isDefined(self.fate_fortune) )
	{
		time_left *= level.zombie_vars["fate_fortune_drop_mod"];
	}
	self notify("veh_activated");
	tank thread maps\_zombietron_pickups::veh_chicken_watcher();
	self thread maps\_zombietron_pickups::tank_outofworld_watcher();
	self waittill_any_or_timeout( time_left, "disconnect", "tank_abort" );
	self iprintln("Cool Down Started!");
	self notify( "veh_done" );

	self.tank = undefined;
	if( self.usingvehicle )	// just in case lets make sure we are in a vehicle
	{
		tank MakeVehicleUsable();
		tank UseBy( self );
	}
	tank Delete();

	if( IsDefined(self.aborted_tank) )
	{
		self.aborted_tank = undefined;
		origin = maps\_zombietron_main::get_player_spawn_point();
		above = origin + (0,0,100);
		below = origin + (0,0,-100);
		hitp = PlayerPhysicsTrace( above, below );
		self SetOrigin( hitp );
	}


	PlayFx( level._effect["respawn"], self.origin, AnglesToForward(self.angles) );
	self RadiusDamage( self.origin, 200, 10000, 10000, self );

	self DisableInvulnerability();

	self maps\_zombietron_pickups::turn_shield_on( true );
}

has_weapon( weaponname )
{
	has_weapon = self getCurrentWeapon();
	
	return has_weapon;
}

//giving a gun

weapon_give( weapon )
{

	current_weapon = self getCurrentWeapon();
	self TakeWeapon( current_weapon );
	self GiveWeapon( weapon );
	new_default = weapon;
	self.default_weap = new_default;
	//self SwitchToWeapon( weapon );
}

minus_to_player_score( points )
{
	if( !IsDefined( points ))
	{
		return;
	}

	self.score -= points; 

	// also set the score onscreen
	self set_player_score_hud(); 
}