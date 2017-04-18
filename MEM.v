module MEM_stage
(
	input	clk,
	input	rst,
	input	[15:0] ex_alu_res,
	input	[15:0] ex_store_data,
	input	[2:0] ex_op_dest,
	input 	mem_write_en,
	input 	ex_wb_mux,
	input 	ex_wb_en,
	output 	reg mem_wb_mux,
	output 	reg mem_wb_en,
	output 	reg [2:0] mem_op_dest,
	output 	reg [15:0]mem_alu_res,
	output 	 reg [15:0]mem_mem_data
);
wire [15:0]mem_data_temp;
memory mem(clk,rst,ex_alu_res,ex_store_data,mem_write_en,mem_data_temp);
always @(posedge clk or posedge rst) begin
	if (rst) begin
		mem_op_dest <= 0;
		mem_wb_mux <= 0;
		mem_wb_en <= 0;
		mem_alu_res <=0;
	end
	else begin
		mem_mem_data <= mem_data_temp;
		mem_op_dest <=  ex_op_dest;
		mem_wb_mux <= ex_wb_mux;
		mem_wb_en <= ex_wb_en;
		mem_alu_res <= ex_alu_res;	
	end
end

endmodule