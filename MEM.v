module MEM_stage
(
	input	clk,
	input	rst,
	input 	[3:0]opcode_ex_mem,
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

	//
	inout reg [15:0] SRAM_DATA,
	output [17:0] SRAM_ADDRESS,
	output SRAM_UB_N_O, // gnd
	output SRAM_LB_N_O, // gnd
	output SRAM_WE_N_O, 
	output SRAM_CE_N_O, // gnd
	output SRAM_OE_N_O,  // gnd
	output reg ready,
	output [1:0] counter_out
);
parameter NOP = 0,ADDI=9,LD=10,ST=11,BZ=12;
wire [15:0]mem_data_temp;
reg [1:0] counter;
assign counter_out = counter;

assign SRAM_UB_N_O = 0; // gnd
assign SRAM_LB_N_O = 0; // gnd 
assign SRAM_CE_N_O = 0; // gnd
assign SRAM_OE_N_O = 0; // gnd

assign SRAM_WE_N_O = !mem_write_en;

assign SRAM_ADDRESS = {2'b00 , ex_alu_res};
assign mem_data_temp = SRAM_DATA;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		ready <= 1;
		counter <= 0;
		mem_op_dest <= 0;
		mem_wb_mux <= 0;
		mem_wb_en <= 0;
		mem_alu_res <=0;
		mem_mem_data <=0;
		opcode_mem_wb <=0;
	end
	else begin
		SRAM_DATA <= 16'bzzzzzzzzzzzzzzzzzzzz;
		{mem_mem_data , mem_op_dest , mem_wb_mux , mem_wb_en , mem_alu_res , opcode_mem_wb} <= 0;
		if(opcode_ex_mem == LD || opcode_ex_mem == ST) counter <= counter + 1;
		else begin 
			counter <= 0;
			ready <= 1;
			mem_mem_data <= mem_data_temp;
			mem_op_dest <=  ex_op_dest;
			mem_wb_mux <= ex_wb_mux;
			mem_wb_en <= ex_wb_en;
			mem_alu_res <= ex_alu_res;	
			opcode_mem_wb <= opcode_ex_mem;
		end
		if(counter == 2'd3) begin
			if(mem_write_en) begin
				SRAM_DATA <= ex_store_data;
			end
			ready <= 1;
			counter <= 0;
			mem_mem_data <= mem_data_temp;
			mem_op_dest <=  ex_op_dest;
			mem_wb_mux <= ex_wb_mux;
			mem_wb_en <= ex_wb_en;
			mem_alu_res <= ex_alu_res;	
			opcode_mem_wb <= opcode_ex_mem;
		end
		else if(opcode_ex_mem == LD || opcode_ex_mem == ST) begin
			ready <= 0;
		end
	end
end

endmodule