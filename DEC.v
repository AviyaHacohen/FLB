module DEC(
	input logic [1:0] os_bin,
	input logic dec_clk,
	input logic [7:0] s_mtrx,   
	input logic [7:0] s_band,
	input logic csr_dec_en,
	output logic [63:0] mtrx_thrm,
	output logic [29:0] band_thrm
	);


	logic [15:0] col_off;
	logic [15:0] col_on;
	logic [15:0] row_p;
	logic [15:0] row_n;
	logic [7:0] n;
	
	
	B2T_16b B2T_16b_inst( 
		.n(n),
		.col_off(col_off), 
		.col_on(col_on),
		.row_p(row_p), 
		.row_n(row_n)
	);
	
	B2T_15b B2T_15b_inst1(
		.binary(s_band[7:4]),
		.thermo(band_thrm[29:15])
	);
	
	B2T_15b B2T_15b_inst2(
		.binary(s_band[3:0]),
		.thermo(band_thrm[14:0])
	);
	
	
	assign n = s_mtrx + {6'b0,os_bin};

	
	always_ff @(posedge dec_clk or negedge csr_dec_en) begin
		if (!csr_dec_en) begin
			mtrx_thrm <= 64'b0;	
		end 
		else begin
			mtrx_thrm[15:0] <= col_on;
			mtrx_thrm[31:16] <= col_off;
			mtrx_thrm[47:32] <= row_p;
			mtrx_thrm[63:48] <= row_n;
		end 
	end

endmodule
