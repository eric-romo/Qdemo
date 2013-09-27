class QDemoGame extends UTGame
config(game);


static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
	return Default.Class;
}
// this sets this game class as default - needed to compile correctly in "play on PC"


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

}
