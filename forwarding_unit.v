module forwarding_unit
(
	input 	hazard_en,
	input 	[2:0] id_src1,
	input 	[2:0] id_src2,
	input 	id_op_code_is_st,
	input 	[2:0] ex_op_dest,
	input	[2:0] mem_op_dest,
	input	[2:0] wb_op_dest,
	output reg [1:0] frwd_op1_mux,
	output reg [1:0] frwd_op2_mux,
	output reg [1:0] frwd_store_data
);

parameter  FORWARD_EX_RES = 2'b10;
parameter  FORWARD_MEM_RES = 2'b11;
parameter  FORWARD_WB_RES = 2'b01;

	always @(*) begin
		{frwd_store_data,frwd_op2_mux,frwd_op1_mux} <= 0;
		if (hazard_en == 0) begin
			if (id_src1 != 0 ) begin
				if ( id_src1 == ex_op_dest) begin
					frwd_op1_mux <= FORWARD_EX_RES;
				end
				else if (id_src1 == mem_op_dest) begin
					frwd_op1_mux <= FORWARD_MEM_RES;
				end
				else if (id_src1 == wb_op_dest) begin
					frwd_op1_mux <= FORWARD_WB_RES;
				end

			end

			if(id_src2 != 0) begin
				if(id_op_code_is_st) begin
					if(id_src2 == ex_op_dest)
						frwd_store_data <= FORWARD_EX_RES;
					else if (id_src2 == mem_op_dest)
						frwd_store_data <= FORWARD_MEM_RES;
					else if (id_src2 == wb_op_dest)
						frwd_store_data <= FORWARD_WB_RES;
				end 
				else begin
					if(id_src2 == ex_op_dest)
						frwd_op2_mux <= FORWARD_EX_RES;
					else if (id_src2 == mem_op_dest)
						frwd_op2_mux <= FORWARD_MEM_RES;
					else if (id_src2 == wb_op_dest)
						frwd_op2_mux <= FORWARD_WB_RES;
				end
			end
		end
	end
endmodule