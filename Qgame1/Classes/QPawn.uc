class QPawn extends UTPawn
	config(Game)
	notplaceable;

//testing hydra arm motion code - begin

var QPlayerController ThePlayerController;
var SkelControlSingleBone RightHand, LeftHand, head;
var SkelControlLimb RightArm, LeftArm;

var repnotify vector RightArmLocation, LeftArmLocation, SocketLocation,  headposition;
var repnotify bool blimbsmoving;
var repnotify rotator righthandrotation, headrotation, lefthandrotation;



replication
	{
		if (bnetdirty)
			blimbsmoving, righthandrotation, rightarmlocation, socketlocation, LeftArmLocation, headposition, headrotation, lefthandrotation;
	}

simulated event ReplicatedEvent(name VarName)
{
    `log(VarName @ "replicated");
    if (VarName == 'blimbsmoving')
    {
    	armsandheadmove();
    	`log("armsmove replicated");
    }
    else
    {
    	//Super.ReplicatedEvent(VarName);
    }

	Super.ReplicatedEvent(VarName);
}


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	ThePlayerController = QPlayerController(GetALocalPlayerController());

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
	
	
	if (skelcomp == mesh)
	{
	RightArm = SkelControlLimb(mesh.FindSkelControl('RightForeArm'));
	LeftArm = SkelControlLimb(mesh.FindSkelControl('LeftForeArm'));

	RightHand = SkelControlSingleBone(mesh.FindSkelControl('RightHand'));
	LeftHand = SkelControlSingleBone(mesh.FindSkelControl('LeftHand'));
	head = skelcontrolsinglebone(mesh.FindSkelControl('HeadControl'));
	}
}


simulated event TickSpecial(float DeltaTime)
{
	
	super.TickSpecial(DeltaTime);
//	armsandheadmove();  //putting this in here seems to increase body movement...not sure if I want this

}





simulated function armsandheadmove()
{
	local vector jointdirection, jointdirectionL;


	//JointDirection = vect(-50,0,-50);  //uncomment for UDK skel
	//jointdirectionL = vect(-50,0,50); //uncomment for UDK skel
	jointdirectionL = vect(-50,0,-50);
	JointDirection = vect(50,0,-50);
	
		RightHand.BoneRotation = righthandrotation;
		LeftHand.BoneRotation = lefthandrotation;
		//lefthand.BoneRotation.Roll = lefthand.BoneRotation.Roll + 32750;  //left hand axes are rotated 180deg //uncomment for UDK skel
		righthand.BoneRotation.yaw = righthand.BoneRotation.yaw + 32750;    //remove for UDK skel
		righthand.BoneRotation.roll = -righthand.BoneRotation.roll; //remove for UDK skel
		righthand.BoneRotation.Pitch = -righthand.BoneRotation.Pitch;   //remove for UDK skel

		if(bIsCrouched) RightArmLocation.Z -= CrouchHeight * 0.5;
		
		RightArm.EffectorLocation = RightArmLocation + Location;
		Mesh.GetSocketWorldLocationAndRotation('WeaponPoint',SocketLocation);
		RightArm.JointTargetLocation = TransformVectorByRotation(RightHand.BoneRotation, JointDirection) + SocketLocation;

		if(bIsCrouched) LeftArmLocation.Z -= CrouchHeight * 0.5;
		LeftArm.EffectorLocation = LeftArmLocation + Location;
		Mesh.GetSocketWorldLocationAndRotation('DualWeaponPoint',SocketLocation);
		LeftArm.JointTargetLocation = TransformVectorByRotation(LeftHand.BoneRotation, JointDirectionL) + SocketLocation;			
		
		//head.BoneRotation = headrotation - Rotation;
		head.BoneRotation.Pitch = headrotation.Roll;
		head.BoneRotation.Roll = -headrotation.Pitch;
		head.BoneRotation.Yaw = headrotation.Yaw;

		head.BoneRotation.Roll = head.BoneRotation.Roll +16375;
		head.BoneRotation.Yaw = head.BoneRotation.Yaw - 16375;

}


// this runs on the client that runs the command, as well as being called from the server function below
simulated function ToggleBool()
{
    blimbsmoving = !blimbsmoving;
    armsandheadmove();
    if(Role < ROLE_Authority)
        ServerToggleBool(rightarmlocation, socketlocation, righthandrotation, leftarmlocation, headposition, headrotation, lefthandrotation);
	
}

// this is called on the server, and toggles it on the server side.  the replication code automatically handles sending it to everyone that
// has a copy of this object
reliable server function ServerToggleBool(vector s_RightArmLocation, vector s_SocketLocation, rotator s_righthandrotation, vector s_LeftArmLocation, vector s_headposition, rotator s_headrotation, rotator s_lefthandrotation)
{
  //  `log("Toggling bool!");
    blimbsmoving = !blimbsmoving;
	rightarmlocation = s_rightarmlocation;
	socketlocation = s_socketlocation;
	righthandrotation = s_righthandrotation;
	leftarmlocation = s_leftarmlocation;
	headposition = s_headposition;
	headrotation = s_headrotation;
	lefthandrotation = s_lefthandrotation;
	armsandheadmove();
}

//end hydra arm motion code

simulated event destroyed()
{
	super.destroyed();
	
	RightArm = none;
	LeftArm = none;
	RightHand = none;
	LeftHand = none;
	head = none;
}

DefaultProperties
{
	
	blimbsmoving = false
	
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
		AnimTreeTemplate=AnimTree'testpackage1.avatars.mixamo_animtree'
		//AnimTreeTemplate=AnimTree'demo_asset.HX_FreeArms_3'  //uncomment for UDK skel
		bCacheAnimSequenceNodes=FALSE
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		CastShadow=true
		BlockRigidBody=TRUE
		bUpdateSkelWhenNotRendered=true
		bIgnoreControllersWhenNotRendered=false //was true
		bUpdateKinematicBonesFromAnimation=true
		bCastDynamicShadow=true
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
		bUseOnePassLightingOnTranslucency=TRUE
		bPerBoneMotionBlur=true
	End Object
	Mesh=WPawnSkeletalMeshComponent
	Components.Add(WPawnSkeletalMeshComponent)
 
	drawscale = 0.7
 
	Begin Object Name=CollisionCylinder
		CollisionRadius=+010.000000
		CollisionHeight=+44.000000
	End Object
	CylinderComponent=CollisionCylinder
	

	//bmeshsetyet = false;
	baseeyeheight = 27; // was21...want to net ~27, but accomodating for crouch
	CrouchHeight=45.0
	JumpZ=0.0
	//AccelRate=0.0

	

}
