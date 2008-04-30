//--------------------------------------------------------------------------------------------------
// Design      : H264Decoder
// Author      : KE XU
// Email	   : kexu@ee.cuhk.edu.hk
// File        : rec_DF_RAM1.v
// Generated   : Dec 7 2005
//-------------------------------------------------------------------------------------------------
//
// Description : SRAM between reconstruction and deblocking filter (96x32bit)
//-------------------------------------------------------------------------------------------------
`timescale 1ns/1ns
module rec_DF_RAM1_wrapper (clk,gclk_rec_DF_RAM1,reset_n,
	rec_DF_RAM1_cs_n,rec_DF_RAM1_wr,rec_DF_RAM1_addr,rec_DF_RAM1_din,rec_DF_RAM1_dout);
	input clk;
	input gclk_rec_DF_RAM1;
	input reset_n;
	input rec_DF_RAM1_cs_n;
	input rec_DF_RAM1_wr;
	input [6:0] rec_DF_RAM1_addr;
	input [31:0] rec_DF_RAM1_din;
	output [31:0] rec_DF_RAM1_dout;
	
	reg rec_DF_RAM1_OEN;
	always @ (posedge clk)
		if (reset_n == 1'b0)
			rec_DF_RAM1_OEN <= 1'b1;
		else if (!rec_DF_RAM1_cs_n && !rec_DF_RAM1_wr)
			rec_DF_RAM1_OEN <= 1'b0;
		else
			rec_DF_RAM1_OEN <= 1'b1;
	
	wire rec_DF_RAM1_CEN;
	assign rec_DF_RAM1_CEN = rec_DF_RAM1_cs_n & rec_DF_RAM1_OEN;
	
	rec_DF_RAM1_96x32 rec_DF_RAM1_96x32 (
		.CK(gclk_rec_DF_RAM1),
		.ADR(rec_DF_RAM1_addr),
		.DI(rec_DF_RAM1_din),
		.WEN(~rec_DF_RAM1_wr),
		.CEN(rec_DF_RAM1_CEN),
		.OEN(rec_DF_RAM1_OEN),
		.DOUT(rec_DF_RAM1_dout)
		);
endmodule	
/*	
module rec_DF_RAM1_96x32 (CK,ADR,DI,WEN,CEN,OEN,DOUT);
	input CK;
	input [6:0] ADR;
	input [31:0] DI;
	input WEN;
	input CEN;
	input OEN;
	output [31:0] DOUT;
	reg [31:0] DOUT;
	reg [31:0] RAM [0:95];
	
	always @ (posedge CK)
		if (!CEN &&  !WEN)
			RAM[ADR] <= DI;
	
	always @ (posedge CK)
		if (!CEN && !OEN)
			DOUT <= RAM[ADR];
endmodule*/

			