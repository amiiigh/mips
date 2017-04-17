module memory
(
	input 	clk,
	input   rst,
	input 	[5:0] addr,
	input 	[15:0] data_in,
	input 	write_mem_en,
	output 	[15:0] data_out
);
reg [15:0] registers [0:63];
integer i;
assign data_out = registers[addr] ;
always @(posedge clk) begin
	if(rst)
	begin 
		for(i = 0; i<64; i=i+1)
		begin
			registers[i]<=0;
		end	
	end	
	else if (write_mem_en) 
	begin
		registers [addr] <= data_in;
	end
end

endmodule