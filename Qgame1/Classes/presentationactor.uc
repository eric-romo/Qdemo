class presentationactor extends kactorspawnable;

DefaultProperties
{

begin object name=staticmeshcomponent0
		StaticMesh=StaticMesh'demo_asset.Whole_mirror_Glass'
		materials(0)= Material'demo_asset.slideshow1_mat'
		scale3d = (x=15.0, y=5.0, z=5.0)
		LightEnvironment=MyLightEnvironment
		BlockRigidBody=false
		BlockZeroExtent=false
		end object

	
	bnodelete=false
	bWakeOnLevelStart=true
	Physics=PHYS_none


}
