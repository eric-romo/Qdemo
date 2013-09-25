class QPawn extends UTPawn
	config(Game)
	notplaceable;

//testing hydra arm motion code - begin
/*
var QPlayerController ThePlayerController;
var SkelControlSingleBone RightHand, LeftHand;
var SkelControlLimb RightArm, LeftArm;
//var float CamOffsetDistance;
//var int IsoCamAngle;

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	super.PostInitAnimTree(SkelComp);
	RightHand = SkelControlSingleBone(mesh.FindSkelControl('RightHand'));
	LeftHand = SkelControlSingleBone(mesh.FindSkelControl('LeftHand'));
	RightArm = SkelControlLimb(mesh.FindSkelControl('RightArm'));
	LeftArm = SkelControlLimb(mesh.FindSkelControl('LeftArm'));
	LeftLegControl = SkelControlFootPlacement(Mesh.FindSkelControl(LeftFootControlName));
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
	FlyingDirOffset = AnimNodeAimOffset( mesh.FindAnimNode('FlyingDirOffset') );
}


simulated event TickSpecial(float DeltaTime)
{
	local rotator TempRotation;
	local vector RightArmLocation, LeftArmLocation, SocketLocation, JointDirection;
	super.TickSpecial(DeltaTime);

	JointDirection = vect(-50,0,-50);

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

*/
//end hydra arm motion code


DefaultProperties
{
/*	bScriptTickSpecial = true
	
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
		// To change pawn's mesh, go to HXFamilyInfo_PC
		AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.HX_FreeArms_2'
		bCacheAnimSequenceNodes=FALSE
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		bOwnerNoSee=true
		CastShadow=true
		BlockRigidBody=TRUE
		bUpdateSkelWhenNotRendered=false
		bIgnoreControllersWhenNotRendered=TRUE
		bUpdateKinematicBonesFromAnimation=true
		bCastDynamicShadow=true
		Translation=(Z=8.0)
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
		Scale = 100.0
		// Scale=1.075
		// Nice lighting for hair
		bUseOnePassLightingOnTranslucency=TRUE
		bPerBoneMotionBlur=true
	End Object
	Mesh=WPawnSkeletalMeshComponent
	Components.Add(WPawnSkeletalMeshComponent)
	*/
	/*

	Components.Remove(WPawnSkeletalMeshComponent)
	Begin Object Class=SkeletalMeshComponent Name=HeadSkeletalMeshComponent 
		SkeletalMesh=SkeletalMesh'PLAYERMODEL_VR.UT3_MALE_HEAD'
		AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.HX_FreeArms_2'
		PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
		// PhysicsAsset=PhysicsAsset'PLAYERMODEL_VR.UT3_MALE_HEAD_Physics'
		bCacheAnimSequenceNodes=FALSE
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		bOwnerNoSee=true
		CastShadow=true
		BlockRigidBody=TRUE
		bUpdateSkelWhenNotRendered=false
		bIgnoreControllersWhenNotRendered=TRUE
		bUpdateKinematicBonesFromAnimation=true
		bCastDynamicShadow=true
		Translation=(Z=8.0)
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
		Scale = 1.2
		// Scale=1.075
		// Nice lighting for hair
		bUseOnePassLightingOnTranslucency=TRUE
		bPerBoneMotionBlur=true
	End Object
	HeadSkeletalMesh=HeadSkeletalMeshComponent
	Components.Add(HeadSkeletalMeshComponent)

	Begin Object Class=SkeletalMeshComponent Name=TorsoSkeletalMeshComponent  
		SkeletalMesh=SkeletalMesh'PLAYERMODEL_VR.UT3_MALE_BASE'
		// AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.HX_FreeArms_2'
		// PhysicsAsset=PhysicsAsset'PLAYERMODEL_VR.UT3_MALE_BASE_Physics'
		bCacheAnimSequenceNodes=FALSE
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		bOwnerNoSee=false
		CastShadow=true
		BlockRigidBody=TRUE
		bUpdateSkelWhenNotRendered=false
		bIgnoreControllersWhenNotRendered=TRUE
		bUpdateKinematicBonesFromAnimation=true
		bCastDynamicShadow=true
		Translation=(Z=8.0)
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
		Scale = 1.2
		// Scale=1.075
		// Nice lighting for hair
		bUseOnePassLightingOnTranslucency=TRUE
		bPerBoneMotionBlur=true
		ParentAnimComponent=HeadSkeletalMeshComponent
		ShadowParent=HeadSkeletalMeshComponent
	End Object
	TorsoSkeletalMesh=TorsoSkeletalMeshComponent
	Components.Add(TorsoSkeletalMeshComponent)

	Begin Object Class=SkeletalMeshComponent Name=ShoulderPadSkeletalMeshComponent
		SkeletalMesh=SkeletalMesh'PLAYERMODEL_VR.UT3_MALE_SHOULDERS'
		// AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.HX_FreeArms_2'
		// PhysicsAsset=PhysicsAsset'PLAYERMODEL_VR.UT3_MALE_SHOULDERS_Physics'
		bCacheAnimSequenceNodes=FALSE
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		bOwnerNoSee=true
		CastShadow=true
		BlockRigidBody=TRUE
		bUpdateSkelWhenNotRendered=false
		bIgnoreControllersWhenNotRendered=TRUE
		bUpdateKinematicBonesFromAnimation=true
		bCastDynamicShadow=true
		Translation=(Z=8.0)
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
		Scale = 1.2
		// Scale=1.075
		// Nice lighting for hair
		bUseOnePassLightingOnTranslucency=TRUE
		bPerBoneMotionBlur=true
		ParentAnimComponent=HeadSkeletalMeshComponent
		ShadowParent=HeadSkeletalMeshComponent
	End Object
	ShoulderPadSkeletalMesh=ShoulderPadSkeletalMeshComponent
	Components.Add(ShoulderPadSkeletalMeshComponent)

	Begin Object Class=SkeletalMeshComponent Name=LeftHandSkeletalMeshComponent
		SkeletalMesh=SkeletalMesh'PLAYERMODEL_VR.UT3_MALE_LHAND'
		// AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.HX_FreeArms_2'
		// PhysicsAsset=PhysicsAsset'PLAYERMODEL_VR.UT3_MALE_LHAND_Physics'
		bCacheAnimSequenceNodes=FALSE
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		bOwnerNoSee=false
		CastShadow=true
		BlockRigidBody=TRUE
		bUpdateSkelWhenNotRendered=false
		bIgnoreControllersWhenNotRendered=TRUE
		bUpdateKinematicBonesFromAnimation=true
		bCastDynamicShadow=true
		Translation=(Z=8.0)
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
		Scale = 1.2
		// Scale=1.075
		// Nice lighting for hair
		bUseOnePassLightingOnTranslucency=TRUE
		bPerBoneMotionBlur=true
		ParentAnimComponent=HeadSkeletalMeshComponent
		ShadowParent=HeadSkeletalMeshComponent
	End Object
	LeftHandSkeletalMesh=LeftHandSkeletalMeshComponent
	Components.Add(LeftHandSkeletalMeshComponent)


*/

	
	
	Begin Object Name=CollisionCylinder
		CollisionRadius=+001.000000
		CollisionHeight=+044.000000
	End Object
	CylinderComponent=CollisionCylinder
	
	
	baseeyeheight = 21;
	JumpZ=0.0
	//AccelRate=0.0


}
