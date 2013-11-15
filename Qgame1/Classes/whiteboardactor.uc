class whiteboardactor extends kactorspawnable;


DefaultProperties
{

begin object name=staticmeshcomponent0
		//StaticMesh=StaticMesh'demo_asset.whiteboard'
		staticmesh=StaticMesh'demo_asset.Master_Cube'
		materials(0)= Material'demo_asset.whiteboard_material'
		scale3d = (x=5.0, y=0.5, z=6.0)
		LightEnvironment=MyLightEnvironment
		BlockRigidBody=false
		BlockZeroExtent=false
		RBChannel=RBCC_GameplayPhysics
		RBCollideWithChannels=(Default=false,BlockingVolume=false,GameplayPhysics=false,EffectPhysics=false)
		end object

	
	bnodelete=false
	bWakeOnLevelStart=true
	Physics=PHYS_none





}
