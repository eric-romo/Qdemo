class QDemoGame extends UTGame
config(game);

var playerstart mostrecentstart;


static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
	return Default.Class;
}
// this sets this game class as default - needed to compile correctly in "play on PC"


function PlayerStart ChoosePlayerStart( Controller Player, optional byte InTeam )
{
	local PlayerStart P, BestStart;
	
	foreach WorldInfo.AllNavigationPoints(class'PlayerStart', P)
	{
		if (p != mostrecentstart)
			BestStart = P;
	}
	
	
	`log("starting at: " $ beststart.Name);
	mostrecentstart = beststart;
	return BestStart;
	
}


DefaultProperties
{

Acronym = "QU"
MapPrefixes[0] = "QU"

bGivePhysicsGun=false //don't need a gun
DefaultInventory(0)=none //don't need a gun
buseclassicHUD=true //get rid of the HUD
HUDType=none //get rid of the HUD

PlayerReplicationInfoClass=class'QPlayerReplicationInfo'
DefaultPawnClass=class'QPawn' //set custom pawn class 
PlayerControllerClass=class'QPlayerController'

bQuickStart = true

}
