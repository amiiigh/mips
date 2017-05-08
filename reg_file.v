module reg_file
(
	input 	clk,
	input 	rst,
	input 	[2:0] reg_rd_addr_1,
	output 	[15:0]reg_rd_data_1,

	input 	[2:0] reg_rd_addr_2,
	output 	[15:0]reg_rd_data_2,
	
	input 	[2:0] reg_wr_dest,
	input 	[15:0]reg_wr_data,
	input 	reg_wr_en
);
	reg [15:0] registers [7:0];
	integer i;
	assign reg_rd_data_1 = registers [reg_rd_addr_1];
	assign reg_rd_data_2 = registers [reg_rd_addr_2];
	always @(negedge clk or posedge rst) begin

		if (rst) begin
			for(i = 0; i<8; i=i+1)
			begin
				registers[i]<=0;
			end	
		end
		else begin
			if (reg_wr_en && reg_wr_dest != 0) 
			begin
				registers [reg_wr_dest] <= reg_wr_data;
			end
		end
	end
endmodule