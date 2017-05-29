module MEM_stage
(
	input	clk,
	input	rst,
	input 	[3:0]opcode_ex_mem,
	input 	[3:0]opcode_id_ex,
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
	output 	reg [15:0]mem_mem_data,
	output 	reg [3:0]opcode_mem_wb,
	inout  reg [15:0] SRAM_DATA,
	output reg [17:0] SRAM_ADDRESS,
	output SRAM_UB_N_O,
	output SRAM_LB_N_O,
	output reg SRAM_WE_N_O, 
	output SRAM_CE_N_O,
	output SRAM_OE_N_O, 
	output reg ready,
	output [1:0] counter_out
);

parameter NOP = 0,ADDI=9,LD=10,ST=11,BZ=12;
wire [15:0]mem_data_temp;
wire is_mem_op;
reg [1:0] counter;
assign SRAM_UB_N_O = 0; // gnd
assign SRAM_LB_N_O = 0; // gnd 
assign SRAM_CE_N_O = 0; // gnd
assign SRAM_OE_N_O = 0; // gnd
assign is_mem_op = opcode_id_ex == LD || opcode_id_ex == ST;
assign counter_out = counter;



assign mem_data_temp = SRAM_DATA;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		{counter,mem_op_dest,mem_wb_mux,mem_wb_en,mem_alu_res,mem_mem_data,opcode_mem_wb}<=0;
		ready <= 1;
	end
	else begin
		{mem_mem_data , mem_op_dest , mem_wb_mux , mem_wb_en , mem_alu_res , opcode_mem_wb} <= 0;
		ready<=1;
		if (is_mem_op) begin
			if(counter == 0)begin
				mem_mem_data <= mem_data_temp;
				mem_op_dest <=  ex_op_dest;
				mem_wb_mux <= ex_wb_mux;
				mem_wb_en <= ex_wb_en;
				mem_alu_res <= ex_alu_res;	
				opcode_mem_wb <= opcode_ex_mem;
			end
			counter <= counter + 2'b1;
		end
		else begin
			counter <= 0;
			mem_mem_data <= mem_data_temp;
			mem_op_dest <=  ex_op_dest;
			mem_wb_mux <= ex_wb_mux;
			mem_wb_en <= ex_wb_en;
			mem_alu_res <= ex_alu_res;	
			opcode_mem_wb <= opcode_ex_mem;
		end

		if(counter == 2'd3) begin
			ready <= 1;
			mem_mem_data <= mem_data_temp;
			mem_op_dest <=  ex_op_dest;
			mem_wb_mux <= ex_wb_mux;
			mem_wb_en <= ex_wb_en;
			mem_alu_res <= ex_alu_res;	
			opcode_mem_wb <= opcode_ex_mem;
		end
		else if (is_mem_op) begin
			ready <= 0 ;
		end
	end
end



always @( * ) begin
	SRAM_ADDRESS <= {2'b00 , ex_alu_res};
	SRAM_WE_N_O <= ~mem_write_en;
	SRAM_DATA <= mem_write_en ? ex_store_data : 16'bz;
end

endmodule