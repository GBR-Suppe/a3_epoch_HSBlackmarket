/*
	a3 epoch trader
	tradermenu.hpp
	by Halv & Suppe

	Copyright (C) 2015  Halvhjearne & Suppe > README.md
*/

class HS_trader_dialog
{
	idd=9999;
	moveingenabled=false;
	class controls
	{
		class HS_trader_back: HALV_IGUIBack
		{
			idc = -1;
			x = 0.273196 * safezoneW + safezoneX;
			y = 0.192077 * safezoneH + safezoneY;
			w = 0.453608 * safezoneW;
			h = 0.615845 * safezoneH;
		};
		class HS_trader_frame: HALV_RscFrame
		{
			idc = -1;
			text = "HS Blackmarket Trader by Halv & Suppe";
			x = 0.273196 * safezoneW + safezoneX;
			y = 0.192077 * safezoneH + safezoneY;
			w = 0.453608 * safezoneW;
			h = 0.615845 * safezoneH;
		};
		class HS_trader_textframe: HALV_RscFrame
		{
			idc = -1;
			x = 0.293814 * safezoneW + safezoneX;
			y = 0.225069 * safezoneH + safezoneY;
			w = 0.0824742 * safezoneW;
			h = 0.0219945 * safezoneH;
		};
		class HS_trader_text: HALV_RscStructuredText
		{
			idc = -1;
			text = "$STR_HS_TRADERMENU"; //--- ToDo: Localize;
			x = 0.293814 * safezoneW + safezoneX;
			y = 0.225069 * safezoneH + safezoneY;
			w = 0.0824742 * safezoneW;
			h = 0.0219945 * safezoneH;
		};
		class HS_trader_buysellswitchBack: HALV_IGUIBack
		{
			idc = -1;
			x = 0.376289 * safezoneW + safezoneX;
			y = 0.247064 * safezoneH + safezoneY;
			w = 0.0824742 * safezoneW;
			h = 0.0219945 * safezoneH;
		};
		class HS_trader_buysellswitchFrame: HALV_RscFrame
		{
			idc = -1;
			x = 0.376289 * safezoneW + safezoneX;
			y = 0.247064 * safezoneH + safezoneY;
			w = 0.0824742 * safezoneW;
			h = 0.0219945 * safezoneH;
		};
		class HS_trader_buysellCheckbox: HALV_RscCheckbox
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
		class HS_trader_selltxtframe: HALV_RscFrame
		{
			idc = -1;
			x = 0.376289 * safezoneW + safezoneX;
			y = 0.225069 * safezoneH + safezoneY;
			w = 0.0824742 * safezoneW;
			h = 0.0219945 * safezoneH;
		};
		class HS_trader_selltxt: HALV_RscStructuredText
		{
			idc = 9996;
			text = "0 Crypto"; //--- ToDo: Localize;
			x = 0.376289 * safezoneW + safezoneX;
			y = 0.225069 * safezoneH + safezoneY;
			w = 0.0824742 * safezoneW;
			h = 0.0219945 * safezoneH;
			tooltip = "$STR_HS_CURRENTTRADE"; // Tooltip text
		};
		class HS_trader_confirm: HALV_RscButton
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
		class HS_trader_listboxframe: HALV_RscFrame
		{
			idc = -1;
			x = 0.293814 * safezoneW + safezoneX;
			y = 0.269057 * safezoneH + safezoneY;
			w = 0.164948 * safezoneW;
			h = 0.505873 * safezoneH;
		};
		class HS_trader_tree: HALV_CT_TREE
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
		class HS_trader_listbox: HALV_RscListBox
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

		class HS_trader_selecttypeback: HALV_IGUIBack
		{
			idc = -1;
			x = 0.324613 * safezoneW + safezoneX;
			y = 0.269058 * safezoneH + safezoneY;
			w = 0.350775 * safezoneW;
			h = 0.19795 * safezoneH;
		};
		class HS_trader_selecttypeframe: HALV_RscFrame
		{
			idc = -1;
			text = "HS Blackmarket Trader by Halv & Suppe"; //--- ToDo: Localize;
			x = 0.324613 * safezoneW + safezoneX;
			y = 0.269058 * safezoneH + safezoneY;
			w = 0.350775 * safezoneW;
			h = 0.19795 * safezoneH;
		};
		class HS_trader_selecttypetextframe: HALV_RscFrame
		{
			idc = -1;
			x = 0.33493 * safezoneW + safezoneX;
			y = 0.291052 * safezoneH + safezoneY;
			w = 0.330141 * safezoneW;
			h = 0.0329917 * safezoneH;
		};
		class HS_trader_selecttypetempframe: HALV_RscFrame
		{
			idc = -1;
			x = 0.510317 * safezoneW + safezoneX;
			y = 0.401025 * safezoneH + safezoneY;
			w = 0.154754 * safezoneW;
			h = 0.043989 * safezoneH;
		};
		class HS_trader_selecttypenorm: HALV_RscFrame
		{
			idc = -1;
			x = 0.33493 * safezoneW + safezoneX;
			y = 0.401025 * safezoneH + safezoneY;
			w = 0.154754 * safezoneW;
			h = 0.043989 * safezoneH;
		};
		class HS_trader_checkavaiframe: HALV_RscFrame
		{
			idc = -1;
			x = 0.33493 * safezoneW + safezoneX;
			y = 0.335041 * safezoneH + safezoneY;
			w = 0.330141 * safezoneW;
			h = 0.043989 * safezoneH;
		};
		class HS_trader_selecttypetext: HALV_RscStructuredText
		{
			idc = -1;
			text = "$STR_HS_SELECTHALFORFULLTEXT"; //--- ToDo: Localize;
			x = 0.33493 * safezoneW + safezoneX;
			y = 0.291052 * safezoneH + safezoneY;
			w = 0.330141 * safezoneW;
			h = 0.0329917 * safezoneH;
		};
		class HS_trader_selecttypenormbut: HALV_RscButton
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
		class HS_trader_selecttypetemp: HALV_RscButton
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
		class HS_trader_checkavai: HALV_RscButton
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