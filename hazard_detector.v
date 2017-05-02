module hazard_detector
(
	input 	clk,
	input 	rst,
	input 	hazard_en,
	input	[2:0]src_1,
	input 	[2:0]src_2,
	input	[2:0]dest_ex,
	input 	[2:0]dest_mem,
	input 	[2:0]dest_wb,
	input 	[2:0]dest_reg,
	output	reg stall
);
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
end
endmodule