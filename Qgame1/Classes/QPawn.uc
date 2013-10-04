class QPawn extends UTPawn
	config(Game)
	notplaceable;

//testing hydra arm motion code - begin

var QPlayerController ThePlayerController;
var SkelControlSingleBone RightHand, LeftHand;
var SkelControlLimb RightArm, LeftArm;
var bool bmeshsetyet;
//var float CamOffsetDistance;
//var int IsoCamAngle;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	ThePlayerController = QPlayerController(GetALocalPlayerController());

	//code to fix flying pawn?
	if (!bDeleteMe)
	{
		if (Mesh != None)
		{
			BaseTranslationOffset = Mesh.Translation.Z;
			CrouchTranslationOffset = Mesh.Translation.Z + CylinderComponent.CollisionHeight - CrouchHeight;
			OverlayMesh.SetParentAnimComponent(Mesh);
		}
	}

}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	super.PostInitAnimTree(SkelComp);
	
	//beta code for arm control
	RightArm = SkelControlLimb(mesh.FindSkelControl('RightForeArm'));
	LeftArm = SkelControlLimb(mesh.FindSkelControl('LeftForeArm'));

	RightHand = SkelControlSingleBone(mesh.FindSkelControl('RightHand'));
	LeftHand = SkelControlSingleBone(mesh.FindSkelControl('LeftHand'));
/*	existing code for arm control
 *	
 *  RightArm = SkelControlLimb(mesh.FindSkelControl('RightArm'));
	LeftArm = SkelControlLimb(mesh.FindSkelControl('LeftArm'));
*/

/*	LeftLegControl = SkelControlFootPlacement(Mesh.FindSkelControl(LeftFootControlName));
	RightLegControl = SkelControlFootPlacement(Mesh.FindSkelControl(RightFootControlName));
	FeignDeathBlend = AnimNodeBlend(Mesh.FindAnimNode('FeignDeathBlend'));
	FullBodyAnimSlot = AnimNodeSlot(Mesh.FindAnimNode('FullBodySlot'));
	TopHalfAnimSlot = AnimNodeSlot(Mesh.FindAnimNode('TopHalfSlot'));
	RootRotControl = SkelControlSingleBone( mesh.FindSkelControl('RootRot') );
	AimNode = AnimNodeAimOffset( mesh.FindAnimNode('AimNode') );
	GunRecoilNode = GameSkelCtrl_Recoil( mesh.FindSkelControl('GunRecoilNode') );
	LeftRecoilNode = GameSkelCtrl_Recoil( mesh.FindSkelControl('LeftRecoilNode') );
	RightRecoilNode = GameSkelCtrl_Recoil( mesh.FindSkelControl('RightRecoilNode') );
	DrivingNode = UTAnimBlendByDriving( mesh.FindAnimNode('DrivingNode') );
	VehicleNode = UTAnimBlendByVehicle( mesh.FindAnimNode('VehicleNode') );
	HoverboardingNode = UTAnimBlendByHoverboarding( mesh.FindAnimNode('Hoverboarding') );
	FlyingDirOffset = AnimNodeAimOffset( mesh.FindAnimNode('FlyingDirOffset') );*/
}


simulated event TickSpecial(float DeltaTime)
{
	local rotator TempRotation;
	local vector RightArmLocation, LeftArmLocation, SocketLocation, JointDirection;
	super.TickSpecial(DeltaTime);

	JointDirection = vect(-50,0,-50);
	
	if (bmeshsetyet == false)
		{setmeshvisibility(true);
		bmeshsetyet = true;}

	if(ThePlayerController.TheSixense.calibrated)
	{
		
		TempRotation.Yaw = Rotation.Yaw;

		RightHand.BoneRotation = QuatToRotator(ThePlayerController.TheSixense.altControllerData.Controller[1].Quat_rot) + TempRotation;
		LeftHand.BoneRotation = QuatToRotator(ThePlayerController.TheSixense.altControllerData.Controller[0].Quat_rot) + TempRotation;

		RightArmLocation = ThePlayerController.TheSixense.altControllerData.Controller[1].vector_Pos >> TempRotation;
		LeftArmLocation = ThePlayerController.TheSixense.altControllerData.Controller[0].vector_Pos >> TempRotation;

		if(bIsCrouched) RightArmLocation.Z -= CrouchHeight * 0.5;
		RightArm.EffectorLocation = RightArmLocation + Location;
		Mesh.GetSocketWorldLocationAndRotation('WeaponPoint',SocketLocation);
		RightArm.JointTargetLocation = TransformVectorByRotation(RightHand.BoneRotation, JointDirection) + SocketLocation;

		if(bIsCrouched) LeftArmLocation.Z -= CrouchHeight * 0.5;
		LeftArm.EffectorLocation = LeftArmLocation + Location;
		Mesh.GetSocketWorldLocationAndRotation('DualWeaponPoint',SocketLocation);
		LeftArm.JointTargetLocation = TransformVectorByRotation(LeftHand.BoneRotation, JointDirection) + SocketLocation;
	
	}


}


//end hydra arm motion code


DefaultProperties
{
	

	
	bScriptTickSpecial = true
	
	Begin Object Name=MyLightEnvironment
		bSynthesizeSHLight=TRUE
		bIsCharacterLightEnvironment=TRUE
		bUseBooleanEnvironmentShadowing=FALSE
		InvisibleUpdateTime=1
		MinTimeBetweenFullUpdates=.2
	End Object
	Components.Add(MyLightEnvironment)
	
	Components.Remove(WPawnSkeletalMeshComponent)
	Begin Object Name=WPawnSkeletalMeshComponent
		AnimTreeTemplate=AnimTree'demo_asset.HX_FreeArms_3'  //_2 is the default
		bCacheAnimSequenceNodes=FALSE
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
	//	bOwnerNoSee=false
		CastShadow=true
		BlockRigidBody=TRUE
		bUpdateSkelWhenNotRendered=true
		bIgnoreControllersWhenNotRendered=TRUE
		bUpdateKinematicBonesFromAnimation=true
		bCastDynamicShadow=true
	//	Translation=(Z=-50.0)
	//	translation=(x=30.0)
		RBChannel=RBCC_Untitled3
		RBCollideWithChannels=(Untitled3=true)
		LightEnvironment=MyLightEnvironment
		bOverrideAttachmentOwnerVisibility=true
		bAcceptsDynamicDecals=FALSE
		bHasPhysicsAssetInstance=true
		TickGroup=TG_PreAsyncWork
		MinDistFactorForKinematicUpdate=0.2
		bChartDistanceFactor=true
		//bSkipAllUpdateWhenPhysicsAsleep=TRUE
		RBDominanceGroup=20
	//	Scale3D=(X=0.50,Y=0.50,Z=0.50)
		//Scale = 10.0 //was 100
		// Scale=1.075
		// Nice lighting for hair
		bUseOnePassLightingOnTranslucency=TRUE
		bPerBoneMotionBlur=true
	End Object
	Mesh=WPawnSkeletalMeshComponent
	Components.Add(WPawnSkeletalMeshComponent)
 
 
	Begin Object Name=CollisionCylinder
		CollisionRadius=+010.000000
		CollisionHeight=+44.000000
	End Object
	CylinderComponent=CollisionCylinder
	

	bmeshsetyet = false;
	baseeyeheight = 27; // was21...want to net ~27, but accomodating for crouch
	CrouchHeight=45.0
	JumpZ=0.0
	//AccelRate=0.0

	

}
