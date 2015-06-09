module adio_codec (
	output			oAUD_DATA,
	output			oAUD_LRCK,
	output	reg		oAUD_BCK,
	input	[1:0]	iSrc_Select,
	input			iCLK_18_4,
	input			iRST_N,
	input [51:0]	iRate
	);				

parameter	REF_CLK			=	18432000;	//	18.432	MHz
parameter	SAMPLE_RATE		=	48000;		//	48		KHz
parameter	DATA_WIDTH		=	16;			//	16		Bits
parameter	CHANNEL_NUM		=	2;			//	Dual Channel

parameter	SIN_SAMPLE_DATA	=	48;

////////////	Input Source Number	//////////////
parameter	SIN_SANPLE		=	0;
//////////////////////////////////////////////////

//	Internal Registers and Wires
reg		[3:0]	BCK_DIV;
reg		[8:0]	LRCK_1X_DIV;
reg		[7:0]	LRCK_2X_DIV;
reg		[6:0]	LRCK_4X_DIV;
reg		[3:0]	SEL_Cont;
////////	DATA Counter	////////
reg		[7:0] SIN_Cont;
////////////////////////////////////
reg		[DATA_WIDTH-1:0]	Sin_Out;
reg							LRCK_1X;
reg							LRCK_2X;
reg							LRCK_4X;

////////////	AUD_BCK Generator	//////////////
always@(posedge iCLK_18_4 or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		BCK_DIV		<=	0;
		oAUD_BCK	<=	0;
	end
	else
	begin
		if(BCK_DIV >= REF_CLK/(iRate*DATA_WIDTH*CHANNEL_NUM*2)-1 )
		begin
			BCK_DIV		<=	0;
			oAUD_BCK	<=	~oAUD_BCK;
		end
		else
		BCK_DIV		<=	BCK_DIV+1;
	end
end


//////////////////////////////////////////////////
////////////	AUD_LRCK Generator	//////////////
always@(posedge iCLK_18_4 or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		LRCK_1X_DIV	<=	0;
		LRCK_2X_DIV	<=	0;
		LRCK_4X_DIV	<=	0;
		LRCK_1X		<=	0;
		LRCK_2X		<=	0;
		LRCK_4X		<=	0;
	end
	else
	begin
		//	LRCK 1X
		if(LRCK_1X_DIV >= REF_CLK/(iRate*2)-1 )
		begin
			LRCK_1X_DIV	<=	0;
			LRCK_1X	<=	~LRCK_1X;
		end
		else
		LRCK_1X_DIV		<=	LRCK_1X_DIV+1;
		//	LRCK 2X
		if(LRCK_2X_DIV >= REF_CLK/(iRate*4)-1 )
		begin
			LRCK_2X_DIV	<=	0;
			LRCK_2X	<=	~LRCK_2X;
		end
		else
		LRCK_2X_DIV		<=	LRCK_2X_DIV+1;		
		//	LRCK 4X
		if(LRCK_4X_DIV >= REF_CLK/(iRate*8)-1 )
		begin
			LRCK_4X_DIV	<=	0;
			LRCK_4X	<=	~LRCK_4X;
		end
		else
		LRCK_4X_DIV		<=	LRCK_4X_DIV+1;		
	end
end
assign	oAUD_LRCK	=	LRCK_1X;
//////////////////////////////////////////////////
//////////	Sin LUT ADDR Generator	//////////////
always@(negedge LRCK_1X or negedge iRST_N)
begin
	if(!iRST_N)
	SIN_Cont	<=	0;
	else
	begin
		if(SIN_Cont < SIN_SAMPLE_DATA-1 )
			SIN_Cont	<=	SIN_Cont+1;
		else
		SIN_Cont	<=	0;
	end
end

//////////////////////////////////////////////////
//////////	16 Bits PISO MSB First	//////////////
always@(negedge oAUD_BCK or negedge iRST_N)
begin
	if(!iRST_N)
	SEL_Cont	<=	0;
	else
	SEL_Cont	<=	SEL_Cont+1;
end

assign	oAUD_DATA	=	Sin_Out[~SEL_Cont];		

//////////////////////////////////////////////////

////////////	Sin Wave ROM Table	//////////////
always@(SIN_Cont)
	begin
    	case(SIN_Cont)
			 0 :  Sin_Out   <=    0;
			 1 :  Sin_Out   <=    2990;
			 2 :  Sin_Out   <=    5954;
			 3 :  Sin_Out   <=    8870;
			 4 :  Sin_Out   <=   11711;
			 5 :  Sin_Out   <=   14454;
			 6 :  Sin_Out   <=   17077;
			 7 :  Sin_Out   <=   19557;
			 8 :  Sin_Out   <=   21874;
			 9 :  Sin_Out   <=   24009;
			 10 :  Sin_Out   <=   25943;
			 11 :  Sin_Out   <=   27661;
			 12 :  Sin_Out   <=   29149;
			 13 :  Sin_Out   <=   30393;
			 14 :  Sin_Out   <=   31383;
			 15 :  Sin_Out   <=   32112;
			 16 :  Sin_Out   <=   32573;
			 17 :  Sin_Out   <=   32762;
			 18 :  Sin_Out   <=   32678;
			 19 :  Sin_Out   <=   32321;
			 20 :  Sin_Out   <=   31694;
			 21 :  Sin_Out   <=   30804;
			 22 :  Sin_Out   <=   29656;
			 23 :  Sin_Out   <=   28261;
			 24 :  Sin_Out   <=   26630;
			 25 :  Sin_Out   <=   24776;
			 26 :  Sin_Out   <=   22717;
			 27 :  Sin_Out   <=   20467;
			 28 :  Sin_Out   <=   18047;
			 29 :  Sin_Out   <=   15477;
			 30 :  Sin_Out   <=   12777;
			 31 :  Sin_Out   <=    9970;
			 32 :  Sin_Out   <=    7081;
			 33 :  Sin_Out   <=    4132;
			 34 :  Sin_Out   <=    1149;
			 35 :  Sin_Out   <=   63692;
			 36 :  Sin_Out   <=   60714;
			 37 :  Sin_Out   <=   57777;
			 38 :  Sin_Out   <=   54905;
			 39 :  Sin_Out   <=   52121;
			 40 :  Sin_Out   <=   49450;
			 41 :  Sin_Out   <=   46912;
			 42 :  Sin_Out   <=   44530;
			 43 :  Sin_Out   <=   42323;
			 44 :  Sin_Out   <=   40309;
			 45 :  Sin_Out   <=   38507;
			 46 :  Sin_Out   <=   36929;
			 47 :  Sin_Out   <=   35590;
			 48 :  Sin_Out   <=   34501;
			 49 :  Sin_Out   <=   33671;
			 50 :  Sin_Out   <=   33107;
			 51 :  Sin_Out   <=   32813;
			 52 :  Sin_Out   <=   32793;
			 53 :  Sin_Out   <=   33045;
			 54 :  Sin_Out   <=   33568;
			 55 :  Sin_Out   <=   34359;
			 56 :  Sin_Out   <=   35409;
			 57 :  Sin_Out   <=   36710;
			 58 :  Sin_Out   <=   38252;
			 59 :  Sin_Out   <=   40022;
			 60 :  Sin_Out   <=   42004;
			 61 :  Sin_Out   <=   44183;
			 62 :  Sin_Out   <=   46540;
			 63 :  Sin_Out   <=   49055;
			 64 :  Sin_Out   <=   51708;
			 65 :  Sin_Out   <=   54476;
			 66 :  Sin_Out   <=   57336;
			 67 :  Sin_Out   <=   60265;
			 68 :  Sin_Out   <=   63238;
		default	:
			   Sin_Out		<=		0		;
	endcase
end


endmodule
								
			
					

