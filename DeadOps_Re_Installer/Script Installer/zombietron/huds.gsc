#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombietron_utility;
#include maps\_zombietron_score;

hud_init()
{	
	level thread upon_player_connection(); //set up health hud
	thread zombiesleft_hud(); // setup counter
}

upon_player_connection() //this is all first person stuff
{
	for(;;)
	{
		level waittill("connecting", player); // looks for connecting players
		player thread health_hud();
	}
}

zombiesleft_hud() // zombies left function
{   
	Remaining = create_simple_hud();
  	Remaining.horzAlign = "center";
  	Remaining.vertAlign = "middle";
   	Remaining.alignX = "Left";
   	Remaining.alignY = "middle";
   	Remaining.y = 193;
   	Remaining.x = 37.5;
   	Remaining.foreground = 1;
   	Remaining.fontscale = 1.35;
   	Remaining.alpha = 1;
   	//Remaining.color = ( 0.423, 0.004, 0 );


   	ZombiesLeft = create_simple_hud();
   	ZombiesLeft.horzAlign = "center";
   	ZombiesLeft.vertAlign = "middle";
   	ZombiesLeft.alignX = "center";
   	ZombiesLeft.alignY = "middle";
   	ZombiesLeft.y = 193;
   	ZombiesLeft.x = -1;
   	ZombiesLeft.foreground = 1;
   	ZombiesLeft.fontscale = 1.35;
   	ZombiesLeft.alpha = 1;
   	//ZombiesLeft.color = ( 0.423, 0.004, 0 );
   	ZombiesLeft SetText("^1Zombies Left: ");

	while(1)
	{
		remainingZombies = get_enemy_count() + level.zombie_total;
		Remaining SetValue(remainingZombies);

		if(remainingZombies == 0 )
			{
			Remaining.alpha = 0; 
			while(1)
				{
					remainingZombies = get_enemy_count() + level.zombie_total;
					if(remainingZombies != 0 )
					{
					Remaining.alpha = 1; 
					break;
					}
					wait 0.5;
				}
			}
		wait 0.5;
	}		
}

get_enemy_count() //this is needed sense dead ops doesnt have it
{
	enemies = [];
	valid_enemies = [];
	enemies = GetAiSpeciesArray( "axis", "all" );
	for( i = 0; i < enemies.size; i++ )
	{
		if ( is_true( enemies[i].ignore_enemy_count ) )
		{
			continue;
		}

		if( isDefined( enemies[i].animname ) )
		{
			valid_enemies = array_add( valid_enemies, enemies[i] );
		}
	}
	return valid_enemies.size;
}


//health hud
health_hud()
{   
	self endon( "disconnect" );
	level endon("game_ended");
	
   	health = create_simple_hud(self); //health value
   	health.horzAlign = "center";
   	health.vertAlign = "top";
   	health.alignX = "center";
   	health.alignY = "top";
   	health.y = 22;
   	health.x = -1;
   	health.foreground = 1;
   	health.fontscale = 1.25;
   	health.alpha = 1;
	health.hidewheninmenu = 1;
   	health.color = ( 0.49, 0, 0 );

    health_text = create_simple_hud(self); //health text
   	health_text.horzAlign = "center";
   	health_text.vertAlign = "top";
   	health_text.alignX = "center";
   	health_text.alignY = "top";
   	health_text.y = 5;
   	health_text.x = -1;
   	health_text.foreground = 1;
   	health_text.fontscale = 1.25;
   	health_text.alpha = 1;
	health_text.hidewheninmenu = 1;
    health_text SetText("Health");
	
	while(1)
	{
		health SetValue(self.health);
		wait 0.05;
	}
	
}

//this is for new zombietron hud, this is not done, also make sure to chnage the shaders as they are not correct. 
//needs to destroy og hud, and then you must keep the hud updated!
tron_hud()
{
	//shader icon for lives 
	tronhudLs = create_simple_hud(self);
	tronhudLs.alignX = "right"; 
	tronhudLs.alignY = "bottom";
	tronhudLs.horzAlign = "user_right"; 
	tronhudLs.vertAlign = "user_bottom";
   	tronhudLs.y = -125;
   	tronhudLs.x = -1;
   	tronhudLs.foreground = 1;
   	tronhudLs.alpha = 1;
	tronhudLs.hidewheninmenu = 1;
	tronhudLs SetShader( "zom_icon_player_life" );
	//add the life text hud here  self.revives = self.lives;
	
	//nukes shader
	tronhudNs = create_simple_hud(self);
	tronhudNs.alignX = "right"; 
	tronhudNs.alignY = "bottom";
	tronhudNs.horzAlign = "user_right"; 
	tronhudNs.vertAlign = "user_bottom";
   	tronhudNs.y = -125;
   	tronhudNs.x = -1;
   	tronhudNs.foreground = 1;
   	tronhudNs.alpha = 1;
	tronhudNs.hidewheninmenu = 1;
	tronhudNs SetShader( "zom_icon_player_life" );
	//nukes text here  	self.assists = self.bombs;

	
	//zoom shader
	tronhudZs = create_simple_hud(self);
	tronhudZs.alignX = "right"; 
	tronhudZs.alignY = "bottom";
	tronhudZs.horzAlign = "user_right"; 
	tronhudZs.vertAlign = "user_bottom";
   	tronhudZs.y = -125;
   	tronhudZs.x = -1;
   	tronhudZs.foreground = 1;
   	tronhudZs.alpha = 1;
	tronhudZs.hidewheninmenu = 1;
	tronhudZs SetShader( "zom_pack_a_punch_battery_icon" );
	//add zoom text here   self.downs	 = self.boosters;

	//add point hud from norm zom, make sure to track all players
	
}
