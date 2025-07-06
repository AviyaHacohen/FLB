module FLB_tb;
	// Inputs
	logic nsh_clk;    
	logic ref_clk; 
	logic [15:0] dlf_out;
	logic [7:0] band;
	
	logic csr_dec_en;
	logic csr_flb_sdm_en; 
	logic csr_flb_sdm_order;
	logic csr_flb_sdm_thrm_en; 
	logic [1:0] csr_flb_mtrx_clk_lag;
	logic [1:0] csr_flb_smpl_clk_lag;
	logic csr_sync_en;
	logic csr_flb_en;
	
	// Outputs
	logic [2:0] os_thrm_FLB;
	logic [1:0] os_bin_FLB;
	logic [63:0] mtrx_thrm_FLB;
	logic [29:0] band_thrm_FLB;
	
	integer file;
	logic [1:0] n;

	
	
	FLB flb_inst (
		.nsh_clk(nsh_clk),
		.ref_clk(ref_clk),
		.dlf_out(dlf_out),
		.band(band),
		.csr_dec_en(csr_dec_en),
		.csr_flb_sdm_en(csr_flb_sdm_en),
		.csr_flb_sdm_order(csr_flb_sdm_order),
		.csr_flb_sdm_thrm_en(csr_flb_sdm_thrm_en),
		.csr_flb_mtrx_clk_lag(csr_flb_mtrx_clk_lag),
		.csr_flb_smpl_clk_lag(csr_flb_smpl_clk_lag),
		.csr_sync_en(csr_sync_en),
		.csr_flb_en(csr_flb_en),
		.os_thrm_FLB(os_thrm_FLB),
		.os_bin_FLB(os_bin_FLB),
		.mtrx_thrm_FLB(mtrx_thrm_FLB),
		.band_thrm_FLB(band_thrm_FLB)
	);
	
	//Generate clocks
	always #1 nsh_clk = ~nsh_clk; 
	always #20 ref_clk = ~ref_clk; 
	
	initial begin
		nsh_clk = 1'b0;
		ref_clk = 1'b0;
		
		//block function
		csr_flb_mtrx_clk_lag = 2'b01;
		csr_flb_smpl_clk_lag = 2'b10;
		csr_flb_sdm_order = 1'b1;
		csr_flb_sdm_thrm_en = 1'b1; //if separate matrix for SDM
		//csr_flb_sdm_thrm_en = 1'b0; //if same matrix for SDM
		
		//FF reset
		csr_dec_en = 1'b1;
		csr_flb_sdm_en = 1'b1;
		csr_sync_en = 1'b1;
		csr_flb_en = 1'b1;
		
		#10;
		
		csr_dec_en = 1'b0;
		csr_flb_sdm_en = 1'b0;
		csr_sync_en = 1'b0;
		csr_flb_en = 1'b0;
		


		#10;

	  	//release enable
		csr_sync_en = 1'b1;
		#470;
		csr_flb_sdm_en = 1'b1;
		csr_dec_en = 1'b1;
		csr_flb_en = 1'b1;
	end
	
	//create dlf_out & band
	initial begin
		band = 8'h62;
		dlf_out = 16'h132A;
		
	
		file = $fopen("/project/tsmc28mmwave/users/yaelguri/ws/FLB_NEW/FLB_tb/FLB_RTL_const2.txt", "w");
		//const1 = dlf_out=0, band=0
		//const2 = dlf_out=0X132A , band= 0x62
		//const3 = dlf_out=0X2081 , band= 0xA0

		repeat (65000) begin
			@(posedge nsh_clk);
			if (os_thrm_FLB == 3'b0) n=2'b0;
			if (os_thrm_FLB == 3'b001) n=2'b01;
			if (os_thrm_FLB == 3'b011) n=2'b10;
			if (os_thrm_FLB == 3'b111) n=2'b11;
			$fwrite(file, "%d\n", n);
		end
		$finish;
	end
endmodule