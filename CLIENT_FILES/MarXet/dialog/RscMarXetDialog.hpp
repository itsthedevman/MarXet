class RscMarXetDialog
{
	idd = 21000;
	onLoad = "uiNamespace setVariable ['RscMarXetDialog', _this select 0]; [""Load""] call ExileClient_MarXet_gui_load";
	onUnload = "[""UnLoad""] call ExileClient_MarXet_gui_load;uiNamespace setVariable ['RscMarXetDialog', displayNull];";
	class controls
	{
		class MarXetCenterPanelBackground: RscMarXetText
        {
        	idc = 21001;
        	x = 0.402031 * safezoneW + safezoneX;
        	y = 0.247 * safezoneH + safezoneY;
        	w = 0.195937 * safezoneW;
        	h = 0.528 * safezoneH;
        	colorBackground[] = {0.05,0.05,0.05,0.7};
        };
        class MarXetCreateAListingTitleBackground: RscMarXetText
        {
        	idc = 21002;
        	text = "CREATE A LISTING";
        	x = 0.200937 * safezoneW + safezoneX;
        	y = 0.2206 * safezoneH + safezoneY;
        	w = 0.195937 * safezoneW;
        	h = 0.022 * safezoneH;
        	colorBackground[] = {0.1,0.1,0.1,1};
        };
        class MarXetRightPanelBackground: RscMarXetText
        {
        	idc = 21003;
        	x = 0.603125 * safezoneW + safezoneX;
        	y = 0.247 * safezoneH + safezoneY;
        	w = 0.195937 * safezoneW;
        	h = 0.528 * safezoneH;
        	colorBackground[] = {0.05,0.05,0.05,0.7};
        };
        class MarXetLeftPanelBackground: RscMarXetText
        {
        	idc = 21004;
        	x = 0.200937 * safezoneW + safezoneX;
        	y = 0.247 * safezoneH + safezoneY;
        	w = 0.195937 * safezoneW;
        	h = 0.528 * safezoneH;
        	colorBackground[] = {0.05,0.05,0.05,0.7};
        };
        class MarXetInformationTitleBackground: RscMarXetText
        {
        	idc = 21005;
        	text = "INFORMATION";
        	x = 0.402031 * safezoneW + safezoneX;
        	y = 0.2206 * safezoneH + safezoneY;
        	w = 0.195937 * safezoneW;
        	h = 0.022 * safezoneH;
        	colorBackground[] = {0.1,0.1,0.1,1};
        };
        class MarXetLeftPanelTitleBackground: RscMarXetText
        {
        	idc = 21006;
        	text = "CURRENT LISTINGS";
        	x = 0.603125 * safezoneW + safezoneX;
        	y = 0.2206 * safezoneH + safezoneY;
        	w = 0.195937 * safezoneW;
        	h = 0.022 * safezoneH;
        	colorBackground[] = {0.1,0.1,0.1,1};
        };
		class CenterDescription: RscMarXetStructuredText
		{
			idc = 21008;

			text = "<t font='OrbitronLight' size='0.7'><t size='1' align='center'>WELCOME!</t><br/>Buying:<br/>Choose your new purchase in the list to the right and click purchase.<br/>Listing/Selling:<br/>Click your desired item/vehicle you want to list on the left<br/>Set your price and click Confirm Listing<br/><br/><t color='#ff0000'>WARNING:</t><br/>Any items in vehicles or any attachments on weapons will be deleted upon listing!</t>";
			x = 0.412344 * safezoneW + safezoneX;
			y = 0.346 * safezoneH + safezoneY;
			w = 0.175313 * safezoneW;
			h = 0.22 * safezoneH;
			colorBackground[] = {-1,-1,-1,0};
		};
		class CenterItemName: RscMarXetText
		{
			idc = 21009;
			x = 0.427812 * safezoneW + safezoneX;
			y = 0.577 * safezoneH + safezoneY;
			w = 0.144375 * safezoneW;
			h = 0.022 * safezoneH;
			colorBackground[] = {-1,-1,-1,0};
			SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			style = 0x02;
		};
		class CenterPriceTitle: RscMarXetText
		{
			idc = 21010;

			text = "PRICE:";
			x = 0.427812 * safezoneW + safezoneX;
			y = 0.61 * safezoneH + safezoneY;
			w = 0.0360947 * safezoneW;
			h = 0.022 * safezoneH;
			colorBackground[] = {-1,-1,-1,0};
		};
		class CenterPriceEditBox: RscMarXetEdit
		{
			idc = 21011;
			x = 0.463906 * safezoneW + safezoneX;
			y = 0.61 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.022 * safezoneH;
			colorBackground[] = {-1,-1,-1,0};
			colorText[] = {0.988,0.749,0,1};
		};
		class CenterVehicleDamage: RscMarXetText
		{
			idc = 21020;
			show = false;
			text = "Health:";
			x = 0.427812 * safezoneW + safezoneX;
			y = 0.676 * safezoneH + safezoneY;
			w = 0.0464063 * safezoneW;
			h = 0.022 * safezoneH;
			colorBackground[] = {-1,-1,-1,0};
		};
		class CenterVehicleHealthPercentage: RscMarXetText
		{
			idc = 21021;
			show = false;
			text = "100%";
			x = 0.463219 * safezoneW + safezoneX;
			y = 0.676 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.022 * safezoneH;
			colorBackground[] = {-1,-1,-1,0};
			colorText[] = {0.988,0.749,0,1};
		};
		class CenterVehicleFuel: RscMarXetText
		{
			idc = 21022;
			show = false;
			text = "Fuel:";
			x = 0.5 * safezoneW + safezoneX;
			y = 0.676 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.022 * safezoneH;
			colorBackground[] = {-1,-1,-1,0};
		};
		class CenterVehicleFuelPercentage: RscMarXetText
		{
			idc = 21023;
			show = false;
			text = "100%";
			x = 0.533307 * safezoneW + safezoneX;
			y = 0.676 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.022 * safezoneH;
			colorBackground[] = {-1,-1,-1,0};
			colorText[] = {0.988,0.749,0,1};
		};
		class CenterPurchaseButton: RscMarXetButton
		{
			idc = 21014;
			text = "Purchase";
			x = 0.505156 * safezoneW + safezoneX;
			y = 0.72 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.033 * safezoneH;
			onButtonClick = "[""buttonPressed"",0] call ExileClient_MarXet_gui_load;";
		};
		class CenterConfirmButton: RscMarXetButton
		{
			idc = 21024;
			text = "Comfirm Listing";
			show = false;
			x = 0.505156 * safezoneW + safezoneX;
			y = 0.72 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.033 * safezoneH;
			onButtonClick = "[""buttonPressed"",1] call ExileClient_MarXet_gui_load;";
		};
		class CenterExitButton: RscMarXetButton
		{
			idc = 21015;
			text = "Exit";
			x = 0.4175 * safezoneW + safezoneX;
			y = 0.72 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.033 * safezoneH;
			onButtonClick = "closeDialog 21000;";
		};
        class RightDropdown: RscMarXetCombo
        {
        	idc = 21016;
			x = 0.608281 * safezoneW + safezoneX;
			y = 0.258 * safezoneH + safezoneY;
			w = 0.0896563 * safezoneW;
			h = 0.022 * safezoneH;
        };
        class RightListbox: RscExileMarXetItemListBox
        {
        	idc = 21017;
        	x = 0.608281 * safezoneW + safezoneX;
        	y = 0.291 * safezoneH + safezoneY;
        	w = 0.185625 * safezoneW;
        	h = 0.473 * safezoneH;
        };
        class LeftListbox: RscExileMarXetItemListBox
        {
        	idc = 21018;
        	x = 0.206094 * safezoneW + safezoneX;
        	y = 0.291 * safezoneH + safezoneY;
        	w = 0.185625 * safezoneW;
        	h = 0.473 * safezoneH;
        };
        class LeftDropdown: RscMarXetCombo
        {
        	idc = 21019;
        	x = 0.206094 * safezoneW + safezoneX;
        	y = 0.258 * safezoneH + safezoneY;
        	w = 0.113437 * safezoneW;
        	h = 0.022 * safezoneH;
        };
		class LeftPanelPlayerMoney: RscMarXetStructuredText
		{
			idc = 21025;
			x = 0.313344 * safezoneW + safezoneX;
			y = 0.2206 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			colorBackground[] = {-1,-1,-1,0};
		};
		class VehiclePinCode: RscMarXetText
		{
			idc = 21031;
			show = false;
			text = "PIN CODE:"; //--- ToDo: Localize;
			x = 0.427812 * safezoneW + safezoneX;
			y = 0.643 * safezoneH + safezoneY;
			w = 0.0464063 * safezoneW;
			h = 0.022 * safezoneH;
			colorBackground[] = {-1,-1,-1,0};
		};
		class VehiclePinCodeEditBox: RscMarXetEdit
		{
			idc = 21032;
			show = false;
			x = 0.482219 * safezoneW + safezoneX;
			y = 0.6432 * safezoneH + safezoneY;
			w = 0.0567187 * safezoneW;
			h = 0.022 * safezoneH;
			colorBackground[] = {-1,-1,-1,0};
		};
		class Sorting: RscMarXetCombo
		{
			idc = 21033;
			x = 0.702094 * safezoneW + safezoneX;
			y = 0.258 * safezoneH + safezoneY;
			w = 0.0908125 * safezoneW;
			h = 0.022 * safezoneH;
		};

		class NotificationBackground: RscMarXetText
		{
			idc = 21029;
			show = false;
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.2206 * safezoneH + safezoneY;
			w = 0.598125 * safezoneW;
			h = 0.5544 * safezoneH;
			colorBackground[] = {0.067,0.082,0.094,0.95};
		};
		class NotificationTitle: RscMarXetStructuredText
		{
			idc = 21030;
			show = false;
			x = 0.355625 * safezoneW + safezoneX;
			y = 0.401 * safezoneH + safezoneY;
			w = 0.185625 * safezoneW;
			h = 0.044 * safezoneH;
			colorBackground[] = {-1,-1,-1,0};
		};
		class NotificationText: RscMarXetStructuredText
		{
			idc = 21026;
			show = false;
			x = 0.355625 * safezoneW + safezoneX;
			y = 0.456 * safezoneH + safezoneY;
			w = 0.299062 * safezoneW;
			h = 0.11 * safezoneH;
			colorBackground[] = {-1,-1,-1,0};
		};
		class NotificationConfirm: RscMarXetButton
		{
			idc = 21027;
			show = false;
			text = "Purchase"; //--- ToDo: Localize;
			x = 0.489687 * safezoneW + safezoneX;
			y = 0.588 * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.022 * safezoneH;
			onButtonClick = "[""DisplayNotification"",1] call ExileClient_MarXet_gui_load;";
		};
		class NotificationCancel: RscMarXetButton
		{
			idc = 21028;
			show = false;
			text = "Cancel"; //--- ToDo: Localize;
			x = 0.572187 * safezoneW + safezoneX;
			y = 0.588 * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.022 * safezoneH;
			onButtonClick = "[""DisplayNotification"",2] call ExileClient_MarXet_gui_load;";
		};

		class CenterMarXetTitle: RscMarXetStructuredText
		{
			idc = 21007;

			text = "<t color='#FFFFFF' font='OrbitronLight' size='2' valign='middle' align='center' shadow='0'>Mar<t color='#531517' font='OrbitronLight' size='2' valign='middle' align='center' shadow='0'>X</t>et</t>";
			x = 0.427812 * safezoneW + safezoneX;
			y = 0.2705 * safezoneH + safezoneY;
			w = 0.144375 * safezoneW;
			h = 0.077 * safezoneH;
			colorBackground[] = {-1,-1,-1,0};
		};
    };
};
