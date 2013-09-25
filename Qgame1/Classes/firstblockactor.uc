class firstblockactor extends kactorspawnable;

/*event untouch(actor other)
{
	super.untouch(other);
	other.SetPhysics(PHYS_rigidbody);
}*/

DefaultProperties
{

	begin object name=staticmeshcomponent0
		StaticMesh=StaticMesh'demo_asset.TexPropCube3'
		scale3d = (x=0.15, y=0.15, z=0.15)
		end object

	CollisionComponent=StaticMeshComponent0
	
	bnodelete=false
	bWakeOnLevelStart=true
	
	


}
