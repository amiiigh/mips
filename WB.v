module WB_stage
(
	input	clk,
	input	rst,
	input 	[15:0]alu_res,
	input 	[15:0]mem_res,
	input 	[2:0] mem_wb_dest,
	input 	alu_bar_mem,
	input	wb_en,
	output 	reg [2:0] wb_dest,
	output  reg [15:0]wb_data,
	output 	reg regfile_en
);
always @(posedge clk or posedge rst) begin
	if (rst) begin
		{wb_data,wb_dest,regfile_en} <= 0;
	end
	else begin
		{wb_data,wb_dest,regfile_en} <= 0;
		if (wb_en) begin
			wb_dest <= mem_wb_dest;
			if (alu_bar_mem == 0)begin
				wb_data <= alu_res;
			end
			else begin
				wb_data <= mem_res;
			end
		end
	end
end
endmodule