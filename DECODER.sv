module DECODER(
	input [15:0] col_off,
	input [15:0] col_on,
	input [15:0] row_p,
	input [15:0] row_n,
	output reg [7:0] num_cap
);
	integer i, j;

	always @(*) begin
		num_cap = 8'b0;
		for (i = 0; i < 16; i = i + 1) begin
			for (j = 0; j < 16; j = j + 1) begin
				if (i % 2 == 0) begin
					num_cap = num_cap + {7'b0,~(col_off[i] & (~(col_on[i] & row_n[j])))};
				end 
				else begin
					num_cap = num_cap + {7'b0,~(col_off[i] & (~(col_on[i] & row_p[j])))};
				end
			end
		end
	end
endmodule