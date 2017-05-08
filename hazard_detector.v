module hazard_detector
(
	input 	clk,
	input 	rst,
	input 	[3:0]opcode_id,
	input 	[3:0]opcode_ex,
	input 	[3:0]opcode_mem,
	input 	[3:0]opcode_wb,
	input 	hazard_en,
	input	[2:0]src_1,
	input 	[2:0]src_2,
	input	[2:0]dest_ex,
	input 	[2:0]dest_mem,
	input 	[2:0]dest_wb,
	input 	[2:0]dest_reg,
	output	reg stall
);

parameter NOP=0;
parameter ADDI=9;
parameter LD=10;
parameter ST=11;
parameter BZ=12;
always @(*) begin
	stall <=0;
	if (rst) begin
		stall <= 0;	
	end
	else if(hazard_en) begin
	 	if ( (src_1 != 0 && (src_1 == dest_ex || src_1 == dest_mem || src_1 == dest_wb || src_1 == dest_reg)) ||
			  	(src_2 != 0 && (src_2 == dest_ex || src_2 == dest_mem || src_2 == dest_wb || src_2 == dest_reg))) begin
			stall <= 1;
		end
	end
	else begin
		if ( (opcode_id != NOP && opcode_id != BZ && opcode_ex == LD) && (src_1 == dest_ex || src_2 == dest_ex) )begin
			stall <= 1;
		end
		if ( (opcode_id == BZ && opcode_ex != NOP && opcode_ex != BZ ) && (src_1 == dest_ex || src_2 == dest_ex) ) begin
			stall <= 1;
		end
		if ( (opcode_id == BZ && opcode_mem == LD)&& (src_1 == dest_mem || src_2 == dest_mem) ) begin
			stall <= 1;
		end
		if ( (opcode_id == BZ && opcode_wb == LD)&& (src_1 == dest_wb || src_2 == dest_wb) ) begin
			stall <= 1;
		end
	end
end
endmodule