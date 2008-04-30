// 
// Copyright (C) 2004 Virtual Silicon Technology Inc.. All Rights Reserved.
// Silicon Ready, The Heart of Great Silicon, and the Virtual Silicon logo are
// registered trademarks of Virtual Silicon Technology Inc.
// All other trademarks are the property of their respective owner.
// 
// Virtual Silicon Technology Inc.
// 1322 Orleans Drive          
// Sunnyvale, CA 94089-1135
// Phone : 408-548-2700
// Fax : 408-548-2750
// Web Site : www.virtual-silicon.com
// 
// VST Library Release: UMCL18G415T3_1.0
// Product:  High Density Single Port SRAM Compiler
// Process:  L180 Generic II
// 
// High Density one-Port RAM 96 words by 32 bits
// column mux = 4
// bytewrite  = n
// test       = n
// powerbus   = b
// frequency  = 10
// 
`timescale 1 ns / 1 ps

`celldefine
module rec_DF_RAM0_96x32 (
  CK,
  CEN,
  WEN,
  OEN,
  ADR,
  DI,
  DOUT
  );

// parameter and port declaration block
  parameter words = 96;
  parameter bits = 32;
  parameter addMsb = 6;
  parameter bytes= 4;
  parameter bitMsb = 31;

  input CK;
  input CEN;
  input WEN;
  input OEN;
  input [addMsb:0] ADR;
  input [bitMsb:0] DI;
  output [bitMsb:0] DOUT;

// input buffer block
  buf (buf_CK, CK);
  buf (buf_CEN, CEN);
  buf (buf_WEN, WEN);
  buf (buf_OEN, OEN);

  wire [addMsb:0] buf_ADR;
  wire [bitMsb:0] buf_DI;
  assign buf_ADR = ADR;
  assign buf_DI = DI;


// internal variable declarations
  reg int_CEN;
  reg int_WEN;
  reg [addMsb:0] int_ADR;
  reg [bitMsb:0] int_DI;
  reg [bitMsb:0] int_DOUT;
  reg [bitMsb:0] memory_array [95:0];

  reg old_CK;
  reg write_error;
  reg read_error;
  reg risingTmp;
  always @(posedge buf_CK)
     risingTmp = 1'b1;
  always @(negedge buf_CK)
     risingTmp = 1'b0;

  wire risingCK = risingTmp;

  wire rflag = risingCK & (buf_WEN!==1'b0);
  wire wflag = risingCK & (buf_WEN!==1'b1);


// DOUT processing
  wire [bitMsb:0] out_DOUT;
  assign out_DOUT = int_DOUT;

  wire int_OEN = buf_OEN;
  bufif0(DOUT[0], out_DOUT[0], int_OEN);
  bufif0(DOUT[1], out_DOUT[1], int_OEN);
  bufif0(DOUT[2], out_DOUT[2], int_OEN);
  bufif0(DOUT[3], out_DOUT[3], int_OEN);
  bufif0(DOUT[4], out_DOUT[4], int_OEN);
  bufif0(DOUT[5], out_DOUT[5], int_OEN);
  bufif0(DOUT[6], out_DOUT[6], int_OEN);
  bufif0(DOUT[7], out_DOUT[7], int_OEN);
  bufif0(DOUT[8], out_DOUT[8], int_OEN);
  bufif0(DOUT[9], out_DOUT[9], int_OEN);
  bufif0(DOUT[10], out_DOUT[10], int_OEN);
  bufif0(DOUT[11], out_DOUT[11], int_OEN);
  bufif0(DOUT[12], out_DOUT[12], int_OEN);
  bufif0(DOUT[13], out_DOUT[13], int_OEN);
  bufif0(DOUT[14], out_DOUT[14], int_OEN);
  bufif0(DOUT[15], out_DOUT[15], int_OEN);
  bufif0(DOUT[16], out_DOUT[16], int_OEN);
  bufif0(DOUT[17], out_DOUT[17], int_OEN);
  bufif0(DOUT[18], out_DOUT[18], int_OEN);
  bufif0(DOUT[19], out_DOUT[19], int_OEN);
  bufif0(DOUT[20], out_DOUT[20], int_OEN);
  bufif0(DOUT[21], out_DOUT[21], int_OEN);
  bufif0(DOUT[22], out_DOUT[22], int_OEN);
  bufif0(DOUT[23], out_DOUT[23], int_OEN);
  bufif0(DOUT[24], out_DOUT[24], int_OEN);
  bufif0(DOUT[25], out_DOUT[25], int_OEN);
  bufif0(DOUT[26], out_DOUT[26], int_OEN);
  bufif0(DOUT[27], out_DOUT[27], int_OEN);
  bufif0(DOUT[28], out_DOUT[28], int_OEN);
  bufif0(DOUT[29], out_DOUT[29], int_OEN);
  bufif0(DOUT[30], out_DOUT[30], int_OEN);
  bufif0(DOUT[31], out_DOUT[31], int_OEN);


  and (chk_DI, ~buf_CEN, ~buf_WEN);

  reg mpwCK_notifier;
  reg pwhCK_notifier;
  reg shCEN_notifier;
  reg shADR_notifier;
  reg shWEN_notifier;
  reg shDI_notifier;

  integer i, j, h, k, m;

  parameter x_data = 32'bx;
  parameter data_0 = {32{1'b0}};
  parameter x_adr  = 7'bx;
  parameter adr_0  = {7{1'b0}};

initial begin
   for (i = 0; i < words; i=i+1) 
   	memory_array[i] = x_data;
end

initial begin
    read_error = 1'b0;
    write_error = 1'b0;
	 old_CK = 1'b0;
    // Wait for valid initial transition
    wait (buf_CK === 1'b0);

    forever @(buf_CK) begin
		case ({old_CK,buf_CK})
      // 0->1 transition
      2'b01:
		begin
        int_CEN = buf_CEN;
        int_WEN = buf_WEN;
        int_ADR = buf_ADR;
        int_DI = buf_DI;

        	if (int_CEN === 1'b0) begin
          		// Read cycle
				if( ^int_ADR === 1'bx)  begin
					ADR_error;
          		end else if (int_WEN === 1'b1) begin
              		int_DOUT = memory_array[int_ADR];
          		// Write cycle
          		end else if (int_WEN === 1'b0) begin 
					if (write_error === 1'b0) begin
              			memory_array[int_ADR] = int_DI; // Write cycle
              			int_DOUT = int_DI;
            		end
          		// Unknown cycle
          		end else begin // int_WEN = x
            		SHWrite_error;
          		end
        	end else if (int_CEN === 1'bx) begin
        		wipe_memory_output;
        	end
      // 0->unknown transition, wait until returns to 0
      end 
	  2'b0x, 2'b1x, 2'bx1, 2'bx0: begin
        int_CEN = 1'bx;
        wipe_memory_output;
      	end
	 endcase
		old_CK <= #0.002 buf_CK;
    end
  end  // end memory loop


//====================
// Task and procedure
//====================

// This task process entire MEM and OUTPUTs
task wipe_memory_output;
integer i;
  begin
    write_error = 1'b1;
    int_DOUT = x_data;
    int_ADR = x_adr;
    int_WEN = 1'bx;
    int_DI = x_data;


    for (i = 0; i < words; i=i+1) begin
    	memory_array[i] = x_data;
    end
    write_error = 1'b0;
  end
endtask

// This task process write through violation
task SHWrite_error;
integer ic, ib;
  begin
  	write_error = 1'b1;
  	read_error = 1'b1;
    if (int_WEN===1'bx) begin
    	memory_array[int_ADR] = x_data;
		int_DOUT = x_data;
    end else if (int_WEN===1'b0) begin
    	memory_array[int_ADR] = int_DI;
		int_DOUT = int_DI;
    end

  	write_error = 1'b0;
  	read_error = 1'b0;
  end
endtask

// This task process read violation
task SHRead_error;
  begin
    read_error = 1'b1;
    int_DOUT = x_data;
    //wait (buf_CK === 1'b0);
    read_error = 1'b0;
  end
endtask

// This task process ADR violation
task ADR_error;
integer i;
  begin
	write_error = 1'b1;
	read_error = 1'b1;
	int_DOUT = x_data;
	for (i = 0; i < words; i=i+1) 
		memory_array[i] = x_data;
   write_error = 1'b0;
	read_error = 1'b0;
  end
endtask

//=======================
// Violation processing 
//=======================
// CK violation
always @(pwhCK_notifier) begin
  $display ("%m CLK cycle pulse width high timing violation detected %t", $realtime);
  int_CEN = 1'bx;
  wipe_memory_output;
end

always @(mpwCK_notifier) begin
  $display ("%m CLK cycle timing violation detected %t", $realtime);
  #0.001;
  wipe_memory_output;
  risingTmp = 1'b0;
end


// CEN violation
always @(shCEN_notifier) begin
  int_CEN = 1'bx;
  $display ("%m Cell enable timing violation detected %t", $realtime);
  wipe_memory_output;
end

// ADR violation
always @(shADR_notifier) begin
  int_ADR = x_adr;
  $display ("%m Address timing violation detected %t", $realtime);
  ADR_error;
end

// WEN violation
always @(shWEN_notifier) begin
  int_WEN = 1'bx;
  $display ("%m Write enable timing violation detected %t", $realtime);
  if( ^int_ADR !== 1'bx)
  	  SHWrite_error;
end


// DI violation
always @(shDI_notifier) begin
  int_DI = x_data;
  $display ("%m Input data timing violation detected %t", $realtime);
  if( ^int_ADR !== 1'bx)
  	  SHWrite_error;
end



specify

    // Path delays
   if (rflag)  (CK *> DOUT[0]) = 0.1;
   if (wflag)  (CK *> DOUT[0]) = 0.1;
   if (rflag)  (CK *> DOUT[1]) = 0.1;
   if (wflag)  (CK *> DOUT[1]) = 0.1;
   if (rflag)  (CK *> DOUT[2]) = 0.1;
   if (wflag)  (CK *> DOUT[2]) = 0.1;
   if (rflag)  (CK *> DOUT[3]) = 0.1;
   if (wflag)  (CK *> DOUT[3]) = 0.1;
   if (rflag)  (CK *> DOUT[4]) = 0.1;
   if (wflag)  (CK *> DOUT[4]) = 0.1;
   if (rflag)  (CK *> DOUT[5]) = 0.1;
   if (wflag)  (CK *> DOUT[5]) = 0.1;
   if (rflag)  (CK *> DOUT[6]) = 0.1;
   if (wflag)  (CK *> DOUT[6]) = 0.1;
   if (rflag)  (CK *> DOUT[7]) = 0.1;
   if (wflag)  (CK *> DOUT[7]) = 0.1;
   if (rflag)  (CK *> DOUT[8]) = 0.1;
   if (wflag)  (CK *> DOUT[8]) = 0.1;
   if (rflag)  (CK *> DOUT[9]) = 0.1;
   if (wflag)  (CK *> DOUT[9]) = 0.1;
   if (rflag)  (CK *> DOUT[10]) = 0.1;
   if (wflag)  (CK *> DOUT[10]) = 0.1;
   if (rflag)  (CK *> DOUT[11]) = 0.1;
   if (wflag)  (CK *> DOUT[11]) = 0.1;
   if (rflag)  (CK *> DOUT[12]) = 0.1;
   if (wflag)  (CK *> DOUT[12]) = 0.1;
   if (rflag)  (CK *> DOUT[13]) = 0.1;
   if (wflag)  (CK *> DOUT[13]) = 0.1;
   if (rflag)  (CK *> DOUT[14]) = 0.1;
   if (wflag)  (CK *> DOUT[14]) = 0.1;
   if (rflag)  (CK *> DOUT[15]) = 0.1;
   if (wflag)  (CK *> DOUT[15]) = 0.1;
   if (rflag)  (CK *> DOUT[16]) = 0.1;
   if (wflag)  (CK *> DOUT[16]) = 0.1;
   if (rflag)  (CK *> DOUT[17]) = 0.1;
   if (wflag)  (CK *> DOUT[17]) = 0.1;
   if (rflag)  (CK *> DOUT[18]) = 0.1;
   if (wflag)  (CK *> DOUT[18]) = 0.1;
   if (rflag)  (CK *> DOUT[19]) = 0.1;
   if (wflag)  (CK *> DOUT[19]) = 0.1;
   if (rflag)  (CK *> DOUT[20]) = 0.1;
   if (wflag)  (CK *> DOUT[20]) = 0.1;
   if (rflag)  (CK *> DOUT[21]) = 0.1;
   if (wflag)  (CK *> DOUT[21]) = 0.1;
   if (rflag)  (CK *> DOUT[22]) = 0.1;
   if (wflag)  (CK *> DOUT[22]) = 0.1;
   if (rflag)  (CK *> DOUT[23]) = 0.1;
   if (wflag)  (CK *> DOUT[23]) = 0.1;
   if (rflag)  (CK *> DOUT[24]) = 0.1;
   if (wflag)  (CK *> DOUT[24]) = 0.1;
   if (rflag)  (CK *> DOUT[25]) = 0.1;
   if (wflag)  (CK *> DOUT[25]) = 0.1;
   if (rflag)  (CK *> DOUT[26]) = 0.1;
   if (wflag)  (CK *> DOUT[26]) = 0.1;
   if (rflag)  (CK *> DOUT[27]) = 0.1;
   if (wflag)  (CK *> DOUT[27]) = 0.1;
   if (rflag)  (CK *> DOUT[28]) = 0.1;
   if (wflag)  (CK *> DOUT[28]) = 0.1;
   if (rflag)  (CK *> DOUT[29]) = 0.1;
   if (wflag)  (CK *> DOUT[29]) = 0.1;
   if (rflag)  (CK *> DOUT[30]) = 0.1;
   if (wflag)  (CK *> DOUT[30]) = 0.1;
   if (rflag)  (CK *> DOUT[31]) = 0.1;
   if (wflag)  (CK *> DOUT[31]) = 0.1;

 (OEN *> DOUT[0]) = 0.1; 
 (OEN *> DOUT[1]) = 0.1; 
 (OEN *> DOUT[2]) = 0.1; 
 (OEN *> DOUT[3]) = 0.1; 
 (OEN *> DOUT[4]) = 0.1; 
 (OEN *> DOUT[5]) = 0.1; 
 (OEN *> DOUT[6]) = 0.1; 
 (OEN *> DOUT[7]) = 0.1; 
 (OEN *> DOUT[8]) = 0.1; 
 (OEN *> DOUT[9]) = 0.1; 
 (OEN *> DOUT[10]) = 0.1; 
 (OEN *> DOUT[11]) = 0.1; 
 (OEN *> DOUT[12]) = 0.1; 
 (OEN *> DOUT[13]) = 0.1; 
 (OEN *> DOUT[14]) = 0.1; 
 (OEN *> DOUT[15]) = 0.1; 
 (OEN *> DOUT[16]) = 0.1; 
 (OEN *> DOUT[17]) = 0.1; 
 (OEN *> DOUT[18]) = 0.1; 
 (OEN *> DOUT[19]) = 0.1; 
 (OEN *> DOUT[20]) = 0.1; 
 (OEN *> DOUT[21]) = 0.1; 
 (OEN *> DOUT[22]) = 0.1; 
 (OEN *> DOUT[23]) = 0.1; 
 (OEN *> DOUT[24]) = 0.1; 
 (OEN *> DOUT[25]) = 0.1; 
 (OEN *> DOUT[26]) = 0.1; 
 (OEN *> DOUT[27]) = 0.1; 
 (OEN *> DOUT[28]) = 0.1; 
 (OEN *> DOUT[29]) = 0.1; 
 (OEN *> DOUT[30]) = 0.1; 
 (OEN *> DOUT[31]) = 0.1; 



    // Timing check parameters
  specparam tsadrl = 0;
  specparam thadrl = 0;
  specparam tsadrh = 0;
  specparam thadrh = 0;
  specparam tsdil = 0;
  specparam tsdih = 0;
  specparam thdil = 0;
  specparam thdih = 0;
  specparam tscenl = 0;
  specparam thcenl = 0;
  specparam tscenh = 0;
  specparam thcenh = 0;
  specparam tswenl = 0;
  specparam thwenl = 0;
  specparam tswenh = 0;
  specparam thwenh = 0;
  specparam tcyc = 0;
  specparam tlck = 0;
  specparam thck = 0;

    // Timing checks
  $setuphold(posedge CK, negedge CEN, tscenl, thcenl, shCEN_notifier);
  $setuphold(posedge CK, posedge CEN, tscenh, thcenh, shCEN_notifier);

  $setuphold(posedge CK &&& (CEN===1'b0), negedge ADR[0], tsadrl, thadrl, shADR_notifier);
  $setuphold(posedge CK &&& (CEN===1'b0), posedge ADR[0], tsadrh, thadrh, shADR_notifier);
  $setuphold(posedge CK &&& (CEN===1'b0), negedge ADR[1], tsadrl, thadrl, shADR_notifier);
  $setuphold(posedge CK &&& (CEN===1'b0), posedge ADR[1], tsadrh, thadrh, shADR_notifier);
  $setuphold(posedge CK &&& (CEN===1'b0), negedge ADR[2], tsadrl, thadrl, shADR_notifier);
  $setuphold(posedge CK &&& (CEN===1'b0), posedge ADR[2], tsadrh, thadrh, shADR_notifier);
  $setuphold(posedge CK &&& (CEN===1'b0), negedge ADR[3], tsadrl, thadrl, shADR_notifier);
  $setuphold(posedge CK &&& (CEN===1'b0), posedge ADR[3], tsadrh, thadrh, shADR_notifier);
  $setuphold(posedge CK &&& (CEN===1'b0), negedge ADR[4], tsadrl, thadrl, shADR_notifier);
  $setuphold(posedge CK &&& (CEN===1'b0), posedge ADR[4], tsadrh, thadrh, shADR_notifier);
  $setuphold(posedge CK &&& (CEN===1'b0), negedge ADR[5], tsadrl, thadrl, shADR_notifier);
  $setuphold(posedge CK &&& (CEN===1'b0), posedge ADR[5], tsadrh, thadrh, shADR_notifier);
  $setuphold(posedge CK &&& (CEN===1'b0), negedge ADR[6], tsadrl, thadrl, shADR_notifier);
  $setuphold(posedge CK &&& (CEN===1'b0), posedge ADR[6], tsadrh, thadrh, shADR_notifier);

  $setuphold(posedge CK &&& (CEN===1'b0), negedge WEN, tswenl, thwenl, shWEN_notifier);
  $setuphold(posedge CK &&& (CEN===1'b0), posedge WEN, tswenh, thwenh, shWEN_notifier);

  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[0], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[0], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[1], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[1], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[2], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[2], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[3], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[3], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[4], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[4], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[5], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[5], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[6], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[6], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[7], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[7], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[8], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[8], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[9], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[9], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[10], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[10], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[11], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[11], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[12], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[12], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[13], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[13], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[14], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[14], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[15], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[15], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[16], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[16], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[17], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[17], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[18], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[18], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[19], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[19], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[20], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[20], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[21], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[21], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[22], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[22], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[23], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[23], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[24], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[24], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[25], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[25], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[26], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[26], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[27], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[27], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[28], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[28], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[29], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[29], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[30], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[30], tsdih, thdih, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), negedge DI[31], tsdil, thdil, shDI_notifier);
  $setuphold(posedge CK &&& (chk_DI===1'b1), posedge DI[31], tsdih, thdih, shDI_notifier);

  $period(posedge CK, tcyc, mpwCK_notifier);
  $width(negedge CK, tlck, 0, mpwCK_notifier);
  $width(posedge CK, thck, 0, pwhCK_notifier);

endspecify

endmodule
`endcelldefine
