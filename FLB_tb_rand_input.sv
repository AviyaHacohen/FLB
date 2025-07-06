module FLB_tb_rand_input;

	`define INPUT "/project/tsmc28mmwave/users/yaelguri/ws/FLB_NEW/FLB_tb/sin_input_flb.txt"
	`define OUTPUT "/project/tsmc28mmwave/users/yaelguri/ws/FLB_NEW/FLB_tb/sin_output_flb_fix.txt"

	
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
	
	//for the decoder at the end
	logic [15:0] col_on;
	logic [15:0] col_off;
	logic [15:0] row_p;
	logic [15:0] row_n;
	logic [7:0] num_cap;
	
	// File I/O declarations
	integer sin_input;
	integer output_mtrx_thrm;

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
	
	DECODER decoder_inst (
		.col_off(col_off),
		.col_on(col_on),
		.row_p(row_p),
		.row_n(row_n),
		.num_cap(num_cap)
	);
	
	//Generate clocks
	always #1 nsh_clk = ~nsh_clk; 
	always #20 ref_clk = ~ref_clk; 
	
	assign col_on = mtrx_thrm_FLB[15:0];
	assign col_off = mtrx_thrm_FLB[31:16];
	assign row_p = mtrx_thrm_FLB[47:32];
	assign row_n = mtrx_thrm_FLB[63:48];
	
	always @(posedge ref_clk) begin
		if (!$feof(sin_input)) begin
			$fscanf(sin_input, "%d\n", dlf_out);

		end
		else begin
			$fclose(sin_input);
			$finish;
		end	
	end
	
	always @(posedge nsh_clk) begin
		if (!$feof(sin_input)) begin
			$fwrite(output_mtrx_thrm, "%d\n", num_cap);

		end
		else begin
			$fclose(output_mtrx_thrm);
			$finish;
		end	
	end
	
	
	
	initial begin
		nsh_clk = 1'b0;
		ref_clk = 1'b0;
		
		//block function
		csr_flb_mtrx_clk_lag = 2'b01;
		csr_flb_smpl_clk_lag = 2'b10;
		csr_flb_sdm_order = 1'b1;
		//csr_flb_sdm_thrm_en = 1'b1; //if separate matrix for SDM
		csr_flb_sdm_thrm_en = 1'b0; //if same matrix for SDM
		
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
		csr_flb_sdm_en = 1'b1;
		csr_dec_en = 1'b1;
		csr_flb_en = 1'b1;
	end
	
	initial begin
		band = 8'h99;
		
		sin_input = $fopen(`INPUT, "r");
		output_mtrx_thrm = $fopen(`OUTPUT, "w");
	
		
		if (sin_input == 0) begin
			$display("Error opening file input");
			$finish;
		end
		
		if (output_mtrx_thrm == 0) begin
			$display("Error opening file output");
			$finish;
		end
	end

endmodule