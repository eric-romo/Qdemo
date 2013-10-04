class Sixense extends Object
	DLLBind(sixense);

var bool calibrated;
var vector origin;

const SIXENSE_BUTTON_BUMPER 	= 128; //(0x01<<7)
const SIXENSE_BUTTON_JOYSTICK 	= 256; //(0x01<<8)
const SIXENSE_BUTTON_1      	= 32;  //(0x01<<5)
const SIXENSE_BUTTON_2      	= 64;  //(0x01<<6)
const SIXENSE_BUTTON_3      	= 8;   //(0x01<<3)
const SIXENSE_BUTTON_4      	= 16;  //(0x01<<4)
const SIXENSE_BUTTON_START  	= 1;   //(0x01<<0)

struct sixenseControllerData {
  var float pos[3];
  var float rot_mat[9];
  var float joystick_x;
  var float joystick_y;
  var float trigger;
  var int buttons;
  var byte sequence_number;
  var float rot_quat[4];
  var byte firmware_revision[2];
  var byte hardware_revision[2];
  var byte packet_type[2];
  var byte magnetic_frequency[2];
  var int enabled;
  var int controller_index;
  var byte is_docked;
  var byte which_hand;
  var byte hemi_tracking_enabled;

};



struct sixenseAllControllerData{
	var sixenseControllerData controller[4];
};

var sixenseAllControllerData TheControllerData;

struct altsixensedata
{
  var vector vector_pos;
  var quat quat_rot;
};

struct altSixenseAllData
{
	var altSixenseData Controller[2];
};

var altsixensealldata altcontrollerdata;

`define m33el(x, y) `y + `x * 3

dllimport final function int sixenseInit( );
dllimport final function int sixenseExit( );

dllimport final function int sixenseGetMaxBases();
dllimport final function int sixenseSetActiveBase( int i );
dllimport final function int sixenseIsBaseConnected( int i );

dllimport final function int sixenseGetMaxControllers( );
dllimport final function int sixenseIsControllerEnabled( int which );
dllimport final function int sixenseGetNumActiveControllers( );

dllimport final function int sixenseGetHistorySize();

dllimport final function int sixenseGetData( int which, int index_back, out sixenseControllerData data );
dllimport final function int sixenseGetAllData( int index_back, out sixenseAllControllerData data );
dllimport final function int sixenseGetNewestData( int which, out sixenseControllerData data );
dllimport final function int sixenseGetAllNewestData( out sixenseAllControllerData data );

dllimport final function int sixenseSetHemisphereTrackingMode( int which_controller, int state );
dllimport final function int sixenseGetHemisphereTrackingMode( int which_controller, out int state );

dllimport final function int sixenseAutoEnableHemisphereTracking( int which_controller );

dllimport final function int sixenseSetHighPriorityBindingEnabled( int on_or_off );
dllimport final function int sixenseGetHighPriorityBindingEnabled( out int on_or_off );

dllimport final function int sixenseTriggerVibration( int controller_id, int duration_100ms, int pattern_id );

dllimport final function int sixenseSetFilterEnabled( int on_or_off );
dllimport final function int sixenseGetFilterEnabled( out int on_or_off );

dllimport final function int sixenseSetFilterParams( float near_range, float near_val, float far_range, float far_val );
dllimport final function int sixenseGetFilterParams( out float near_range, out float near_val, out float far_range, out float far_val );

dllimport final function int sixenseSetBaseColor( byte red, byte green, byte blue );
dllimport final function int sixenseGetBaseColor( out byte red, out byte green, out byte blue );

function Calibrate()
{
	local vector RightPos;
	local vector LeftPos;
	local vector MidPoint;
	

	RightPos.X = -TheControllerData.Controller[1].pos[2];
	RightPos.Y = TheControllerData.Controller[1].pos[0];
	RightPos.Z = TheControllerData.Controller[1].pos[1];
	LeftPos.X = -TheControllerData.Controller[0].pos[2];
	LeftPos.Y = TheControllerData.Controller[0].pos[0];
	LeftPos.Z = TheControllerData.Controller[0].pos[1];
	MidPoint = LeftPos - RightPos;
	MidPoint = MidPoint * 0.5;
	origin = RightPos + MidPoint;
	
	`log("Calibrated!");
	calibrated=true;
}

function ParseData()
{
	if(calibrated)
	{
		ParseSixense(0); //left
		ParseSixense(1); //right
	}
}

function ParseSixense(int SC)
{
	local float ArmMultiplier;
	
	ArmMultiplier = 0.065; // How much to multiply the sixense vectors by (was0.065)

	altControllerData.Controller[SC].vector_Pos.X = -TheControllerData.Controller[SC].pos[2];
	altControllerData.Controller[SC].vector_Pos.Y = TheControllerData.Controller[SC].pos[0];
	altControllerData.Controller[SC].vector_Pos.Z = TheControllerData.Controller[SC].pos[1];
	altControllerData.Controller[SC].vector_Pos = (altControllerData.Controller[SC].vector_Pos - origin) * ArmMultiplier;

	altControllerData.Controller[SC].Quat_rot.W = -TheControllerData.Controller[SC].rot_quat[3];
	altControllerData.Controller[SC].Quat_rot.X = -TheControllerData.Controller[SC].rot_quat[2];
	altControllerData.Controller[SC].Quat_rot.Y = TheControllerData.Controller[SC].rot_quat[0];
	altControllerData.Controller[SC].Quat_rot.Z = TheControllerData.Controller[SC].rot_quat[1];
}
	
DefaultProperties
{

calibrated = false;

}
