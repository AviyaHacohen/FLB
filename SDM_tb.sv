module SDM_tb;

	// Inputs
	logic nsh_clk;       
	logic [7:0] s_os;
	logic csr_flb_sdm_en; 
	logic csr_flb_sdm_order;
	logic csr_flb_sdm_thrm_en;
	
	// Outputs
	logic [1:0] os_bin;    
	logic [2:0] os_thrm; 
	
	// Variables for testing
	integer count; 
	
	// File I/O declarations
	integer file;

	// Instantiate the module under test
	SDM sdm_inst (
		.nsh_clk(nsh_clk),       
		.s_os(s_os), 
		.csr_flb_sdm_en(csr_flb_sdm_en), 
		.csr_flb_sdm_order(csr_flb_sdm_order),
		.csr_flb_sdm_thrm_en(csr_flb_sdm_thrm_en),
		.os_bin(os_bin),    
		.os_thrm(os_thrm)  
	);

	// Generate clock
	always #1 nsh_clk = ~nsh_clk;  // Period of 1 ns (1 GHz)
	
	// clk counter
	always @(posedge nsh_clk)
	  begin
		  count <= count + 1; 
	  end
	
	// Test stimulus
	initial begin
		// Initialize inputs
		nsh_clk = 1'b0;
		csr_flb_sdm_en = 1'b1;
		csr_flb_sdm_order = 1'b0;
		csr_flb_sdm_thrm_en = 1'b0;
		s_os = 8'b01001010;
		count= 0;
		
		//FF reset
		#5 csr_flb_sdm_en = 1'b0;
		
		// Enable SDM
		#5 csr_flb_sdm_en = 1'b1;

		// Open CSV file for writing
		file = $fopen("/project/tsmc28mmwave/users/yaelguri/ws/FLB_NEW/SDM_tb/SDM_RTL_order1_const.txt", "w");

		repeat (4200) begin
			@(posedge nsh_clk);
	
			if (count >= 6) begin	
				$display("os_bin: %b | os_thrm: %b | s_os: %d | SDM order: %d", os_bin, os_thrm, s_os, csr_flb_sdm_order + 1);
				$fwrite(file, "%d\n", os_bin);
			end
		end
	
		// Close CSV file
		$fclose(file);
		
		$finish;
	end

endmodule
