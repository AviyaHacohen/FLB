module FLB(
		//input
		input  logic nsh_clk,     
		input  logic ref_clk, 
		input  logic [15:0] dlf_out,
		input  logic [7:0] band,
	
		
		input logic csr_dec_en, 
		input  logic csr_flb_sdm_en, 
		input  logic csr_flb_sdm_order,
		input  logic csr_flb_sdm_thrm_en, 
		input  logic [1:0] csr_flb_mtrx_clk_lag,
		input  logic [1:0] csr_flb_smpl_clk_lag,
		input  logic csr_sync_en, 
		input  logic csr_flb_en, 
			
		//output
		output logic [2:0] os_thrm_FLB,
		output logic [1:0] os_bin_FLB,
		output logic [63:0] mtrx_thrm_FLB,
		output logic [29:0] band_thrm_FLB
	);

		//signals between the block
		logic [7:0] s_os;
		logic [7:0] s_mtrx;   
		logic [7:0] s_band;   
		logic dec_clk;
		logic [1:0] os_bin;
		logic [2:0] os_thrm;
		logic [63:0] mtrx_thrm;
		logic [29:0] band_thrm;
		logic [7:0] s_mtrx_after_delay;   
		logic [7:0] d1;
		logic [7:0] d2;
		logic [7:0] d3;
		logic nsh_clk_input;
		
		logic flb_en_sync_0, flb_en_sync_1;
		logic flb_en_latch;
	
	SYNC sync_inst(
		.nsh_clk(nsh_clk_input),     
		.ref_clk(ref_clk), 
		.dlf_out (dlf_out), 
		.band(band),
		.csr_flb_mtrx_clk_lag(csr_flb_mtrx_clk_lag),
		.csr_flb_smpl_clk_lag(csr_flb_smpl_clk_lag),
		.csr_flb_sdm_thrm_en(csr_flb_sdm_thrm_en),
		.csr_sync_en(csr_sync_en),
		.s_os(s_os),     
		.s_mtrx(s_mtrx),   
		.s_band(s_band),   
		.dec_clk(dec_clk)  

	);	
	
	SDM sdm_inst(
		.nsh_clk(nsh_clk_input),       
		.s_os(s_os),
		.csr_flb_sdm_en(csr_flb_sdm_en), 
		.csr_flb_sdm_order(csr_flb_sdm_order),
		.csr_flb_sdm_thrm_en(csr_flb_sdm_thrm_en),
		.os_bin(os_bin),    
		.os_thrm(os_thrm)		
	
	);
	
	DEC dec_inst(
		.os_bin(os_bin),
		.dec_clk(dec_clk),
		.s_mtrx(s_mtrx_after_delay),   
		.s_band(s_band),
		.csr_dec_en(csr_dec_en),
		.mtrx_thrm(mtrx_thrm),
		.band_thrm(band_thrm)
	
	);
	
	always_ff @(posedge dec_clk or negedge csr_flb_en) begin
		if (!csr_flb_en) begin
			os_thrm_FLB <= 3'b0;
			os_bin_FLB <= 2'b0;
			mtrx_thrm_FLB <= 64'b0;
			band_thrm_FLB <= 30'b0;
		end 
		else begin
			os_thrm_FLB <= os_thrm;
			os_bin_FLB <= os_bin;
			mtrx_thrm_FLB <= mtrx_thrm;
			band_thrm_FLB <= band_thrm;
		end 
	end
	
	//fix delay between sdm to dec
	always @(posedge nsh_clk_input or negedge csr_flb_en) begin
		if (!csr_flb_en) begin
			d1 <= 8'b0;
			d2 <= 8'b0;
			d3 <= 8'b0;
		end else begin
			d1 <= s_mtrx; 
			d2 <= d1;
			d3 <= d2;
		end
	end

	assign s_mtrx_after_delay = d3;
	
	//Asynchronous reset
	
	//step 1 - Synchronizer
	always_ff @(posedge nsh_clk or negedge csr_flb_en) begin
		if (!csr_flb_en) begin
			flb_en_sync_0 <= 1'b0;
			flb_en_sync_1 <= 1'b0;
		end else begin
			flb_en_sync_0 <= csr_flb_en;
			flb_en_sync_1 <= flb_en_sync_0;
		end
	end
	
	//step 2 - Latch 
	always_latch begin
		if (!csr_flb_en)
			flb_en_latch = 1'b0;
		else if (nsh_clk == 1'b0)
			flb_en_latch = flb_en_sync_1;
		else
			flb_en_latch = flb_en_latch; 
	end
	
	//step 3 - AND
	assign nsh_clk_input = nsh_clk & flb_en_latch;


endmodule
