module WB_stage
(
	input	clk,
	input	rst,
	input 	[15:0]alu_res,
	input 	[15:0]mem_res,
	output 	reg [2:0] wb_dest,
	input 	alu_mem_bar,
	output  reg [15:0]wb_data,
	output 	reg wb_en
);
always @(posedge clk or posedge rst) begin
	if (rst) begin
		{wb_data,wb_dest,wb_en} <= 0;
	end
	else if () begin
		if (alu_mem_bar == 1)begin
			wb_data <= alu_res;
		end
		else begin
			wb_data <= mem_res;
		end
	end
end
endmodule