module SYNC_tb;

	//Signals for module ports
	logic nsh_clk;
	logic ref_clk;
	logic [15:0] dlf_out;
	logic [7:0] band;
	logic [1:0] csr_flb_mtrx_clk_lag;
	logic [1:0] csr_flb_smpl_clk_lag;
	logic csr_sync_en;
	logic [7:0] s_os;
	logic [7:0] s_mtrx;
	logic [7:0] s_band;
	logic dec_clk;
	
	//Create dlf_out
	parameter DLF_W = 16;    //16 BIT  
	integer ref_clk_count;       
	real test_noise;
	integer loop_data;
	integer nsh_range; 	      
	integer seed;     


	//Instantiate the module under test
	SYNC sync_inst (
	  .nsh_clk(nsh_clk),
	  .ref_clk(ref_clk),
	  .dlf_out(dlf_out),
	  .band(band),
	  .csr_flb_mtrx_clk_lag(csr_flb_mtrx_clk_lag),
	  .csr_flb_smpl_clk_lag(csr_flb_smpl_clk_lag),
	  .csr_sync_en(csr_sync_en),
	  .s_os(s_os),
	  .s_mtrx(s_mtrx),
	  .s_band(s_band),
	  .dec_clk(dec_clk)
	);

	//Generate clocks
	always #1 nsh_clk = ~nsh_clk;  // Period of 1 ns (1 GHz)
	always #20 ref_clk = ~ref_clk;  // Period of 20 ns (50 MHz)

	initial begin
		nsh_clk = 1'b0;
		ref_clk = 1'b0;
		csr_sync_en = 1'b0;
		band = 8'b0;
		csr_flb_mtrx_clk_lag = 2'b01;
		csr_flb_smpl_clk_lag = 2'b10;
	
	  // release enable
	  #20 csr_sync_en = 1'b1;
	  

	  #1000 band = 8'hFF;
	  #1000 band = 8'hAA;
	
	end

	
	// Ref-Clock counter
	// =====================
	always @(posedge ref_clk)
	  begin
		 ref_clk_count <= ref_clk_count + 1; 
	  end
	
	//create dlf_out
	initial begin
		ref_clk_count = 0;
		nsh_range = 32'd10;    
		seed = $urandom();
		
	
		repeat (4200) begin
			@(posedge ref_clk);
	
			if (ref_clk_count > 10) begin	
				test_noise = $itor($dist_normal(seed, 0, (nsh_range) * $rtoi(1.0e6))) / 1.0e6;
				loop_data = $rtoi((1 << (DLF_W - 1)) + (1 << (DLF_W - 3)) * $sin(2 * 3.14 * $itor(ref_clk_count) / 4001) + test_noise);
				dlf_out = loop_data[15:0];
			end
		end
		$finish;
	end

	/*initial begin
	  $monitor("At time %t, dlf_out = %h, band = %h, s_os = %h, s_mtrx = %h, s_band = %h, dec_clk = %b", 
			   $time, dlf_out, band, s_os, s_mtrx, s_band, dec_clk);
	end*/

endmodule
