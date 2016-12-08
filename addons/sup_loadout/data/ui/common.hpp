#define GUI_GRID_X      (0)
#define GUI_GRID_Y      (0)
#define GUI_GRID_W      (0.025)
#define GUI_GRID_H      (0.04)
#define GUI_GRID_WAbs   (1)
#define GUI_GRID_HAbs   (1)

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

#define MyTag_ST_UNDEFINED              0       // Not Sure what this is
#define MyTag_ST_POS                    0x0F
#define MyTag_ST_HPOS                   0x03
#define MyTag_ST_VPOS                   0x0C
#define MyTag_ST_LEFT                   0x00    //left aligned text
#define MyTag_ST_RIGHT                  0x01    //left aligned text
#define MyTag_ST_CENTER                 0x02    //center aligned text
#define MyTag_ST_DOWN                   0x04
#define MyTag_ST_UP                     0x08
#define MyTag_ST_VCENTER                0x0C

#define MyTag_ST_TYPE                   0xF0
#define MyTag_ST_SINGLE                 0x00    //single line textbox
#define MyTag_ST_MULTI                  0x10    //multi-line textbox (text will wrap, and newline character can be used). There is no scrollbar, but mouse wheel/arrows can scroll it. Control will be outlined with a line (color = text color).
#define MyTag_ST_TITLE_BAR              0x20
#define MyTag_ST_PICTURE                0x30    //turns a static control into a picture control. 'Text' will be used as picture path. Picture will be stretched to fit the control.
#define MyTag_ST_FRAME                  0x40    //control becomes a frame. Background is clear and text is placed along the top edge of the control. Control is outlined with text color (as in MyTag_ST_MULTI)
#define MyTag_ST_BACKGROUND             0x50
#define MyTag_ST_GROUP_BOX              0x60
#define MyTag_ST_GROUP_BOX2             0x70
#define MyTag_ST_HUD_BACKGROUND         0x80    //control is rounded and outlined (just like a hint box)
#define MyTag_ST_TILE_PICTURE           0x90
#define MyTag_ST_WITH_RECT              0xA0
#define MyTag_ST_LINE                   0xB0    //a line is drawn between the top left and bottom right of the control (color = text color). Background is clear. Control can still have text, however.

#define MyTag_ST_SHADOW                 0x100   //text or image is given a shadow
#define MyTag_ST_NO_RECT                0x200   //when combined with MyTag_ST_MULTI, it eliminates the outline around the control. Might combine with other styles for similar effect.
#define MyTag_ST_KEEP_ASPECT_RATIO      0x800   //used for pictures, it makes the displayed picture keep its aspect ratio.

#define MyTag_ST_TITLE                  MyTag_ST_TITLE_BAR + MyTag_ST_CENTER

// Slider styles
#define MyTag_SL_DIR                    0x400
#define MyTag_SL_VERT                   0
#define MyTag_SL_HORZ                   0x400

#define MyTag_SL_TEXTURES               0x10

// progress bar
#define MyTag_ST_VERTICAL               0x01
#define MyTag_ST_HORIZONTAL             0

// Listbox styles
#define MyTag_LB_TEXTURES               0x10    //removes all extra lines from listbox, leaving only a gradiant scrollbar. Useful when LB has a painted background behind it.
#define MyTag_LB_MULTI                  0x20    //allows multiple elements of the LB to be selected (by holding shift / ctrl)

// Tree styles
#define MyTag_TR_SHOWROOT               1
#define MyTag_TR_AUTOCOLLAPSE           2

// MessageBox styles
#define MyTag_MB_BUTTON_OK              1
#define MyTag_MB_BUTTON_CANCEL          2
#define MyTag_MB_BUTTON_USER            4

///////////////////////////////////////////////////////////////////////////
/// Base Classes
///////////////////////////////////////////////////////////////////////////

class RscText;
class RscButton;
class RscCombo;
class RscListBox;
class RscListNBox;
class RscEdit;
class RscFrame;

class LoadoutManager_RscText : RscText {
    access = 0;
    type = 0;
    idc = -1;
    colorBackground[] = {0,0,0,0};
    colorText[] = {1,1,1,1};
    text = "";
    fixedWidth = 0;
    x = 0;
    y = 0;
    h = 0.037;
    w = 0.3;
    class Attributes {
        font = "PuristaMedium";
        color = "#C0C0C0";
        align = "center";
        valign = "middle";
        shadow = false;
        shadowColor = "#000000";
    };
    style = 0;
    font = "PuristaMedium";
    SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
    linespacing = 1;
};

class LoadoutManager_RscPicture {
    access = 0;
    type = 0;
    idc = -1;
    style = 48;
    colorBackground[] ={0,0,0,0};
    colorText[] ={1,1,1,1};
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

class LoadoutManager_RscEdit {
    access = 0;
    type = 2;
    x = 0;
    y = 0;
    h = 0.04;
    w = 0.2;
    colorBackground[] = {0,0,0,1};
    colorText[] = {0.95,0.95,0.95,1};
    colorDisabled[] = {1,1,1,0.25};
    colorSelection[] = {
        "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.69])",
        "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.75])",
        "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.5])",
        1
    };
    autocomplete = "";
    text = "";
    size = 0.2;
    style = "0x00 + 0x40";
    font = "PuristaMedium";
    shadow = 2;
    sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
    canModify = 1;
};

class LoadoutManager_RscCombo {
    access = 0;
    type = 4;
    colorSelect[] = {0,0,0,1};
    colorText[] = {0.95,0.95,0.95,1};
    colorBackground[] = {0,0,0,1};
    coloLoadoutManager_Rscrollbar[] = {1,0,0,1};
    soundSelect[] =
    {
        "\A3\ui_f\data\sound\LoadoutManager_RscCombo\soundSelect",
        0.1,
        1
    };
    soundExpand[] =
    {
        "\A3\ui_f\data\sound\LoadoutManager_RscCombo\soundExpand",
        0.1,
        1
    };
    soundCollapse[] =
    {
        "\A3\ui_f\data\sound\LoadoutManager_RscCombo\soundCollapse",
        0.1,
        1
    };
    maxHistoryDelay = 1;
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
      class ComboScrollBar
       {
            color[] = {1,1,1,0.6};
            colorActive[] = {1,1,1,1};
         colorDisabled[] = {1,1,1,0.3};
         shadow = 0;
         arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
            arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
           border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
         thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
      };
    style = 16;
    x = 0;
    y = 0;
    w = 0.12;
    h = 0.035;
    shadow = 0;
    colorSelectBackground[] ={1,1,1,0.7};
    arrowEmpty = "\A3\ui_f\data\GUI\LoadoutManager_RscCommon\LoadoutManager_Rsccombo\arrow_combo_ca.paa";
    arrowFull = "\A3\ui_f\data\GUI\LoadoutManager_RscCommon\LoadoutManager_Rsccombo\arrow_combo_active_ca.paa";
    wholeHeight = 0.45;
    color[] = {1,1,1,1};
    colorActive[] = {1,0,0,1};
    colorDisabled[] = {1,1,1,0.25};
    font = "PuristaMedium";
    sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
};

class LoadoutManager_RscFrame : RscFrame {
    colorBackground[] = {0,0,0,0};
    colorText[] = {1,1,1,1};
    font = "PuristaMedium";
    shadow = 2;
    sizeEx = 0.02;
    style = 0x40;
    text = "";
    type = 0;
};

class LoadoutManager_RscButton : RscButton {
    access = 0;
    type = 1;
    text = "";
    colorText[] = {1,1,1,1};
    colorDisabled[] = {1,1,1,0.25};
    colorSelect[] = {0,0,0,0.5};
    colorSelect2[] = {0,0,0,0.5};
    colorBackground[] = {0,0,0,0.5};
    colorBackgroundDisabled[] = {0,0,0,0.5};
    colorBackgroundActive[] = {1,1,1,.7};
    class Attributes {
        font = "RobotoCondensed";
        color = "#C0C0C0";
        align = "center";
        valign = "middle";
        shadow = false;
        shadowColor = "#000000";
    };
    font = "RobotoCondensed";
    sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
    borderSize = 0;
    colorFocused[] = {0,0,0,.5};
    colorShadow[] = {0,0,0,0};
    colorBorder[] = {0,0,0,1};
    style = 2;
};

class LoadoutManager_RscListBox : RscListBox {
    style = 16;
    type = 5;
    rowHeight = 0.0375;
    colorText[] = {1,1,1,1};
    colorDisabled[] = {1,1,1,0.25};
    colorRsc_Rscrollbar[] = {1,0,0,0};
    colorSelect[] = {0,0,0,1};
    colorSelect2[] = {0,0,0,1};
    colorSelectBackground[] = {0.95,0.95,0.95,1};
    colorSelectBackground2[] = {1,1,1,0.5};
    colorBackground[] = {0,0,0,0.3};
    font = "PuristaMedium";
    sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
    colorShadow[] = {0,0,0,0.5};
    color[] = {1,1,1,1};
    period = 1.2;
};
/*
class LoadoutManager_RscListNBox : RscListNBox {
    style = "ST_LEFT + LB_TEXTURES";
    type = 102;
    rowHeight = .05;
    idcLeft = -1;
    idcRight = -1;
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
    period = 1;
    sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
    drawSideArrows = 1;
};
*/

class LoadoutManager_RscListNBox : RscListNBox {
    style = "ST_LEFT + LB_TEXTURES";
    type = 102;
    rowHeight = .05;
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
    period = 1;
    sizeEx = "(safeZoneH / 100) + (safeZoneH / 100)";
    autoScrollDelay = 5;
    autoScrollRewind = 0;
    autoScrollSpeed = -1;
    arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
    arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
    drawSideArrows = 1;
};


class LoadoutManager_RscStructuredText {
    access = 0;
    type = 13;
    idc = -1;
    style = 0;
    colorText[] = {1,1,1,1};
    class Attributes
    {
        font = "PuristaMedium";
        color = "#ffffff";
        align = "left";
        shadow = 1;
    };
    x = 0;
    y = 0;
    h = 0.035;
    w = 0.1;
    text = "";
    size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
    shadow = 1;
};

class LoadoutManager_RscControlsGroup {
    class VScrollbar
    {
        color[] = {1,1,1,1};
        width = 0.021;
        autoScrollSpeed = -1;
        autoScrollDelay = 5;
        autoScrollRewind = 0;
        shadow = 0;
    };
    class HScrollbar
    {
        color[] = {1,1,1,1};
        height = 0.028;
        shadow = 0;
    };
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
    class Controls
    {
    };
    type = 15;
    idc = -1;
    x = 0;
    y = 0;
    w = 1;
    h = 1;
    shadow = 0;
    style = 16;
};