module B2T_15b(
	input logic [3:0] binary,
	output logic [14:0] thermo
);
  
	always @(*)   	
			thermo = (15'b1 << binary) - 15'b1;
		
endmodule