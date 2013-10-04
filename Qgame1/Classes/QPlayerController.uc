class QPlayerController extends UTPlayerController;

var LHandPawn LeftHand, RightHand;
var vector SpawnLocation;
var vector LeftPosition, RightPosition,  Leftposition_old, Rightposition_old, leftposition_delta, rightposition_delta;
var rotator LeftOrientation, RightOrientation, LeftOrientation_old, RightOrientation_old, leftorientation_delta, rightorientation_delta;
var rotator leftorientation_delta_world, rightorientation_delta_world;
var sixense TheSixense;
var Matrix sxMat;
var vector leftx, lefty, leftz, L_objx, L_objy, L_objz, leftx_old, lefty_old, leftz_old, leftx_delta, lefty_delta, leftz_delta, L_offsetx, L_offsety, L_offsetz;
var vector left_old_transpose_x, left_old_transpose_y, left_old_transpose_z;
var vector rightx, righty, rightz, R_objx, R_objy, R_objz, rightx_old, righty_old, rightz_old, rightx_delta, righty_delta, rightz_delta, R_offsetx, R_offsety, R_offsetz;
var vector right_old_transpose_x, right_old_transpose_y, right_old_transpose_z;
var vector newpawnlocation;
var float pos_scale, base_dist, base_height;
var bool bwastouchingL, bwastouchingR, bfirstblockpressed, bjengapressed;
var array<firstblockactor> firstblock;
var array<jengaactor> jengablock;


`define m33el(x, y) `y + `x * 3


simulated event PostBeginPlay()
{	
	super.PostBeginPlay();
	
	
	TheSixense = new class'Sixense';
	TheSixense.sixenseInit();
	TheSixense.sixenseGetAllNewestData(TheSixense.TheControllerData);
	TheSixense.sixenseSetFilterEnabled(1);

	`log("I have arrived in the controller...should spawn now!");
	
	spawnlocation.X=-560;
	spawnlocation.Y=-224;
	spawnlocation.Z=377;

	LeftHand = spawn(class'LHandPawn',,,spawnlocation);
	
	spawnlocation.X=-360;
	spawnlocation.Y=200;
	spawnlocation.Z=800;

	RightHand = spawn(class'LHandPawn',,,spawnlocation); //cleaner way to do this?  spawnlocation is hard coded...

	
}


event PlayerTick( float DeltaTime )
{
	
	
	Leftposition_old = leftposition;
	Rightposition_old = rightposition;
	Leftorientation_old = leftorientation;
	Rightorientation_old = rightorientation;

	TheSixense.sixenseGetAllNewestData(TheSixense.TheControllerData);

	//one time sixense calibration call.  Press both triggers and hold controllers straight out
	if (!thesixense.calibrated && thesixense.TheControllerData.controller[0].trigger>0 && thesixense.TheControllerData.controller[1].trigger>0)
	{thesixense.Calibrate();}

	if (thesixense.calibrated ==true)
		thesixense.ParseData();

	//begin sixense position and orientation
	//position - need to work on scaling...
	LeftPosition.X=pawn.Location.X + base_dist - pos_scale * TheSixense.TheControllerData.controller[0].pos[2];
	LeftPosition.Y=pawn.Location.Y + pos_scale * TheSixense.TheControllerData.controller[0].pos[0];
	//LeftPosition.Z=Pawn.Location.Z + base_height + pos_scale * TheSixense.TheControllerData.controller[0].pos[1];
	LeftPosition.Z=base_height + pos_scale * TheSixense.TheControllerData.controller[0].pos[1];
	LeftHand.setlocation(LeftPosition);  //was setlocation
	
	//position debug
	
	`log("pawn.z: " $ pawn.Location.Z);
	`log("base eye height: " $ pawn.BaseEyeHeight);
	

	if (thesixense.TheControllerData.controller[1].buttons == 32)
		thesixense.calibrated=false;

	if (thesixense.TheControllerData.controller[1].buttons == 64)
		bduck=1;


	RightPosition.X=pawn.Location.X + base_dist - pos_scale * TheSixense.TheControllerData.controller[1].pos[2];
	RightPosition.Y=pawn.Location.Y + pos_scale * TheSixense.TheControllerData.controller[1].pos[0];
	//RightPosition.Z=Pawn.Location.Z + base_height + pos_scale * TheSixense.TheControllerData.controller[1].pos[1];
	RightPosition.Z=base_height + pos_scale * TheSixense.TheControllerData.controller[1].pos[1];
	RightHand.setlocation(RightPosition);


	//orientation
	//adding orientation transformation from Sixense to Unreal format
	
	
	//X Basis Vector
	sxMat.XPlane.X = TheSixense.TheControllerData.controller[0].rot_mat[ `m33el(2, 2) ]; 
	sxMat.XPlane.Y = -TheSixense.TheControllerData.controller[0].rot_mat[ `m33el(2, 0) ]; 
	sxMat.XPlane.Z = -TheSixense.TheControllerData.controller[0].rot_mat[ `m33el(2, 1) ];
	sxMat.XPlane.W = 0;
	
	//Y Basis Vector
	sxMat.YPlane.X = -TheSixense.TheControllerData.controller[0].rot_mat[ `m33el(0, 2) ];
	sxMat.YPlane.Y = TheSixense.TheControllerData.controller[0].rot_mat[ `m33el(0, 0) ];
	sxMat.YPlane.Z = TheSixense.TheControllerData.controller[0].rot_mat[ `m33el(0, 1) ]; 
	sxMat.YPlane.W = 0;
	
	//Z Basis Vector
	sxMat.ZPlane.X = -TheSixense.TheControllerData.controller[0].rot_mat[ `m33el(1, 2) ];
	sxMat.ZPlane.Y = TheSixense.TheControllerData.controller[0].rot_mat[ `m33el(1, 0) ];
	sxMat.ZPlane.Z = TheSixense.TheControllerData.controller[0].rot_mat[ `m33el(1, 1) ];
	sxMat.ZPlane.W = 0;
	
	//W Basis Vector
	sxMat.WPlane.X = 0;
	sxMat.WPlane.Y = 0;
	sxMat.WPlane.Z = 0;
	sxMat.WPlane.W = 1;

	leftorientation = matrixgetrotator(sxMat);

	LeftHand.SetRotation(LeftOrientation);

//X Basis Vector
	sxMat.XPlane.X = TheSixense.TheControllerData.controller[1].rot_mat[ `m33el(2, 2) ]; 
	sxMat.XPlane.Y = -TheSixense.TheControllerData.controller[1].rot_mat[ `m33el(2, 0) ]; 
	sxMat.XPlane.Z = -TheSixense.TheControllerData.controller[1].rot_mat[ `m33el(2, 1) ];
	sxMat.XPlane.W = 0;
	
	//Y Basis Vector
	sxMat.YPlane.X = -TheSixense.TheControllerData.controller[1].rot_mat[ `m33el(0, 2) ];
	sxMat.YPlane.Y = TheSixense.TheControllerData.controller[1].rot_mat[ `m33el(0, 0) ];
	sxMat.YPlane.Z = TheSixense.TheControllerData.controller[1].rot_mat[ `m33el(0, 1) ]; 
	sxMat.YPlane.W = 0;
	
	//Z Basis Vector
	sxMat.ZPlane.X = -TheSixense.TheControllerData.controller[1].rot_mat[ `m33el(1, 2) ];
	sxMat.ZPlane.Y = TheSixense.TheControllerData.controller[1].rot_mat[ `m33el(1, 0) ];
	sxMat.ZPlane.Z = TheSixense.TheControllerData.controller[1].rot_mat[ `m33el(1, 1) ];
	sxMat.ZPlane.W = 0;
	
	//W Basis Vector
	sxMat.WPlane.X = 0;
	sxMat.WPlane.Y = 0;
	sxMat.WPlane.Z = 0;
	sxMat.WPlane.W = 1;

	rightorientation = matrixgetrotator(sxMat);

	RightHand.SetRotation(RightOrientation);
//end sixense position and orientation	
	
//calculate delta position and orientation

	leftposition_delta = leftposition - leftposition_old;
	leftorientation_delta = leftorientation - leftorientation_old;

	rightposition_delta = rightposition - rightposition_old;
	rightorientation_delta = rightorientation - rightorientation_old;
	
	leftx_old = leftx;
	lefty_old = lefty;
	leftz_old= leftz;

	getaxes(leftorientation, leftx, lefty, leftz);
	
	leftx_delta = leftx - leftx_old;
	lefty_delta = lefty - lefty_old;
	leftz_delta = leftz - leftz_old;
	
	rightx_old = rightx;
	righty_old = righty;
	rightz_old= rightz;

	getaxes(rightorientation, rightx, righty, rightz);
	
	rightx_delta = rightx - rightx_old;
	righty_delta = righty - righty_old;
	rightz_delta = rightz - rightz_old;

	//touch detection

	//left hand
	if (lefthand.Touching[0] != none)
	{`log("TOUCH!:" $ lefthand.Touching[0]);
	lefthand.changecolor(true);}
	
	if (thesixense.TheControllerData.controller[0].trigger>0)
		{
		lefthand.Touching[0].SetPhysics(PHYS_none);
		lefthand.Touching[0].SetLocation(lefthand.Touching[0].Location + leftposition_delta);
		
		getaxes(lefthand.Touching[0].Rotation, L_objx, L_objy, L_objz);
	
	//computing delta for object basis vectors
	L_offsetx = resultx(left_old_transpose_x, left_old_transpose_y, left_old_transpose_z,L_objx);
	L_offsety = resulty(left_old_transpose_x, left_old_transpose_y, left_old_transpose_z,L_objy);
	L_offsetz = resultz(left_old_transpose_x, left_old_transpose_y, left_old_transpose_z,L_objz);

	L_offsetx = resultx(leftx_delta, lefty_delta, leftz_delta, L_offsetx);
	L_offsety = resulty(leftx_delta, lefty_delta, leftz_delta, L_offsety);
	L_offsetz = resultz(leftx_delta, lefty_delta, leftz_delta, L_offsetz);
	
	L_objx = L_objx+L_offsetx;
	L_objy = L_objy+L_offsety;
	L_objz = L_objz+L_offsetz;

	leftorientation_delta_world = orthorotation(L_objx, L_objy, L_objz);

	lefthand.Touching[0].SetRotation(leftorientation_delta_world);
	
		bwastouchingL = true;
		}

	if (thesixense.TheControllerData.controller[0].trigger==0 && bwastouchingL)
		{lefthand.Touching[0].SetPhysics(PHYS_rigidbody);
		bwastouchingL=false;
		`log("release!");}


	if (lefthand.Touching[0] == none)
	{`log("NO TOUCH");
	lefthand.changecolor(false);}

	//right hand
	if (righthand.Touching[0] != none)
	{`log("TOUCH!:" $ righthand.Touching[0]);
	righthand.changecolor(true);
		if (thesixense.TheControllerData.controller[1].trigger>0)
		{
		righthand.Touching[0].SetPhysics(PHYS_none);
		righthand.Touching[0].SetLocation(righthand.Touching[0].Location + rightposition_delta);
		
		getaxes(righthand.Touching[0].Rotation, R_objx, R_objy, R_objz);
	
		//computing delta for object basis vectors
		R_offsetx = resultx(right_old_transpose_x, right_old_transpose_y, right_old_transpose_z,R_objx);
		R_offsety = resulty(right_old_transpose_x, right_old_transpose_y, right_old_transpose_z,R_objy);
		R_offsetz = resultz(right_old_transpose_x, right_old_transpose_y, right_old_transpose_z,R_objz);

		R_offsetx = resultx(rightx_delta, righty_delta, rightz_delta, R_offsetx);
		R_offsety = resulty(rightx_delta, righty_delta, rightz_delta, R_offsety);
		R_offsetz = resultz(rightx_delta, righty_delta, rightz_delta, R_offsetz);
	
		R_objx = R_objx+R_offsetx;
		R_objy = R_objy+R_offsety;
		R_objz = R_objz+R_offsetz;

		rightorientation_delta_world = orthorotation(R_objx, R_objy, R_objz);

		righthand.Touching[0].SetRotation(rightorientation_delta_world);


		bwastouchingR = true;
		}
		if (thesixense.TheControllerData.controller[1].trigger==0 && bwastouchingR)
		{righthand.Touching[0].SetPhysics(PHYS_rigidbody);
		bwastouchingR=false;}
	}

	if (righthand.Touching[0] == none)
	{`log("NO TOUCH:" $ righthand.Touching[0]);
	righthand.changecolor(false);}


	getunaxes(leftorientation, left_old_transpose_x, left_old_transpose_y, left_old_transpose_z);
	getunaxes(rightorientation, right_old_transpose_x, right_old_transpose_y, right_old_transpose_z);


//end touch and movement

// fiddle with spawning new objects

	if (thesixense.TheControllerData.controller[0].buttons == 32 && bfirstblockpressed == false)
		addfirstblocks();

	if (thesixense.TheControllerData.controller[0].buttons == 64)
		removefirstblocks();

    if (thesixense.TheControllerData.controller[0].buttons == 8 && bjengapressed == false)
		addjenga();

	if (thesixense.TheControllerData.controller[0].buttons == 16)
		removejengablocks();


//end object creation and destruction


	if ( !bShortConnectTimeOut )
	{
		bShortConnectTimeOut = true;
		ServerShortTimeout();
	}

	if ( Pawn != AcknowledgedPawn )
	{
		if ( Role < ROLE_Authority )
		{
			// make sure old pawn controller is right
			if ( (AcknowledgedPawn != None) && (AcknowledgedPawn.Controller == self) )
				AcknowledgedPawn.Controller = None;
		}
		AcknowledgePossession(Pawn);
	}

	PlayerInput.PlayerInput(DeltaTime);
	if ( bUpdatePosition )
	{
		ClientUpdatePosition();
	}
	PlayerMove(DeltaTime);

	AdjustFOV(DeltaTime);
}

function addfirstblocks()
{
	local int i, j, k, blockindex;
	
	blockindex = 0;
	
	if (bjengapressed == true)
		removejengablocks();

	for (k=0; k<=3; k++)
		for (i=0; i<=2; i++)
			for (j=0; j<=2; j++)
			{
				spawnlocation.X = pawn.Location.X -150 + 75*(i+1);
				spawnlocation.Y = pawn.Location.Y  + 75 + (j+1)*50;
				spawnlocation.Z = pawn.Location.Z + 50*k;
				if (randrange(0,1)>0.60)
					{firstblock[blockindex] = spawn(class'firstblockactor',,,spawnlocation);
					blockindex++;
					}
			}
	if (bfirstblockpressed == false)
	{pos_scale = 2*pos_scale;
	base_dist = 1.5* base_dist;}


	bfirstblockpressed = true;
}

function removefirstblocks()
{
    local int destroyindex;
	
	for (destroyindex = 0; destroyindex <=firstblock.Length; destroyindex++) 
			{firstblock[destroyindex].Destroy();}
	
	if (bfirstblockpressed ==true)
	{pos_scale = pos_scale/2;
		base_dist = base_dist/1.5;}
			
	bfirstblockpressed = false;
	
}

function addjenga()
{
	local int j, k, blockindex;
	local rotator jengarotation;

	if (bfirstblockpressed == true)
		removefirstblocks();

	blockindex = 0;
	jengarotation.Pitch = 0;
	jengarotation.Roll = 0;
	jengarotation.Yaw = -16000;

	for (k=0; k<=7; k++)
			for (j=0; j<=2; j++)
			{   if(k % 2 ==0)
					{spawnlocation.X = pawn.Location.X + 50;
					spawnlocation.Y = pawn.Location.Y -5 + j*5;
					spawnlocation.Z = pawn.Location.Z + 10*k;
					jengablock[blockindex] = spawn(class'jengaactor',,,spawnlocation,jengarotation);
					blockindex++;
					}
				else
				{   spawnlocation.X = pawn.Location.X + 50 -5 + j*5;
					spawnlocation.Y = pawn.Location.Y; 
					spawnlocation.Z = pawn.Location.Z + 10*k;
					jengablock[blockindex] = spawn(class'jengaactor',,,spawnlocation);
					blockindex++;
					
				}
					
			}
	bjengapressed = true;

}

function removejengablocks()
{
    local int destroyindex;
	
	for (destroyindex = 0; destroyindex <=jengablock.Length; destroyindex++) 
			{jengablock[destroyindex].Destroy();}
			bjengapressed = false;
}

function vector resultx (vector Ax, vector Ay, vector Az, vector Bx)
{
	local vector result_temp;
	
	result_temp.x = Ax.X * Bx.X + Ay.x * Bx.Y + Az.X * Bx.Z;
	result_temp.y = Ax.Y * Bx.X + Ay.Y * Bx.Y + Az.Y * Bx.z;
	result_temp.z = Ax.z * Bx.X + Ay.z * Bx.Y + Az.z * Bx.z;

	return result_temp;
}

function vector resulty (vector Ax, vector Ay, vector Az, vector By)
{
	local vector result_temp;
	
	result_temp.x = Ax.X * By.X + Ay.x * By.Y + Az.X * By.Z;
	result_temp.y = Ax.Y * By.X + Ay.Y * By.Y + Az.Y * By.z;
	result_temp.z = Ax.z * By.X + Ay.z * By.Y + Az.z * By.z;

	return result_temp;
}

function vector resultz (vector Ax, vector Ay, vector Az, vector Bz)
{
	local vector result_temp;
	
	result_temp.x = Ax.X * Bz.X + Ay.x * Bz.Y + Az.X * Bz.Z;
	result_temp.y = Ax.Y * Bz.X + Ay.Y * Bz.Y + Az.Y * Bz.z;
	result_temp.z = Ax.z * Bz.X + Ay.z * Bz.Y + Az.z * Bz.z;

	return result_temp;
}

DefaultProperties
{
	pos_scale = 0.14;
	base_dist = 100;
	base_height = 60;
	bwastouchingL = false;
	bwastouchingR = false;
	bfirstblockpressed = false;
//	bduck=1; //crouched?

}
