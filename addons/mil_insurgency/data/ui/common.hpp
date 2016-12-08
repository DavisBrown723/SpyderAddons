#define GUI_GRID_X	(0)
#define GUI_GRID_Y	(0)
#define GUI_GRID_W	(0.025)
#define GUI_GRID_H	(0.04)
#define GUI_GRID_WAbs	(1)
#define GUI_GRID_HAbs	(1)

///////////////////////////////////////////////////////////////////////////
/// Styles
///////////////////////////////////////////////////////////////////////////

// Control types
#define CT_STATIC           0
#define CT_BUTTON           1
#define CT_EDIT             2
#define CT_SLIDER           3
#define CT_COMBO            4
#define CT_LISTBOX          5
#define CT_TOOLBOX          6
#define CT_CHECKBOXES       7
#define CT_PROGRESS         8
#define CT_HTML             9
#define CT_STATIC_SKEW      10
#define CT_ACTIVETEXT       11
#define CT_TREE             12
#define CT_STRUCTURED_TEXT  13
#define CT_CONTEXT_MENU     14
#define CT_CONTROLS_GROUP   15
#define CT_SHORTCUTBUTTON   16
#define CT_XKEYDESC         40
#define CT_XBUTTON          41
#define CT_XLISTBOX         42
#define CT_XSLIDER          43
#define CT_XCOMBO           44
#define CT_ANIMATED_TEXTURE 45
#define CT_OBJECT           80
#define CT_OBJECT_ZOOM      81
#define CT_OBJECT_CONTAINER 82
#define CT_OBJECT_CONT_ANIM 83
#define CT_LINEBREAK        98
#define CT_USER             99
#define CT_MAP              100
#define CT_MAP_MAIN         101
#define CT_LISTNBOX         102

// Static styles
#define ST_POS            0x0F
#define ST_HPOS           0x03
#define ST_VPOS           0x0C
#define ST_LEFT           0x00
#define ST_RIGHT          0x01
#define ST_CENTER         0x02
#define ST_DOWN           0x04
#define ST_UP             0x08
#define ST_VCENTER        0x0C

#define ST_TYPE           0xF0
#define ST_SINGLE         0x00
#define ST_MULTI          0x10
#define ST_TITLE_BAR      0x20
#define ST_PICTURE        0x30
#define ST_FRAME          0x40
#define ST_BACKGROUND     0x50
#define ST_GROUP_BOX      0x60
#define ST_GROUP_BOX2     0x70
#define ST_HUD_BACKGROUND 0x80
#define ST_TILE_PICTURE   0x90
#define ST_WITH_RECT      0xA0
#define ST_LINE           0xB0

#define ST_SHADOW         0x100
#define ST_NO_RECT        0x200
#define ST_KEEP_ASPECT_RATIO  0x800

#define ST_TITLE          ST_TITLE_BAR + ST_CENTER

// Slider styles
#define SL_DIR            0x400
#define SL_VERT           0
#define SL_HORZ           0x400

#define SL_TEXTURES       0x10

// progress bar
#define ST_VERTICAL       0x01
#define ST_HORIZONTAL     0

// Listbox styles
#define LB_TEXTURES       0x10
#define LB_MULTI          0x20

// Tree styles
#define TR_SHOWROOT       1
#define TR_AUTOCOLLAPSE   2

// MessageBox styles
#define MB_BUTTON_OK      1
#define MB_BUTTON_CANCEL  2
#define MB_BUTTON_USER    4


///////////////////////////////////////////////////////////////////////////
/// Base Classes
///////////////////////////////////////////////////////////////////////////
class Insurgency_RscText
{
	access = 0;
	type = 0;
	idc = -1;
	colorBackground[] =
	{
		0,
		0,
		0,
		0
	};
	colorText[] =
	{
		1,
		1,
		1,
		1
	};
	text = "";
	fixedWidth = 0;
	x = 0;
	y = 0;
	h = 0.037;
	w = 0.3;
	style = 0;
	shadow = 1;
	colorShadow[] =
	{
		0,
		0,
		0,
		0.5
	};
	font = "PuristaMedium";
	SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	linespacing = 1;
};
class Insurgency_RscPicture
{
	access = 0;
	type = 0;
	idc = -1;
	style = 2096;
	colorBackground[] =
	{
		0,
		0,
		0,
		0
	};
	colorText[] =
	{
		1,
		1,
		1,
		1
	};
	font = "TahomaB";
	sizeEx = 0;
	lineSpacing = 0;
	text = "";
	fixedWidth = 0;
	shadow = 0;
	x = 0;
	y = 0;
	w = 0.2;
	h = 0.15;
};
class Insurgency_RscCombo
{
	access = 0;
	type = 4;
	colorSelect[] =
	{
		0,
		0,
		0,
		1
	};
	colorText[] =
	{
		0.95,
		0.95,
		0.95,
		1
	};
	colorBackground[] =
	{
		0,
		0,
		0,
		1
	};
	colorScrollbar[] =
	{
		1,
		0,
		0,
		1
	};
	soundSelect[] =
	{
		"\A3\ui_f\data\sound\RscCombo\soundSelect",
		0.1,
		1
	};
	soundExpand[] =
	{
		"\A3\ui_f\data\sound\RscCombo\soundExpand",
		0.1,
		1
	};
	soundCollapse[] =
	{
		"\A3\ui_f\data\sound\RscCombo\soundCollapse",
		0.1,
		1
	};
	maxHistoryDelay = 1;
	class ScrollBar
	{
		color[] =
		{
			1,
			1,
			1,
			0.6
		};
		colorActive[] =
		{
			1,
			1,
			1,
			1
		};
		colorDisabled[] =
		{
			1,
			1,
			1,
			0.3
		};
		shadow = 0;
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
	};
	style = 16;
	x = 0;
	y = 0;
	w = 0.12;
	h = 0.035;
	shadow = 0;
	colorSelectBackground[] =
	{
		1,
		1,
		1,
		0.7
	};
	arrowEmpty = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_ca.paa";
	arrowFull = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_active_ca.paa";
	wholeHeight = 0.45;
	color[] =
	{
		1,
		1,
		1,
		1
	};
	colorActive[] =
	{
		1,
		0,
		0,
		1
	};
	colorDisabled[] =
	{
		1,
		1,
		1,
		0.25
	};
	font = "PuristaMedium";
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
};
class Insurgency_RscListBox
{
	access = 0;
	type = 5;
	w = 0.4;
	h = 0.4;
	rowHeight = 0;
	colorText[] = {0,0,0,1};
	colorDisabled[] =
	{
		1,
		1,
		1,
		0.25
	};
	colorScrollbar[] =
	{
		1,
		0,
		0,
		0
	};
	colorSelect[] =
	{
		0,
		0,
		0,
		1
	};
	colorSelect2[] =
	{
		0,
		0,
		0,
		1
	};
	colorSelectBackground[] =
	{
		0.95,
		0.95,
		0.95,
		1
	};
	colorSelectBackground2[] =
	{
		1,
		1,
		1,
		0.5
	};
	colorBackground[] = {0,0,0,0};
	soundSelect[] =
	{
		"\A3\ui_f\data\sound\RscListbox\soundSelect",
		0.09,
		1
	};
	arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
	arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
	class ScrollBar
	{
		color[] =
		{
			1,
			1,
			1,
			0.6
		};
		colorActive[] =
		{
			1,
			1,
			1,
			1
		};
		colorDisabled[] =
		{
			1,
			1,
			1,
			0.3
		};
		shadow = 0;
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
	};
	class ListScrollBar {
		color[] = {1,1,1,1};
		autoScrollEnabled = 1;
		
		colorActive[] = {1, 1, 1, 1};
		colorDisabled[] = {1, 1, 1, 0.3};
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
	};
	style = 16;
	font = "PuristaMedium";
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	shadow = 0;
	colorShadow[] =
	{
		0,
		0,
		0,
		0.5
	};
	color[] =
	{
		1,
		1,
		1,
		1
	};
	period = 1.2;
	maxHistoryDelay = 1;
	autoScrollSpeed = -1;
	autoScrollDelay = 5;
	autoScrollRewind = 0;
};

class Insurgency_ListNBox {
	style = "ST_LEFT + LB_TEXTURES";
	type = 102;
	rowHeight = .06;
	idcLeft = -1;
	idcRight = -1;
	w = "(safeZoneW / 10)";
	x = "safeZoneX + (safeZoneW / 5)";
	y = "safeZoneY + (safeZoneH / 2.25)";
	color[] = {1,1,1,1};
	colorPicture[] = {1,1,1,1};
	colorText[] = {1,1,1,1};
	colorDisabled[] = {1,1,1,0.25};
	colorSelect[] = {0,0,0,1};
	colorSelect2[] = {0,0,0,1};
	colorSelectBackground[] ={0.95,0.95,0.95,1};
	colorSelectBackground2[] = {1,1,1,0.5};
	colorBackground[] = {0,0,0,0.3};
	colorPictureDisabled[] = {1,1,1,1};
	colorPictureSelected[] = {1,1,1,1};
	font = "PuristaMedium";
	h = "(safeZoneH / 17)";
	maxHistoryDelay = 1;
	period = 1;
	shadow = 0;
	sizeEx = "(safeZoneH / 100) + (safeZoneH / 100)";
	soundCollapse[] = {"",0.1,1};
	soundExpand[] = {"",0.1,1};
	soundSelect[] = {"",0.1,1};
	autoScrollDelay = 5;
	autoScrollRewind = 0;
	autoScrollSpeed = -1;
	class ScrollBar
	{
		color[] = {1,1,1,0.6};
		colorActive[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,0.3};
		shadow = 0;
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
	};
	class ListScrollBar {
		color[] = {1,1,1,1};
		autoScrollEnabled = 1;
		colorActive[] = {1, 1, 1, 1};
		colorDisabled[] = {1, 1, 1, 0.3};
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
	};
	arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
	arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
	drawSideArrows = 1;
};

class Insurgency_RscButton
{
	access = 0;
	type = 1;
	text = "";
	colorText[] = {1,1,1,1};
	colorDisabled[] = {1,1,1,0.25};
	colorBackground[] = {0,0,0,0.5};
	colorBackgroundDisabled[] = {0,0,0,0.5};
	colorBackgroundActive[] = {0,0,0,1};
	colorFocused[] =
	{
		0,
		0,
		0,
		.65
	};
	colorShadow[] =
	{
		0,
		0,
		0,
		0
	};
	colorBorder[] =
	{
		0,
		0,
		0,
		1
	};
	soundEnter[] =
	{
		"\A3\ui_f\data\sound\RscButton\soundEnter",
		0.09,
		1
	};
	soundPush[] =
	{
		"\A3\ui_f\data\sound\RscButton\soundPush",
		0.09,
		1
	};
	soundClick[] =
	{
		"\A3\ui_f\data\sound\RscButton\soundClick",
		0.09,
		1
	};
	soundEscape[] =
	{
		"\A3\ui_f\data\sound\RscButton\soundEscape",
		0.09,
		1
	};
	textureNoShortcut = "";
	animTextureNormal = "";
	animTextureDisabled = "";
	animTextureOver = "";
	animTextureFocused = "";
	animTexturePressed = "";
	animTextureDefault = "";
	style = 2;
	x = 0;
	y = 0;
	w = 0.095589;
	h = 0.039216;
	shadow = 2;
	font = "PuristaMedium";
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	offsetX = 0.003;
	offsetY = 0.003;
	offsetPressedX = 0.000;
	offsetPressedY = 0.002;
	borderSize = 0;
};

class Insurgency_RscMapControl
{
access = 0;
alphaFadeEndScale = 2;
alphaFadeStartScale = 2;
colorBackground[] = {0.969,0.957,0.949,1};
colorCountlines[] = {0.572,0.354,0.188,0.25};
colorCountlinesWater[] = {0.491,0.577,0.702,0.3};
colorForest[] = {0.624,0.78,0.388,0.5};
colorForestBorder[] = {0,0,0,0};
colorGrid[] = {0.1,0.1,0.1,0.6};
colorGridMap[] = {0.1,0.1,0.1,0.6};
colorInactive[] = {1,1,1,0.5};
colorLevels[] = {0.286,0.177,0.094,0.5};
colorMainCountlines[] = {0.572,0.354,0.188,0.5};
colorMainCountlinesWater[] = {0.491,0.577,0.702,0.6};
colorMainRoads[] = {0.9,0.5,0.3,1};
colorMainRoadsFill[] = {1,0.6,0.4,1};
colorNames[] = {0.1,0.1,0.1,0.9};
colorOutside[] = {0,0,0,1};
colorPowerLines[] = {0.1,0.1,0.1,1};
colorRailWay[] = {0.8,0.2,0,1};
colorRoads[] = {0.7,0.7,0.7,1};
colorRoadsFill[] = {1,1,1,1};
colorRocks[] = {0,0,0,0.3};
colorRocksBorder[] = {0,0,0,0};
colorSea[] = {0.467,0.631,0.851,0.5};
colorText[] = {0,0,0,1};
colorTracks[] = {0.84,0.76,0.65,0.15};
colorTracksFill[] = {0.84,0.76,0.65,1};
deletable = 0;
fade = 0;
font = "TahomaB";
fontGrid = "TahomaB";
fontInfo = "PuristaMedium";
fontLabel = "PuristaMedium";
fontLevel = "TahomaB";
fontNames = "EtelkaNarrowMediumPro";
fontUnits = "TahomaB";
h = "SafeZoneH - 1.5 * ( ( ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
idc = 51;
maxSatelliteAlpha = 0.85;
moveOnEdges = 1;
ptsPerSquareCLn = 10;
ptsPerSquareCost = 10;
ptsPerSquareExp = 10;
ptsPerSquareFor = 9;
ptsPerSquareForEdge = 9;
ptsPerSquareObj = 9;
ptsPerSquareRoad = 6;
ptsPerSquareSea = 5;
ptsPerSquareTxt = 20;
scaleDefault = 0.16;
scaleMax = 1;
scaleMin = 0.001;
shadow = 0;
showCountourInterval = 0;
sizeEx = 0.04;
sizeExGrid = 0.02;
sizeExInfo = "( ( ( ((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
sizeExLabel = "( ( ( ((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
sizeExLevel = 0.02;
sizeExNames = "( ( ( ((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8) * 2";
sizeExUnits = "( ( ( ((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
stickX[] = {0.2,["Gamma",1,1.5]};
stickY[] = {0.2,["Gamma",1,1.5]};
style = 48;
text = "#(argb,8,8,3)color(1,1,1,1)";
type = 101;
w = "SafeZoneWAbs";
x = "SafeZoneXAbs";
y = "SafeZoneY + 1.5 * ( ( ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
onMouseButtonClick = "";
onMouseButtonDblClick = "";

class ActiveMarker {
color[] = {0.3,0.1,0.9,1};
size = 50;
};

class LineMarker
{
color[] = {0.3,0.1,0.9,1};
size = 20;
lineWidthThin = 2;
lineWidthThick = 3;
lineLengthMin = 5;
lineDistanceMin = 5;
};

class Legend {
color[] = {0,0,0,1};
colorBackground[] = {1,1,1,0.5};
font = "PuristaMedium";
h = "3.5 * ( ( ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
sizeEx = "( ( ( ((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
w = "10 * ( ((safezoneW / safezoneH) min 1.2) / 40)";
x = "SafeZoneX + ( ((safezoneW / safezoneH) min 1.2) / 40)";
y = "SafeZoneY + safezoneH - 4.5 * ( ( ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
};

class Bunker {
coefMax = 4;
coefMin = 0.25;
color[] = {0,0,0,1};
icon = "\A3\ui_f\data\map\mapcontrol\bunker_ca.paa";
importance = "1.5 * 14 * 0.05";
size = 14;
};

class Bush {
coefMax = 4;
coefMin = 0.25;
color[] = {0.45,0.64,0.33,0.4};
icon = "\A3\ui_f\data\map\mapcontrol\bush_ca.paa";
importance = "0.2 * 14 * 0.05 * 0.05";
size = "14/2";
};

class BusStop {
coefMax = 1;
coefMin = 0.85;
color[] = {1,1,1,1};
icon = "\A3\ui_f\data\map\mapcontrol\busstop_CA.paa";
importance = 1;
size = 24;
};

class Command {
coefMax = 1;
coefMin = 1;
color[] = {1,1,1,1};
icon = "\A3\ui_f\data\map\mapcontrol\waypoint_ca.paa";
importance = 1;
size = 18;
};

class CustomMark {
coefMax = 1;
coefMin = 1;
color[] = {0,0,0,1};
icon = "\A3\ui_f\data\map\mapcontrol\custommark_ca.paa";
importance = 1;
size = 24;
};

class Cross {
coefMax = 1;
coefMin = 0.85;
color[] = {0,0,0,1};
icon = "\A3\ui_f\data\map\mapcontrol\Cross_CA.paa";
importance = 1;
size = 24;
};

class Shipwreck {
coefMax = 1;
coefMin = 0.85;
color[] = {0,0,0,1};
icon = "\A3\ui_f\data\map\mapcontrol\Shipwreck_CA.paa";
importance = 1;
size = 24;
};

class Fortress {
coefMax = 4;
coefMin = 0.25;
color[] = {0,0,0,1};
icon = "\A3\ui_f\data\map\mapcontrol\bunker_ca.paa";
importance = "2 * 16 * 0.05";
size = 16;
};

class Fuelstation {
coefMax = 1;
coefMin = 0.85;
color[] = {1,1,1,1};
icon = "\A3\ui_f\data\map\mapcontrol\fuelstation_CA.paa";
importance = 1;
size = 24;
};

class Fountain {
coefMax = 4;
coefMin = 0.25;
color[] = {0,0,0,1};
icon = "\A3\ui_f\data\map\mapcontrol\fountain_ca.paa";
importance = "1 * 12 * 0.05";
size = 11;
};

class Hospital {
coefMax = 1;
coefMin = 0.85;
color[] = {1,1,1,1};
icon = "\A3\ui_f\data\map\mapcontrol\hospital_CA.paa";
importance = 1;
size = 24;
};

class Chapel {
coefMax = 1;
coefMin = 0.85;
color[] = {0,0,0,1};
icon = "\A3\ui_f\data\map\mapcontrol\Chapel_CA.paa";
importance = 1;
size = 24;
};

class Church {
coefMax = 1;
coefMin = 0.85;
color[] = {1,1,1,1};
icon = "\A3\ui_f\data\map\mapcontrol\church_CA.paa";
importance = 1;
size = 24;
};

class Lighthouse {
coefMax = 1;
coefMin = 0.85;
color[] = {1,1,1,1};
icon = "\A3\ui_f\data\map\mapcontrol\lighthouse_CA.paa";
importance = 1;
size = 24;
};

class Quay {
coefMax = 1;
coefMin = 0.85;
color[] = {1,1,1,1};
icon = "\A3\ui_f\data\map\mapcontrol\quay_CA.paa";
importance = 1;
size = 24;
};

class Rock {
coefMax = 4;
coefMin = 0.25;
color[] = {0.1,0.1,0.1,0.8};
icon = "\A3\ui_f\data\map\mapcontrol\rock_ca.paa";
importance = "0.5 * 12 * 0.05";
size = 12;
};

class Ruin {
coefMax = 4;
coefMin = 1;
color[] = {0,0,0,1};
icon = "\A3\ui_f\data\map\mapcontrol\ruin_ca.paa";
importance = "1.2 * 16 * 0.05";
size = 16;
};

class SmallTree {
coefMax = 4;
coefMin = 0.25;
color[] = {0.45,0.64,0.33,0.4};
icon = "\A3\ui_f\data\map\mapcontrol\bush_ca.paa";
importance = "0.6 * 12 * 0.05";
size = 12;
};

class Stack {
coefMax = 4;
coefMin = 0.9;
color[] = {0,0,0,1};
icon = "\A3\ui_f\data\map\mapcontrol\stack_ca.paa";
importance = "2 * 16 * 0.05";
size = 20;
};

class Tree {
coefMax = 4;
coefMin = 0.25;
color[] = {0.45,0.64,0.33,0.4};
icon = "\A3\ui_f\data\map\mapcontrol\bush_ca.paa";
importance = "0.9 * 16 * 0.05";
size = 12;
};

class Task {
coefMax = 1;
coefMin = 1;
color[] = {"(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])","(profilenamespace getvariable ['IGUI_TEXT_RGB_G',1])","(profilenamespace getvariable ['IGUI_TEXT_RGB_B',1])","(profilenamespace getvariable ['IGUI_TEXT_RGB_A',0.8])"};
colorCanceled[] = {0.7,0.7,0.7,1};
colorCreated[] = {1,1,1,1};
colorDone[] = {0.7,1,0.3,1};
colorFailed[] = {1,0.3,0.2,1};
icon = "\A3\ui_f\data\map\mapcontrol\taskIcon_CA.paa";
iconCanceled = "\A3\ui_f\data\map\mapcontrol\taskIconCanceled_CA.paa";
iconCreated = "\A3\ui_f\data\map\mapcontrol\taskIconCreated_CA.paa";
iconDone = "\A3\ui_f\data\map\mapcontrol\taskIconDone_CA.paa";
iconFailed = "\A3\ui_f\data\map\mapcontrol\taskIconFailed_CA.paa";
importance = 1;
size = 27;
};

class Tourism {
coefMax = 4;
coefMin = 0.7;
color[] = {0,0,0,1};
icon = "\A3\ui_f\data\map\mapcontrol\tourism_ca.paa";
importance = "1 * 16 * 0.05";
size = 16;
};

class Transmitter {
coefMax = 1;
coefMin = 0.85;
color[] = {1,1,1,1};
icon = "\A3\ui_f\data\map\mapcontrol\transmitter_CA.paa";
importance = 1;
size = 24;
};

class ViewTower {
coefMax = 4;
coefMin = 0.5;
color[] = {0,0,0,1};
icon = "\A3\ui_f\data\map\mapcontrol\viewtower_ca.paa";
importance = "2.5 * 16 * 0.05";
size = 16;
};

class Watertower {
coefMax = 1;
coefMin = 0.85;
color[] = {1,1,1,1};
icon = "\A3\ui_f\data\map\mapcontrol\watertower_CA.paa";
importance = 1;
size = 24;
};

class power {
coefMax = 1;
coefMin = 0.85;
color[] = {1,1,1,1};
icon = "\A3\ui_f\data\map\mapcontrol\power_CA.paa";
importance = 1;
size = 24;
};

class powersolar {
coefMax = 1;
coefMin = 0.85;
color[] = {1,1,1,1};
icon = "\A3\ui_f\data\map\mapcontrol\powersolar_CA.paa";
importance = 1;
size = 24;
};

class powerwave {
coefMax = 1;
coefMin = 0.85;
color[] = {1,1,1,1};
icon = "\A3\ui_f\data\map\mapcontrol\powerwave_CA.paa";
importance = 1;
size = 24;
};

class powerwind {
coefMax = 1;
coefMin = 0.85;
color[] = {1,1,1,1};
icon = "\A3\ui_f\data\map\mapcontrol\powerwind_CA.paa";
importance = 1;
size = 24;
};

class Waypoint {
coefMax = 1;
coefMin = 1;
color[] = {0,0,0,1};
icon = "\A3\ui_f\data\map\mapcontrol\waypoint_ca.paa";
importance = 1;
size = 24;
};

class WaypointCompleted {
coefMax = 1;
coefMin = 1;
color[] = {0,0,0,1};
icon = "\A3\ui_f\data\map\mapcontrol\waypointCompleted_ca.paa";
importance = 1;
size = 24;
};
};

class Insurgency_RscMap {
access = 0;
class controls {
	class Map : Insurgency_RscMapControl {
	moveOnEdges = 0;
	x = 0;
	y = 0;
	w = 0.83;
	h = 1;
	};
	};
	};
	class ALiVECommandTablet_RscToolbox {
	idc = -1;
	type = CT_TOOLBOX;
	style = ST_CENTER;
	x = 0.1;
	y = 0.2;
	w = 0.2;
	h = 0.15;
	colorText[] = {1,1,1,1};
	color[] = {0,0,0,1};
	colorTextSelect[] = {0,0,0,1};
	colorSelect[] = {0,0,0,1};
	colorTextDisable[] = {0.4,0.4,0.4,1};
	colorDisable[] = {0.4,0.4,0.4,1};
	colorSelectedBg[] = {1,1,1,1};
	font = "PuristaMedium";
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	rows = 0;
	columns = 0;
	strings[] = {};
	values[] = {};
	onToolBoxSelChanged = "";
	};
	class RscButtonSpacer {
	type = 0;
	idc = 124;
	style = 128;
	text = "";
	colorText[] =
	{
	0,
	0,
	0,
	0
	};
	font = "PuristaMedium";
	sizeEx = 0;
	shadow = 0;
	x = 0.1;
	y = 0.1;
	w = 0.1;
	h = 0.1;
	colorBackground[] =
	{
	0,
	0,
	0,
	0.8
	};
};