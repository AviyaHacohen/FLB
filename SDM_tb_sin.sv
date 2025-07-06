module SDM_tb_sin;
	
	`define INPUT "/project/tsmc28mmwave/users/yaelguri/ws/FLB_NEW/SDM_tb/random_input.txt"
	
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
	integer random_input;
	integer y_output;

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
	always #5 nsh_clk = ~nsh_clk;  // Period of 1 ns (1 GHz)
	
	// clk counter
	always @(posedge nsh_clk)
	  begin
		  count <= count + 1; 
	  end
	
	initial begin
		// Initialize inputs
		nsh_clk = 1'b0;
		csr_flb_sdm_en = 1'b1;
		csr_flb_sdm_order = 1'b1;
		csr_flb_sdm_thrm_en = 1'b0;
		count= 0;
		
		//FF reset
		#5 csr_flb_sdm_en = 1'b0;
		
		// Enable SDM
		#5 csr_flb_sdm_en = 1'b1;
		
		
		random_input = $fopen(`INPUT, "r");
		y_output = $fopen("/project/tsmc28mmwave/users/yaelguri/ws/FLB_NEW/SDM_tb/SDM_RTL_order2_rand.txt", "w");

		
		if (random_input == 0) begin
			$display("Error opening file %s", `INPUT);
			$finish;
		end
		
		@(posedge nsh_clk);
		while (!$feof(random_input)) begin
			$fscanf(random_input, "%d\n", s_os);
			if (count>=2) $fwrite(y_output, "%d\n", os_bin);
			@(negedge nsh_clk);
		end
		$fclose(random_input);
		$fclose(y_output);
		$finish;

	end
	
	endmodule