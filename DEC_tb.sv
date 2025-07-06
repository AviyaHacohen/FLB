module DEC_tb;
		
		logic [1:0] os_bin;
		logic dec_clk;
		logic [7:0] s_mtrx;   
		logic [7:0] s_band;
		logic csr_dec_en;
		logic [63:0] mtrx_thrm;
		logic [31:0] band_thrm;
		
		logic [15:0] col_off;
		logic [15:0] col_on;
		logic [15:0] row_p;
		logic [15:0] row_n;
		logic [7:0] num_cap;
		
		integer n;

	DEC dec_inst(
		.os_bin(os_bin),
		.dec_clk(dec_clk),
		.s_mtrx(s_mtrx),
		.s_band(s_band),
		.csr_dec_en(csr_dec_en),
		.mtrx_thrm(mtrx_thrm),
		.band_thrm(band_thrm)
		);
	
	DECODER decoder_inst ( 
		.col_off(col_off),
		.col_on(col_on),
		.row_p(row_p),
		.row_n(row_n), 
		.num_cap(num_cap)
	);
	
	assign col_on = mtrx_thrm[15:0];
	assign col_off = mtrx_thrm[31:16];
	assign row_p = mtrx_thrm[47:32];
	assign row_n = mtrx_thrm[63:48];
	
	always #5 dec_clk = ~dec_clk;

	
	initial begin 
		dec_clk = 1'b0;
		os_bin = 2'b0;
		s_band = 8'd10;		
		csr_dec_en = 1'b0;
		#1 csr_dec_en = 1'b1;

		for (n = 0; n < 256; n = n + 1) begin
			#20;
			s_mtrx = n;
			$display("\n-- Test Case %d --", n-1);
			$display("Input number: %d", s_mtrx-1);
			$display("Output number: %d", num_cap);
			$display("col_off: %b", col_off);  
			$display("col_on:  %b", col_on);
			$display("row_p:   %b", row_p);  
			$display("row_n:   %b", row_n);
			$display("-----------------"); 
		
			if (n == 255) begin
				$display("\n=== Test Completed ==="); 
				$finish;
			end
		
		end 

	end
endmodule