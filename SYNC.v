module SYNC (

input  logic nsh_clk,     
input  logic ref_clk, 
input  logic [15:0] dlf_out, 
input  logic [7:0] band,
input  logic [1:0] csr_flb_mtrx_clk_lag,
input  logic [1:0] csr_flb_smpl_clk_lag,
input  logic csr_flb_sdm_thrm_en,
input  logic csr_sync_en,
output logic [7:0] s_os,     
output logic [7:0] s_mtrx,   
output logic [7:0] s_band,   
output logic dec_clk     //  mtrx_clk  
);

	logic pulse0;
	logic pulse1;
	logic pulse2;
	logic pulse3;
	logic pulse4;
	logic pulse5;
	logic smpl_clk;
	logic zm_3;
	logic zm_2; 
	logic zm_1;
	
	//2-FF Synchronizer for CDC 
	
	always_ff @(posedge nsh_clk or negedge csr_sync_en) begin
		if (~csr_sync_en)
			zm_1 <= 1'd0;
		else
			zm_1 <= ref_clk;
	end
	
	always_ff @(posedge nsh_clk or negedge csr_sync_en) begin
		if (~csr_sync_en)			
			zm_2 <= 1'd0;
		else
			zm_2 <= zm_1;
	  end
	
	always_ff @(posedge nsh_clk or negedge csr_sync_en) begin
		if (~csr_sync_en)
			zm_3 <= 1'd0;
		else			
			zm_3 <= zm_2;
	end
	
	assign pulse0 = (~zm_3) & zm_2; //creating first pulse
	
	always_ff @(posedge nsh_clk or negedge csr_sync_en) begin
		if (~csr_sync_en)
			pulse1 <= 1'b0;
		else
			pulse1 <= pulse0;
	end
	
	always_ff @(posedge nsh_clk or negedge csr_sync_en) begin
		if (~csr_sync_en)
			pulse2 <= 1'd0;
		else 
			pulse2 <= pulse1;
	end
	
	always_ff @(posedge nsh_clk or negedge csr_sync_en) begin
		if (~csr_sync_en)
			pulse3 <= 1'd0;
		else 
			pulse3 <= pulse2;
	end
	
	always_ff @(posedge nsh_clk or negedge csr_sync_en) begin
		if (~csr_sync_en)
			pulse4 <= 1'd0;
		else 
			pulse4 <= pulse3;
	end
	
	always_ff @(posedge nsh_clk or negedge csr_sync_en) begin
		if (~csr_sync_en)
			pulse5 <= 1'd0;
		else 
			pulse5 <= pulse4;
	end
	
	
	//Sampling the lv_pulse according to smpl_clk_lag[1:0]
	
	always_comb begin
		case(csr_flb_smpl_clk_lag)
			2'b00: smpl_clk = pulse1;  //lag0
			2'b01: smpl_clk = pulse2;  //lag1
			2'b10: smpl_clk = pulse3;  //lag2
			2'b11: smpl_clk = pulse4;  //lag3
		endcase
	end
	
	//Sampling the lv_pulse according to mtrx_clk_lag[1:0]
	
	always_comb begin
		case({csr_flb_sdm_thrm_en,csr_flb_mtrx_clk_lag})
			3'b100: dec_clk = pulse2;  //lag0
			3'b101: dec_clk = pulse3;  //lag1
			3'b110: dec_clk = pulse4;  //lag2
			3'b111: dec_clk = pulse5;  //lag3
			default: dec_clk = nsh_clk;
		endcase
	end
	
	
	//smpl_clk is used to sample the inputs of the synchronizer
	
	always_ff @(posedge smpl_clk or negedge csr_sync_en) begin
		if (~csr_sync_en) begin
			s_os <= 8'b0;
			s_mtrx <= 8'b0;
		end	  	
		else begin
			s_os <= dlf_out[7:0];
			s_mtrx <= dlf_out[15:8];
		end
	end
	
	always_ff @(posedge smpl_clk or negedge csr_sync_en) begin			
		if (~csr_sync_en)
			s_band <= 8'b0;
		else
			s_band <= band;
	end

endmodule