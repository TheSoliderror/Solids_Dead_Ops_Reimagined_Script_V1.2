#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombietron_utility;
#include maps\_zombietron_score;

perks_init()
{	
	//this will allow no texture icon to be called
	PrecacheShader( "specialty_juggernaut_zombies_pro" );
	
	//for beta test, add every perk to all rooms.
	// you can edit area lives as basicly a life buy for right now ig.
	//prison
	//-2521.05, -5189, -51.875 //this is wrong and out of map maybe new one will work??
	//-2829.79, -6056.56, -51.875
	level thread perk_machine( (-2829.79, -5189, -51.875), (0, 0, 0), "p_glo_electrical_insulator01","Jugg",25000 , "perk_jugg" ); //jugg-ish
	level thread perk_machine( (-2829.79, -6056.56, -51.875), (0, 0, 0), "p_glo_electrical_insulator01","Normalness",10000 , "perk_norm" ); //normal controls
	//bull run
	//-2342.87, -3084.03, -43.875
	//-2506.33, -2135.64, -43.6581
	level thread perk_machine( (-2506.33, -2135.64, -43.6581), (0, 0, 0), "p_glo_electrical_insulator01","Jugg",25000 , "perk_jugg" ); //jugg-ish
	level thread perk_machine( (-2342.87, -3084.03, -43.875), (0, 0, 0), "p_glo_electrical_insulator01","Normalness",10000 , "perk_norm" ); //normal controls
	//court yard
	//-581.359, 489.725, -84.875 //this is wrong, idk where this is, but I think i forgot a - in middle cord
	//100.359, -1460.41, -84.875
	level thread perk_machine( (-581.359, -489.725, -84.875), (0, 0, 0), "p_glo_electrical_insulator01","Jugg",25000 , "perk_jugg" ); //jugg-ish
	level thread perk_machine( (100.359, -1460.41, -84.875), (0, 0, 0), "p_glo_electrical_insulator01","Normalness",10000 , "perk_norm" ); //normal controls
	//Russian court yard
	//3829.1, 1153.16, -107.875
	//4153.13, 1142.3, -107.875
	level thread perk_machine( (4153.13, 1142.3, -107.875), (0, 0, 0), "p_glo_electrical_insulator01","Jugg",25000 , "perk_jugg" ); //jugg-ish
	level thread perk_machine( (3829.1, 1153.16, -107.875), (0, 0, 0), "p_glo_electrical_insulator01","Normalness",10000 , "perk_norm" ); //normal controls
	//Slums
	//-48.117, -4408.31, 46.325
	//-723.067, -4158.04, 38.325
	level thread perk_machine( (-48.117, -4408.31, 46.325), (0, 0, 0), "p_glo_electrical_insulator01","Jugg",25000 , "perk_jugg" ); //jugg-ish
	level thread perk_machine( (-723.067, -4158.04, 38.325), (0, 0, 0), "p_glo_electrical_insulator01","Normalness",10000 , "perk_norm" ); //normal controls
	//Rooftop
	//-8372.36, 1669.32, 0.125
	//-8306.09, 1228.01, 0.125
	level thread perk_machine( (-8372.36, 1669.32, 0.125), (0, 0, 0), "p_glo_electrical_insulator01","Jugg",25000 , "perk_jugg" ); //jugg-ish
	level thread perk_machine( (-8306.09, 1228.01, 0.125), (0, 0, 0), "p_glo_electrical_insulator01","Normalness",10000 , "perk_norm" ); //normal controls
	//sapwn
	level thread perk_machine( (-7902.41, -2663.33, -109.964), (0, 0, 0), "p_glo_electrical_insulator01","Jugg",25000 , "perk_jugg" ); //jugg-ish
	level thread perk_machine( (-8279.62, -2625.19, -109.964), (0, 0, 0), "p_glo_electrical_insulator01","Normalness",10000 , "perk_norm" ); //normal controls
	//level thread perk_machine( (-8269.18, -2981.31, -109.964), (0, 0, 0), "p_glo_electrical_insulator01","Survivor",50 , "perk_arealives" ); //add 1 life after each area
	//change the price before release
	
}

perk_machine( origin, angles, model_name, perk_name, cost, perk) 
{
    collision = spawn("script_model", ( (origin[0]), (origin[1]), (origin[2] + 50)) ); 
    collision setModel("collision_geo_32x32x128");
    collision rotateTo(angles, .1);
    collision hide();
    vender_perk = spawn( "script_model", origin );
    vender_perk setModel( model_name );
    vender_perk rotateTo(angles, .1);
    trig = spawn("trigger_radius", origin, 1, 25, 25);
    trig SetCursorHint( "HINT_NOICON" );
    trig setHintString("Press ^3&&1^7 to Buy  "+ perk_name +" [Cost: "+ cost +"]");  
	trig thread perk_think(perk, cost);
}

perk_think(perk, cost)
{
	for(;;)
	{
		self waittill("trigger", player);

		has_perk_bottle = player HasWeapon("zombie_perk_bottle_revive"); //incase players accidentally press the use key twice, prevents dupe purchase
		
		if(perk == "perk_jugg" && player.jugg == false && (player.score >= cost) || 
		perk == "perk_norm" && player.norm == false && (player.score >= cost))
		{	
			if(player useButtonPressed())
			{
				while( player UseButtonPressed() )
				{
					wait 0.05;
				}
				player minus_to_player_score( cost );
				player give_tron_perk(perk);
				player perk_hud_create(perk);
				playsoundatposition("zmb_fate_choose", self.origin);//zmb_1st_vox_00
				//player playSound("zmb_player_shield_half");
			}	
		}
		else
		{
			if(player useButtonPressed())
			{
				while( player UseButtonPressed() )
				{
					wait 0.05;
				}
				player playsound("zmb_fate_spawn");
			}
		}
	}
}

give_tron_perk(perk)
{
	
	switch( perk )
	{
	case "perk_jugg":
		self.jugg = true;
		//self SetMaxHealth(600); //2 hits
		self SetMaxHealth(1100); //3 hits
		break;
	case "perk_norm":
		self.norm = true;
		self AllowJump( true );
		self AllowCrouch( true );
		self AllowSprint( true );
		break;
	default:
		break;
	//case "perk_arealives":
	//	self.arealives = true;
	//	self thread scripts\sp\zombietron\area_lives::area_lives_think(); //need to keep an eye on this
	//	break;
	}
}

perk_cheak()
{
	while(1)
	{
		players = GetPlayers();	
		for(i = 0; i < players.size; i ++)
		{
			if( players[i].health < 0 )
			{
				players[i].jugg = false;
				players[i] thread perk_hud_destroy("perk_jugg");


				players[i].norm = false;
				players[i] AllowJump( false );
				players[i] AllowCrouch( false );
				players[i] AllowSprint( false );
				players[i] thread perk_hud_destroy("perk_norm");

				//players[i] iPrintLn("You have died!");
			}
		}
		
		wait 0.05;
	}
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


perk_hud_create( perk )
{
	if ( !IsDefined( self.perk_hud ) )
	{
		self.perk_hud = [];
	}

	shader = "specialty_juggernaut_zombies_pro";

	hud = create_simple_hud( self );
	hud.foreground = true; 
	hud.sort = 1; 
	hud.hidewheninmenu = false; 
	hud.alignX = "left"; 
	hud.alignY = "bottom";
	hud.horzAlign = "user_left"; 
	hud.vertAlign = "user_bottom";
	hud.x = self.perk_hud.size * 30; 
	hud.y = hud.y - 70; 
	hud.alpha = 1;
	hud SetShader( shader, 24, 24 );

	self.perk_hud[ perk ] = hud;
	//color
	switch( perk )
	{
	case "perk_jugg":
		self.perk_hud["perk_jugg"].color  = (255,0,0);
		break;
	case "perk_norm":
		self.perk_hud["perk_norm"].color  = (250,240,230);
		break;
	case "perk_arealives":
		self.perk_hud["perk_arealives"].color  = (0,0,230);
		break;
	}
}

perk_hud_destroy( perk )
{
	self.perk_hud[ perk ] destroy_hud();
	self.perk_hud[ perk ] = undefined;
}