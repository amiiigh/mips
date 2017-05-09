module EX_stage
(
	input	clk,
	input	rst,
	input   stall_mem_ready,
	input 	[3:0] opcode_id_ex,
	input	[1:0] frwd_op1_mux,
	input	[1:0] frwd_op2_mux,
	input	[1:0] frwd_store_data,
	input   [15:0] frwd_res_ex,
  	input   [15:0] frwd_res_mem,
  	input   [15:0] frwd_res_wb,
	input 	[15:0]rs_1,
	input 	[15:0]rs_2,
	input 	[2:0] cmd,
	output reg[15:0]alu_res,
	input [15:0] id_ex_store_data,
	input [2:0] id_ex_op_dest,
	input id_ex_mem_write_en,
	input id_ex_wb_mux,
	input id_ex_wb_en,
	output reg [15:0] ex_store_data,
	output reg [2:0] ex_op_dest,
	output reg ex_mem_write_en,
	output reg ex_wb_mux,
	output reg ex_wb_en,
	output reg [3:0] opcode_ex_mem
);
parameter  FORWARD_EX_RES = 2'b10;
parameter  FORWARD_MEM_RES = 2'b11;
parameter  FORWARD_WB_RES = 2'b01;
wire [15:0] alu_op1, alu_op2;
assign alu_op1 =(frwd_op1_mux == FORWARD_EX_RES) ? frwd_res_ex :
                  ((frwd_op1_mux == FORWARD_MEM_RES) ? frwd_res_mem :
                   ((frwd_op1_mux == FORWARD_WB_RES) ? frwd_res_wb:rs_1));
assign alu_op2 =(frwd_op2_mux == FORWARD_EX_RES) ? frwd_res_ex :
                  ((frwd_op2_mux == FORWARD_MEM_RES) ? frwd_res_mem :
                   ((frwd_op2_mux == FORWARD_WB_RES) ? frwd_res_wb:rs_2));
wire [15:0]alu_res_temp;
always @(posedge clk or posedge rst) begin
	if (rst) begin
		ex_store_data <= 0;
		ex_op_dest <= 0;
		ex_mem_write_en <= 0;
		ex_wb_mux <= 0;
		ex_wb_en <= 0;
		alu_res <= 0;
		opcode_ex_mem <=0;
	end
	else if(!stall_mem_ready) begin
		opcode_ex_mem <= opcode_id_ex;
		alu_res <= alu_res_temp;
		ex_store_data <= (frwd_store_data == FORWARD_EX_RES) ? frwd_res_ex:
		((frwd_store_data == FORWARD_MEM_RES )? frwd_res_mem:
			((frwd_store_data == FORWARD_WB_RES )?frwd_res_wb:id_ex_store_data));
		ex_op_dest <= id_ex_op_dest;
		ex_mem_write_en <= id_ex_mem_write_en;
		ex_wb_mux <= id_ex_wb_mux;
		ex_wb_en <= id_ex_wb_en;
	end
end

ALU alu(alu_op1,alu_op2,cmd,alu_res_temp);
endmodule