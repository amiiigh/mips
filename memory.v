module memory
(
	input 	clk,
	input 	[5:0] addr,
	input 	[15:0] data_in,
	input 	write_mem_en,
	output 	[15:0] data_out
);
reg [15:0] registers[0:63];
assign data_out = registers[addr] ;
always @(posedge clk) begin
	if (write_mem_en) 
	begin
		registers [addr] <= data_in;
	end
end

endmodule