class LHandPawn extends kactorspawnable;

Simulated Event PostBeginPlay() {
	
	super.postbeginplay();
   ( StaticMeshComponent.GetRootBodyInstance() ).CustomGravityFactor = 0;
}


simulated function changecolor(bool colorchoice)
	{

	
		if (colorchoice)
		{staticmeshcomponent.SetMaterial(0,Material'ExampleMap_Resources.Translucent_Red');}

		if (!colorchoice)
		{staticmeshcomponent.SetMaterial(0,Material'demo_asset.Materials.test_mat2');}
	

	}


event untouch(actor other)
{
	super.untouch(other);
	if (other.Class != class'whiteboardactor')
		other.SetPhysics(PHYS_rigidbody);
}

defaultproperties
{


    Begin Object Name=staticmeshcomponent0
	StaticMesh=StaticMesh'demo_asset.TexPropSphere3'
	materials(0)= Material'demo_asset.Materials.test_mat2'
	LightEnvironment=MyLightEnvironment
	BlockRigidBody=false
	BlockZeroExtent=false
	hiddengame=false
	ScriptRigidBodyCollisionThreshold=0.001 
	RBChannel=RBCC_GameplayPhysics
	RBCollideWithChannels=(Default=false,BlockingVolume=false,GameplayPhysics=false,EffectPhysics=false)
  End Object

	drawscale = 0.01
	bBlockActors=false
	bcollideworld=false
	bstatic=false
	bnodelete=false
	bnoencroachcheck=false
	bWakeOnLevelStart=true
	MaxPhysicsVelocity=0.0
	Physics=PHYS_none

	
	
}

