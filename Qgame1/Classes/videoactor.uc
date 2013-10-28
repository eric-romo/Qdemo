class videoactor extends kactorspawnable;

DefaultProperties
{
	begin object name=staticmeshcomponent0
		StaticMesh=StaticMesh'demo_asset.Whole_mirror_Glass'
		materials(0)= Material'demo_asset.movie_material'
		scale3d = (x=24.0, y=1.0, z=13.5)
		LightEnvironment=MyLightEnvironment
		BlockRigidBody=false
		BlockZeroExtent=false
		end object

	bnodelete=false
	bWakeOnLevelStart=true
	Physics=PHYS_none



}
