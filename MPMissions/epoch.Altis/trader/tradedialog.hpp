/*
	a3 epoch trader
	tradermenu.hpp
	by Halv & Suppe
*/
// Control types
#define CT_MAP_MAIN 101
#define CT_TREE 12
#define CT_STRUCTURED_TEXT 13
// Static styles
#define ST_PICTURE 0x30
#define ST_MULTI 16
// Listbox styles
#define ST_LEFT 0x00
#define LB_TEXTURES 0x10

// Base Classes

class HS_IGUIBack
{
	type = 0;
	idc = -1;
	style = 80;
	text = "";
	colorText[] = {.1,.1,.1,.6};
	font = "PuristaMedium";
	sizeEx = 0;
	shadow = 0;
	x = 0.1;
	y = 0.1;
	w = 0.1;
	h = 0.1;
	colorbackground[] = {.1,.1,.1,.6};
};

class HS_RscFrame
{
	type = 0;
	idc = -1;
	style = 64;
	shadow = 2;
	colorBackground[] = {0,.5,1,.8};
	colorText[] = {0,.5,1,.8};
	font = "PuristaLight";
	sizeEx = 0.02;
	text = "";
};

class HS_RscListBox
{
	access = 0;
	type = 5;
	w = 0.4;
	h = 0.4;
	rowHeight = 0;
	colorText[] = {1, 1, 1, 1};
	colorDisabled[] = {1, 1, 1, 0.25};
	colorScrollbar[] = {1, 0, 0, 0};
	colorSelect[] = {0, 0, 0, 1};
	colorSelect2[] = {0, 0, 0, 1};
	colorSelectBackground[] = {0.95, 0.95, 0.95, 1};
	colorSelectBackground2[] = {1, 1, 1, 0.5};
	colorBackground[] = {0.2,0.2,0.2,0.6};
	pictureColor[] = {1,1,1,1}; // Picture color
	pictureColorSelect[] = {1,1,1,1}; // Selected picture color
	pictureColorDisabled[] = {1,1,1,0.5}; // Disabled picture color
	soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect", 0.09, 1};
	arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
	arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
	class ListScrollBar
	{
		color[] = {1, 1, 1, 0.6};
		colorActive[] = {1, 1, 1, 1};
		colorDisabled[] = {1, 1, 1, 0.3};
		shadow = 0;
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
	};
	style = 16;
	font = "PuristaMedium";
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	shadow = 0;
	colorShadow[] = {0, 0, 0, 0.5};
	color[] = {1, 1, 1, 1};
	period = 1.2;
	maxHistoryDelay = 1;
	autoScrollSpeed = -1;
	autoScrollDelay = 5;
	autoScrollRewind = 0;
};

class HS_CT_TREE
{
	access = 0; // Control access (0 - ReadAndWrite, 1 - ReadAndCreate, 2 - ReadOnly, 3 - ReadOnlyVerified)
	type = CT_TREE; // Type is 12
	style = ST_LEFT; // Style
	x = 0.35567 * safezoneW + safezoneX;
	y = 0.137091 * safezoneH + safezoneY;
	w = 0.438144 * safezoneW;
	h = 0.725818 * safezoneH;
	colorBorder[] = {0,.5,1,.8}; // Frame color
	colorBackground[] = {0.2,0.2,0.2,0.6}; // Fill color
	colorSelect[] = {1,0.5,0,1}; // Selected item fill color (when multiselectEnabled is 0)
	colorMarked[] = {1,0.5,0,0.5}; // Marked item fill color (when multiselectEnabled is 1)
	colorMarkedSelected[] = {1,0.5,0,1}; // Selected item fill color (when multiselectEnabled is 1)
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	font = "EtelkaMonospacePro"; // Font from CfgFontFamilies
	shadow = 1; // Shadow (0 - none, 1 - N/A, 2 - black outline)
	colorText[] = {1,1,1,1}; // Text color
	colorSelectText[] = {1,1,1,1}; // Selected text color (when multiselectEnabled is 0)
	colorMarkedText[] = {1,1,1,1}; // Selected text color (when multiselectEnabled is 1)
	tooltip = ""; // Tooltip text
	tooltipColorShade[] = {0,0,0,1}; // Tooltip background color
	tooltipColorText[] = {1,1,1,1}; // Tooltip text color
	tooltipColorBox[] = {1,1,1,1}; // Tooltip frame color
	multiselectEnabled = 0; // Allow selecting multiple items while holding Ctrl or Shift
	expandOnDoubleclick = 1; // Expand/collapse item upon double-click
	hiddenTexture = "A3\ui_f\data\gui\rsccommon\rsctree\hiddenTexture_ca.paa"; // Expand icon
	expandedTexture = "A3\ui_f\data\gui\rsccommon\rsctree\expandedTexture_ca.paa"; // Collapse icon
	maxHistoryDelay = 1; // Time since last keyboard type search to reset it
	// Scrollbar configuration
	class ScrollBar
	{
		width = 0; // width of ScrollBar
		height = 0; // height of ScrollBar
//		scrollSpeed = 0.01; // scroll speed of ScrollBar
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa"; // Arrow
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa"; // Arrow when clicked on
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa"; // Slider background (stretched vertically)
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa"; // Dragging element (stretched vertically)
		color[] = {1,1,1,1}; // Scrollbar color
	};
	colorDisabled[] = {0,0,0,0}; // Does nothing, but must be present, otherwise an error is shown
	colorArrow[] = {0,0,0,0}; // Does nothing, but must be present, otherwise an error is shown
};

class HS_RscButton
{
	access = 0;
	type = 1;
	text = "";
	colorText[] = {1,1,1,0.8};
	colorDisabled[] = {0.4,0.4,0.4,1};
	colorBackground[] = {.7,.7,.7,.6};
	colorBackgroundDisabled[] = {.95,.95,.95,1};
	colorBackgroundActive[] = {.3,.3,.3,.6};
	colorFocused[] = {.7,.7,.7,.8};
	colorShadow[] = {.1,.1,.1,1};
	colorBorder[] = {.7,.7,.7,.5};
	soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1};
	soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1};
	soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1};
	soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1};
	style = 2;
	x = 0;
	y = 0;
	w = 0.095589;
	h = 0.039216;
	shadow = 1;
	font = "PuristaMedium";
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	offsetX = 0.003;
	offsetY = 0.003;
	offsetPressedX = 0.002;
	offsetPressedY = 0.002;
	borderSize = 0;
};

class HS_RscCheckbox
{
	idc = -1;
	type = 7;
	style = 2;
	x = "LINE_X(XVAL)";
	y = "LINE_Y";
	w = "LINE_W(WVAL)";
	h = 0.029412;
	colorText[] = {0,.5,1,1};
	color[] = {.7,.7,.7,.5};
	colorBackground[] = {.7,.7,.7,.2};
	colorTextSelect[] = {0, 0.8, 0,.8};
	colorSelectedBg[] = {.1,.1,.1,.2};
	colorSelect[] = {.7,.7,.7,.2};
	colorTextDisable[] = {0.4, 0.4, 0.4, 1};
	colorDisable[] = {0.4, 0.4, 0.4, 1};
	font = "PuristaMedium";
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	rows = 1;
	columns = 1;
};

class HS_RscStructuredText
{
	access = 0;
	type = CT_STRUCTURED_TEXT;
	idc = -1;
	style = ST_LEFT;
	colorText[] = {1,1,1,1};
	colorBackground[] = {.1,.1,.1,.6};
	class Attributes
	{
		font = "PuristaMedium";
		color = "#ffffff";
		align = "center";
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

class HS_trader_dialog
{
	idd=9999;
	moveingenabled=false;
	class controls
	{
		class HS_trader_back: HS_IGUIBack
		{
			idc = -1;
			x = 0.273196 * safezoneW + safezoneX;
			y = 0.192077 * safezoneH + safezoneY;
			w = 0.453608 * safezoneW;
			h = 0.615845 * safezoneH;
		};
		class HS_trader_frame: HS_RscFrame
		{
			idc = -1;
			text = "HS Blackmarket Trader by Halv & Suppe";
			x = 0.273196 * safezoneW + safezoneX;
			y = 0.192077 * safezoneH + safezoneY;
			w = 0.453608 * safezoneW;
			h = 0.615845 * safezoneH;
		};
		class HS_trader_textframe: HS_RscFrame
		{
			idc = -1;
			x = 0.293814 * safezoneW + safezoneX;
			y = 0.225069 * safezoneH + safezoneY;
			w = 0.0824742 * safezoneW;
			h = 0.0219945 * safezoneH;
		};
		class HS_trader_text: HS_RscStructuredText
		{
			idc = -1;
			text = "$STR_HS_TRADERMENU"; //--- ToDo: Localize;
			x = 0.293814 * safezoneW + safezoneX;
			y = 0.225069 * safezoneH + safezoneY;
			w = 0.0824742 * safezoneW;
			h = 0.0219945 * safezoneH;
		};
		class HS_trader_buysellswitchBack: HS_IGUIBack
		{
			idc = -1;
			x = 0.376289 * safezoneW + safezoneX;
			y = 0.247064 * safezoneH + safezoneY;
			w = 0.0824742 * safezoneW;
			h = 0.0219945 * safezoneH;
		};
		class HS_trader_buysellswitchFrame: HS_RscFrame
		{
			idc = -1;
			x = 0.376289 * safezoneW + safezoneX;
			y = 0.247064 * safezoneH + safezoneY;
			w = 0.0824742 * safezoneW;
			h = 0.0219945 * safezoneH;
		};
		class HS_trader_buysellCheckbox: HS_RscCheckbox
		{
			idc = -1;
			x = 0.376289 * safezoneW + safezoneX;
			y = 0.247064 * safezoneH + safezoneY;
			w = 0.0824742 * safezoneW;
			h = 0.0219945 * safezoneH;
			strings[] = {"$STR_HS_BUY_MODE"};
			checked_strings[] = {"$STR_HS_SELL_MODE"};
			onCheckBoxesSelChanged = "_this call HS_buyorsell;call HS_trader_menu;false";
			tooltip = "$STR_HS_CLICK_TOSWITCH"; // Tooltip text
		};
		class HS_trader_selltxtframe: HS_RscFrame
		{
			idc = -1;
			x = 0.376289 * safezoneW + safezoneX;
			y = 0.225069 * safezoneH + safezoneY;
			w = 0.0824742 * safezoneW;
			h = 0.0219945 * safezoneH;
		};
		class HS_trader_selltxt: HS_RscStructuredText
		{
			idc = 9996;
			text = "0 Crypto"; //--- ToDo: Localize;
			x = 0.376289 * safezoneW + safezoneX;
			y = 0.225069 * safezoneH + safezoneY;
			w = 0.0824742 * safezoneW;
			h = 0.0219945 * safezoneH;
			tooltip = "$STR_HS_CURRENTTRADE"; // Tooltip text
		};
		class HS_trader_confirm: HS_RscButton
		{
			idc = -1;
			text = "$STR_HS_CONFIRMTRADE"; //--- ToDo: Localize;
			x = 0.293814 * safezoneW + safezoneX;
			y = 0.247064 * safezoneH + safezoneY;
			w = 0.0824742 * safezoneW;
			h = 0.0219945 * safezoneH;
			action = "call HS_confirmtrade";
			tooltip = "$STR_HS_CLICKTOCONFIRMTRADE"; // Tooltip text
		};
		class HS_trader_listboxframe: HS_RscFrame
		{
			idc = -1;
			x = 0.293814 * safezoneW + safezoneX;
			y = 0.269057 * safezoneH + safezoneY;
			w = 0.164948 * safezoneW;
			h = 0.505873 * safezoneH;
		};
		class HS_trader_tree: HS_CT_TREE
		{
			idc = 9997;
			text = "";
			x = 0.458763 * safezoneW + safezoneX;
			y = 0.225069 * safezoneH + safezoneY;
			w = 0.247423 * safezoneW;
			h = 0.549862 * safezoneH;
			onTreeDblClick = "_this call HS_additemtolb;false";
			onTreeSelChanged = "_this call Halv_onlbtreeselected;false";
		};
		class HS_trader_listbox: HS_RscListBox
		{
			idc = 9998;
			x = 0.293814 * safezoneW + safezoneX;
			y = 0.269057 * safezoneH + safezoneY;
			w = 0.164948 * safezoneW;
			h = 0.505873 * safezoneH;
			onLBDblClick = "_this call HS_deleteitemfromlb;false";
			onLBSelChanged = "_this call Halv_onlbtreeselected;false";
		};
	};
};

class HS_trader_dialog2
{
	idd=9980;
	moveingenabled=false;
	class controls
	{

		class HS_trader_selecttypeback: HS_IGUIBack
		{
			idc = -1;
			x = 0.324613 * safezoneW + safezoneX;
			y = 0.269058 * safezoneH + safezoneY;
			w = 0.350775 * safezoneW;
			h = 0.19795 * safezoneH;
		};
		class HS_trader_selecttypeframe: HS_RscFrame
		{
			idc = -1;
			text = "HS Blackmarket Trader by Halv & Suppe"; //--- ToDo: Localize;
			x = 0.324613 * safezoneW + safezoneX;
			y = 0.269058 * safezoneH + safezoneY;
			w = 0.350775 * safezoneW;
			h = 0.19795 * safezoneH;
		};
		class HS_trader_selecttypetextframe: HS_RscFrame
		{
			idc = -1;
			x = 0.33493 * safezoneW + safezoneX;
			y = 0.291052 * safezoneH + safezoneY;
			w = 0.330141 * safezoneW;
			h = 0.0329917 * safezoneH;
		};
		class HS_trader_selecttypetempframe: HS_RscFrame
		{
			idc = -1;
			x = 0.510317 * safezoneW + safezoneX;
			y = 0.401025 * safezoneH + safezoneY;
			w = 0.154754 * safezoneW;
			h = 0.043989 * safezoneH;
		};
		class HS_trader_selecttypenorm: HS_RscFrame
		{
			idc = -1;
			x = 0.33493 * safezoneW + safezoneX;
			y = 0.401025 * safezoneH + safezoneY;
			w = 0.154754 * safezoneW;
			h = 0.043989 * safezoneH;
		};
		class HS_trader_checkavaiframe: HS_RscFrame
		{
			idc = -1;
			x = 0.33493 * safezoneW + safezoneX;
			y = 0.335041 * safezoneH + safezoneY;
			w = 0.330141 * safezoneW;
			h = 0.043989 * safezoneH;
		};
		class HS_trader_selecttypetext: HS_RscStructuredText
		{
			idc = -1;
			text = "$STR_HS_SELECTHALFORFULLTEXT"; //--- ToDo: Localize;
			x = 0.33493 * safezoneW + safezoneX;
			y = 0.291052 * safezoneH + safezoneY;
			w = 0.330141 * safezoneW;
			h = 0.0329917 * safezoneH;
		};
		class HS_trader_selecttypenormbut: HS_RscButton
		{
			idc = -1;
			text = "$STR_HS_BUYFULLPRICE"; //--- ToDo: Localize;
			x = 0.334929 * safezoneW + safezoneX;
			y = 0.401025 * safezoneH + safezoneY;
			w = 0.154754 * safezoneW;
			h = 0.043989 * safezoneH;
//			tooltip = "$STR_HS_PRESSTOBUYHALFPRICE"; //--- ToDo: Localize;
			action = "call HS_buyvehiclesaved";
		};
		class HS_trader_selecttypetemp: HS_RscButton
		{
			idc = -1;
			text = "$STR_HS_BUYHALFPRICE"; //--- ToDo: Localize;
			x = 0.510317 * safezoneW + safezoneX;
			y = 0.401025 * safezoneH + safezoneY;
			w = 0.154754 * safezoneW;
			h = 0.043989 * safezoneH;
			tooltip = "$STR_HS_PRESSTOBUYHALFPRICE"; //--- ToDo: Localize;
			action = "call HS_buyvehicletemp";
		};
		class HS_trader_checkavai: HS_RscButton
		{
			idc = -1;
			text = "$STR_HS_BUYCHECK"; //--- ToDo: Localize;
			x = 0.33493 * safezoneW + safezoneX;
			y = 0.335041 * safezoneH + safezoneY;
			w = 0.330141 * safezoneW;
			h = 0.043989 * safezoneH;
			tooltip = "$STR_HS_PRESSTOCHECK"; //--- ToDo: Localize;
			action = "call HS_checkavailability";
		};
	};
};