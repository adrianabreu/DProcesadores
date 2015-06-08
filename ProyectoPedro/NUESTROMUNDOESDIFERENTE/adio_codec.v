module adio_codec (
	output			oAUD_DATA,
	output			oAUD_LRCK,
	output	reg		oAUD_BCK,
	input	[1:0]	iSrc_Select,
	input			iCLK_18_4,
	input			iRST_N,
	input [51:0]	iRate,
	);				

parameter	REF_CLK			=	18432000;	//	18.432	MHz
parameter	SAMPLE_RATE		=	48000;		//	48		KHz
parameter	DATA_WIDTH		=	16;			//	16		Bits
parameter	CHANNEL_NUM		=	2;			//	Dual Channel

parameter	SIN_SAMPLE_DATA	=	48;

////////////	Input Source Number	//////////////
parameter	SIN_SANPLE		=	0;
//////////////////////////////////////////////////

//input [51:0]iRefClock;
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
/*always@(SIN_Cont)
begin
    case(SIN_Cont)
    0  :  Sin_Out       <=      0       ;
    1  :  Sin_Out       <=      4276    ;
    2  :  Sin_Out       <=      8480    ;
    3  :  Sin_Out       <=      12539   ;
    4  :  Sin_Out       <=      16383   ;
    5  :  Sin_Out       <=      19947   ;
    6  :  Sin_Out       <=      23169   ;
    7  :  Sin_Out       <=      25995   ;
    8  :  Sin_Out       <=      28377   ;
    9  :  Sin_Out       <=      30272   ;
    10  :  Sin_Out      <=      31650   ;
    11  :  Sin_Out      <=      32486   ;
    12  :  Sin_Out      <=      32767   ;
    13  :  Sin_Out      <=      32486   ;
    14  :  Sin_Out      <=      31650   ;
    15  :  Sin_Out      <=      30272   ;
    16  :  Sin_Out      <=      28377   ;
    17  :  Sin_Out      <=      25995   ;
    18  :  Sin_Out      <=      23169   ;
    19  :  Sin_Out      <=      19947   ;
    20  :  Sin_Out      <=      16383   ;
    21  :  Sin_Out      <=      12539   ;
    22  :  Sin_Out      <=      8480    ;
    23  :  Sin_Out      <=      4276    ;
    24  :  Sin_Out      <=      0       ;
    25  :  Sin_Out      <=      61259   ;
    26  :  Sin_Out      <=      57056   ;
    27  :  Sin_Out      <=      52997   ;
    28  :  Sin_Out      <=      49153   ;
    29  :  Sin_Out      <=      45589   ;
    30  :  Sin_Out      <=      42366   ;
    31  :  Sin_Out      <=      39540   ;
    32  :  Sin_Out      <=      37159   ;
    33  :  Sin_Out      <=      35263   ;
    34  :  Sin_Out      <=      33885   ;
    35  :  Sin_Out      <=      33049   ;
    36  :  Sin_Out      <=      32768   ;
    37  :  Sin_Out      <=      33049   ;
    38  :  Sin_Out      <=      33885   ;
    39  :  Sin_Out      <=      35263   ;
    40  :  Sin_Out      <=      37159   ;
    41  :  Sin_Out      <=      39540   ;
    42  :  Sin_Out      <=      42366   ;
    43  :  Sin_Out      <=      45589   ;
    44  :  Sin_Out      <=      49152   ;
    45  :  Sin_Out      <=      52997   ;
    46  :  Sin_Out      <=      57056   ;
    47  :  Sin_Out      <=      61259   ;
	default	:
		   Sin_Out		<=		0		;
	endcase
end
*/
//////////////////////////////////////////////////

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

/*
always@(SIN_Cont)
begin
    case(SIN_Cont)
		 0 :  Sin_Out       <=   0;
		 1 :  Sin_Out       <= 2241;
		 2 :  Sin_Out       <= 4472;
		 3 :  Sin_Out       <= 6683;
		 4 :  Sin_Out       <= 8861;
		 5 :  Sin_Out       <=10998;
		 6 :  Sin_Out       <=13084;
		 7 :  Sin_Out       <=15109;
		 8 :  Sin_Out       <=17062;
		 9 :  Sin_Out       <=18936;
		 10 :  Sin_Out       <=20721;
		 11 :  Sin_Out       <=22409;
		 12 :  Sin_Out       <=23992;
		 13 :  Sin_Out       <=25462;
		 14 :  Sin_Out       <=26813;
		 15 :  Sin_Out       <=28039;
		 16 :  Sin_Out       <=29133;
		 17 :  Sin_Out       <=30091;
		 18 :  Sin_Out       <=30908;
		 19 :  Sin_Out       <=31579;
		 20 :  Sin_Out       <=32103;
		 21 :  Sin_Out       <=32477;
		 22 :  Sin_Out       <=32699;
		 23 :  Sin_Out       <=32767;
		 24 :  Sin_Out       <=32681;
		 25 :  Sin_Out       <=32443;
		 26 :  Sin_Out       <=32053;
		 27 :  Sin_Out       <=31512;
		 28 :  Sin_Out       <=30824;
		 29 :  Sin_Out       <=29991;
		 30 :  Sin_Out       <=29018;
		 31 :  Sin_Out       <=27909;
		 32 :  Sin_Out       <=26669;
		 33 :  Sin_Out       <=25305;
		 34 :  Sin_Out       <=23821;
		 35 :  Sin_Out       <=22227;
		 36 :  Sin_Out       <=20527;
		 37 :  Sin_Out       <=18732;
		 38 :  Sin_Out       <=16849;
		 39 :  Sin_Out       <=14887;
		 40 :  Sin_Out       <=12856;
		 41 :  Sin_Out       <=10764;
		 42 :  Sin_Out       <= 8622;
		 43 :  Sin_Out       <= 6439;
		 44 :  Sin_Out       <= 4226;
		 45 :  Sin_Out       <= 1993;
		 46 :  Sin_Out       <=65286;
		 47 :  Sin_Out       <=63045;
		 48 :  Sin_Out       <=60816;
		 49 :  Sin_Out       <=58609;
		 50 :  Sin_Out       <=56434;
		 51 :  Sin_Out       <=54303;
		 52 :  Sin_Out       <=52223;
		 53 :  Sin_Out       <=50206;
		 54 :  Sin_Out       <=48261;
		 55 :  Sin_Out       <=46397;
		 56 :  Sin_Out       <=44622;
		 57 :  Sin_Out       <=42945;
		 58 :  Sin_Out       <=41375;
		 59 :  Sin_Out       <=39917;
		 60 :  Sin_Out       <=38580;
		 61 :  Sin_Out       <=37368;
		 62 :  Sin_Out       <=36289;
		 63 :  Sin_Out       <=35347;
		 64 :  Sin_Out       <=34546;
		 65 :  Sin_Out       <=33890;
		 66 :  Sin_Out       <=33383;
		 67 :  Sin_Out       <=33026;
		 68 :  Sin_Out       <=32821;
		 69 :  Sin_Out       <=32770;
		 70 :  Sin_Out       <=32872;
		 71 :  Sin_Out       <=33128;
		 72 :  Sin_Out       <=33535;
		 73 :  Sin_Out       <=34092;
		 74 :  Sin_Out       <=34796;
		 75 :  Sin_Out       <=35645;
		 76 :  Sin_Out       <=36633;
		 77 :  Sin_Out       <=37757;
		 78 :  Sin_Out       <=39011;
		 79 :  Sin_Out       <=40389;
		 80 :  Sin_Out       <=41885;
		 81 :  Sin_Out       <=43492;
		 82 :  Sin_Out       <=45202;
		 83 :  Sin_Out       <=47007;
		 84 :  Sin_Out       <=48900;
		 85 :  Sin_Out       <=50870;
		 86 :  Sin_Out       <=52908;
		 87 :  Sin_Out       <=55006;
		 88 :  Sin_Out       <=57154;
		 89 :  Sin_Out       <=59340;
		 90 :  Sin_Out       <=61556;
		 91 :  Sin_Out       <=63790;
		 default : Sin_Out <= 0;
	endcase
end
*/
endmodule
								
			
					

