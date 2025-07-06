module B2T_16b(
	input [7:0] n,
	output reg [15:0] col_off,
	output reg [15:0] col_on,
	output reg [15:0] row_p,
	output reg [15:0] row_n
);
	reg [4:0] col_on_num;
	reg [3:0] row_on_num;

	
	always @(*) begin
		col_on_num = {1'b0,n[7:4]} + 5'b1;
		row_on_num = n[3:0];
		
		col_on = ~(16'hFFFF >> col_on_num);
		col_off = ~(col_on << 1);
		
		if (col_on_num[0] == 1'b1) begin
			row_p = ~(16'hFFFF >> row_on_num);
			row_n = ~row_p;
		end
		else begin
			row_n = (16'b1 << row_on_num) - 16'b1;
			row_p = ~row_n;
		end
	end

endmodule