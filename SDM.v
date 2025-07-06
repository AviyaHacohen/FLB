module SDM (
	input  logic nsh_clk,       
	input  logic [7:0] s_os, 
	input  logic csr_flb_sdm_en, 
	input  logic csr_flb_sdm_order,
	input  logic csr_flb_sdm_thrm_en, //if 1 os_thrm if 0 os_bin
	//outputs
	output logic [1:0] os_bin,    
	output logic [2:0] os_thrm  
);

	logic [8:0] v0;
	logic [7:0] e0;
	
	logic [8:0] v1;
	logic [7:0] e1;
	
	logic y0;
	logic y0_prev;
	logic y1;
	logic y1_prev;
	logic order_enable;
	logic [1:0] bin;
	logic [2:0] thrm_temp;
	
	// First-order sigma-delta modulator (DEFM)
	
	assign y0 = v0[8]; 
	assign e0 = v0[7:0];
  
	always_ff @(posedge nsh_clk or negedge csr_flb_sdm_en) begin
		if (!csr_flb_sdm_en)
			v0 <= 9'b0;
		else
			v0 <= {1'b0,s_os} + {1'b0,e0};
		end
	
		
	// Second-order sigma-delta modulator
	assign order_enable = csr_flb_sdm_order & csr_flb_sdm_en;
	
	assign y1 = v1[8]; 
	assign e1 = v1[7:0];
  
	always_ff @(posedge nsh_clk or negedge order_enable) begin
		if (!order_enable)
			v1 <= 9'b0;
		else
			v1 <= {1'b0,e0} + {1'b0,e1};
		end
	
	always_ff @(posedge nsh_clk or negedge order_enable) begin
		if (!order_enable)
			y1_prev <= 1'b0;
		else
			y1_prev <= y1;
		end
		
	always_ff @(posedge nsh_clk or negedge csr_flb_sdm_en) begin
		if (!csr_flb_sdm_en)
			y0_prev <= 1'b0;
		else
			y0_prev <= y0;
		end
	  
	assign bin = 2'b01 + {1'b0,y0_prev} + {1'b0,y1} - {1'b0,y1_prev};
	
	// Thermometer code conversion
	always_comb begin
		case(bin)
			2'b00: thrm_temp = 3'b000;
			2'b01: thrm_temp = 3'b001;
			2'b10: thrm_temp = 3'b011;
			2'b11: thrm_temp = 3'b111;
		endcase
	end

	//if bin configuration is on (csr_flb_sdm_thrm_en=0)
		
	always_ff @(posedge nsh_clk or negedge csr_flb_sdm_en) begin
		if (!csr_flb_sdm_en) begin
			os_bin <= 2'b0;
			os_thrm <= 3'b000;			 
		end
		else begin
			if (!csr_flb_sdm_thrm_en) begin
				os_bin <= bin;
				os_thrm <= 3'b0;
			end 
			else begin
				os_bin <= 2'b0;
				os_thrm <= thrm_temp;	
			end
		end	
	end
	
endmodule
