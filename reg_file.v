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
	assign reg_rd_data_1 = registers [reg_rd_addr_1];
	assign reg_rd_data_2 = registers [reg_rd_addr_2];

	integer i;
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			registers[0] <= 15'd0; 
			registers[1] <= 15'd1;
			registers[2] <= 15'd2;
			registers[3] <= 15'd3;
			registers[4] <= 15'd4;
			registers[5] <= 15'd5;
			registers[6] <= 15'd6;
			registers[7] <= 15'd7;
		end
		else begin
			if (reg_wr_en && reg_wr_dest != 0) 
			begin
				registers [reg_wr_dest] <= reg_wr_data;
			end
		end
	end
endmodule