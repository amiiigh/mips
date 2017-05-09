module ID_stage
(
	input	clk,
	input	rst,
	input 	stall_mem_ready,
	input	[1:0] frwd_bz,
	input   [15:0] frwd_res_ex,
  	input   [15:0] frwd_res_mem,
  	input   [15:0] frwd_res_wb,
	input 	stall,
	input 	[15:0]input_instr,
	output 	[2:0]rs1_addr,
	output 	[2:0]rs2_addr,
	output 	reg [15:0]rs1_data_out,
	output  reg [15:0]rs2_data_out,
	input 	[15:0]rs1_data_in,
	input 	[15:0]rs2_data_in,
	output 	reg [2:0]alu_cmd,
	output 	branch_taken,
	output 	[5:0]branch_offset_imm,

	output 	reg [15:0] id_ex_store_data,
	output 	reg [2:0] id_ex_op_dest,
	output 	reg id_ex_mem_write_en,
	output 	reg id_ex_wb_mux,
	output 	reg id_ex_wb_en,
	output 	reg [2:0] fsrc1,
	output 	reg [2:0] fsrc2,
	output 	[3:0] opcode_out,
	output 	reg [3:0] opcode_reg_out
);

parameter NOP = 0,ADDI=9,LD=10,ST=11,BZ=12;
parameter ALU_CMD_ADD = 0;
parameter  FORWARD_EX_RES = 2'b10;
parameter  FORWARD_MEM_RES = 2'b11;
parameter  FORWARD_WB_RES = 2'b01;
wire [3:0] opcode;
wire [15:0]branch_input;
always @(posedge clk or posedge rst) begin
	if (rst) begin
		{alu_cmd, rs1_data_out, rs2_data_out,id_ex_store_data,id_ex_op_dest,id_ex_mem_write_en,id_ex_wb_mux,id_ex_wb_en,fsrc1,fsrc2,opcode_reg_out} <=0;
	end
	else if(!stall_mem_ready) begin
		{alu_cmd, rs1_data_out, rs2_data_out,id_ex_store_data,id_ex_op_dest,id_ex_mem_write_en,id_ex_wb_mux,id_ex_wb_en,fsrc2,fsrc1,opcode_reg_out} <=0;
		if (!branch_taken && !stall && opcode!=NOP)begin
			opcode_reg_out <= opcode;
			fsrc1 <= rs1_addr;
			fsrc2 <= rs2_addr;
			if (opcode <9)begin
				rs1_data_out <= rs1_data_in;
				rs2_data_out <= rs2_data_in;
				id_ex_wb_en <= 1;
				alu_cmd <= input_instr[15:12]-1;
				id_ex_op_dest <= input_instr[11:9];
			end
			else if (opcode == ADDI) begin
				rs1_data_out <= rs1_data_in;
				id_ex_wb_en <= 1;
				fsrc2 <= 0;
				alu_cmd <= ALU_CMD_ADD;
				rs2_data_out <= $signed(branch_offset_imm);
				id_ex_op_dest <= input_instr[11:9];
			end
			else if (opcode == LD) begin
				id_ex_wb_mux <= 1;
				rs1_data_out <= rs1_data_in;
				id_ex_wb_en <= 1;
				fsrc2 <= 0;
				alu_cmd <= ALU_CMD_ADD;
				rs2_data_out <= $signed(branch_offset_imm);
				id_ex_op_dest <= input_instr[11:9];
			end
			else if (opcode == ST) begin
				rs1_data_out <= rs1_data_in;
				rs2_data_out <= $signed(branch_offset_imm);
				alu_cmd <= ALU_CMD_ADD;
				id_ex_op_dest <= 0;
				id_ex_mem_write_en <= 1;
				id_ex_store_data <= rs2_data_in;
			end
			else if (opcode == BZ) begin
				rs1_data_out <= rs1_data_in;
				fsrc2 <= 0;
			end
		end
	end
end
assign branch_input = (frwd_bz == FORWARD_EX_RES) ? frwd_res_ex :
                  ((frwd_bz == FORWARD_MEM_RES) ? frwd_res_mem :
                   ((frwd_bz == FORWARD_WB_RES) ? frwd_res_wb:rs1_data_in));

assign opcode = input_instr[15:12];
assign opcode_out = input_instr[15:12];
assign branch_offset_imm = input_instr[5:0];
assign branch_taken = (opcode == BZ) && (branch_input == 0);
assign rs1_addr = input_instr[8:6];
assign rs2_addr = (opcode == ST) ? input_instr[11:9] : input_instr[5:3];
endmodule