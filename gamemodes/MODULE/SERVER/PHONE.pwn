new PlayerText:phTextD[32][MAX_PLAYERS];
new bool: UsingPhone[MAX_PLAYERS];
new bool: CallingNum[MAX_PLAYERS];
new EnteredPhoneNumb[MAX_PLAYERS][7];

CMD:showphone(playerid, params[])
{
	if(!UsingPhone[playerid])
	{
		LoadPhoneVisuals(playerid);

		for(new i; i < sizeof(phTextD); i ++)
		{
			PlayerTextDrawShow(playerid, phTextD[i][playerid]);
		}

		SelectTextDraw(playerid, 0x616161FF);
		UsingPhone[playerid] = true;
	}

	else if(UsingPhone[playerid])
	{
		for(new i; i < sizeof(phTextD); i ++)
		{
			PlayerTextDrawDestroy(playerid, phTextD[i][playerid]);
		}

        CancelSelectTextDraw(playerid);
		UsingPhone[playerid] = false;
	}

	return true;
}

stock LoadPhoneVisuals(playerid)
{
					///////////////////////////////////
					// -- // PHONE SHAPE/BOXES // -- //
					///////////////////////////////////

	phTextD[0][playerid] = CreatePlayerTextDraw(playerid, 596.333190, 290.625885, "case");
	PlayerTextDrawLetterSize(playerid, phTextD[0][playerid], 0.000000, 16.345470);
	PlayerTextDrawTextSize(playerid, phTextD[0][playerid], 517.000000, 0.000000);
	PlayerTextDrawUseBox(playerid, phTextD[0][playerid], true);
	PlayerTextDrawBoxColor(playerid, phTextD[0][playerid], 255);
	PlayerTextDrawFont(playerid, phTextD[0][playerid], 0);
	PlayerTextDrawSetProportional(playerid, phTextD[0][playerid], 1);

	phTextD[1][playerid] = CreatePlayerTextDraw(playerid, 592.000366, 304.314910, "screen");
	PlayerTextDrawLetterSize(playerid, phTextD[1][playerid], 0.000000, 6.029420);
	PlayerTextDrawTextSize(playerid, phTextD[1][playerid], 520.666687, 0.000000);
	PlayerTextDrawUseBox(playerid, phTextD[1][playerid], true);
	PlayerTextDrawBoxColor(playerid, phTextD[1][playerid], 1822335999);
	PlayerTextDrawFont(playerid, phTextD[1][playerid], 0);

	phTextD[2][playerid] = CreatePlayerTextDraw(playerid, 592.666503, 364.463134, "num_pad");
	PlayerTextDrawLetterSize(playerid, phTextD[2][playerid], 0.000000, 7.598971);
	PlayerTextDrawTextSize(playerid, phTextD[2][playerid], 520.333312, 0.000000);
	PlayerTextDrawUseBox(playerid, phTextD[2][playerid], true);
	PlayerTextDrawBoxColor(playerid, phTextD[2][playerid], 387389439);
	PlayerTextDrawFont(playerid, phTextD[2][playerid], 0);

					////////////////////////////////////
					// -- // PHONE SCREEN STUFF // -- //
					////////////////////////////////////

	phTextD[19][playerid] = CreatePlayerTextDraw(playerid, 536.999633, 289.125976, "Badger");
	PlayerTextDrawLetterSize(playerid, phTextD[19][playerid], 0.311333, 1.268148);
	PlayerTextDrawColor(playerid, phTextD[19][playerid], 572662527);
	PlayerTextDrawBackgroundColor(playerid, phTextD[19][playerid], 51);

	phTextD[3][playerid] = CreatePlayerTextDraw(playerid, 524.666625, 303.229583, "IIII");
	PlayerTextDrawLetterSize(playerid, phTextD[3][playerid], 0.202666, 0.608592);
	PlayerTextDrawColor(playerid, phTextD[3][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, phTextD[3][playerid], 51);
	PlayerTextDrawFont(playerid, phTextD[3][playerid], 2);

	phTextD[4][playerid] = CreatePlayerTextDraw(playerid, 535.666748, 322.725921, "Whiz");
	PlayerTextDrawLetterSize(playerid, phTextD[4][playerid], 0.449999, 1.600000);
	PlayerTextDrawAlignment(playerid, phTextD[4][playerid], 1);
	PlayerTextDrawColor(playerid, phTextD[4][playerid], 1822335999);
	PlayerTextDrawBackgroundColor(playerid, phTextD[4][playerid], 51);

    phTextD[5][playerid] = CreatePlayerTextDraw(playerid, 525.000122, 345.444519, "");
	PlayerTextDrawLetterSize(playerid, phTextD[5][playerid], 0.5, 1.2);
	PlayerTextDrawSetShadow(playerid, phTextD[5][playerid], 0);
	PlayerTextDrawSetOutline(playerid, phTextD[5][playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, phTextD[5][playerid], 51);

					///////////////////////////////////
					// -- // PHONE NUMPAD KEYS // -- //
					///////////////////////////////////

	phTextD[7][playerid] = CreatePlayerTextDraw(playerid, 545.333312, 366.537017, "num_1");
	PlayerTextDrawUseBox(playerid, phTextD[7][playerid], true);
	PlayerTextDrawBoxColor(playerid, phTextD[7][playerid], 858993663);
	PlayerTextDrawFont(playerid, phTextD[7][playerid], 0);
	PlayerTextDrawLetterSize(playerid, phTextD[7][playerid], 0.000000, 1.434774);
	PlayerTextDrawTextSize(playerid, phTextD[7][playerid], 523.666564, 0.000000);

	phTextD[8][playerid] = CreatePlayerTextDraw(playerid, 545.333007, 383.544525, "num_2");
	PlayerTextDrawLetterSize(playerid, phTextD[8][playerid], 0.000000, 1.434774);
	PlayerTextDrawTextSize(playerid, phTextD[8][playerid], 523.666381, 0.000000);
	PlayerTextDrawUseBox(playerid, phTextD[8][playerid], true);
	PlayerTextDrawBoxColor(playerid, phTextD[8][playerid], 858993663);
	PlayerTextDrawFont(playerid, phTextD[8][playerid], 0);

	phTextD[9][playerid] = CreatePlayerTextDraw(playerid, 545.333374, 400.551849, "num_3");
	PlayerTextDrawLetterSize(playerid, phTextD[9][playerid], 0.000000, 1.434774);
	PlayerTextDrawTextSize(playerid, phTextD[9][playerid], 523.666687, 0.000000);
	PlayerTextDrawUseBox(playerid, phTextD[9][playerid], true);
	PlayerTextDrawBoxColor(playerid, phTextD[9][playerid], 858993663);
	PlayerTextDrawFont(playerid, phTextD[9][playerid], 0);

	phTextD[10][playerid] = CreatePlayerTextDraw(playerid, 545.333251, 417.559387, "num_4");
	PlayerTextDrawLetterSize(playerid, phTextD[10][playerid], 0.000000, 1.434774);
	PlayerTextDrawTextSize(playerid, phTextD[10][playerid], 523.666625, 0.000000);
	PlayerTextDrawUseBox(playerid, phTextD[10][playerid], true);
	PlayerTextDrawBoxColor(playerid, phTextD[10][playerid], 858993663);
	PlayerTextDrawFont(playerid, phTextD[10][playerid], 0);

	phTextD[11][playerid] = CreatePlayerTextDraw(playerid, 589.666625, 366.537017, "num_5");
	PlayerTextDrawLetterSize(playerid, phTextD[11][playerid], 0.000000, 1.422016);
	PlayerTextDrawTextSize(playerid, phTextD[11][playerid], 567.666625, 0.000000);
	PlayerTextDrawUseBox(playerid, phTextD[11][playerid], true);
	PlayerTextDrawBoxColor(playerid, phTextD[11][playerid], 858993663);
	PlayerTextDrawFont(playerid, phTextD[11][playerid], 0);

	phTextD[12][playerid] = CreatePlayerTextDraw(playerid, 589.666687, 383.544586, "num_6");
	PlayerTextDrawLetterSize(playerid, phTextD[12][playerid], 0.000000, 1.422016);
	PlayerTextDrawTextSize(playerid, phTextD[12][playerid], 567.666687, 0.000000);
	PlayerTextDrawUseBox(playerid, phTextD[12][playerid], true);
	PlayerTextDrawBoxColor(playerid, phTextD[12][playerid], 858993663);
	PlayerTextDrawFont(playerid, phTextD[12][playerid], 0);

	phTextD[13][playerid] = CreatePlayerTextDraw(playerid, 589.666564, 400.551940, "num_7");
	PlayerTextDrawLetterSize(playerid, phTextD[13][playerid], 0.000000, 1.422016);
	PlayerTextDrawTextSize(playerid, phTextD[13][playerid], 567.666625, 0.000000);
	PlayerTextDrawUseBox(playerid, phTextD[13][playerid], true);
	PlayerTextDrawBoxColor(playerid, phTextD[13][playerid], 858993663);
	PlayerTextDrawFont(playerid, phTextD[13][playerid], 0);

	phTextD[14][playerid] = CreatePlayerTextDraw(playerid, 589.666748, 417.559204, "num_8");
	PlayerTextDrawLetterSize(playerid, phTextD[14][playerid], 0.000000, 1.422015);
	PlayerTextDrawTextSize(playerid, phTextD[14][playerid], 567.666748, 0.000000);
	PlayerTextDrawUseBox(playerid, phTextD[14][playerid], true);
	PlayerTextDrawBoxColor(playerid, phTextD[14][playerid], 858993663);
	PlayerTextDrawFont(playerid, phTextD[14][playerid], 0);

	phTextD[15][playerid] = CreatePlayerTextDraw(playerid, 569.666809, 382.714874, "num_9");
	PlayerTextDrawLetterSize(playerid, phTextD[15][playerid], 0.000000, -2.160291);
	PlayerTextDrawTextSize(playerid, phTextD[15][playerid], 543.333312, 0.000000);
	PlayerTextDrawUseBox(playerid, phTextD[15][playerid], true);
	PlayerTextDrawBoxColor(playerid, phTextD[15][playerid], 858993663);
	PlayerTextDrawFont(playerid, phTextD[15][playerid], 0);

	phTextD[16][playerid] = CreatePlayerTextDraw(playerid, 569.666687, 383.544494, "num_10");
	PlayerTextDrawLetterSize(playerid, phTextD[16][playerid], 0.000000, 1.434771);
	PlayerTextDrawTextSize(playerid, phTextD[16][playerid], 543.333374, 0.000000);
	PlayerTextDrawUseBox(playerid, phTextD[16][playerid], true);
	PlayerTextDrawBoxColor(playerid, phTextD[16][playerid], 858993663);
	PlayerTextDrawFont(playerid, phTextD[16][playerid], 0);

	phTextD[17][playerid] = CreatePlayerTextDraw(playerid, 569.666625, 400.551818, "num_11");
	PlayerTextDrawLetterSize(playerid, phTextD[17][playerid], 0.000000, 1.434774);
	PlayerTextDrawTextSize(playerid, phTextD[17][playerid], 543.333312, 0.000000);
	PlayerTextDrawUseBox(playerid, phTextD[17][playerid], true);
	PlayerTextDrawBoxColor(playerid, phTextD[17][playerid], 858993663);
	PlayerTextDrawFont(playerid, phTextD[17][playerid], 0);

	phTextD[18][playerid] = CreatePlayerTextDraw(playerid, 569.666259, 417.559356, "num_12");
	PlayerTextDrawLetterSize(playerid, phTextD[18][playerid], 0.000000, 1.401441);
	PlayerTextDrawTextSize(playerid, phTextD[18][playerid], 543.333068, 0.000000);
	PlayerTextDrawUseBox(playerid, phTextD[18][playerid], true);
	PlayerTextDrawBoxColor(playerid, phTextD[18][playerid], 858993663);
	PlayerTextDrawFont(playerid, phTextD[18][playerid], 0);

					//////////////////////////////////////
					// -- // PHONE NUMPAD NUMBERS // -- //
					/////////////////////////////////////

	phTextD[20][playerid] = CreatePlayerTextDraw(playerid, 528.666625, 365.451965, "1");
	PlayerTextDrawTextSize(playerid, phTextD[20][playerid], 540.0, 12.0);
	PlayerTextDrawLetterSize(playerid, phTextD[20][playerid], 0.449999, 1.600000);
	PlayerTextDrawSetSelectable(playerid, phTextD[20][playerid], true);
	PlayerTextDrawBackgroundColor(playerid, phTextD[20][playerid], 51);

	phTextD[21][playerid] = CreatePlayerTextDraw(playerid, 550.999206, 365.037048, "2");
	PlayerTextDrawTextSize(playerid, phTextD[21][playerid], 560.0, 12.0);
	PlayerTextDrawLetterSize(playerid, phTextD[21][playerid], 0.449999, 1.600000);
	PlayerTextDrawSetSelectable(playerid, phTextD[21][playerid], true);
	PlayerTextDrawBackgroundColor(playerid, phTextD[21][playerid], 51);

	phTextD[22][playerid] = CreatePlayerTextDraw(playerid, 573.333435, 365.037109, "3");
	PlayerTextDrawTextSize(playerid, phTextD[22][playerid], 580.0, 12.0);
	PlayerTextDrawLetterSize(playerid, phTextD[22][playerid], 0.449999, 1.600000);
	PlayerTextDrawSetSelectable(playerid, phTextD[22][playerid], true);
	PlayerTextDrawBackgroundColor(playerid, phTextD[22][playerid], 51);

	phTextD[23][playerid] = CreatePlayerTextDraw(playerid, 528.999938, 382.044555, "4");
	PlayerTextDrawTextSize(playerid, phTextD[23][playerid], 540.0, 12.0);
	PlayerTextDrawLetterSize(playerid, phTextD[23][playerid], 0.449999, 1.600000);
	PlayerTextDrawSetSelectable(playerid, phTextD[23][playerid], true);
	PlayerTextDrawBackgroundColor(playerid, phTextD[23][playerid], 51);

	phTextD[24][playerid] = CreatePlayerTextDraw(playerid, 551.333129, 382.044403, "5");
	PlayerTextDrawTextSize(playerid, phTextD[24][playerid], 560.0, 12.0);
	PlayerTextDrawLetterSize(playerid, phTextD[24][playerid], 0.449999, 1.600000);
	PlayerTextDrawSetSelectable(playerid, phTextD[24][playerid], true);
	PlayerTextDrawBackgroundColor(playerid, phTextD[24][playerid], 51);

	phTextD[25][playerid] = CreatePlayerTextDraw(playerid, 573.999633, 382.459411, "6");
	PlayerTextDrawTextSize(playerid, phTextD[25][playerid], 580.0, 12.0);
	PlayerTextDrawLetterSize(playerid, phTextD[25][playerid], 0.449999, 1.600000);
	PlayerTextDrawBackgroundColor(playerid, phTextD[25][playerid], 51);
	PlayerTextDrawSetSelectable(playerid, phTextD[25][playerid], true);

	phTextD[26][playerid] = CreatePlayerTextDraw(playerid, 528.999816, 399.881317, "7");
	PlayerTextDrawLetterSize(playerid, phTextD[26][playerid], 0.449999, 1.600000);
	PlayerTextDrawBackgroundColor(playerid, phTextD[26][playerid], 51);
	PlayerTextDrawTextSize(playerid, phTextD[26][playerid], 540.0, 12.0);
	PlayerTextDrawSetSelectable(playerid, phTextD[26][playerid], true);

	phTextD[27][playerid] = CreatePlayerTextDraw(playerid, 551.666442, 399.466644, "8");
	PlayerTextDrawLetterSize(playerid, phTextD[27][playerid], 0.449999, 1.600000);
	PlayerTextDrawBackgroundColor(playerid, phTextD[27][playerid], 51);
	PlayerTextDrawTextSize(playerid, phTextD[27][playerid], 560.0, 12.0);
	PlayerTextDrawSetSelectable(playerid, phTextD[27][playerid], true);

	phTextD[28][playerid] = CreatePlayerTextDraw(playerid, 574.000000, 399.466827, "9");
	PlayerTextDrawLetterSize(playerid, phTextD[28][playerid], 0.449999, 1.600000);
	PlayerTextDrawBackgroundColor(playerid, phTextD[28][playerid], 51);
	PlayerTextDrawTextSize(playerid, phTextD[28][playerid], 580.0, 12.0);
	PlayerTextDrawSetSelectable(playerid, phTextD[28][playerid], true);

	phTextD[29][playerid] = CreatePlayerTextDraw(playerid, 551.333312, 416.474090, "0");
	PlayerTextDrawLetterSize(playerid, phTextD[29][playerid], 0.449999, 1.600000);
	PlayerTextDrawBackgroundColor(playerid, phTextD[29][playerid], 51);
	PlayerTextDrawTextSize(playerid, phTextD[29][playerid], 560.0, 12.0);
	PlayerTextDrawSetSelectable(playerid, phTextD[29][playerid], true);

	phTextD[30][playerid] = CreatePlayerTextDraw(playerid, 528.666687, 416.059234, "-");
	PlayerTextDrawLetterSize(playerid, phTextD[30][playerid], 0.449999, 1.600000);
	PlayerTextDrawBackgroundColor(playerid, phTextD[30][playerid], 51);
	PlayerTextDrawTextSize(playerid, phTextD[30][playerid], 540.0, 12.0);
	PlayerTextDrawSetSelectable(playerid, phTextD[30][playerid], true);

	phTextD[31][playerid] = CreatePlayerTextDraw(playerid, 574.333251, 415.644378, "~g~c");
	PlayerTextDrawLetterSize(playerid, phTextD[31][playerid], 0.449999, 1.600000);
	PlayerTextDrawBackgroundColor(playerid, phTextD[31][playerid], 51);
	PlayerTextDrawTextSize(playerid, phTextD[31][playerid], 580.0, 12.0);
	PlayerTextDrawSetSelectable(playerid, phTextD[31][playerid], true);

	return true;
}

// Dialing Sound: PlayerPlaySound(playerid, 3600, 0, 0, 0);

